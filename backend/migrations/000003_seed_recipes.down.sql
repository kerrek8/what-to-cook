-- 000003_seed_recipes.down.sql
DELETE FROM recipe_ingredients WHERE recipe_id BETWEEN 1 AND 37;
DELETE FROM recipes WHERE id BETWEEN 1 AND 37;
