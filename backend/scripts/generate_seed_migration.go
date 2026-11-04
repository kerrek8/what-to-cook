package main

import (
	"bufio"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"

	"github.com/kerrek8/what-to-cook/backend/internal/provider"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

type PreparedRecipe struct {
	External   provider.ExternalRecipe               `json:"external"`
	Translated *service.GroqRecipeTranslateResponse `json:"translated"`
}

func isCacheItemValid(item PreparedRecipe) bool {
	if item.Translated == nil {
		return false
	}
	if item.Translated.CookingTimeMinutes <= 0 {
		return false
	}
	if item.Translated.Difficulty == "" {
		return false
	}
	if len(item.Translated.Ingredients) == 0 {
		return false
	}
	if len(item.Translated.LocalizedInstructions) == 0 {
		return false
	}
	return true
}

func readKeyFromDotEnv(path string) string {
	f, err := os.Open(path)
	if err != nil {
		return ""
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "GROQ_API_KEY=") {
			return strings.TrimSpace(strings.TrimPrefix(line, "GROQ_API_KEY="))
		}
	}
	return ""
}

func sqlQuote(val string) string {
	return "'" + strings.ReplaceAll(val, "'", "''") + "'"
}

func loadM2Ingredients(m2Path string) map[string]bool {
	m2Set := make(map[string]bool)
	data, err := os.ReadFile(m2Path)
	if err != nil {
		log.Printf("[WARN] Could not read M2 file %s: %v", m2Path, err)
		return m2Set
	}
	re := regexp.MustCompile(`\('([^']+)'`)
	matches := re.FindAllStringSubmatch(string(data), -1)
	for _, m := range matches {
		if len(m) > 1 {
			m2Set[strings.ToLower(strings.TrimSpace(m[1]))] = true
		}
	}
	log.Printf("Loaded %d ingredients from %s", len(m2Set), m2Path)
	return m2Set
}

func main() {
	defaultUp := "migrations/000005_seed_recipes.up.sql"
	defaultDown := "migrations/000005_seed_recipes.down.sql"
	defaultM2 := "migrations/000002_seed_ingredients.up.sql"
	if _, err := os.Stat("backend/migrations"); err == nil {
		defaultUp = "backend/migrations/000005_seed_recipes.up.sql"
		defaultDown = "backend/migrations/000005_seed_recipes.down.sql"
		defaultM2 = "backend/migrations/000002_seed_ingredients.up.sql"
	}

	cacheFlag := flag.String("cache", "backend/cmd/seed_generator/seed_cache.json", "Path to seed cache JSON")
	outUpFlag := flag.String("out-up", defaultUp, "Output up-migration SQL file")
	outDownFlag := flag.String("out-down", defaultDown, "Output down-migration SQL file")
	m2Flag := flag.String("m2", defaultM2, "Path to 000002_seed_ingredients.up.sql")
	flag.Parse()

	m2Set := loadM2Ingredients(*m2Flag)

	cachePath := *cacheFlag
	if _, err := os.Stat(cachePath); err != nil {
		alt := "cmd/seed_generator/seed_cache.json"
		if _, err := os.Stat(alt); err == nil {
			cachePath = alt
		}
	}

	data, err := os.ReadFile(cachePath)
	if err != nil {
		log.Fatalf("Failed to read cache file %s: %v", cachePath, err)
	}

	var recipes []PreparedRecipe
	if err := json.Unmarshal(data, &recipes); err != nil {
		log.Fatalf("Failed to parse cache JSON: %v", err)
	}

	log.Printf("Loaded %d recipes from %s. Validating...", len(recipes), cachePath)

	validRecipes := make([]PreparedRecipe, 0, len(recipes))
	for _, r := range recipes {
		if !isCacheItemValid(r) {
			log.Printf("[WARN] Recipe %s %q is invalid (missing ingredients or time=0). Skipping...", r.External.ExternalID, r.External.Title)
			continue
		}
		validRecipes = append(validRecipes, r)
	}

	log.Printf("Valid recipes count: %d / %d. Generating SQL...", len(validRecipes), len(recipes))

	upSQL := generateUpSQL(validRecipes, m2Set)
	downSQL := generateDownSQL(validRecipes)

	_ = os.MkdirAll(filepath.Dir(*outUpFlag), 0755)
	if err := os.WriteFile(*outUpFlag, []byte(upSQL), 0644); err != nil {
		log.Fatalf("Failed to write up migration: %v", err)
	}
	log.Printf("Up migration saved to %s", *outUpFlag)

	_ = os.MkdirAll(filepath.Dir(*outDownFlag), 0755)
	if err := os.WriteFile(*outDownFlag, []byte(downSQL), 0644); err != nil {
		log.Fatalf("Failed to write down migration: %v", err)
	}
	log.Printf("Down migration saved to %s", *outDownFlag)

	log.Println("Seed migration generated successfully!")
}

