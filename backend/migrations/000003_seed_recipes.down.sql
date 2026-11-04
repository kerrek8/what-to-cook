-- 000003_seed_recipes.down.sql
DELETE FROM recipe_ingredients WHERE recipe_id IN (1, 2, 3, 4, 5);
DELETE FROM recipes WHERE id IN (1, 2, 3, 4, 5);
