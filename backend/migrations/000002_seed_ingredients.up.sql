-- Seed ingredients catalog
INSERT INTO ingredients (name, name_en, category, default_unit, is_pantry_essential) VALUES
-- Базовая корзина (Pantry Essentials)
('соль', 'Salt', 'spices', 'g', TRUE),
('сахар', 'Sugar', 'spices', 'g', TRUE),
('вода питьевая', 'Water', 'other', 'ml', TRUE),
('масло растительное', 'Vegetable Oil', 'spices', 'ml', TRUE),
('масло сливочное', 'Butter', 'dairy', 'g', TRUE),
('перец черный молотый', 'Black Pepper', 'spices', 'g', TRUE),
('мука пшеничная', 'Wheat Flour', 'grains', 'g', TRUE),

-- Овощи и зелень (Vegetables & Herbs)
('картофель', 'Potato', 'vegetables', 'g', FALSE),
('лук репчатый', 'Onion', 'vegetables', 'g', FALSE),
('морковь', 'Carrot', 'vegetables', 'g', FALSE),
('чеснок', 'Garlic', 'vegetables', 'g', FALSE),
('помидоры', 'Tomato', 'vegetables', 'g', FALSE),
('огурцы', 'Cucumber', 'vegetables', 'g', FALSE),
('капуста белокочанная', 'Cabbage', 'vegetables', 'g', FALSE),
('перец болгарский', 'Bell Pepper', 'vegetables', 'g', FALSE),
('кабачок', 'Zucchini', 'vegetables', 'g', FALSE),
('баклажан', 'Eggplant', 'vegetables', 'g', FALSE),
('свекла', 'Beetroot', 'vegetables', 'g', FALSE),
('брокколи', 'Broccoli', 'vegetables', 'g', FALSE),
('цветная капуста', 'Cauliflower', 'vegetables', 'g', FALSE),
('шампиньоны', 'Champignons', 'vegetables', 'g', FALSE),
('укроп', 'Dill', 'vegetables', 'g', FALSE),
('петрушка', 'Parsley', 'vegetables', 'g', FALSE),
('зеленый лук', 'Green Onion', 'vegetables', 'g', FALSE),
('листья салата', 'Lettuce', 'vegetables', 'g', FALSE),
('шпинат', 'Spinach', 'vegetables', 'g', FALSE),

-- Мясо и птица (Meat & Poultry)
('куриное филе', 'Chicken Breast', 'meat', 'g', FALSE),
('куриные бедра', 'Chicken Thighs', 'meat', 'g', FALSE),
('говядина', 'Beef', 'meat', 'g', FALSE),
('свинина', 'Pork', 'meat', 'g', FALSE),
('фарш домашний', 'Mixed Minced Meat', 'meat', 'g', FALSE),
('фарш говяжий', 'Beef Mince', 'meat', 'g', FALSE),
('фарш куриный', 'Chicken Mince', 'meat', 'g', FALSE),
('бекон', 'Bacon', 'meat', 'g', FALSE),
('индейка филе', 'Turkey Breast', 'meat', 'g', FALSE),
('сосиски', 'Sausages', 'meat', 'g', FALSE),

-- Молочные продукты и яйца (Dairy & Eggs)
('яйца куриные', 'Eggs', 'dairy', 'pcs', FALSE),
('молоко', 'Milk', 'dairy', 'ml', FALSE),
('сыр твердый', 'Hard Cheese', 'dairy', 'g', FALSE),
('сыр моцарелла', 'Mozzarella', 'dairy', 'g', FALSE),
('творог', 'Cottage Cheese', 'dairy', 'g', FALSE),
('сметана', 'Sour Cream', 'dairy', 'g', FALSE),
('кефир', 'Kefir', 'dairy', 'ml', FALSE),
('сливки', 'Cream', 'dairy', 'ml', FALSE),
('йогурт натуральный', 'Plain Yogurt', 'dairy', 'g', FALSE),
('майонез', 'Mayonnaise', 'dairy', 'g', FALSE),

-- Крупы, бобовые и макароны (Grains & Pasta)
('рис круглозерный', 'Round Rice', 'grains', 'g', FALSE),
('рис длиннозерный', 'Long Grain Rice', 'grains', 'g', FALSE),
('гречневая крупа', 'Buckwheat', 'grains', 'g', FALSE),
('овсяные хлопья', 'Oatmeal', 'grains', 'g', FALSE),
('макароны', 'Pasta', 'grains', 'g', FALSE),
('спагетти', 'Spaghetti', 'grains', 'g', FALSE),
('манная крупа', 'Semolina', 'grains', 'g', FALSE),
('фасоль консервированная', 'Canned Beans', 'grains', 'g', FALSE),
('горошек консервированный', 'Canned Green Peas', 'grains', 'g', FALSE),
('кукуруза консервированная', 'Canned Sweet Corn', 'grains', 'g', FALSE),

-- Рыба и морепродукты (Fish & Seafood)
('филе лосося', 'Salmon Fillet', 'fish', 'g', FALSE),
('минтай филе', 'Pollock Fillet', 'fish', 'g', FALSE),
('треска филе', 'Cod Fillet', 'fish', 'g', FALSE),
('тунец консервированный', 'Canned Tuna', 'fish', 'g', FALSE),
('креветки', 'Shrimp', 'fish', 'g', FALSE),
('крабовые палочки', 'Crab Sticks', 'fish', 'g', FALSE),

-- Фрукты (Fruits)
('яблоки', 'Apples', 'fruits', 'g', FALSE),
('бананы', 'Bananas', 'fruits', 'g', FALSE),
('лимон', 'Lemon', 'fruits', 'g', FALSE),
('апельсины', 'Oranges', 'fruits', 'g', FALSE),

-- Соусы и приправы (Sauces & Spices)
('томатная паста', 'Tomato Paste', 'spices', 'g', FALSE),
('соевый соус', 'Soy Sauce', 'spices', 'ml', FALSE),
('лавровый лист', 'Bay Leaf', 'spices', 'pcs', FALSE),
('паприка молотая', 'Ground Paprika', 'spices', 'g', FALSE),
('кориандр молотый', 'Ground Coriander', 'spices', 'g', FALSE),
('горчица', 'Mustard', 'spices', 'g', FALSE),
('мед', 'Honey', 'spices', 'g', FALSE),
('дрожжи сухие', 'Dry Yeast', 'bakery', 'g', FALSE),
('уксус столовый', 'Table Vinegar', 'spices', 'ml', FALSE)
ON CONFLICT (name) DO NOTHING;