func generateUpSQL(recipes []PreparedRecipe, m2Set map[string]bool) string {
	var sb strings.Builder
	sb.WriteString("-- 000005_seed_recipes.up.sql\n")
	sb.WriteString(fmt.Sprintf("-- Pre-seeded %d translated recipes with ingredients, localized instructions, cooking time and difficulty\n\n", len(recipes)))

	// 1. Ingredients
	sb.WriteString("-- 1. Insert any new ingredients used in seeded recipes\n")
	sb.WriteString("INSERT INTO ingredients (name, name_en, category, default_unit, is_pantry_essential) VALUES\n")

	type ingData struct {
		nameRu string
		nameEn string
	}
	uniqueIngs := make(map[string]ingData)

	for _, r := range recipes {
		for idx, ing := range r.Translated.Ingredients {
			nameRu := strings.ToLower(strings.TrimSpace(ing.RussianName))
			if nameRu == "" {
				continue
			}
			var nameEn string
			extIdx := int(ing.ID) - 1
			if extIdx >= 0 && extIdx < len(r.External.Ingredients) {
				nameEn = strings.TrimSpace(r.External.Ingredients[extIdx].Name)
			} else if idx < len(r.External.Ingredients) {
				nameEn = strings.TrimSpace(r.External.Ingredients[idx].Name)
			}
			if _, exists := uniqueIngs[nameRu]; !exists {
				uniqueIngs[nameRu] = ingData{nameRu: nameRu, nameEn: nameEn}
			}
		}
	}

	ingList := make([]ingData, 0, len(uniqueIngs))
	for _, v := range uniqueIngs {
		if !m2Set[v.nameRu] {
			ingList = append(ingList, v)
		}
	}

	sort.Slice(ingList, func(i, j int) bool {
		return ingList[i].nameRu < ingList[j].nameRu
	})

	for i, ing := range ingList {
		comma := ","
		if i == len(ingList)-1 {
			comma = ""
		}
		enSQL := "NULL"
		if ing.nameEn != "" {
			enSQL = sqlQuote(ing.nameEn)
		}
		sb.WriteString(fmt.Sprintf("(%s, %s, 'Другое', 'г', FALSE)%s\n", sqlQuote(ing.nameRu), enSQL, comma))
	}
	sb.WriteString("ON CONFLICT (name) DO NOTHING;\n\n")

	// 2. Recipes
	sb.WriteString("-- 2. Insert recipes and recipe ingredients\n")
	for _, r := range recipes {
		extJSON, _ := json.Marshal(r.External.Instructions)
		locJSON, _ := json.Marshal(r.Translated.LocalizedInstructions)

		descSQL := "NULL"
		if r.External.Category != "" {
			descSQL = sqlQuote(r.External.Category)
		}
		locDescSQL := "NULL"
		if r.Translated.LocalizedDescription != "" {
			locDescSQL = sqlQuote(r.Translated.LocalizedDescription)
		}
		imgSQL := "NULL"
		if r.External.ImageURL != "" {
			imgSQL = sqlQuote(r.External.ImageURL)
		}

		cookingTime := r.Translated.CookingTimeMinutes
		if cookingTime <= 0 {
			cookingTime = 35
		}
		difficulty := r.Translated.Difficulty
		if difficulty == "" {
			difficulty = "medium"
		}

		sb.WriteString(fmt.Sprintf(`INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    %s, %s, %s, %s::jsonb,
    %s, %s, %s::jsonb,
    %d, %s, %s,
    'translated', NOW()
) ON CONFLICT (external_id) DO UPDATE SET
    title = EXCLUDED.title,
    localized_title = EXCLUDED.localized_title,
    localized_description = EXCLUDED.localized_description,
    localized_instructions = EXCLUDED.localized_instructions,
    cooking_time_minutes = EXCLUDED.cooking_time_minutes,
    difficulty = EXCLUDED.difficulty,
    image_url = EXCLUDED.image_url,
    translation_status = 'translated';

`,
			sqlQuote(r.External.ExternalID),
			sqlQuote(r.External.Title),
			descSQL,
			sqlQuote(string(extJSON)),
			sqlQuote(r.Translated.LocalizedTitle),
			locDescSQL,
			sqlQuote(string(locJSON)),
			cookingTime,
			sqlQuote(difficulty),
			imgSQL,
		))

		// 3. Recipe Ingredients
		for idx, ing := range r.Translated.Ingredients {
			nameRu := strings.ToLower(strings.TrimSpace(ing.RussianName))
			if nameRu == "" {
				continue
			}

			dispEn := ""
			extIdx := int(ing.ID) - 1
			if extIdx >= 0 && extIdx < len(r.External.Ingredients) {
				dispEn = strings.TrimSpace(r.External.Ingredients[extIdx].Measure + " " + r.External.Ingredients[extIdx].Name)
			} else if idx < len(r.External.Ingredients) {
				dispEn = strings.TrimSpace(r.External.Ingredients[idx].Measure + " " + r.External.Ingredients[idx].Name)
			}

			dispEnSQL := "NULL"
			if dispEn != "" {
				dispEnSQL = sqlQuote(dispEn)
			}
			locDispSQL := "NULL"
			if ing.LocalizedDisplayText != "" {
				locDispSQL = sqlQuote(ing.LocalizedDisplayText)
			}

			sb.WriteString(fmt.Sprintf(`INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, %s, %s, 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = %s AND LOWER(i.name) = %s
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
`,
				dispEnSQL,
				locDispSQL,
				sqlQuote(r.External.ExternalID),
				sqlQuote(nameRu),
			))
		}
		sb.WriteString("\n")
	}

	return sb.String()
}

func generateDownSQL(recipes []PreparedRecipe) string {
	var sb strings.Builder
	sb.WriteString("-- 000005_seed_recipes.down.sql\n")
	sb.WriteString(fmt.Sprintf("-- Remove %d seeded recipes\n\n", len(recipes)))

	extIDs := make([]string, len(recipes))
	for i, r := range recipes {
		extIDs[i] = sqlQuote(r.External.ExternalID)
	}

	sb.WriteString(fmt.Sprintf("DELETE FROM recipes WHERE external_id IN (%s);\n", strings.Join(extIDs, ", ")))
	return sb.String()
}

func init() {
	_ = time.Second
	_ = context.Background
}
