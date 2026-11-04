-- 000006_russian_categories_and_units.down.sql

UPDATE ingredients SET category = CASE category
    WHEN 'Специи' THEN 'spices'
    WHEN 'Овощи и зелень' THEN 'vegetables'
    WHEN 'Мясо и птица' THEN 'meat'
    WHEN 'Молочные продукты' THEN 'dairy'
    WHEN 'Крупы и мука' THEN 'grains'
    WHEN 'Рыба и морепродукты' THEN 'fish'
    WHEN 'Фрукты' THEN 'fruits'
    WHEN 'Другое' THEN 'other'
    ELSE category
END;

UPDATE ingredients SET default_unit = CASE default_unit
    WHEN 'шт' THEN 'pcs'
    WHEN 'г' THEN 'g'
    WHEN 'мл' THEN 'ml'
    WHEN 'кг' THEN 'kg'
    WHEN 'л' THEN 'l'
    ELSE default_unit
END;

UPDATE recipe_ingredients SET unit = CASE unit
    WHEN 'шт' THEN 'pcs'
    WHEN 'г' THEN 'g'
    WHEN 'мл' THEN 'ml'
    WHEN 'кг' THEN 'kg'
    WHEN 'л' THEN 'l'
    ELSE unit
END;
