-- 000006_russian_categories_and_units.up.sql

UPDATE ingredients SET category = CASE category
    WHEN 'spices' THEN 'Специи'
    WHEN 'vegetables' THEN 'Овощи и зелень'
    WHEN 'meat' THEN 'Мясо и птица'
    WHEN 'dairy' THEN 'Молочные продукты'
    WHEN 'grains' THEN 'Крупы и мука'
    WHEN 'fish' THEN 'Рыба и морепродукты'
    WHEN 'fruits' THEN 'Фрукты'
    WHEN 'other' THEN 'Другое'
    ELSE category
END;

UPDATE ingredients SET default_unit = CASE default_unit
    WHEN 'pcs' THEN 'шт'
    WHEN 'g' THEN 'г'
    WHEN 'ml' THEN 'мл'
    WHEN 'kg' THEN 'кг'
    WHEN 'l' THEN 'л'
    ELSE default_unit
END;

UPDATE recipe_ingredients SET unit = CASE unit
    WHEN 'pcs' THEN 'шт'
    WHEN 'g' THEN 'г'
    WHEN 'ml' THEN 'мл'
    WHEN 'kg' THEN 'кг'
    WHEN 'l' THEN 'л'
    ELSE unit
END;
