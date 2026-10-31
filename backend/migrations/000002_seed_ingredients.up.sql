-- Seed ingredients catalog
INSERT INTO ingredients (name, name_en, category, default_unit, is_pantry_essential) VALUES
-- Базовая корзина (Pantry Essentials)
('Соль', 'Salt', 'spices', 'g', TRUE),
('Сахар', 'Sugar', 'spices', 'g', TRUE),
('Вода питьевая', 'Water', 'other', 'ml', TRUE),
('Масло растительное', 'Vegetable Oil', 'spices', 'ml', TRUE),
('Масло сливочное', 'Butter', 'dairy', 'g', TRUE),
('Перец черный молотый', 'Black Pepper', 'spices', 'g', TRUE),
('Мука пшеничная', 'Wheat Flour', 'grains', 'g', TRUE),

-- Овощи и зелень (Vegetables & Herbs)
('Картофель', 'Potato', 'vegetables', 'g', FALSE),
('Лук репчатый', 'Onion', 'vegetables', 'g', FALSE),
('Морковь', 'Carrot', 'vegetables', 'g', FALSE),
('Чеснок', 'Garlic', 'vegetables', 'g', FALSE),
('Помидоры', 'Tomato', 'vegetables', 'g', FALSE),
('Огурцы', 'Cucumber', 'vegetables', 'g', FALSE),
('Капуста белокочанная', 'Cabbage', 'vegetables', 'g', FALSE),
('Перец болгарский', 'Bell Pepper', 'vegetables', 'g', FALSE),
('Кабачок', 'Zucchini', 'vegetables', 'g', FALSE),
('Баклажан', 'Eggplant', 'vegetables', 'g', FALSE),
('Свекла', 'Beetroot', 'vegetables', 'g', FALSE),
('Брокколи', 'Broccoli', 'vegetables', 'g', FALSE),
('Цветная капуста', 'Cauliflower', 'vegetables', 'g', FALSE),
('Шампиньоны', 'Champignons', 'vegetables', 'g', FALSE),
('Укроп', 'Dill', 'vegetables', 'g', FALSE),
('Петрушка', 'Parsley', 'vegetables', 'g', FALSE),
('Зеленый лук', 'Green Onion', 'vegetables', 'g', FALSE),
('Листья салата', 'Lettuce', 'vegetables', 'g', FALSE),
('Шпинат', 'Spinach', 'vegetables', 'g', FALSE),

-- Мясо и птица (Meat & Poultry)
('Куриное филе', 'Chicken Breast', 'meat', 'g', FALSE),
('Куриные бедра', 'Chicken Thighs', 'meat', 'g', FALSE),
('Говядина', 'Beef', 'meat', 'g', FALSE),
('Свинина', 'Pork', 'meat', 'g', FALSE),
('Фарш домашний', 'Mixed Minced Meat', 'meat', 'g', FALSE),
('Фарш говяжий', 'Beef Mince', 'meat', 'g', FALSE),
('Фарш куриный', 'Chicken Mince', 'meat', 'g', FALSE),
('Бекон', 'Bacon', 'meat', 'g', FALSE),
('Индейка филе', 'Turkey Breast', 'meat', 'g', FALSE),
('Сосиски', 'Sausages', 'meat', 'g', FALSE),

-- Молочные продукты и яйца (Dairy & Eggs)
('Яйца куриные', 'Eggs', 'dairy', 'pcs', FALSE),
('Молоко', 'Milk', 'dairy', 'ml', FALSE),
('Сыр твердый', 'Hard Cheese', 'dairy', 'g', FALSE),
('Сыр моцарелла', 'Mozzarella', 'dairy', 'g', FALSE),
('Творог', 'Cottage Cheese', 'dairy', 'g', FALSE),
('Сметана', 'Sour Cream', 'dairy', 'g', FALSE),
('Кефир', 'Kefir', 'dairy', 'ml', FALSE),
('Сливки', 'Cream', 'dairy', 'ml', FALSE),
('Йогурт натуральный', 'Plain Yogurt', 'dairy', 'g', FALSE),
('Майонез', 'Mayonnaise', 'dairy', 'g', FALSE),

-- Крупы, бобовые и макароны (Grains & Pasta)
('Рис круглозерный', 'Round Rice', 'grains', 'g', FALSE),
('Рис длиннозерный', 'Long Grain Rice', 'grains', 'g', FALSE),
('Гречневая крупа', 'Buckwheat', 'grains', 'g', FALSE),
('Овсяные хлопья', 'Oatmeal', 'grains', 'g', FALSE),
('Макароны', 'Pasta', 'grains', 'g', FALSE),
('Спагетти', 'Spaghetti', 'grains', 'g', FALSE),
('Манная крупа', 'Semolina', 'grains', 'g', FALSE),
('Фасоль консервированная', 'Canned Beans', 'grains', 'g', FALSE),
('Горошек консервированный', 'Canned Green Peas', 'grains', 'g', FALSE),
('Кукуруза консервированная', 'Canned Sweet Corn', 'grains', 'g', FALSE),

-- Рыба и морепродукты (Fish & Seafood)
('Филе лосося', 'Salmon Fillet', 'fish', 'g', FALSE),
('Минтай филе', 'Pollock Fillet', 'fish', 'g', FALSE),
('Треска филе', 'Cod Fillet', 'fish', 'g', FALSE),
('Тунец консервированный', 'Canned Tuna', 'fish', 'g', FALSE),
('Креветки', 'Shrimp', 'fish', 'g', FALSE),
('Крабовые палочки', 'Crab Sticks', 'fish', 'g', FALSE),

-- Фрукты (Fruits)
('Яблоки', 'Apples', 'fruits', 'g', FALSE),
('Бананы', 'Bananas', 'fruits', 'g', FALSE),
('Лимон', 'Lemon', 'fruits', 'g', FALSE),
('Апельсины', 'Oranges', 'fruits', 'g', FALSE),

-- Соусы и приправы (Sauces & Spices)
('Томатная паста', 'Tomato Paste', 'spices', 'g', FALSE),
('Соевый соус', 'Soy Sauce', 'spices', 'ml', FALSE),
('Лавровый лист', 'Bay Leaf', 'spices', 'pcs', FALSE),
('Паприка молотая', 'Ground Paprika', 'spices', 'g', FALSE),
('Кориандр молотый', 'Ground Coriander', 'spices', 'g', FALSE),
('Горчица', 'Mustard', 'spices', 'g', FALSE),
('Мед', 'Honey', 'spices', 'g', FALSE),
('Дрожжи сухие', 'Dry Yeast', 'bakery', 'g', FALSE),
('Уксус столовый', 'Table Vinegar', 'spices', 'ml', FALSE)
ON CONFLICT (name) DO NOTHING;
