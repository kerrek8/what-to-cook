-- 000005_seed_recipes.up.sql
-- Pre-seeded 73 translated recipes with ingredients, localized instructions, cooking time and difficulty

-- 1. Insert any new ingredients used in seeded recipes
INSERT INTO ingredients (name, name_en, category, default_unit, is_pantry_essential) VALUES
('bay leaves', 'Bay Leaves', 'Другое', 'г', FALSE),
('canola oil', 'Canola Oil', 'Другое', 'г', FALSE),
('celery', 'Celery', 'Другое', 'г', FALSE),
('chicken thighs', 'Chicken Thighs', 'Другое', 'г', FALSE),
('chinese five spice powder', 'Chinese five spice powder', 'Другое', 'г', FALSE),
('cinnamon stick', 'Cinnamon Stick', 'Другое', 'г', FALSE),
('cloves', 'Cloves', 'Другое', 'г', FALSE),
('dry sherry', 'Dry sherry', 'Другое', 'г', FALSE),
('egg', 'Egg', 'Другое', 'г', FALSE),
('ground ginger', 'Ground Ginger', 'Другое', 'г', FALSE),
('jasmine rice', 'Jasmine Rice', 'Другое', 'г', FALSE),
('scallions', 'Scallions', 'Другое', 'г', FALSE),
('scotch bonnet', 'Scotch Bonnet', 'Другое', 'г', FALSE),
('авокадо', 'Avocado', 'Другое', 'г', FALSE),
('ананасовые кусочки', 'Pineapple Chunks', 'Другое', 'г', FALSE),
('ананасовый сок', 'Pineapple Juice', 'Другое', 'г', FALSE),
('английская горчица', 'English Mustard', 'Другое', 'г', FALSE),
('апельсиновый сок', 'Orange', 'Другое', 'г', FALSE),
('арахис', 'Peanuts', 'Другое', 'г', FALSE),
('арахисовое масло', 'Peanut Butter', 'Другое', 'г', FALSE),
('багет', 'Baguette', 'Другое', 'г', FALSE),
('базилик', 'Basil', 'Другое', 'г', FALSE),
('бамбуковые стебли', 'Bamboo Shoot', 'Другое', 'г', FALSE),
('банан', 'Banana', 'Другое', 'г', FALSE),
('басмати рис', 'Basmati Rice', 'Другое', 'г', FALSE),
('белая рыба', 'white fish', 'Другое', 'г', FALSE),
('белое вино', 'White Wine', 'Другое', 'г', FALSE),
('белок яйца', 'Egg White', 'Другое', 'г', FALSE),
('белый уксус', 'White Vinegar', 'Другое', 'г', FALSE),
('ванильный экстракт', 'Vanilla Extract', 'Другое', 'г', FALSE),
('винегретный соус', 'Vinaigrette Dressing', 'Другое', 'г', FALSE),
('винный уксус', 'Red Wine Vinegar', 'Другое', 'г', FALSE),
('виноградные помидоры', 'Grape Tomatoes', 'Другое', 'г', FALSE),
('вода', 'Water', 'Другое', 'г', FALSE),
('водяные орехи', 'Water Chestnut', 'Другое', 'г', FALSE),
('все специи', 'allspice', 'Другое', 'г', FALSE),
('всея специи', 'Allspice', 'Другое', 'г', FALSE),
('вяленые помидоры', 'Sun-Dried Tomatoes', 'Другое', 'г', FALSE),
('гарам масала', 'garam masala', 'Другое', 'г', FALSE),
('гарм масала', 'garam masala', 'Другое', 'г', FALSE),
('гвоздика', 'Cloves', 'Другое', 'г', FALSE),
('говядина, фарш', 'Ground Beef', 'Другое', 'г', FALSE),
('говяжий бульон', 'Beef Stock', 'Другое', 'г', FALSE),
('говяжий фарш', 'Minced Beef', 'Другое', 'г', FALSE),
('говяжье филе', 'Beef Fillet', 'Другое', 'г', FALSE),
('горчика дижон', 'Dijon Mustard', 'Другое', 'г', FALSE),
('горчица дижон', 'Dijon Mustard', 'Другое', 'г', FALSE),
('горчичный порошок', 'Mustard Powder', 'Другое', 'г', FALSE),
('горячий говяжий бульон', 'hot beef stock', 'Другое', 'г', FALSE),
('гочуджан', 'Gochujang', 'Другое', 'г', FALSE),
('грецкие орехи', 'Walnuts', 'Другое', 'г', FALSE),
('греческий йогурт', 'Greek Yogurt', 'Другое', 'г', FALSE),
('грибы', 'mushrooms', 'Другое', 'г', FALSE),
('грюйер', 'Gruyere', 'Другое', 'г', FALSE),
('дайкон', 'Daikon Radish', 'Другое', 'г', FALSE),
('двойной крем', 'Double Cream', 'Другое', 'г', FALSE),
('дрожжи', 'Yeast', 'Другое', 'г', FALSE),
('дымный айоли', 'Smoky Aïoli', 'Другое', 'г', FALSE),
('жареные бобы', 'Refried Beans', 'Другое', 'г', FALSE),
('жареный перец', 'Roasted pepper', 'Другое', 'г', FALSE),
('жасминовый рис', 'Jasmine Rice', 'Другое', 'г', FALSE),
('желтки яиц', 'Egg Yolks', 'Другое', 'г', FALSE),
('желтый болгарский перец', 'Yellow Pepper', 'Другое', 'г', FALSE),
('желтый перец', 'Yellow Pepper', 'Другое', 'г', FALSE),
('зеленая сальса', 'Green Salsa', 'Другое', 'г', FALSE),
('зеленая фасоль', 'Green Beans', 'Другое', 'г', FALSE),
('зеленые оливки', 'Green Olives', 'Другое', 'г', FALSE),
('зеленый горошек', 'Peas', 'Другое', 'г', FALSE),
('зеленый перец', 'Green Pepper', 'Другое', 'г', FALSE),
('зеленый перец чили', 'Green Chilli', 'Другое', 'г', FALSE),
('зеленый чили', 'Green Chilli', 'Другое', 'г', FALSE),
('зелёный лук', 'Spring Onions', 'Другое', 'г', FALSE),
('измельчённый чеснок', 'minced garlic', 'Другое', 'г', FALSE),
('изюм', 'Raisins', 'Другое', 'г', FALSE),
('имбирная паста', 'Ginger Paste', 'Другое', 'г', FALSE),
('имбирный сироп', 'Ginger Cordial', 'Другое', 'г', FALSE),
('имбирь', 'Ginger', 'Другое', 'г', FALSE),
('итальянская приправа', 'italian seasoning', 'Другое', 'г', FALSE),
('каджун', 'cajun', 'Другое', 'г', FALSE),
('кайненский перец', 'Cayenne Pepper', 'Другое', 'г', FALSE),
('капуста', 'Cabbage', 'Другое', 'г', FALSE),
('кардамон', 'Cardamom', 'Другое', 'г', FALSE),
('карри порошок', 'Curry Powder', 'Другое', 'г', FALSE),
('картофель джерси роял', 'Jersey Royal Potatoes', 'Другое', 'г', FALSE),
('касава', 'Cassava', 'Другое', 'г', FALSE),
('кинза', 'Coriander', 'Другое', 'г', FALSE),
('киноа', 'Quinoa', 'Другое', 'г', FALSE),
('кокосовое молоко', 'Coconut Milk', 'Другое', 'г', FALSE),
('кокосовый крем', 'Coconut cream', 'Другое', 'г', FALSE),
('консервированные помидоры', 'Tinned Tomatos', 'Другое', 'г', FALSE),
('консервированные томаты', 'tomatoes', 'Другое', 'г', FALSE),
('копченая паприка', 'Smoked Paprika', 'Другое', 'г', FALSE),
('копченая треска', 'Smoked Haddock', 'Другое', 'г', FALSE),
('кориандр', 'Coriander', 'Другое', 'г', FALSE),
('корица', 'Cinnamon', 'Другое', 'г', FALSE),
('коричневый рис', 'brown rice', 'Другое', 'г', FALSE),
('коричневый сахар', 'Brown Sugar', 'Другое', 'г', FALSE),
('королевские креветки', 'King Prawns', 'Другое', 'г', FALSE),
('кошерная соль', 'Kosher Salt', 'Другое', 'г', FALSE),
('красная карри паста', 'Red Curry Paste', 'Другое', 'г', FALSE),
('красная паприка', 'Red Pepper', 'Другое', 'г', FALSE),
('красное вино', 'Red Wine', 'Другое', 'г', FALSE),
('красные хлопья перца', 'red chilli flakes', 'Другое', 'г', FALSE),
('красный болгарский перец', 'Red Pepper', 'Другое', 'г', FALSE),
('красный лук', 'Red Onions', 'Другое', 'г', FALSE),
('красный перец', 'Red Pepper', 'Другое', 'г', FALSE),
('красный перец кайенский', 'cayenne pepper', 'Другое', 'г', FALSE),
('красный перец чили', 'Red Chilli', 'Другое', 'г', FALSE),
('красный сладкий перец', 'Red Pepper', 'Другое', 'г', FALSE),
('красный чили', 'Red Chilli', 'Другое', 'г', FALSE),
('крем‑фреш', 'Creme Fraiche', 'Другое', 'г', FALSE),
('кристаллический сахар', 'Caster Sugar', 'Другое', 'г', FALSE),
('крошки сыра', 'Cheese Curds', 'Другое', 'г', FALSE),
('кукуруза', 'Sweetcorn', 'Другое', 'г', FALSE),
('кукурузные тортильи', 'corn tortillas', 'Другое', 'г', FALSE),
('кукурузный крахмал', 'Starch', 'Другое', 'г', FALSE),
('кумин', 'Cumin Seeds', 'Другое', 'г', FALSE),
('кунжутное масло', 'Sesame Seed Oil', 'Другое', 'г', FALSE),
('куриная грудка', 'Chicken Breast', 'Другое', 'г', FALSE),
('куриные грудки', 'Chicken Breasts', 'Другое', 'г', FALSE),
('куриные крылья', 'Chicken Wings', 'Другое', 'г', FALSE),
('куриные ножки', 'Chicken drumsticks', 'Другое', 'г', FALSE),
('куриный бульон', 'Chicken Stock', 'Другое', 'г', FALSE),
('куриный бульонный кубик', 'Chicken Stock Cube', 'Другое', 'г', FALSE),
('курица', 'Chicken', 'Другое', 'г', FALSE),
('куркума', 'Turmeric', 'Другое', 'г', FALSE),
('кускус', 'Couscous', 'Другое', 'г', FALSE),
('лайм', 'Lime', 'Другое', 'г', FALSE),
('лайм каффир', 'Kaffir Lime Leaves', 'Другое', 'г', FALSE),
('лапша лингвини', 'Linguine Pasta', 'Другое', 'г', FALSE),
('лемонграсс', 'Lemongrass', 'Другое', 'г', FALSE),
('лимонная трава', 'Lemongrass Stalks', 'Другое', 'г', FALSE),
('лимонный сок', 'Lemon Juice', 'Другое', 'г', FALSE),
('лист лазаньи', 'Lasagne Sheets', 'Другое', 'г', FALSE),
('лист лайма', 'Lime', 'Другое', 'г', FALSE),
('листья базилика', 'Basil Leaves', 'Другое', 'г', FALSE),
('листья лайма', 'Lime Leaves', 'Другое', 'г', FALSE),
('лосось', 'Salmon', 'Другое', 'г', FALSE),
('лук', 'Onion', 'Другое', 'г', FALSE),
('лук-шалот', 'Leek', 'Другое', 'г', FALSE),
('луковая соль', 'Onion Salt', 'Другое', 'г', FALSE),
('малина', 'Raspberries', 'Другое', 'г', FALSE),
('маржорама', 'marjoram', 'Другое', 'г', FALSE),
('масло', 'Oil', 'Другое', 'г', FALSE),
('масло для жарки', 'Oil', 'Другое', 'г', FALSE),
('масло из кунжута', 'Sesame Seed Oil', 'Другое', 'г', FALSE),
('масляная фасоль', 'Butter Beans', 'Другое', 'г', FALSE),
('мексиканский сыр', 'Shredded Mexican Cheese', 'Другое', 'г', FALSE),
('миндаль', 'Almonds', 'Другое', 'г', FALSE),
('молодой горошек', 'Bean Sprouts', 'Другое', 'г', FALSE),
('молотая гвоздика', 'Allspice', 'Другое', 'г', FALSE),
('молотый имбирь', 'ground ginger', 'Другое', 'г', FALSE),
('молотый кумин', 'Ground Cumin', 'Другое', 'г', FALSE),
('морская соль', 'Sea Salt', 'Другое', 'г', FALSE),
('моцарелла', 'Mozzarella Balls', 'Другое', 'г', FALSE),
('мука', 'Flour', 'Другое', 'г', FALSE),
('мускатный орех', 'Nutmeg', 'Другое', 'г', FALSE),
('мята', 'Mint', 'Другое', 'г', FALSE),
('мёд', 'Honey', 'Другое', 'г', FALSE),
('нарезанные помидоры', 'chopped tomatoes', 'Другое', 'г', FALSE),
('нут', 'Chickpeas', 'Другое', 'г', FALSE),
('овощной бульон', 'Vegetable Stock', 'Другое', 'г', FALSE),
('огурец', 'Cucumber', 'Другое', 'г', FALSE),
('оливковое масло', 'Olive Oil', 'Другое', 'г', FALSE),
('оливковое масло первого отжима', 'Extra Virgin Olive Oil', 'Другое', 'г', FALSE),
('оливковое масло первого сорта', 'Extra Virgin Olive Oil', 'Другое', 'г', FALSE),
('орегано', 'oregano', 'Другое', 'г', FALSE),
('орех пекан', 'Pecan Nuts', 'Другое', 'г', FALSE),
('острые перцы', 'Birds-eye Chillies', 'Другое', 'г', FALSE),
('панировочные сухари', 'breadcrumbs', 'Другое', 'г', FALSE),
('паприка', 'paprika', 'Другое', 'г', FALSE),
('пармезан', 'Parmigiano-Reggiano', 'Другое', 'г', FALSE),
('пармская ветчина', 'Parma ham', 'Другое', 'г', FALSE),
('пассата', 'Passata', 'Другое', 'г', FALSE),
('паста галангала', 'Galangal Paste', 'Другое', 'г', FALSE),
('паста массаман', 'Massaman curry paste', 'Другое', 'г', FALSE),
('паста тамаринд', 'Tamarind paste', 'Другое', 'г', FALSE),
('пене ригате', 'penne rigate', 'Другое', 'г', FALSE),
('перец', 'Pepper', 'Другое', 'г', FALSE),
('перец скоут-бонет', 'Scotch Bonnet', 'Другое', 'г', FALSE),
('перец чили', 'Chilli', 'Другое', 'г', FALSE),
('пинто фасоль', 'Pinto Beans', 'Другое', 'г', FALSE),
('пита', 'Pita Bread', 'Другое', 'г', FALSE),
('подсолнечное масло', 'Sunflower Oil', 'Другое', 'г', FALSE),
('помидор', 'Tomato', 'Другое', 'г', FALSE),
('помидоры черри', 'Cherry Tomatoes', 'Другое', 'г', FALSE),
('порей', 'Leek', 'Другое', 'г', FALSE),
('порошок чили', 'Chilli Powder', 'Другое', 'г', FALSE),
('постный фарш из говядины', 'lean minced beef', 'Другое', 'г', FALSE),
('приправы джерк', 'Jerk', 'Другое', 'г', FALSE),
('приправы для фахитас', 'fajita seasoning', 'Другое', 'г', FALSE),
('пшеничная мука', 'Plain Flour', 'Другое', 'г', FALSE),
('разрыхлитель', 'Baking Powder', 'Другое', 'г', FALSE),
('рапсовое масло', 'Rapeseed Oil', 'Другое', 'г', FALSE),
('растительное масло', 'Vegetable Oil', 'Другое', 'г', FALSE),
('рис', 'Rice', 'Другое', 'г', FALSE),
('рис басмати', 'Basmati Rice', 'Другое', 'г', FALSE),
('рисовые лапши', 'Rice Noodles', 'Другое', 'г', FALSE),
('рисовый уксус', 'Rice Vinegar', 'Другое', 'г', FALSE),
('розмарин', 'Rosemary', 'Другое', 'г', FALSE),
('рыбный соус', 'Fish Sauce', 'Другое', 'г', FALSE),
('саке', 'Sake', 'Другое', 'г', FALSE),
('салат', 'Lettuce', 'Другое', 'г', FALSE),
('салат little gem', 'little gem lettuce', 'Другое', 'г', FALSE),
('сало', 'Lard', 'Другое', 'г', FALSE),
('сальса', 'salsa', 'Другое', 'г', FALSE),
('сахар-песок', 'Caster Sugar', 'Другое', 'г', FALSE),
('сахарные горошины', 'Sugar Snap Peas', 'Другое', 'г', FALSE),
('свежий сыр', 'Fromage Frais', 'Другое', 'г', FALSE),
('свиной соус', 'Duck Sauce', 'Другое', 'г', FALSE),
('сельдерей', 'Celery', 'Другое', 'г', FALSE),
('сельдь', 'Herring', 'Другое', 'г', FALSE),
('семена фенхеля', 'Fennel Seeds', 'Другое', 'г', FALSE),
('сладкая копченая паприка', 'sweet smoked paprika', 'Другое', 'г', FALSE),
('сладкий картофель', 'Sweet Potatoes', 'Другое', 'г', FALSE),
('сладкий чили соус', 'sweet chilli sauce', 'Другое', 'г', FALSE),
('сладко-острый соус', 'sweet chilli sauce', 'Другое', 'г', FALSE),
('сливочное масло', 'Butter', 'Другое', 'г', FALSE),
('слоеное тесто', 'Puff Pastry', 'Другое', 'г', FALSE),
('смешанные овощи для жарки', 'stir-fry vegetables', 'Другое', 'г', FALSE),
('сок лайма', 'Lime', 'Другое', 'г', FALSE),
('соль из лука', 'onion salt', 'Другое', 'г', FALSE),
('соль из сельдерея', 'celery salt', 'Другое', 'г', FALSE),
('соус вустерширский', 'worcestershire sauce', 'Другое', 'г', FALSE),
('соус энчилада', 'Enchilada sauce', 'Другое', 'г', FALSE),
('специя кабсе', 'Kabse Spice', 'Другое', 'г', FALSE),
('специя харица', 'Harissa Spice', 'Другое', 'г', FALSE),
('срирача', 'Sriracha', 'Другое', 'г', FALSE),
('сухие абрикосы', 'Dried Apricots', 'Другое', 'г', FALSE),
('сухое белое вино', 'Dry White Wine', 'Другое', 'г', FALSE),
('сушёный орегано', 'dried oregano', 'Другое', 'г', FALSE),
('сыр', 'Cheese', 'Другое', 'г', FALSE),
('сыр грюйер', 'Gruyere cheese', 'Другое', 'г', FALSE),
('сыр монтерей джек', 'shredded Monterey Jack cheese', 'Другое', 'г', FALSE),
('сыр чеддер', 'cheddar cheese', 'Другое', 'г', FALSE),
('тайская красная паста карри', 'Thai Red Curry Paste', 'Другое', 'г', FALSE),
('тайский зеленый карри паста', 'Thai Green Curry Paste', 'Другое', 'г', FALSE),
('тайский красный карри паста', 'Thai Red Curry Paste', 'Другое', 'г', FALSE),
('тамариндовая паста', 'Tamarind Paste', 'Другое', 'г', FALSE),
('тимьян', 'Thyme', 'Другое', 'г', FALSE),
('тмин', 'Cumin', 'Другое', 'г', FALSE),
('томатное пюре', 'Tomato Puree', 'Другое', 'г', FALSE),
('томатный кетчуп', 'Tomato Ketchup', 'Другое', 'г', FALSE),
('томаты в собственном соку', 'Chopped Tomatoes', 'Другое', 'г', FALSE),
('тортилья для тако', 'Hard Taco Shells', 'Другое', 'г', FALSE),
('тортилья из пшеничной муки', 'flour tortilla', 'Другое', 'г', FALSE),
('треска', 'Haddock', 'Другое', 'г', FALSE),
('тупой хлеб', 'Stale bread', 'Другое', 'г', FALSE),
('универсальная приправа', 'All-purpose Seasoning', 'Другое', 'г', FALSE),
('устрицовые грибы', 'Oyster Mushrooms', 'Другое', 'г', FALSE),
('фасоль', 'Kidney Beans', 'Другое', 'г', FALSE),
('фенхель', 'Fennel', 'Другое', 'г', FALSE),
('фета', 'Feta', 'Другое', 'г', FALSE),
('халапеньо', 'Jalapeno', 'Другое', 'г', FALSE),
('хлеб', 'Bread', 'Другое', 'г', FALSE),
('хлопья красного перца', 'Red Pepper Flakes', 'Другое', 'г', FALSE),
('цедра апельсина', 'Orange', 'Другое', 'г', FALSE),
('цукини', 'Courgettes', 'Другое', 'г', FALSE),
('чеддер', 'Cheddar Cheese', 'Другое', 'г', FALSE),
('чернослив', 'Prunes', 'Другое', 'г', FALSE),
('черные оливки', 'Black Olives', 'Другое', 'г', FALSE),
('черный перец', 'black pepper', 'Другое', 'г', FALSE),
('черри томаты', 'Cherry Tomatoes', 'Другое', 'г', FALSE),
('черри-помидоры', 'Cherry Tomatoes', 'Другое', 'г', FALSE),
('чесночный порошок', 'garlic powder', 'Другое', 'г', FALSE),
('чечевица', 'Lentils', 'Другое', 'г', FALSE),
('чили', 'chilli', 'Другое', 'г', FALSE),
('чили порошок', 'chili powder', 'Другое', 'г', FALSE),
('чили хлопья', 'Chilli Flakes', 'Другое', 'г', FALSE),
('чоризо', 'Chorizo', 'Другое', 'г', FALSE),
('чёрный перец', 'Black Pepper', 'Другое', 'г', FALSE),
('шалот', 'Shallots', 'Другое', 'г', FALSE),
('шалфей', 'sage', 'Другое', 'г', FALSE),
('шафран', 'Saffron', 'Другое', 'г', FALSE),
('яблочный уксус', 'Apple Cider Vinegar', 'Другое', 'г', FALSE),
('яичные желтки', 'Egg Yolks', 'Другое', 'г', FALSE),
('яичный белок', 'Egg White', 'Другое', 'г', FALSE),
('яйца', 'Eggs', 'Другое', 'г', FALSE),
('яйца желтки', 'Egg Yolks', 'Другое', 'г', FALSE),
('яйцо', 'Egg', 'Другое', 'г', FALSE)
ON CONFLICT (name) DO NOTHING;

-- 2. Insert recipes and recipe ingredients
INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53261', 'Chicken wings with cumin, lemon & garlic', 'Chicken', '["step 1","Using a pair of sharp kitchen scissors, cut each wing at the knuckle into two pieces. Mix the garlic, lemon zest and juice, cumin and oil with plenty of seasoning, then tip into a dish with the chicken wings and toss to coat. Cover and put in the fridge to marinate for at least 1 hr, or overnight if you have time.","step 2","Heat oven to 200C/180C fan/gas 6, or heat an outdoor barbecue. Bake the chicken wings on an oven tray for 45-50 mins until crisp, or barbecue for 20 mins, drizzling over the honey for the final 10 mins of each method. Serve on a platter with plenty of paper napkins. Fill small bowls with olives, pistachios or almonds, dates and pickled chillies and flatbreads to serve alongside, along with the dishes below."]'::jsonb,
    'Куриные крылья с кумином, лимоном и чесноком', 'Курица', '["Используйте острые кухонные ножницы, разрежьте каждое крыло в суставе на две части. Смешайте чеснок, цедру и сок лимона, кумин и масло с щедрой приправой, затем переложите в миску с куриными крыльями и перемешайте, чтобы покрыть. Накройте и поместите в холодильник минимум 1 час, либо на ночь, если есть время.","Разогрейте духовку до 200 °C (180 °C с вентилятором) или газовой печи 6, либо разогрейте гриль на открытом воздухе. Запекайте куриные крылья на противне 45–50 минут до хрустящей корочки, либо жарьте на гриле 20 минут, поливая медом в течение последних 10 минут каждого метода. Подавайте на блюде с большим количеством бумажных салфеток. В небольшие миски положите оливки, фисташки или миндаль, финики и маринованные перцы, а также лепешки, чтобы подавать вместе с основным блюдом."]'::jsonb,
    130, 'medium', 'https://www.themealdb.com/images/media/meals/4hzyvq1763792564.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '12 Chicken Wings', '12 куриных крыльев', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'куриные крылья'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves minced Garlic', '2 зубчика чеснока, измельчённые', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Zest and juice of 1 Lemon', 'цедра и сок 1 лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Cumin Seeds', '1 чайная ложка семян кумина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'кумин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Olive Oil', '2 столовые ложки оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Honey', '1 столовая ложка меда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53261' AND LOWER(i.name) = 'мед'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53143', 'Easy Spanish chicken', 'Chicken', '["step 1","Heat the oven to 200C/180C fan/gas 6. Heat the olive oil in a large ovenproof frying pan over a medium heat and fry the onion, chorizo and peppers along with a pinch of salt and pepper for 15 mins until the veg has softened and the chorizo has released its oils. Add the paprika and garlic, and cook for another few minutes until fragrant.","step 2","Tip in the chopped tomatoes, olives and butter beans, stir to combine and season. Nestle in the chicken thighs and season well. Transfer to the oven and bake for 40 mins until the chicken skin is crisp and the meat cooked through and tender. Scatter with the parsley and serve.","Watch after ad (0.04):","3 Budget Egg Ideas"]'::jsonb,
    'Курица по-испански', 'Блюдо из курицы', '["Разогрейте духовку до 200 °C.","Нагрейте оливковое масло первого отжима в большой жаропрочной сковороде на среднем огне и обжарьте луковицу, чоризо и перцы, приправив щепоткой соли и перца, 15 минут, пока овощи не размягчатся, а чоризо не выделит жир.","Добавьте паприку и чеснок, готовьте ещё несколько минут до появления аромата.","Выложите нарезанные помидоры, зеленые оливки и масляную фасоль, перемешайте и приправьте.","Вставьте куриные бедра, приправьте хорошо.","Переложите в духовку и запекайте 40 минут, пока кожа курицы не станет хрустящей, а мясо полностью пропечется и станет нежным.","Посыпьте петрушкой и подавайте."]'::jsonb,
    80, 'easy', 'https://www.themealdb.com/images/media/meals/kzxflc1763194887.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbsp Extra Virgin Olive Oil', '2 ст.л. оливкового масла первого отжима', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'оливковое масло первого отжима'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Onion', '1 луковица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150g Chorizo', '150 г чоризо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'чоризо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Red Pepper', '1 красный перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Yellow Pepper', '1 желтый перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'желтый перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon sweet smoked paprika', '1 ч.л. сладкой копченой паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'сладкая копченая паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cloves Garlic', '4 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Tinned Tomatos', '400 г консервированных помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'консервированные помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150g Green Olives', '150 г зеленых оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'зеленые оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Butter Beans', '400 г масляной фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'масляная фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken Thighs', '8 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Handfull Parsley', '1 горсть петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53143' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53162', 'Pollo en pepitoria', 'Chicken', '["step 1","Put the saffron in a small bowl with 75ml of just-boiled water. Stir and set aside. Heat 2 tbsp of the oil in a broad, shallow casserole dish. Cook the garlic until pale gold in colour, then add the blanched almonds and bread, and continue to fry until everything is golden. Tip into a food processor with some salt and pepper and the parsley, and whizz together.","step 2","Heat 2 more tbsp of the oil in the pan and brown the chicken all over, seasoning as you cook. Put in a bowl and set aside.","step 3","Remove all but about 2 tbsp of chicken fat from the pan and cook the onion, carrot and celery until golden. Add the sherry, stirring to dislodge any brown bits that have stuck to the pan. Pour in the stock and the saffron (with its water), and bring to the boil, then turn the heat down to a simmer. Add the spices and bay leaves, and put the chicken back in the pan with any juices. Season and gently cook the chicken for about 40 mins with the lid on.","step 4","Transfer the chicken to a bowl again, leaving the sauce in the pan, and cover with foil to keep warm. Remove the yolks from the eggs and roughly chop the whites. Mash the egg yolks in a small bowl and gradually mix in a couple of tbsp of the sauce. Bring the remaining sauce to the boil to reduce a bit (you want it to just coat the chicken), then turn the heat down. Remove the bay and cinnamon stick. Add the egg yolks and cook for a few mins until the mixture has thickened. Stir in the almond mixture that you made earlier (this will thicken the sauce, too). Put the chicken back in the pan and heat it for about 3 mins, spooning the sauce over it. Season to taste.","step 5","Scatter over the extra parsley, the almonds pieces and the chopped egg whites (if you’re going to use them). You can serve this straight from the dish with some rice, if you like."]'::jsonb,
    'Курица в пепитории', 'Блюдо из курицы', '["В небольшой миске растворите щепот��у шафрана в 75 мл только что закипелой воды. Перемешайте и отложите в сторону.","В широкую, неглубокую кастрюлю налейте 60 мл оливкового масла первого сорта и разогрейте. Обжарьте чеснок до светло-золотистого цвета, затем добавьте обжаренные миндаль и хлеб, продолжайте жарить до золотистого цвета. Переложите смесь в кухонный комбайн, добавьте щепотку гвоздики, лавровые листья, соль и перец, а также петрушку, и взбейте до однородности.","В той же кастрюле разогрейте еще 30 мл масла и обжарьте куриные бедра со всех сторон до румяной корочки, приправляя по вкусу. Переложите курицу в миску и отложите.","Снимите из кастрюли лишний жир, оставив около 30 мл, и обжарьте лук, морковь и сельдерей до золотистого цвета. Добавьте херес, помешивая, чтобы удалить пригоревшие кусочки. Влейте куриный бульон и растворенный шафран, доведите до кипения, затем уменьшите огонь до медленного кипения. Добавьте специи и лавровые листья, верните курицу в кастрюлю с соками. Приправьте и тушите под крышкой около 40 минут.","Переложите курицу обратно в миску, оставив соус в кастрюле, и накройте фольгой, чтобы держать тепло. В отдельной миске взбейте желтки, добавьте пару столовых ложек соуса и постепенно перемешайте. Доведите оставшийся соус до кипения, чтобы он слегка уменьшился. Удалите лавровый лист и палочку корицы. Добавьте желтки и готовьте несколько минут, пока смесь не загустеет. Вмешайте миндальную смесь, которую вы приготовили ранее, чтобы соус загустел. Верните курицу в кастрюлю, прогрейте около 3 м��нут, поливая соусом. Приправьте по вкусу.","Посыпьте сверху дополнительной петрушкой, кусочками миндаля и нарезанными белками яиц (если используете). Подавайте сразу из кастрюли с рисом, если хотите."]'::jsonb,
    90, 'medium', 'https://www.themealdb.com/images/media/meals/li30ck1763281992.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Saffron', 'щепотка шафрана', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'шафран'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tbsp Extra Virgin Olive Oil', '60 мл оливкового масла первого сорта', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'оливковое масло первого сорта'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Garlic Clove', '6 зубчиков чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '35g Almonds', '35 г миндаля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'миндаль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '30g Stale bread', '30 г тупого хлеба', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'тупой хлеб'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs chopped Parsley', '2 ст. л. нарезанной петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken Thighs', '8 куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Carrots', '1 нарезанная морковь', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Celery', '1 chopped celery', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'celery'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250ml Dry sherry', '250ml dry sherry', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'dry sherry'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '350ml Chicken Stock', '350ml куриный бульон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Cinnamon Stick', '1 cinnamon stick', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'cinnamon stick'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Cloves', 'Pinch cloves', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'cloves'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Bay Leaves', '2 bay leaves', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'bay leaves'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Egg', '2 egg', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'egg'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Almonds', '2 tblsp миндаль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53162' AND LOWER(i.name) = 'миндаль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52851', 'Nutty Chicken Curry', 'Chicken', '["Finely slice a quarter of the chilli, then put the rest in a food processor with the ginger, garlic, coriander stalks and one-third of the leaves. Whizz to a rough paste with a splash of water if needed.","Heat the oil in a frying pan, then quickly brown the chicken chunks for 1 min. Stir in the paste for another min, then add the peanut butter, stock and yogurt. When the sauce is gently bubbling, cook for 10 mins until the chicken is just cooked through and sauce thickened. Stir in most of the remaining coriander, then scatter the rest on top with the chilli, if using. Eat with rice or mashed sweet potato."]'::jsonb,
    'Куриный карри с арахисовым соусом', 'Курица', '["Нарежьте мелко четверть красного чили, затем положите остальную часть в кухонный комбайн вместе с имбирём, чесноком, стеблями кориандра и одной трети листьев. Проготовьте грубую пасту, при необходимости добавив каплю воды.","Нагрейте подсолнечное масло в сковороде, затем быстро обжарьте куски курицы 1 минуту. Добавьте пасту и обжаривайте ещё минуту, затем добавьте арахисовое масло, куриный бульон и греческий йогурт. Когда соус начнёт слегка закипать, готовьте 10 минут, пока курица не прожарится, а соус не загустеет.","Вмешайте большую часть оставшегося кориандра, затем посыпьте оставшиеся листья и перец чили сверху, если используете. Подавайте с рисом или пюре из сладкого картофеля."]'::jsonb,
    25, 'medium', 'https://www.themealdb.com/images/media/meals/yxsurp1511304301.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Red Chilli', '1 большой красный чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'красный чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '0.5 Ginger', '0.5 имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Garlic', '1 большой зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Coriander', 'пучок кориандра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'кориандр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Sunflower Oil', '1 ст.л. подсолнечного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'подсолнечное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chicken Breasts', '4 куриные грудки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'куриные грудки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 tblsp Peanut Butter', '5 ст.л. арахисового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'арахисовое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150ml Chicken Stock', '150 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200g Greek Yogurt', '200 г греческого йогурта', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52851' AND LOWER(i.name) = 'греческий йогурт'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53023', 'Sledz w Oleju (Polish Herrings)', 'Seafood', '["Soak herring in cold water for at least 1 hour. If very salty, repeat, changing the water each time.","Drain thoroughly and slice herring into bite-size pieces.","Place in a jar large enough to accommodate the pieces and cover with oil, allspice, peppercorns, and bay leaf. Close the jar.","Refrigerate for 2 to 3 days before eating. This will keep refrigerated up to 2 weeks.","Serve with finely chopped onion or onion slices, lemon, and parsley or dill."]'::jsonb,
    'Сельдь в оливковом масле (польская сельдь)', 'Морепродукты', '["Замочите сел��дь в холодной воде минимум час. Если слишком солёная, повторите, меняя воду.","Хорошо обсушите и нарежьте сельдь небольшими кусочками.","Положите в ёмкость, достаточную для всех кусочков, и залейте оливковым маслом, добавьте молотую гвоздику, перец, лавровый лист. Закройте ёмкость.","Храните в холодильнике 2–3 дня перед употреблением. Это сохранит до 2 недель.","Подавайте с мелко нарезанным луком, лимоном, петрушкой или укропом."]'::jsonb,
    30, 'easy', 'https://www.themealdb.com/images/media/meals/7ttta31593350374.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Herring', '8 сельдей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'сельдь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 sliced Onion', '1 луковица, нарезанная кольцами', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Olive Oil', '120 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Allspice', '5 мл молотой гвоздики', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'молотая гвоздика'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Pepper', '5 мл молотого черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Bay Leaf', '1 лавровый лист', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53023' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53498', 'Samlar Kari – Khmer Red Curry', 'Chicken', '["1. Heat 1 tbsp vegetable oil in a large pot or Dutch oven over medium-high heat until it shimmers, about 2 minutes.","2. Add 1 lb chicken pieces to the pot and cook until browned on all sides, approximately 5–7 minutes, stirring occasionally to prevent sticking.","3. Remove the chicken from the pot and set it aside on a plate, leaving any oil and juices in the pot.","4. Reduce the heat to medium and add 1 sliced onion to the pot, cooking until softened and translucent, about 4 minutes.","5. Stir in 3 cloves minced garlic and 1 tbsp grated ginger, cooking for 1 minute until fragrant to avoid burning.","6. Add 2 tbsp red curry paste to the pot and cook for 1 minute, stirring constantly to toast the spices and deepen the flavor.","7. Pour in 1 can coconut milk and 1 cup chicken broth, scraping the bottom of the pot to incorporate any browned bits for extra richness.","8. Stir in 1 tbsp fish sauce and 1 tbsp palm sugar until fully dissolved, then return the browned chicken to the pot.","9. Bring the mixture to a gentle boil, then reduce the heat to low, cover, and simmer for 15 minutes to allow the flavors to meld.","10. Add 1 cup bamboo shoots and 1 sliced red bell pepper to the pot, simmering uncovered for an additional 5 minutes until the vegetables are tender-crisp.","11. Remove the pot from the heat and stir in 1 cup Thai basil leaves until just wilted, about 1 minute, to preserve their fresh aroma.","12. Serve the curry hot, garnished with lime wedges for a bright, acidic finish."]'::jsonb,
    'Кхмерский красный карри с курицей', 'Блюдо из курицы', '["Нагрейте 15 мл растительного масла в большой кастрюле на среднем огне до блеска, около 2 минут.","Добавьте 450 г куриных бедер и обжаривайте до золотистой корочки со всех сторон, примерно 5–7 минут, периодически помешивая, чтобы не прилипло.","Выньте курицу из кастрюли и отложите на тарелку, оставив масло и соки в кастрюле.","Уменьшите огонь до среднего и добавьте 1 среднюю нарезанную луковицу, готовьте до мягкости и прозрачности, около 4 минут.","Вмешайте 3 зубчика измельчённого чеснока и 15 мл тертого имбиря, готовьте 1 минуту до аромата, чтобы не подгорело.","Добавьте 2 столовые ложки красной карри пасты, готовьте 1 минуту, постоянно помешивая, чтобы специи подрумянились и раскрыли вкус.","Влейте 400 мл кокосового молока и 240 мл куриного бульона, скребком отрывайте ��т дна все подрумяненные кусочки, чтобы они растворились в соусе.","Вмешайте 15 мл рыбного соуса и 15 мл коричневого сахара до полного растворения, затем верните курицу в кастрюлю.","Доведите смесь до лёгкого кипения, затем уменьшите огонь до минимума, накройте крышкой и тушите 15 минут, чтобы ароматы соединились.","Добавьте 240 мл бамбуковых стеблей и 1 среднюю нарезанную красную паприку, тушите без крышки ещё 5 минут, пока овощи не станут слегка хрустящими.","Снимите кастрюлю с огня и вмешайте 240 мл свежих листьев базилика, пока они не слегка увянут, около 1 минуты, чтобы сохранить аромат.","Подавайте карри горячим, украсив дольками лайма для яркого, кислого акцента."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/k5qzdl1782689660.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Vegetable Oil', '15 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Chicken Thighs', '450 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 medium chopped Onion', '1 средняя нарезанная луковица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Cloves Crushed Garlic', '3 зубчика измельчённого чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Ginger', '15 мл тертого имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Red Curry Paste', '2 столовые ложки красной карри пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'красная карри паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 can Coconut Milk', '1 банка кокосового молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Chicken Stock', '240 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Fish Sauce', '15 мл рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Brown Sugar', '15 мл коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Bamboo Shoot', '240 мл бамбуковых стеблей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'бамбуковые стебли'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 sliced Red Pepper', '1 средняя нарезанная красная паприка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'красная паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Basil', 'щепотка базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Lime', 'лайм для подачи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53498' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52813', 'Kentucky Fried Chicken', 'Chicken', '["Preheat fryer to 350°F. Thoroughly mix together all the spice mix ingredients.","Combine spice mix with flour, brown sugar and salt.","Dip chicken pieces in egg white to lightly coat them, then transfer to flour mixture. Turn a few times and make sure the flour mix is really stuck to the chicken. Repeat with all the chicken pieces.","Let chicken pieces rest for 5 minutes so crust has a chance to dry a bit.","Fry chicken in batches. Breasts and wings should take 12-14 minutes, and legs and thighs will need a few more minutes. Chicken pieces are done when a meat thermometer inserted into the thickest part reads 165°F.","Let chicken drain on a few paper towels when it comes out of the fryer. Serve hot."]'::jsonb,
    'Кентукки Фрайд Чикен', 'Блюдо из курицы', '["Разогрейте фритюрницу до 180 °C.","Тщательно смешайте все специи.","Смешайте специи с мукой, коричневым сахаром и солью.","Обмакните куски курицы в белок яйца, затем обваляйте в мучной смеси, убедившись, что смесь прилипла к мясу.","Дайте курице отдохнуть 5 минут, чтобы панировка подсохла.","Жарьте порциями: грудки и крылья – 12–14 минут, бедра и ножки – чуть дольше. Курица готова, когда внутренняя температура достигает 74 °C.","Дайте стечь на бумажных полотенцах и подавайте горячей."]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/40r49m1763197022.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 whole Chicken', '1 целая курица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 quarts neutral frying Oil', '2 литра нейтрального масла для жарки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Egg White', '1 белок яйца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'белок яйца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 1/2 cups Flour', '1 ½ чашки муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Brown Sugar', '1 столовая ложка коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Salt', '1 столовая ложка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon paprika', '1 столовая ложка паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 teaspoons onion salt', '2 чайные ложки соли из лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'соль из лука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon chili powder', '1 чайная ложка чили порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'чили порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon black pepper', '1 чайная ложка черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon celery salt', '½ чайной ложки соли из сельдерея', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'соль из сельдерея'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon sage', '½ чайной ложки шалфея', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'шалфей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon garlic powder', '½ чайной ложки чесночного порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'чесночный порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon allspice', '½ чайной ложки всех специй', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'все специи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon oregano', '½ чайной ложки орегано', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'орегано'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon basil', '½ чайной ложки базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon marjoram', '½ чайной ложки маржорама', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52813' AND LOWER(i.name) = 'маржорама'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52882', 'Three Fish Pie', 'Seafood', '["Preheat the oven to 200C/400F/Gas 6 (180C fan).","Put the potatoes into a saucepan of cold salted water. Bring up to the boil and simmer until completely tender. Drain well and then mash with the butter and milk. Add pepper and taste to check the seasoning. Add salt and more pepper if necessary.","For the fish filling, melt the butter in a saucepan, add the leeks and stir over the heat. Cover with a lid and simmer gently for 10 minutes, or until soft. Measure the flour into a small bowl. Add the wine and whisk together until smooth.","Add the milk to the leeks, bring to the boil and then add the wine mixture. Stir briskly until thickened. Season and add the parsley and fish. Stir over the heat for two minutes, then spoon into an ovenproof casserole. Scatter over the eggs. Allow to cool until firm.","Spoon the mashed potatoes over the fish mixture and mark with a fork. Sprinkle with cheese.","Bake for 30-40 minutes, or until lightly golden-brown on top and bubbling around the edges."]'::jsonb,
    'Три рыбы в запеканке', 'Морепродукты', '["Разогрейте духовку до 200 °C (180 °C вентилятор).","Положите картофель в кастрюлю с холодной подсоленной водой, доведите до кипения и варите до полной мягкости. Слейте воду, затем размягчите картофель с маслом и молоком. Приправьте перцем, посолите и при необходимости добавьте ещё перца.","Для рыбного начинки растопите сливочное масло в сотейнике, добавьте лук-шалот и обжаривайте, пока не станет мягким. Накройте крышкой и тушите на медленном огне 10 минут.","В небольшой миске взбейте муку, добавьте белое вино и взбивайте до однородной массы.","Добавьте молоко к луку, доведите до кипения, затем влейте винную смесь. Быстро помешивайте, пока соус не загустеет. Приправьте, добавьте петрушку и рыбу. Тушите на огне ещё два минуты, затем вылейте в жаропрочную форму. Посыпьте сверху яй��ами. Дайте остыть до застывания.","Сверху выложите размятый картофель, слегка разровняйте вилкой. Посыпьте тертым сыром.","Выпекайте 30–40 минут, пока верх не станет слегка золотистым и не начнут пузыриться края."]'::jsonb,
    60, 'medium', 'https://www.themealdb.com/images/media/meals/spswqs1511558697.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1kg Potatoes', '1 кг картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Knob Butter', '1 кн. сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Dash Milk', '1 щепотка молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50g Gruyere', '50 г грюйера', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'грюйер'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '75g Butter', '75 г сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Leek', '2 ломтика лука-шалота', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'лук-шалот'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '75g Plain Flour', '75 г пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150ml White Wine', '150 мл белого вина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'белое вино'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '568ml Milk', '568 мл молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs chopped Parsley', '2 ст. л. рубленой петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Salmon', '250 г лосося', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'лосось'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Haddock', '250 г трески', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'треска'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Smoked Haddock', '250 г копченой трески', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'копченая треска'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Eggs', '6 яиц', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52882' AND LOWER(i.name) = 'яйца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53459', 'Chicken and Potato Roti', 'Chicken', '["Add a pint of chicken stock to the simmer and put three tablespoons of sugar into a large saucepan on high; cook until the sugar caramelizes, then add the cubed chicken breasts and stir until the chicken browns.","Add chopped onions, garlic, parsley, thyme, jerk seasoning, salt, and the whole scotch bonnet pepper – do not cut up the pepper! Reduce the heat to low and let this simmer for 25 minutes.","In a large mixing bowl, sift the flour, and add a pinch of salt to taste.","Now add the first tablespoon of shortening, and with your fingers, rub the flour into the shortening until it forms a breadcrumb-like consistency.","Then add the second tablespoon of shortening and rub against the flour until it looks like breadcrumbs.","Now add the third tablespoon of shortening and repeat the process.","You should by now have used all the flour. Your bowl should be all breadcrumb-like; if you still have fresh flour, use another tablespoon of shortening until your fresh flour is all used up.","Add a small amount of water and mix with a butter knife; keep adding small amounts until your mixture forms a soft dough.","Now dust your surface with flour and roll out your pastry; you want to roll wafer-thin rounds – this mixture should make at least 12 roti skins.","Cover with a tea towel while returning to the pot.","Now peel the potatoes and cube them into small bite-size pieces.","After 25 minutes of simmering, add 1/2 pint of water and the potatoes to the pool.","Now cover and cook for 30 minutes on low heat.","Turn a flat baking tray upside down, lightly cover with foil, and place on the stovetop on high; cook each roti skin for 1 minute on each side until brown but not crisp.","Now pile up your cooked roti skins, remove the pot after 30 minutes, and remove the whole scotch bonnet.","Take the entire pot to the table with a pile of plates; each person assumes the roti skin, lays it flat on the scale, spoons some filling into the middle of the roti skin, and folds around the filling eats enjoy."]'::jsonb,
    'Куриный и картофельный ротти', 'Блюдо из курицы', '["Добавьте 1 литр куриного бульона в кастрюлю и поставьте на сильный огонь 3 столовые ложки сахара; готовьте, пока сахар не карамелизуется, затем добавьте кубики куриной грудки и помешивайте до золотистой корочки.","Добавьте нарезанный лук, чеснок, петрушку, тимьян, приправу джерк, щепотку соли и целый перец скоут-бонет – не разрезайте перец! Убавьте огонь до минимума и дайте покипеть 25 минут.","В большой миске просейте 450 г муки и добавьте щепотку соли по вкусу.","Добавьте первую столовую ложку растительного масла и, используя пальцы, перемешайте с мукой до состояния крошки.","Затем добавьте вторую столовую ложку масла и продолжайте перемешивать до крошечного состояния.","Добавьте третью столовую ложку масла и повторите процесс до полного использования муки.","Если осталась свежая мука, добавьте еще одну столовую ложку масла, пока смесь не станет однородной крошкой.","Добавьте небольшое количество воды и перемешайте ножом до образования мягкого теста.","Посыпьте рабочую поверхность мукой и раскатайте тесто в тонкие круги – получится минимум 12 коржей ротти.","Покройте тесто полотенцем и дайте отдохнуть, пока готовится основное блюдо.","Очистите картофель и нарежьте его кубиками небольшого размера.","После 25 минут варки добавьте 1/2 литра воды и картофель в кастрюлю.","Накройте крышкой и готовьте на медленном огне 30 минут.","Положите противень на плиту на сильный огонь, слегка накройте фольгой, и обжарьте каждый корж ротти по 1 минуту с каждой стороны до золотистой корочки, но не до хрустящей.","Соберите готовые коржи, выньте кастрюлю, удалите целый перец скоут-бонет, и подайте на стол: каждый человек берёт корж, кладёт его на тарелку, добавляет начинку и складывает, чтобы съесть."]'::jsonb,
    90, 'medium', 'https://www.themealdb.com/images/media/meals/mp9z0i1782238092.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Flour', '450 г муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Shortening', '45 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Splash Water', 'несколько капель воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Chicken Breast', '6 куриных грудок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'куриная грудка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Parsley', 'щепотка петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Thyme', 'щепотка тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Jerk', 'щепотка приправы джерк', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'приправы джерк'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Sugar', 'щепотка сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Black Pepper', 'щепотка черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 large Onion', '2 большие луковицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cloves Garlic', '4 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Scotch Bonnet', '1 перец скоут-бонет', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'перец скоут-бонет'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 lb Potatoes', '227 г картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53459' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52956', 'Chicken Congee', 'Chicken', '["STEP 1 - MARINATING THE CHICKEN","In a bowl, add chicken, salt, white pepper, ginger juice and then mix it together well.","Set the chicken aside.","STEP 2 - RINSE THE WHITE RICE","Rinse the rice in a metal bowl or pot a couple times and then drain the water.","STEP 2 - BOILING THE WHITE RICE","Next add 8 cups of water and then set the stove on high heat until it is boiling. Once rice porridge starts to boil, set the stove on low heat and then stir it once every 8-10 minutes for around 20-25 minutes.","After 25 minutes, this is optional but you can add a little bit more water to make rice porridge to make it less thick or to your preference.","Next add the marinated chicken to the rice porridge and leave the stove on low heat for another 10 minutes.","After an additional 10 minutes add the green onions, sliced ginger, 1 pinch of salt, 1 pinch of white pepper and stir for 10 seconds.","Serve the rice porridge in a bowl","Optional: add Coriander on top of the rice porridge."]'::jsonb,
    'Куриный конжий', 'Курица', '["Маринование курицы: в миске соедините курицу, щепотку соли, щепотку белого перца, 5 мл имбирного сиропа и хорошо перемешайте. Отложите курицу в сторону.","Промывание риса: несколько раз промойте рис в металлической миске или кастрюле, затем слейте воду.","Варка риса: добавьте 2 л воды, поставьте на сильный огонь до кипения. Как только рис начнёт закипать, уменьшите огонь до слабого, помешивая каждые 8–10 минут в течение 20–25 минут. При желании можно добавить немного воды, чтобы консистенция была более жидкой.","Добавление курицы: положите замаринованную курицу в рисовую кашу, оставьте на слабом огне ещё 10 минут.","Финальный штрих: добавьте 15 мл зеленого лука, 5 г имбиря, щепотку соли и щепотку белого перца, перемешайте 10 секунд.","Подача: разлейте конжий по тарелкам. По желанию посыпьте сверху кинзой."]'::jsonb,
    60, 'easy', 'https://www.themealdb.com/images/media/meals/1529446352.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 oz Chicken', '227 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Pepper', 'щепотка перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Ginger Cordial', '5 мл имбирного сиропа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'имбирный сироп'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Ginger', '5 г имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Spring Onions', '15 мл зеленого лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Rice', '100 г риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 cups Water', '2 л воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 oz Coriander', '57 г кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52956' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52771', 'Spicy Arrabiata Penne', 'Vegetarian', '["Bring a large pot of water to a boil. Add kosher salt to the boiling water, then add the pasta. Cook according to the package instructions, about 9 minutes.","In a large skillet over medium-high heat, add the olive oil and heat until the oil starts to shimmer. Add the garlic and cook, stirring, until fragrant, 1 to 2 minutes. Add the chopped tomatoes, red chile flakes, Italian seasoning and salt and pepper to taste. Bring to a boil and cook for 5 minutes. Remove from the heat and add the chopped basil.","Drain the pasta and add it to the sauce. Garnish with Parmigiano-Reggiano flakes and more basil and serve warm."]'::jsonb,
    'Паста Арабиата с острым перцем', 'Вегетарианское блюдо', '["Вскипятите большую кастрюлю воды. Добавьте морскую соль, затем пасту. Готовьте согласно инструкции на упаковке, примерно 9 минут.","В большой сковороде на среднем–высоком огне разогрейте оливковое масло до появления блеска. Добавьте чеснок и готовьте, помешивая, пока не появится аромат, 1–2 минуты.","Добавьте нарезанные помидоры, хлопья красного перца, итальянскую приправу, соль и перец по вкусу. Доведите до кипения и готовьте 5 минут. Снимите с огня и добавьте нарезанный базилик.","Слейте воду с пасты и добавьте её в соус. Посыпьте тертым пармезаном, украсьте дополнительным базиликом и подавайте горячим."]'::jsonb,
    20, 'easy', 'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 pound penne rigate', '450 г пене ригате', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'пене ригате'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup olive oil', '60 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 cloves garlic', '3 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tin chopped tomatoes', '400 г нарезанных помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'нарезанные помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon red chilli flakes', '1/2 чайной ложки хлопьев красного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'красные хлопья перца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon italian seasoning', '1/2 чайной ложки итальянской приправы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'итальянская приправа'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 leaves basil', '6 листьев базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'sprinkling Parmigiano-Reggiano', 'щепотка тертого пармезана', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52771' AND LOWER(i.name) = 'пармезан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52951', 'General Tsos Chicken', 'Chicken', '["DIRECTIONS:","STEP 1 - SAUCE","In a bowl, add 2 Cups of water, 2 Tablespoon soy sauce, 2 Tablespoon white vinegar, sherry cooking wine, 1/4 Teaspoon white pepper, minced ginger, minced garlic, hot pepper, ketchup, hoisin sauce, and sugar.","Mix together well and set aside.","STEP 2 - MARINATING THE CHICKEN","In a bowl, add the chicken, 1 pinch of salt, 1 pinch of white pepper, 2 egg whites, and 3 Tablespoon of corn starch","STEP 3 - DEEP FRY THE CHICKEN","Deep fry the chicken at 350 degrees for 3-4 minutes or until it is golden brown and loosen up the chicken so that they don''t stick together.","Set the chicken aside.","STEP 4 - STIR FRY","Add the sauce to the wok and then the broccoli and wait until it is boiling.","To thicken the sauce, whisk together 2 Tablespoon of cornstarch and 4 Tablespoon of water in a bowl and slowly add to your stir-fry until it''s the right thickness.","Next add in the chicken and stir-fry for a minute and serve on a plate"]'::jsonb,
    'Генеральный цзос курица', 'Курица', '["Сначала приготовьте соус: в миске смешайте 480 мл воды, 30 мл соевого соуса, 30 мл белого уксуса, 30 мл шери, 1/4 чайной ложки белого перца, мелко нарезанный имбирь, чеснок, острый перец, кетчуп, хойсин и сахар, хорошо перемешайте и отложите в сторону.","В отдельной миске соедините куриное филе, щепотку соли, щепотку белого перца, 2 яичных белка и 45 мл кукурузного крахмала, перемешайте до однородности.","Разогрейте растительное масло до 180 °C и обжаривайте курицу 3–4 минуты до золотистой корочки, затем переложите на бумажное полотенце, чтобы убрать лишний жир.","В вок добавьте подготовленный соус, затем брокколи и доведите до кипения. Для загустения взбейте 30 мл кукурузного крахмала с 60 мл воды и постепенно вливайте в вок, пока соус не станет нужной густоты.","Добавьте обжаренную курицу, быстро обжарьте 1 минуту, затем подавайте горячей."]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/1529444113.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 1/2 Chicken Breast', '1 1/2 куриного филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3/4 cup Plain Flour', '3/4 стакана пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Egg', '1 яйцо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'яйцо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Starch', '2 столовые ложки кукурузного крахмала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'кукурузный крахмал'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Baking Powder', '1 столовая ложка разрыхлителя', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'разрыхлитель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '1 чайная ложка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Onion Salt', '1/2 чайной ложки луковой соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'луковая соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 tsp Garlic Powder', '1/4 чайной ложки чесночного порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'чесночный порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3/4 cup Water', '3/4 стакана воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Chicken Stock', '1/2 стакана куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Duck Sauce', '1/4 стакана свиного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'свиной соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tbs Soy Sauce', '3 столовые ложки соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Honey', '2 столовые ложки меда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'мед'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Rice Vinegar', '1 столовая ложка рисового уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'рисовый уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Sesame Seed Oil', '2 столовые ложки масла из кунжута', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'масло из кунжута'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tbs Gochujang', '1/2 столовой ложки гочуджана', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'гочуджан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Starch', '2 столовые ложки кукурузного крахмала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'кукурузный крахмал'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove Garlic', '1 зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chopped Spring Onions', '2 нарезанных зеленых лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Ginger', '1 чайная ложка имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52951' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53367', 'Chicken Fried Rice', 'Chicken', '["Fried rice is best made with leftover rice that''s at least a day old. Otherwise it becomes gummy in the skillet.","If you don’t have any leftover rice from the night before, cook a batch of rice and spread it on a large baking sheet or several large plates. Let the rice dry out for about 1 to 2 hours before using it for fried rice.","Rice sticks to the pan very easily, so make sure to use a wok or pan that doesn’t have a sticky surface. I usually cook stir-fries in my seasoned carbon steel wok, but cast iron or nonstick pans work well, too. You might need to add a little more oil if things aren’t releasing easily.","Prepare the chicken:","Chop the chicken into small 1/4-inch to 1/2-inch cubes. Sprinkle 1/2 teaspoon of salt over the chicken and mix to combine. Set the chicken aside for about 10 minutes (I usually use this time to chop all the vegetables).","Scramble the egg:","Heat a wok or large sauté pan over medium-high heat. Swirl in a tablespoon of oil and add the whisked eggs. Use a spatula to quickly scramble the eggs, breaking the curds into smaller pieces as they come together. Transfer the eggs to a plate.","Cook the chicken:","Add another tablespoon of oil in the wok or pan. Add the chicken and cook for 4 to 5 minutes, stirring occasionally. Turn off the heat and transfer the cooked chicken to a plate.","Using your spatula, scrape off any chicken bits that are still stuck to the wok so they don''t burn during the next step. You can also use paper towels to wipe down your wok or pan.","Cook the vegetables:","Swirl 1 tablespoon of oil into the wok over medium-high heat. Add the diced onions and cook them for 1 minute, until they start to soften. Mix in the minced garlic and ginger and cook until fragrant, about 30 seconds. Add the diced carrots and cook for 2 minutes, stirring frequently. Add 1/2 teaspoon salt and the peas, and stir to incorporate.","Cook the rice:","Add the rice to the wok or pan on top of the vegetables and stir to combine. Using the back of your spatula, smash any large chunks of rice to break them apart. Add the white and green parts of the sliced scallions (save the dark green parts) and five-spice powder. Stir to incorporate. If the rice starts to stick to the pan, stir in a little more oil.","Drizzle the soy sauce and sesame oil over the rice and stir to incorporate. Stir in the cooked chicken, scrambled eggs, and the dark parts of the scallions. Stir briefly to bring it together, and cook for another 1 to 2 minutes.","Serve:","Taste, and add more soy sauce if necessary. Serve immediately."]'::jsonb,
    'Куриный жареный рис', 'Блюдо из курицы', '["Лучше готовить жареный рис с отварным рисом, который был приготовлен хотя бы за день до. Иначе рис станет липким в сковороде.","Если у вас нет отварного риса, приготовьте рис, разложите его на большой противень или несколько больших тарелок и дайте ему подсохнуть примерно 1–2 часа перед использованием.","Рис легко прилипает к сковороде, поэтому используйте вок или сковороду с антипригарным покрытием. Я обычно готовлю в обожжённом углеродном воке, но чугуна или антипригарные сковороды тоже подходят. При необходимости добавьте немного масла.","Подготовьте курицу: нарежьте куриные бедра кубиками 0,6–1,3 см. Посыпьте 5 мл соли, перемешайте. Оставьте на 10 минут (в это время можно нарезать овощи).","Разбейте яйца: разогрейте вок на среднем огне, добавьте 15 мл масла, влейте взбитые яйца, быстро перемешайте лопаткой, чтобы яйца не образовывали большие комки. Переложите яйца на тарелку.","Обжарьте курицу: добавьте ещё 15 мл масла, положите курицу, обжаривайте 4–5 минут, помешивая. Снимите с огня, переложите курицу на тарелку. С помощью лопатки удалите остатки курицы с вок, чтобы они не подгорели. Можно протереть бумажными полотенцами.","Обжарьте овощи: в вок добавьте 15 мл масла, обжарьте нарезанный лук 1 минуту до мягкости. Добавьте измельчённый чеснок и имбирь, готовьте 30 секунд до аромата. Добавьте морковь, обжаривайте 2 минуты, часто помешивая. Добавьте 5 мл соли и горошек, перемешайте.","Добавьте рис: положите рис в вок, перемешайте. Разломайте крупные кусковые риса лопаткой. Добавьте белую и зелёную часть зеленого лука (сохранив тёмную часть) и китайскую пятиспайсную смесь. Перемешайте. Если рис прилипает, добавьте немного масла.","Полейте соевым соусом и кунжутным маслом, перемешайте. Добавьте курицу, яйца и тёмную часть зеленого лука. Быстро перемешайте и готовьте ещё 1–2 минуты.","Подавайте: попробуйте, при необходимости добавьте соевого соуса. Подавайте сразу."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/wuyd2h1765655837.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Chicken Thighs', '1 lb chicken thighs', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'chicken thighs'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '1 tsp соль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Canola Oil', '3  tablespoons canola oil', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'canola oil'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Large Egg', '3 Large egg', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'egg'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2/3 Cup Onion', '2/3 Cup лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves minced Garlic', '2 cloves minced чеснок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Ground Ginger', '2 tsp ground ginger', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'ground ginger'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Carrots', '1 large морковь', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2/3 Cup Peas', '2/3 Cup зеленый горошек', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'зеленый горошек'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cups Jasmine Rice', '4 cups jasmine rice', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'jasmine rice'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Scallions', '2 sliced scallions', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'scallions'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Chinese five spice powder', '1/2 tsp chinese five spice powder', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'chinese five spice powder'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2.5 tbsp Soy Sauce', '2.5 tbsp соевый соус', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Sesame Seed Oil', '1 tsp кунжутное масло', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53367' AND LOWER(i.name) = 'кунжутное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53110', 'Sticky Chicken', 'Chicken', '["step 1","Make 3 slashes on each of the drumsticks. Mix together the soy, honey, oil, tomato purée and mustard. Pour this mixture over the chicken and coat thoroughly. Leave to marinate for 30 mins at room temperature or overnight in the fridge. Heat oven to 200C/fan 180C/gas 6.","step 2","Tip the chicken into a shallow roasting tray and cook for 35 mins, turning occasionally, until the chicken is tender and glistening with the marinade."]'::jsonb,
    'Клеящая курица', 'Курица', '["Сделайте 3 надреза на каждой куриной ножке. Смешайте соевый соус, мед, оливковое масло, томатное пюре и горчицу Дижон. Полейте смесью курицу и тщательно обмажьте. Оставьте мариноваться 30 минут при комнатной температуре или на ночь в холодильнике. Разогрейте духовку до 200 °C (конвекция 180 °C, газ 6).","Положите курицу на неглубокую противень и запекайте 35 минут, периодически переворачивая, пока курица не станет мягкой и не блестеть маринадом."]'::jsonb,
    90, 'medium', 'https://www.themealdb.com/images/media/meals/cj56fs1762340001.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken drumsticks', '8 куриных ножек', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'куриные ножки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Soy Sauce', '2 столовые ложки соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Honey', '1 столовая ложка меда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'мед'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tblsp Olive Oil', '1 столовая ложка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon Tomato Puree', '1 чайная ложка томатного пюре', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'томатное пюре'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Dijon Mustard', '1 столовая ложка горчицы дижон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53110' AND LOWER(i.name) = 'горчица дижон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53105', 'Spiced smoky barbecued chicken', 'Chicken', '["step 1","Make the marinade. Smash the garlic with a little salt using a pestle and mortar. Add the lemon zest and juice, the spice mix, chilli, oil and a good grinding of black pepper. Mix to a paste. This can be done in a mini food processor.","step 2","Toss the chicken in the marinade and set aside while you light the barbecue. When the barbecue’s hot, lay the bunches of herbs on the grid and put the chicken, skin side up, on top. Close the lid, if your barbecue has one, and cook the chicken on the smouldering herbs for about 10 minutes until the meat starts to colour. Turn the chicken and continue to cook for a further 20-30 minutes, turning as necessary, until it is slightly charred from the burnt herbs and cooked through to the bone."]'::jsonb,
    'Курица в барбекю со специями и дымом', 'Курица', '["Приготовьте маринад: разд��вите чеснок с небольшим количеством соли в ступке. Добавьте цедру и сок лимона, карри, хлопья чили, оливковое масло и щедро поперчите. Смешайте до однородной пасты; можно использовать мини-кухонный процессор.","Обваляйте куриные бедра в маринаде и отложите, пока разогреете барбекю. Когда гриль разогреется, разместите горсть розмарина и горсть тимьяна на решетке, сверху положите курицу кожей вверх. Закройте крышку, если барбекю её имеет, и готовьте курицу на дымящихся травах около 10 минут, пока мясо начнет менять цвет.","Переверните курицу и продолжайте готовить ещё 20–30 минут, периодически переворачивая, пока она слегка не подрумянится от обугленных трав и полностью не прожарится до костей."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/a08uqk1761848682.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves Garlic', '2 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice/zest of one Lemon', 'сок и цедра одного лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Curry Powder', '2 ст. л. карри порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'карри порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Chilli Flakes', 'щепотка хлопьев чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'чили хлопья'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Olive Oil', '3 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '12 Chicken Thighs', '12 куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Rosemary', 'горсть розмарина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'розмарин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Rosemary', 'горсть розмарина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'розмарин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Thyme', 'горсть тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Thyme', 'горсть тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Bay Leaves', '2 лавровых листа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53105' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52874', 'Beef and Mustard Pie', 'Beef', '["Preheat the oven to 150C/300F/Gas 2.","Toss the beef and flour together in a bowl with some salt and black pepper.","Heat a large casserole until hot, add half of the rapeseed oil and enough of the beef to just cover the bottom of the casserole.","Fry until browned on each side, then remove and set aside. Repeat with the remaining oil and beef.","Return the beef to the pan, add the wine and cook until the volume of liquid has reduced by half, then add the stock, onion, carrots, thyme and mustard, and season well with salt and pepper.","Cover with a lid and place in the oven for two hours.","Remove from the oven, check the seasoning and set aside to cool. Remove the thyme.","When the beef is cool and you''re ready to assemble the pie, preheat the oven to 200C/400F/Gas 6.","Transfer the beef to a pie dish, brush the rim with the beaten egg yolks and lay the pastry over the top. Brush the top of the pastry with more beaten egg.","Trim the pastry so there is just enough excess to crimp the edges, then place in the oven and bake for 30 minutes, or until the pastry is golden-brown and cooked through.","For the green beans, bring a saucepan of salted water to the boil, add the beans and cook for 4-5 minutes, or until just tender.","Drain and toss with the butter, then season with black pepper.","To serve, place a large spoonful of pie onto each plate with some green beans alongside."]'::jsonb,
    'Говяжий пирог с горчицей', 'Говядина', '["Разогрейте духовку до 150 °C.","Смешайте говядину и муку в миске с солью и черным перцем.","Разогрейте большую сковороду, добавьте половину рапсового масла и немного говядины, чтобы покрыть дно.","Обжарьте до коричневого цвета с каждой стороны, затем выньте и отложите. Повторите с оставшимся маслом и говядиной.","Верните говядину в сковороду, добавьте вино и готовьте, пока жидкость не уменьшится вдвое, затем добавьте бульон, лук, морковь, тимьян и горчицу, приправьте солью и перцем.","Накройте крышкой и запекайте в духовке два часа.","Достаньте из духовки, проверьте приправы, дайте остыть, снимите тимьян.","Когда говядина остынет и вы будете готовы собрать пирог, разогрейте духовку до 200 °C.","Переложите говядину в форму для пирога, смажьте край взбитой желтковой смесью и накройте слоеным тестом. Смажьте верх теста более взбитой желтковой смесью.","Обрежьте лишнее тесто, чтобы осталось достаточно для скрепления краев, затем запекайте 30 минут до золотистого цвета.","Для зеленой фасоли доведите подсоленную воду до кипения, добавьте фасоль и варите 4–5 минут до мягкости.","Слейте воду, перемешайте с маслом, приправьте черным перцем.","Подавайте, положив большую ложку пирога на каждую тарелку с зеленой фасолью."]'::jsonb,
    190, 'medium', 'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1kg Beef', '1 кг говядины', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'говядина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Plain Flour', '2 ст. л. муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Rapeseed Oil', '2 ст. л. рапсового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'рапсовое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200ml Red Wine', '200 мл красного вина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'красное вино'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400ml Beef Stock', '400 мл говяжьего бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'говяжий бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 finely sliced Onion', '1 мелко нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chopped Carrots', '2 нарезанные морковки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 sprigs Thyme', '3 веточки тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Mustard', '2 ст. л. горчицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'горчица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 free-range Egg Yolks', '2 желтка куриных яиц', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'желтки яиц'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Puff Pastry', '400 г слоеного теста', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'слоеное тесто'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Green Beans', '300 г зеленой фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'зеленая фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '25g Butter', '25 г сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Pepper', 'щепотка перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52874' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52850', 'Chicken Couscous', 'Chicken', '["Heat the olive oil in a large frying pan and cook the onion for 1-2 mins just until softened. Add the chicken and fry for 7-10 mins until cooked through and the onions have turned golden. Grate over the ginger, stir through the harissa to coat everything and cook for 1 min more.","Tip in the apricots, chickpeas and couscous, then pour over the stock and stir once. Cover with a lid or tightly cover the pan with foil and leave for about 5 mins until the couscous has soaked up all the stock and is soft. Fluff up the couscous with a fork and scatter over the coriander to serve. Serve with extra harissa, if you like."]'::jsonb,
    'Куриный кускус', 'Блюдо из курицы', '["Нагрейте оливковое масло в большой сковороде и обжарьте лук 1–2 минуты до мягкости.","Добавьте куриное филе и жарьте 7–10 минут до полной готовности и до золотистого цвета лука.","Добавьте имбирь, перемешайте, затем добавьте харицу и обжаривайте 1 минуту.","Добавьте сухие абрикосы, нут и кускус, залейте куриным бульоном и перемешайте.","Накройте крышкой или плотно накройте фольгой, дайте настояться 5 минут, пока кускус впитает бульон и станет мягким.","Разрыхлите кускус вилкой, посыпьте кориандром и подавайте. При желании можно добавить дополнительную харицу."]'::jsonb,
    30, 'medium', 'https://www.themealdb.com/images/media/meals/qxytrx1511304021.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Olive Oil', '1 столовая ложка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 луковица, нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200g Chicken Breast', '200 г куриного филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Ginger', 'щепотка имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Harissa Spice', '2 столовые ложки харицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'специя харица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '10 Dried Apricots', '10 сухих абрикосов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'сухие абрикосы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '220g Chickpeas', '220 г нута', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'нут'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200g Couscous', '200 г кускуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'кускус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200ml Chicken Stock', '200 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Coriander', 'горсть кориандра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52850' AND LOWER(i.name) = 'кориандр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53287', 'Tajine de Poulet aux Carottes et Patates Douces (Chicken and Sweet Potato Tagine)', 'Chicken', '["Combine onions, celery, cilantro, and parsley in a large pot. Stir in turmeric, cumin, paprika, ginger, cayenne pepper, salt, and pepper. Place chicken thighs on top. Drizzle olive oil over chicken. Cover and simmer over low heat until chicken is tender, about 40 minutes.","Place raisins in a small bowl and cover with hot water; let soak for 10 minutes. Drain.","Preheat oven to 400 degrees F (200 degrees C).","Transfer chicken mixture into an oven-safe tagine or casserole dish. Add sweet potato and carrots. Cover with lid or aluminum foil.","Bake in the preheated oven until sweet potato is soft, about 40 minutes. Add drained raisins and prunes. Continue baking, covered, until raisins and prunes are heated through, about 10 minutes."]'::jsonb,
    'Тайджин с курицей, морковью и сладким картофелем', 'Курица', '["Сложите лук, ��ельдерей, кинзу и петрушку в большую кастрюлю. Добавьте куркуму, кумин, паприку, имбирь, кайенский перец, соль и перец. Положите куриные бедра сверху. Полейте оливковым маслом. Накройте крышкой и тушите на медленном огне до мягкости курицы, примерно 40 минут.","Положите изюм в небольшую миску, залейте горячей водой; оставьте на 10 минут. Слейте воду.","Разогрейте духовку до 200 °C.","Переложите смесь с курицей в жаропрочную кастрюлю или форму для запекания. Добавьте сладкий картофель и морковь. Накройте крышкой или фольгой.","Выпекайте в разогретой духовке до мягкости сладкого картофеля, примерно 40 минут. Добавьте отжатый изюм и чернослив. Продолжайте выпекать под крышкой, пока изюм и чернослив не прогреются, около 10 минут."]'::jsonb,
    110, 'medium', 'https://www.themealdb.com/images/media/meals/d8bfyg1764117503.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Onion', '2 луковицы, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Celery', '2 стебля сельдерея, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'сельдерей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 bag Cilantro', '1/2 пакета кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 bag Parsley', '1/2 пакета петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Turmeric', '1/2 ч.л. куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Ground Cumin', '1/2 ч.л. молотого кумина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'кумин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon Paprika', '1/2 ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 tsp Ground Ginger', '1/4 ч.л. молотого имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 tsp Cayenne Pepper', '1/4 ч.л. кайенского перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Salt', 'по вкусу', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Black Pepper', 'по вкусу', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chicken Thighs', '4 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Drizzle Olive Oil', 'полить оливковым маслом', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Raisins', '1/4 стакана изюма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'изюм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Chicken Stock', '1 стакан куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Sweet Potatoes', '1 большой сладкий картофель', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'сладкий картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 sliced thinly Carrots', '3 тонко нарезанные морковки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Prunes', '1/4 стакана чернослива', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53287' AND LOWER(i.name) = 'чернослив'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53557', 'Extra crispy chicken wings', 'Chicken', '["Wash chicken and pat dry","Place in a large bowl","Season with garlic, salt, pepper and turmeric (you can expand your seasoning options if you''d like.","Marinate for at least an hour","Pour some tapioca flour on a plate","Coat the wings with the cassava flour and place them on a rack or plater to set. Leave them for at least 30minutes to an hour.","Heat the oil in the saucepan until it’s hot.","Place wings in pan on medium heat, until light brown.","Drain on a paper towel, and let the wings rest for at least 10 minutes, then return the wings to the hot pan on high heat and fry until golden brown.","Enjoy!"]'::jsonb,
    'Крылья куриные с хрустящей корочкой', 'Курица', '["Промойте куриные крылья и обсушите бумажными полотенцами.","Положите их в большую миску.","Приправьте чесночным порошком, солью, черным перцем и куркумой (можно добавить другие специи по вкусу).","Накройте и оставьте мариноваться минимум на час.","Разложите касаву на тарелке.","Обваляйте крылья в касаве и выложите на решетку или противень, чтобы они высохли. Оставьте на 30–60 минут.","Нагрейте масло в сковороде до горячего состояния.","Обжаривайте крылья на среднем огне до лёгкого золотистого цвета.","Слейте излишки масла на бумажное полотенце, дайте им отдохнуть минимум 10 минут, затем верните в горячую сковороду на сильный огонь и жарьте до золотистой корочки.","Подавайте горячими и наслаждайтесь!"]'::jsonb,
    105, 'medium', 'https://www.themealdb.com/images/media/meals/feh9k21784665694.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Lbs Chicken Wings', '907 г куриных крыльев', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'куриные крылья'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Salt', 'по вкусу соль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Black Pepper', '15 мл черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Garlic Powder', '15 мл чесночного порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'чесночный порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Turmeric', '5 мл куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'For frying Oil', 'масло для жарки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 1/2 cup Cassava', '180 г касавы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53557' AND LOWER(i.name) = 'касава'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52844', 'Lasagne', 'Pasta', '["Heat the oil in a large saucepan. Use kitchen scissors to snip the bacon into small pieces, or use a sharp knife to chop it on a chopping board. Add the bacon to the pan and cook for just a few mins until starting to turn golden. Add the onion, celery and carrot, and cook over a medium heat for 5 mins, stirring occasionally, until softened.","Add the garlic and cook for 1 min, then tip in the mince and cook, stirring and breaking it up with a wooden spoon, for about 6 mins until browned all over.","Stir in the tomato purée and cook for 1 min, mixing in well with the beef and vegetables. Tip in the chopped tomatoes. Fill each can half full with water to rinse out any tomatoes left in the can, and add to the pan. Add the honey and season to taste. Simmer for 20 mins.","Heat oven to 200C/180C fan/gas 6. To assemble the lasagne, ladle a little of the ragu sauce into the bottom of the roasting tin or casserole dish, spreading the sauce all over the base. Place 2 sheets of lasagne on top of the sauce overlapping to make it fit, then repeat with more sauce and another layer of pasta. Repeat with a further 2 layers of sauce and pasta, finishing with a layer of pasta.","Put the crème fraîche in a bowl and mix with 2 tbsp water to loosen it and make a smooth pourable sauce. Pour this over the top of the pasta, then top with the mozzarella. Sprinkle Parmesan over the top and bake for 25–30 mins until golden and bubbling. Serve scattered with basil, if you like."]'::jsonb,
    'Лазанья', 'Итальянская паста', '["Нагрейте оливковое масло в большой кастрюле. С помощью кухонных ножниц разрежьте бекон на мелкие кусочки или нарежьте ножом на плоской доске. Добавьте бекон в кастрюлю и обжаривайте несколько минут до золотистого цвета.","Добавьте лук, сельдерей и морковь, готовьте на среднем огне 5 минут, периодически помешивая, пока овощи не размягчатся.","Добавьте чеснок и готовьте 1 минуту, затем добавьте фарш, помешивая деревянной ложкой, и готовьте около 6 минут до коричневого цвета.","Вмешайте томатную пасту и готовьте 1 минуту, хорошо перемешивая с мясом и овощами. Добавьте томаты в собственном соку. В каждой банке половину воды, чтобы смыть остатки томатов, и добавьте в кастрюлю. Добавьте мёд и приправьте по вкусу. Дайте покипеть 20 минут.","Разогрейте духовку до 200 °C. Для сборки лазаньи выложите немного рагу в дно формы для запекания, распределив соус по основанию. Положите 2 листа лазаньи поверх соуса, слегка перекрывая, затем повторите слои соуса и пасты. Повторите еще два слоя соуса и пасты, завершая слоем пасты.","В миске взбейте крем‑фреш с 2 столовыми ложками воды до однородной консистенции. Полейте сверху пасту, затем выложите моцареллу. Посыпьте пармезаном и запекайте 25–30 минут до золотистого цвета и пузырения. Подавайте, посыпав листьями базилика по желанию."]'::jsonb,
    65, 'medium', 'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tblsp Olive Oil', '1 столовая ложка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Bacon', '2 полоски бекона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'бекон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 finely chopped Onion', '1 мелко нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Stick Celery', '1 палочка сельдерея', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'сельдерей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 medium Carrots', '1 средняя морковь', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves chopped Garlic', '2 зубчика чеснока, мелко нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Minced Beef', '500 г говяжьего фарша', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'говяжий фарш'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbls Tomato Puree', '1 столовая ложка томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '800g Chopped Tomatoes', '800 г томатов в собственном соку', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'томаты в собственном соку'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tblsp Honey', '1 столовая ложка мёда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'мёд'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Lasagne Sheets', '500 г листов лазаньи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'лист лазаньи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400ml Creme Fraiche', '400 мл крем‑фреша', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'крем‑фреш'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '125g Mozzarella Balls', '125 г моцареллы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'моцарелла'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50g Parmesan Cheese', '50 г пармезана', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'пармезан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Topping Basil Leaves', 'Листья базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52844' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52770', 'Spaghetti Bolognese', 'Beef', '["Put the onion and oil in a large pan and fry over a fairly high heat for 3-4 mins. Add the garlic and mince and fry until they both brown. Add the mushrooms and herbs, and cook for another couple of mins.","Stir in the tomatoes, beef stock, tomato ketchup or purée, Worcestershire sauce and seasoning. Bring to the boil, then reduce the heat, cover and simmer, stirring occasionally, for 30 mins.","Meanwhile, cook the spaghetti in a large pan of boiling, salted water, according to packet instructions. Drain well, run hot water through it, put it back in the pan and add a dash of olive oil, if you like, then stir in the meat sauce. Serve in hot bowls and hand round Parmesan cheese, for sprinkling on top."]'::jsonb,
    'Спагетти Болоньезе', 'Блюдо из говядины', '["Нарежьте лук мелкими кубиками. Разогрейте оливковое масло в большой сковороде на среднем огне и обжарьте лук до прозрачности, около 3‑4 минут.","Добавьте чеснок и фарш, обжаривайте, помешивая, пока фарш не подрумянится и чеснок не станет ароматным.","Выложите грибы и сушёный орегано, готовьте ещё пару минут, пока грибы не отдадут влагу.","Влейте томаты, горячий говяжий бульон, томатную пасту и соус Вустерширский. Посолите и поперчите по вкусу. Доведите до кипения, затем уменьшите огонь, накройте крышкой и тушите, периодически помешивая, 30 минут.","В это время отварите спагетти в большой кастрюле с кипящей, подсоленной водой согласно инструкции на упаковке. Слейте воду, промойте спагетти горячей водой, верните в кастрюлю, добавьте щепотку оливкового масла и перемешайте.","Снимите спагетти с огня, добавьте к ним мясной соус, перемешайте и подавайте горячими. Посыпьте сверху тертым пармезаном по желанию."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/sutysw1468247559.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 onions', '2 луковицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tbsp olive oil', '1 ст.л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove garlic', '1 зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g lean minced beef', '500 г постного фарша', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'постный фарш из говядины'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '90g mushrooms', '90 г грибов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'грибы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tsp dried oregano', '1 ч.л. сушёного орегано', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'сушёный орегано'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g can tomatoes', '400 г консервированных томатов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'консервированные томаты'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300ml hot beef stock', '300 мл горячего говяжьего бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'горячий говяжий бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tbsp tomato puree', '1 ст.л. томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tbsp worcestershire sauce', '1 ст.л. соуса Вустерширского', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'соус вустерширский'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '350g spaghetti', '350 г спагетти', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'спагетти'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Topping parmesan', 'пармезан для посыпки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52770' AND LOWER(i.name) = 'пармезан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53220', 'kabse', 'Chicken', '["1","Caramelize the chicken with olive oil then add a maggi cube and boil it for around 30 minutes.","2","In another pot, add all the veggies and caramelize them till they are soft.","3","Once everything is done, add the rice, raisins \u0026 spices to the veggies and add 2 and a half cups of water for the rice to cook.","4","Once the rice is done put everything in the oven."]'::jsonb,
    'Кабсе с курицей и овощами', 'Блюдо из курицы', '["1. Помажьте курицу оливковым маслом, затем добавьте кубик магги и варите около 30 минут.","2. В другой кастрюле добавьте все овощи и карамелизуйте до мягкости.","3. Когда всё готово, добавьте рис, изюм и специи к овощам, затем залейте 2,5 стакана воды для варки риса.","4. После того как рис сварится, переложите всё в духовку и запекайте до готовности."]'::jsonb,
    70, 'medium', 'https://www.themealdb.com/images/media/meals/utqnjv1763598650.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Chicken', '400 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Rice', '1 стакан риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Green Pepper', '1 зеленый перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'зеленый перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Red Pepper', '1 красный перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Mushrooms', '2 гриба', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'грибы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Sweetcorn', '1 банка кукурузы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'кукуруза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Carrots', '2 моркови', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Raisins', 'горсть изюма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'изюм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Turmeric', '1 ч.л. куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Kabse Spice', '1 ч.л. специи кабсе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'специя кабсе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Black Pepper', 'щепотка черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53220' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53358', 'Chicken Mandi', 'Chicken', '["1. Clean and cut the chicken; marinate briefly with salt, turmeric and a little oil.","2. Rinse and soak basmati rice 20–30 minutes.","3. In a large pot, heat ghee/oil. Fry chopped onion until golden. Add minced garlic and green chillies and fry 1–2 min.","4. Add whole spices (cardamom, cloves, cinnamon, bay leaves) and ground spices (coriander, cumin). Stir until fragrant.","5. Add chicken pieces, brown lightly and add enough water/chicken stock to cover. Simmer until chicken is nearly cooked.","6. Remove chicken; measure remaining liquid and add soaked rice. Bring to a boil, then reduce heat, cover and cook rice until almost done.","7. Return the chicken to the rice pot on top, cover tightly and steam on low for 10–15 min so flavors meld.","8. (Optional) For authentic smoky aroma: heat a small charcoal until red hot, place it on a small foil cup in the centre of the pot, add a tsp of butter/oil on the coal then cover immediately to trap smoke for 5–10 minutes. Remove coal.","9. Garnish with fried onions, chopped coriander and serve with chutney or raita."]'::jsonb,
    'Куриный мандий', 'Блюдо из курицы', '["1. Очистите курицу и разрежьте её на куски; приправьте солью, куркумой и небольшим количеством масла, оставьте мариноваться 10–15 минут.","2. Промойте басмати рис и замочите его в холодной воде 20–30 минут.","3. В большой кастрюле разогрейте растительное масло. Обжарьте нарезанный лук до золотистого цвета. Добавьте измельчённый чеснок и зеленый чили, обжаривайте 1–2 минуты.","4. Добавьте целые специи (кардамон, гвоздика, корица, лавровый лист) и молотые специи (кориандр, тмин). Перемешайте до появления аромата.","5. Выложите куски курицы, обжарьте до лёгкой корочки, затем залейте достаточным количеством воды или куриного бульона так, чтобы курица была покрыта. Доведите до кипения и тушите, пока курица почти не приготовится.","6. Уберите курицу из кастрюли; измерьте оставшийся бульон и добавьте в него замоченный рис. Доведите до кипения, затем уменьшите огонь, накройте крышкой и готовьте рис до почти готовности.","7. Верните курицу в кастрюлю, разместив её сверху, плотно накройте крышкой и тушите на медленном огне 10–15 минут, чтобы ароматы смешались.","8. (Опционально) Для аутентичного дымного аромата разогрейте небольшую кость угля до красного жара, положите её в маленькую алюминиевую чашу в центре кастрюли, добавьте чайную ложку масла на уголь, затем немедленно накройте крышкой, чтобы запечатать дым, 5–10 минут. Удалите уголь.","9. Подавайте, посыпав жареным луком, нарезанной кинзой, с чатни или раитой."]'::jsonb,
    80, 'medium', 'https://www.themealdb.com/images/media/meals/er4d081765186828.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Chicken', '1 курица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups Basmati Rice', '400 г басмати риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'басмати рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cups Water', '1 л воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Onion', '1 крупный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cloves Garlic', '4 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Green Chilli', '2 зеленых перца чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'зеленый перец чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 ½ tsp Salt', '7,5 г соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tablespoons Oil', '45 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Turmeric Powder', '15 г куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon Coriander', '5 г кориандра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'кориандр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '½ tbsp Cardamom', '7,5 г кардамона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'кардамон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '¼ teaspoon Cloves', '1,25 г гвоздики', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'гвоздика'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Cinnamon', '2,5 г корицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'корица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Pepper', '5 г черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Bay Leaf', '2 лавровых листа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53358' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53155', 'Spanish chicken pie', 'Chicken', '["step 1","Heat oven to 200C/fan 180C/gas 6. Boil the potatoes for 15-20 mins until tender. Drain, return to the pan, then mash with some seasoning and 2 tsp of the paprika.","step 2","Meanwhile, heat the oil in a large pan, then fry the onions and garlic for a few mins until softened. Stir in the remaining paprika for 1 min, add the tomatoes , then, bring to a simmer. Tip into a large ovenproof dish, then stir in the chicken, peppers, olives and some seasoning.","step 3","Spoon over the mash, then bake for 15 mins until the mash is golden on top and the sauce is bubbling."]'::jsonb,
    'Тортилья с курицей и паприкой', 'Курица', '["Нагрейте духовку до 200 °C (конвекция 180 °C, газ 6). Отварите картофель 15–20 минут до мягкости. Слейте воду, верните в кастрюлю, затем разомните с приправами и 2 ч.л. паприки.","Пока картофель варится, разогрейте оливковое масло в большой сковороде, затем обжарьте лук и чеснок несколько минут до мягкости. Добавьте оставшуюся паприку и обжаривайте 1 минуту, затем добавьте консервированные помидоры и доведите до кипения. Переложите смесь в большую жаропрочную форму, затем добавьте курицу, жареный перец, зеленые оливки и приправы.","Выложите сверху картофельное пюре, затем запекайте 15 минут до золотистой корочки и пока соус не закипит."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/8ovxf41763253962.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 kg Potatoes', '1 кг картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tsp Paprika', '3 ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 teaspoons Olive Oil', '2 ч.л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Onion', '2 луковицы, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves minced Garlic', '2 зубчика чеснока, измельченных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '800g Tinned Tomatos', '800 г консервированных помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'консервированные помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Chicken', '300 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '140g Roasted pepper', '140 г жареного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'жареный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Green Olives', 'горсть зеленых оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53155' AND LOWER(i.name) = 'зеленые оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52945', 'Kung Pao Chicken', 'Chicken', '["Combine the sake or rice wine, soy sauce, sesame oil and cornflour dissolved in water. Divide mixture in half.","In a glass dish or bowl, combine half of the sake mixture with the chicken pieces and toss to coat. Cover dish and place in refrigerator for about 30 minutes.","In a medium frying pan, combine remaining sake mixture, chillies, vinegar and sugar. Mix together and add spring onion, garlic, water chestnuts and peanuts. Heat sauce slowly over medium heat until aromatic.","Meanwhile, remove chicken from marinade and sauté in a large frying pan until juices run clear. When sauce is aromatic, add sautéed chicken and let simmer together until sauce thickens."]'::jsonb,
    'Курица Кунг Пао', 'Курица', '["Смешайте саке, соевый соус, кунжутное масло и кукурузный крахмал, растворенный в воде. Разделите смесь пополам.","В стеклянной миске соедините половину смеси с кусочками курицы и перемешайте, чтобы они покрылись. Накройте миску и поставьте в холодильник примерно на 30 минут.","В средней сковороде соедините оставшуюся часть смеси, чили, уксус и сахар. Перемешайте и добавьте зеленый лук, чеснок, водяные орехи и арахис. Нагрейте соус медленно на среднем огне до появления аромата.","В это время выньте курицу из маринада и обжарьте в большой сковороде до тех пор, пока сок не станет прозрачным. Когда соус ароматный, добавьте обжаренную курицу и тушите вместе, пока соус не загустеет."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/1525872624.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Sake', '30 мл саке', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'саке'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Soy Sauce', '30 мл соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Sesame Seed Oil', '30 мл кунжутного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'кунжутное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Corn Flour', '16 г кукурузного крахмала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'кукурузный крахмал'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Water', '30 мл воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Chicken', '500 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Chilli Powder', '15 г порошка чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'порошок чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Rice Vinegar', '5 мл рисового уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'рисовый уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Brown Sugar', '15 г коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chopped Spring Onions', '4 порции нарезанного зеленого лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 cloves Garlic Clove', '6 зубчиков чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '220g Water Chestnut', '220 г водяных орехов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'водяные орехи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Peanuts', '100 г арахиса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52945' AND LOWER(i.name) = 'арахис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53204', 'Red curry chicken kebabs', 'Chicken', '["step 1","Fire up the barbecue or heat a griddle pan to high. Tip chicken, curry paste and coconut milk into a bowl, then mix well until the chicken is evenly coated. Thread vegetables and chicken onto skewers. Cook the skewers on the barbecue or griddle for 5-8 mins, turning every so often, until the chicken is cooked through and charred. Serve with herby rice, salad and a lime half to squeeze over."]'::jsonb,
    'Кебабы из курицы в красном карри', 'Блюдо из курицы', '["Разогрейте гриль или сковороду-гриль до высокой температуры.","Выложите куриное филе, тайскую красную карри пасту и кокосовое молоко в миску, тщательно перемешайте до однородного покрытия курицы.","Нарядите овощи и курицу на шпажки.","Жарьте шпажки на гриле или сковороде-гриль 5–8 минут, периодически переворачивая, пока курица полностью не прожарится и не подрумянится.","Подавайте с ароматным рисом, салатом и половинкой лайма, выдавив по вкусу."]'::jsonb,
    20, 'easy', 'https://www.themealdb.com/images/media/meals/prjve31763486864.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Chicken Breasts', '2 куриных филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Thai Red Curry Paste', '2 столовые ложки тайского красного карри пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'тайский красный карри паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Coconut Milk', '2 столовые ложки кокосового молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Red Pepper', '1 нарезанный красный перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Courgettes', '1 нарезанный цукини', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'цукини'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cut thin wedges Red Onions', '1 тонко нарезанный красный лук (в виде дольок)', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'красный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Lime', 'лайм для подачи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53204' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52830', 'Crock Pot Chicken Baked Tacos', 'Chicken', '["Put the uncooked chicken breasts in the crock pot. Pour the full bottle of salad dressing over the chicken. Sprinkle the rest of the ingredients over the top and mix them in a bit with a spoon.","Cover your crock pot with the lid and cook on high for 4 hours.","Remove all the chicken breasts from the crock pot and let cool.","Shred the chicken breasts and move to a glass bowl.","Pour most of the liquid over the shredded chicken.","FOR THE TACOS:","Make the guacamole sauce by mixing the avocado and green salsa together. Pour the guacamole mixture through a strainer until smooth and transfer to a squeeze bottle. Cut the tip off the lid of the squeeze bottle to make the opening more wide if needed.","Make the sour cream sauce by mixing the sour cream and milk together until you get a more liquid sour cream sauce. Transfer to a squeeze bottle.","In a 9x 13 glass baking dish, fill all 12+ tacos with a layer of refried beans, cooked chicken and shredded cheese.","Bake at 450 for 10-15 minutes just until the cheese is melted and bubbling.","Out of the oven top all the tacos with the sliced grape tomaotes, jalapeno and cilantro.","Finish with a drizzle of guacamole and sour cream.","Enjoy!"]'::jsonb,
    'Такос с курицей из мультиварки', 'Блюдо из курицы', '["Положите сырые куриные грудки в мультиварку. Залейте всю бутылку винегретного соуса. Посыпьте остальные ингредиенты сверху и слегка перемешайте ложкой.","Накройте крышкой и готовьте на высокой температуре 4 часа.","Уберите все куриные грудки из мультиварки и дайте им остыть.","Разделите куриные грудки на кусочки и переложите в стеклянную миску.","Полейте большую часть жидкости поверх порезанной курицы.","Для тако:","1. Приготовьте гуакамоле, смешав авокадо и зеленую сальсу. Процедите смесь через сито до однородности и переложите в бутылку с распылителем. При необходимости разрежьте крышку, чтобы увеличить отверстие.","2. Приготовьте соус из сметаны, смешав сметану и молоко до жидкой консистенции. Переложите в бутылку с распылителем.","3. В стеклянной форме 9x13 см заполните все 12 тортилья слоями: жареные бобы, курица, сыр.","4. Запекайте при 230°C 10-15 минут до расплавления сыра.","5. Снимите из духовки, украсьте половинками виноградных помидоров, халапеньо и кинзой.","6. Полейте гуакамоле и сметаной.","Наслаждайтесь!"]'::jsonb,
    240, 'medium', 'https://www.themealdb.com/images/media/meals/ypxvwv1505333929.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 - 6 Chicken Breasts', '4-6 куриных грудок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'куриные грудки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 bottle Vinaigrette Dressing', '1 бутылка винегретного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'винегретный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1½ tablespoon Cumin', '1,5 столовые ложки тмина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'тмин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Smoked Paprika', '1 столовая ложка копченой паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'копченая паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon Garlic', '1 чайная ложка чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 can Refried Beans', '1 банка жареных бобов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'жареные бобы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '12 Hard Taco Shells', '12 жестких тортилья для тако', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'тортилья для тако'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups Shredded Mexican Cheese', '2 стакана натертого мексиканского сыра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'мексиканский сыр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Halved Grape Tomatoes', 'половинки виноградных помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'виноградные помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Sliced and Seeded Jalapeno', 'срезанный и без семян халапеньо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'халапеньо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Peeled and Sliced Avocado', 'помидоры авокадо очищенные и нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'авокадо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Green Salsa', '2 столовые ложки зеленой сальсы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'зеленая сальса'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tablespoons Sour Cream', '3 столовые ложки сметаны', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'сметана'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Milk', '1 столовая ложка молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52830' AND LOWER(i.name) = 'молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53501', 'Num Pang – Cambodian Baguette Sandwich', 'Chicken', '["1. In a medium bowl, whisk together the soy sauce and honey to create a marinade.","2. Add the chicken thigh strips to the marinade, ensuring each piece is fully coated, and let it sit for 20 minutes at room temperature.","3. While the chicken marinates, combine the julienned carrots, daikon radish, rice vinegar, and granulated sugar in a separate bowl, stirring until the sugar dissolves to pickle the vegetables.","4. In a small bowl, mix the mayonnaise and sriracha sauce thoroughly to make a spicy aioli.","5. Heat the vegetable oil in a large skillet or wok over medium-high heat until it shimmers, about 2 minutes.","6. Add the marinated chicken strips to the hot skillet in a single layer, cooking for 4-5 minutes per side until they reach an internal temperature of 165°F and develop a golden-brown crust.","7. While the chicken cooks, lightly toast the split baguettes in a toaster oven or under a broiler for 2-3 minutes until just crisp on the edges.","8. Spread a generous layer of the spicy aioli on the inside of each toasted baguette.","9. Drain the pickled carrots and daikon radish from their liquid, then layer them onto the bottom half of each baguette.","10. Place the cooked chicken strips evenly over the pickled vegetables in each sandwich.","11. Top the chicken with fresh cilantro leaves and thinly sliced cucumber.","12. Close the sandwiches by pressing the top half of each baguette down gently."]'::jsonb,
    'Камбоджийский багет с курицей Num Pang', 'Блюдо из курицы', '["В средней миске взбейте соевый соус и мёд, чтобы получить маринад.","Добавьте полоски куриного бедра в маринад, убедившись, что каждое кусок полностью покрыт, и оставьте на 20 минут при комнатной температуре.","Пока курица маринуется, в отдельной миске соедините натёртые морковь, дайкон, рисовый уксус и сахар, перемешивая до растворения сахара, чтобы мариновать овощи.","В небольшой миске тщательно смешайте майонез и соус срирача, чтобы получить острый айоли.","Разогрейте растительное масло в большой сковороде или воке на среднем–высоком огне до блеска, примерно 2 минуты.","Выложите маринованные полоски курицы в горячую сковороду в один слой, готовя по 4–5 минут с каждой стороны до внутренней температуры 74 °C и золотистой корочки.","Пока курица готовится, слегка поджарьте разрезанные багеты в тостере или под грилем 2–3 минуты до лёгкой хрустящей корочки.","Нанесите щедрый слой острого айоли на внутреннюю сторону каждого поджаренного багета.","Слейте маринованные морковь и дайкон из жидкости, затем выложите их на нижнюю половину каждого багета.","Равномерно разместите готовые полоски курицы поверх маринованных овощей в каждом сэндвиче.","Сверху положите свежие листья кинзы и тонко нарезанный огурец.","Закройте сэндвичи, слегка прижав верхнюю половину каждого багета."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/o93jur1782769321.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Baguette', '4 багета', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'багет'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Chicken Thighs', '450 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Soy Sauce', '60 мл соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Honey', '30 мл мёда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'мёд'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Vegetable Oil', '30 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Carrots', '120 г моркови', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Daikon Radish', '120 г дайкон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'дайкон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Rice Vinegar', '60 мл рисового уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'рисовый уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Sugar', '15 г сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Mayonnaise', '60 мл майонеза', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'майонез'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Sriracha', '15 мл срирача', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'срирача'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Cilantro Leaves', '120 г кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Cucumber', '60 г огурца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53501' AND LOWER(i.name) = 'огурец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52839', 'Chilli prawn linguine', 'Pasta', '["Mix the dressing ingredients in a small bowl and season with salt and pepper. Set aside.","Cook the pasta according to the packet instructions. Add the sugar snap peas for the last minute or so of cooking time.","Meanwhile, heat the oil in a wok or large frying pan, toss in the garlic and chilli and cook over a fairly gentle heat for about 30 seconds without letting the garlic brown. Tip in the prawns and cook over a high heat, stirring frequently, for about 3 minutes until they turn pink.","Add the tomatoes and cook, stirring occasionally, for 3 minutes until they just start to soften. Drain the pasta and sugar snaps well, then toss into the prawn mixture. Tear in the basil leaves, stir, and season with salt and pepper.","Serve with salad leaves drizzled with the lime dressing, and warm crusty bread."]'::jsonb,
    'Лингвини с креветками и чили', 'Паста', '["В небольшой миске смешайте ингредиенты для заправки и приправьте солью и перцем. Оставьте в стороне.","Отварите пасту согласно инструкции на упаковке. За минуту до окончания варки добавьте сахарные горошины. Слейте воду.","Разогрейте оливковое масло в воке или большой сковороде. Добавьте чеснок и красный перец чили, обжаривайте на умеренном огне около 30 секунд, не давая чесноку подрумяниться. Затем добавьте креветки и обжаривайте на сильном огне, постоянно помешивая, около 3 минут до розового цвета.","Добавьте черри томаты и готовьте, помешивая, 3 минуты, пока они слегка не размягчатся. Слейте воду с пасты и горошин, затем добавьте их в сковороду с креветками. Всыпьте листья базилика, перемешайте и приправьте солью и перцем.","Подавайте блюдо, украсив листьями салата, полив заправкой из лайма, и подайте с тёплым хрустящим хлебом."]'::jsonb,
    30, 'medium', 'https://www.themealdb.com/images/media/meals/usywpp1511189717.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '280g Linguine Pasta', '280 г лапши лингвини', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'лапша лингвини'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200g Sugar Snap Peas', '200 г сахарных горошин', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'сахарные горошины'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Olive Oil', '2 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves chopped Garlic Clove', '2 зубчика чеснока, мелко нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Red Chilli', '1 крупный красный перец чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'красный перец чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '24 Skinned King Prawns', '24 крупные креветки без кожи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'королевские креветки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '12 Cherry Tomatoes', '12 черри томатов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'черри томаты'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Basil Leaves', 'горсть листьев базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Leaves Lettuce', 'лист салата', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'салат'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'to serve Bread', 'хлеб для подачи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'хлеб'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbsp Fromage Frais', '2 ст. л. свежего сыра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'свежий сыр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Grated Zest of 2 Lime', 'тертая цедра 2 лаймов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Caster Sugar', '2 ч. л. сахара-песка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52839' AND LOWER(i.name) = 'сахар-песок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52855', 'Banana Pancakes', 'Dessert', '["In a bowl, mash the banana with a fork until it resembles a thick purée. Stir in the eggs, baking powder and vanilla.","Heat a large non-stick frying pan or pancake pan over a medium heat and brush with half the oil. Using half the batter, spoon two pancakes into the pan, cook for 1-2 mins each side, then tip onto a plate. Repeat the process with the remaining oil and batter. Top the pancakes with the pecans and raspberries."]'::jsonb,
    'Банановые блинчики', 'Десерт', '["В миске разомните банан вилкой до густой пюре.","Добавьте яйца, щепотку разрыхлителя и щепотку ванильного экстракта, перемешайте.","Разогрейте большую антипригарную сковороду на среднем огне и смажьте половиной масла.","С помощью половины теста вылейте по две блинчики, готовьте 1–2 минуты с каждой стороны, затем переложите на тарелку.","Повторите с оставшимся маслом и тестом.","Посыпьте готовые блинчики орехами пекан и малиной."]'::jsonb,
    20, 'easy', 'https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Banana', '1 большая банан', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'банан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 medium Eggs', '2 средних яйца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'яйца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Baking Powder', 'щепотка разрыхлителя', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'разрыхлитель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'spinkling Vanilla Extract', 'щепотка ванильного экстракта', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'ванильный экстракт'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Oil', '1 чайная ложка масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '25g Pecan Nuts', '25 г орехов пекан', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'орех пекан'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '125g Raspberries', '125 г малины', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52855' AND LOWER(i.name) = 'малина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52804', 'Poutine', 'Miscellaneous', '["Heat oil in a deep fryer or deep heavy skillet to 365°F (185°C).","Warm gravy in saucepan or microwave.","Place the fries into the hot oil, and cook until light brown, about 5 minutes.","Remove to a paper towel lined plate to drain.","Place the fries on a serving platter, and sprinkle the cheese over them.","Ladle gravy over the fries and cheese, and serve immediately."]'::jsonb,
    'Пу́тин', 'Разное', '["Разогрейте растительное масло в глубокой фритюрнице или тяжелой сковороде до 185 °C.","Нагрейте говяжий бульон в сотейнике или микроволновке.","Выложите картофельные палочки в горячее масло и жарьте до светло‑коричневого цвета, примерно 5 минут.","Переложите их на бумажное полотенце, чтобы стекло лишнее масло.","Выложите картофель на сервировочную тарелку и посыпьте крошками сыра.","Полейте бульоном картофель и сыр, и подавайте немедленно."]'::jsonb,
    20, 'easy', 'https://www.themealdb.com/images/media/meals/uuyrrx1487327597.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Dash Vegetable Oil', 'щепотка растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52804' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Can Beef Gravy', '1 банка говяжьего бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52804' AND LOWER(i.name) = 'говяжий бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 thin cut Potatoes', '5 тонко нарезанных картофелин', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52804' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups Cheese Curds', '2 стакана крошек сыра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52804' AND LOWER(i.name) = 'крошки сыра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52928', 'BeaverTails', 'Dessert', '["In the bowl of a stand mixer, add warm water, a big pinch of sugar and yeast. Allow to sit until frothy.","Into the same bowl, add 1/2 cup sugar, warm milk, melted butter, eggs and salt, and whisk until combined.","Place a dough hook on the mixer, add the flour with the machine on, until a smooth but slightly sticky dough forms.","Place dough in a bowl, cover with plastic wrap, and allow to proof for 1 1/2 hours.","Cut dough into 12 pieces, and roll out into long oval-like shapes about 1/4 inch thick that resemble a beaver’s tail.","In a large, deep pot, heat oil to 350 degrees. Gently place beavertail dough into hot oil and cook for 30 to 45 seconds on each side until golden brown.","Drain on paper towels, and garnish as desired. Toss in cinnamon sugar, in white sugar with a squeeze of lemon, or with a generous slathering of Nutella and a handful of toasted almonds. Enjoy!"]'::jsonb,
    'Потоки Бобров', 'Десерт', '["В миску стационарного миксера налейте тёплую воду, щепотку сахара и дрожжи. Оставьте на 5–10 минут, пока смесь не начнёт пузыриться.","В ту же миску добавьте 120 мл сахара, тёплое молоко, растопленное масло, яйца и соль, взбейте до однородности.","Установите на миксер кулинарный крюк, добавьте муку, работайте до получения гладкого, слегка липкого теста.","Переложите тесто в миску, накройте пищевой пленкой и дайте подняться 90 минут.","Разделите тесто на 12 частей, раскатайте в длинные овальные формы толщиной около 6 мм, напоминающие хвосты бобра.","В глубокой кастрюле разогрейте растительное масло до 180 °C. Аккуратно обжарьте тесто по 30–45 секунд с каждой стороны до золотистого цвета.","Выложите на бумажные полотенца, дайте стечь лишнему маслу. По желанию посыпьте сахарно‑порцией, сахаром с лимонным соком или полейте Nutella и посыпьте жареными миндалями. Наслаждайтесь!"]'::jsonb,
    120, 'medium', 'https://www.themealdb.com/images/media/meals/ryppsv1511815505.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Water', '120 мл воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 parts Yeast', '10 мл дрожжей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'дрожжи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Sugar', '120 мл сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Milk', '120 мл молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 tblsp Butter', '90 мл сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Eggs', '2 яйца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'яйца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 ½ tsp Salt', '7,5 мл соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2-1/2 cups Flour', '300 г муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'for frying Oil', '1 литр растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'масло для жарки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'garnish Lemon', '1 лимон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'garnish Sugar', '2 ст.л. сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'garnish Cinnamon', '1 ч.л. корицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52928' AND LOWER(i.name) = 'корица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52920', 'Chicken Marengo', 'Chicken', '["Heat the oil in a large flameproof casserole dish and stir-fry the mushrooms until they start to soften. Add the chicken legs and cook briefly on each side to colour them a little.","Pour in the passata, crumble in the stock cube and stir in the olives. Season with black pepper – you shouldn’t need salt. Cover and simmer for 40 mins until the chicken is tender. Sprinkle with parsley and serve with pasta and a salad, or mash and green veg, if you like."]'::jsonb,
    'Курица Маренго', 'Блюдо из курицы', '["Нагрейте масло в большой огнеупорной кастрюле и обжарьте грибы до мягкости.","Добавьте куриные ножки и обжарьте их по 1-2 минуты с каждой стороны, чтобы слегка подрумяниться.","Влейте томатную пасту, разломайте куриный бульонный кубик и добавьте черные оливки.","Приправьте черным перцем, не добавляйте соль.","Накройте крышкой и тушите 40 минут, пока курица не станет мягкой.","Посыпьте петрушкой и подавайте с пастой и салатом, либо с пюре и зелёными овощами."]'::jsonb,
    55, 'medium', 'https://www.themealdb.com/images/media/meals/qpxvuq1511798906.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Olive Oil', '1 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Mushrooms', '300 г грибов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'грибы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chicken Legs', '4 куриные ножки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'куриные ножки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Passata', '500 г томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Chicken Stock Cube', '1 куриный бульонный кубик', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'куриный бульонный кубик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Black Olives', '100 г черных оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'черные оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Chopped Parsley', '1 пучок мелко нарезанной петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52920' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52765', 'Chicken Enchilada Casserole', 'Chicken', '["Cut each chicken breast in about 3 pieces, so that it cooks faster and put it in a small pot. Pour Enchilada sauce over it and cook covered on low to medium heat until chicken is cooked through, about 20 minutes. No water is needed, the chicken will cook in the Enchilada sauce. Make sure you stir occasionally so that it doesn''t stick to the bottom.","Remove chicken from the pot and shred with two forks.","Preheat oven to 375 F degrees.","Start layering the casserole. Start with about ¼ cup of the leftover Enchilada sauce over the bottom of a baking dish. I used a longer baking dish, so that I can put 2 corn tortillas across. Place 2 tortillas on the bottom, top with ⅓ of the chicken and ⅓ of the remaining sauce. Sprinkle with ⅓ of the cheese and repeat starting with 2 more tortillas, then chicken, sauce, cheese. Repeat with last layer with the remaining ingredients, tortillas, chicken, sauce and cheese.","Bake for 20 to 30 minutes uncovered, until bubbly and cheese has melted and started to brown on top.","Serve warm."]'::jsonb,
    'Запеканка «Куриная энчилада»', 'Блюдо из курицы', '["Нарежьте каждое куриное филе на примерно три части, чтобы они быстрее приготовились, и положите их в небольшую кастрюлю.","Вылейте соус энчилада поверх курицы и тушите, накрыв крышкой, на медленном до среднего огня до полной готовности курицы, примерно 20 минут. Не нужно добавлять воду, курица готовится в соусе. Периодически помешивайте, чтобы она не прилипала к дну.","Снимите курицу из кастрюли и распарьте её двумя вилками.","Разогрейте духовку до 190 °C.","Начните укладывать слои в форму для запекания. Сначала выложите около 60 мл соуса энчилада на дно формы. Положите две кукурузные тортилии поверх соуса, затем 1/3 курицы и 1/3 оставшегося соуса. Посыпьте 1/3 сыра Monterey Jack. Повторите, начиная с двух тортилий, затем курицы, соуса и сыра. Завершите последним слоем, используя оставшиеся ингредиенты, тортилии, курицу, соус и сыр.","Выпекайте 20–30 минут без крышки, пока поверхность не станет пузыриться, сыр не расплавится и слегка не подрумянится.","Подавайте горячим."]'::jsonb,
    50, 'medium', 'https://www.themealdb.com/images/media/meals/qtuwxu1468233098.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '14 oz jar Enchilada sauce', 'банка 400 г соуса энчилада', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52765' AND LOWER(i.name) = 'соус энчилада'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Cups shredded Monterey Jack cheese', '3 стакана тертого сыра Монтерей Джек', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52765' AND LOWER(i.name) = 'сыр монтерей джек'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 corn tortillas', '6 кукурузных лепешек (тортилий)', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52765' AND LOWER(i.name) = 'кукурузные тортильи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chicken breasts', '2 куриные грудки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52765' AND LOWER(i.name) = 'куриные грудки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53164', 'Spanish Chicken', 'Chicken', '["step 1","Heat oven to 190C/170C fan/gas 5. Put all the ingredients into a large, wide ovenproof dish. Mix everything together with your hands and season.","step 2","Bake for 45 mins, stirring the onions after 20 mins, until the chicken is golden and the onions tender. Serve with rice."]'::jsonb,
    'Испанская курица', 'Курица', '["Нагрейте духовку до 190 °C (170 °C с вентилятором/газ 5). Положите все ингредиенты в большую, широкую жаропрочную форму. Смешайте все руками и приправьте.","Выпекайте 45 минут, помешивая лук после 20 минут, пока курица не станет золотистой, а лук не размягчится. Подавайте с рисом."]'::jsonb,
    55, 'easy', 'https://www.themealdb.com/images/media/meals/pqulvm1763282839.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken Thighs', '8 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 sliced thinly Onion', '3 тонко нарезанных лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 teaspoons Paprika', '2 чайные ложки паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Zest and juice of 1 Lemon', 'резка и сок 1 лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Parsley', 'горсть петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150ml Chicken Stock', '150 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Olive Oil', '1 столовая ложка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53164' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53212', 'Thai drumsticks', 'Chicken', '["step 1","Heat oven to 200C/180C fan/gas 6 and line a baking tray with foil. Mix the chilli sauce with the orange zest and juice, garlic, curry paste and ¼ tsp salt. Add the chicken and coat really well.","step 2","Arrange the drumsticks on the foil, spaced apart. Coat the chicken with any marinade left in the bowl, then roast for 35-40 mins until tender. Wrap in foil or pack into a food container."]'::jsonb,
    'Тайские куриные ножки с чили', 'Курица', '["Нагрейте духовку до 200 °C (180 °C с вентилятором/газ 6) и застелите противень алюминиевой фольгой. Смешайте сладко-острый соус с цедрой и соком апельсина, чесноком, тайской красной пастой карри и ¼ чайной ложки соли. Добавьте курицу и хорошо обваляйте.","Разложите ножки на фольге, раздвинув их. Обмажьте курицу оставшимся маринадом, затем запекайте 35–40 минут до мягкости. Положите в фольгу или упакуйте в контейнер."]'::jsonb,
    50, 'medium', 'https://www.themealdb.com/images/media/meals/ittake1763586925.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons sweet chilli sauce', '2 столовые ложки сладко-острого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'сладко-острый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Zest of 1 Orange', 'цедра 1 апельсина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'цедра апельсина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Orange', '2 столовые ложки апельсинового сока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'апельсиновый сок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove peeled crushed Garlic', '1 зубчик чеснока, очищенный и измельченный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tblsp Thai Red Curry Paste', '1 столовая ложка тайской красной пасты карри', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'тайская красная паста карри'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken drumsticks', '8 куриных ножек', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53212' AND LOWER(i.name) = 'куриные ножки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53020', 'Rosol (Polish Chicken Soup)', 'Chicken', '["Add chicken to a large Dutch oven or stock pot","Cover with water","Bring to a boil and simmer for 2 to 2 1/2 hours, skimming any impurities off the top to insure a clear broth","If your pot is big enough, add the vegetables and spices for the last hour of the cooking time","My Dutch oven wasn’t big enough to hold everything, just the chicken and other bones filled the pot, so I cooked the meat/bones for the full cooking time, then removed them, and cooked the vegetables and spices separately","Strain everything out of the broth","Bone the chicken, pulling the meat into large chunks","Slice the carrots","Return the chicken and carrots to the broth","Cook noodles according to package instructions if you’re using them","Add noodles to bowl and then top with hot soup"]'::jsonb,
    'Росоль (польский куриный суп)', 'Суп из курицы', '["Нарежьте куриные ножки и положите их в большую кастрюлю или Dutch oven.","Залейте водой так, чтобы она покрывала мясо.","Доведите до кипения, затем уменьшите огонь и варите на медленном огне 2–2,5 часа, периодически снимая пену, чтобы бульон оставался прозрачным.","Если кастрюля достаточно большая, добавьте овощи и специи за последний час приготовления.","Если кастрюля не вмещает все ингредиенты, сначала варите курицу и кости 2,5 часа, затем выньте их, а овощи и специи варите отдельно.","Процедите бульон через сито, чтобы удалить все твердые части.","Разделите курицу на крупные куски, удалив кости.","Нарежьте морковь ломтиками.","Верните курицу и морковь в бульон.","Если используете лапшу, отварите её согласно инструкции на упаковке.","Подавайте горячий суп, добавив лапшу в тарелку и залив горячим бульоном."]'::jsonb,
    180, 'medium', 'https://www.themealdb.com/images/media/meals/lx1kkj1593349302.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chopped Chicken Legs', '4 куриные ножки, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'куриные ножки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 large Onions', '2 больших луковицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 chopped Carrots', '5 нарезанных морковок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Leek', '1 нарезанный порей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'порей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 small Celery', '1 маленький сельдерей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'сельдерей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 Cabbage', '1/4 кочана капусты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'капуста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 whole Cloves', '1 целая гвоздика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'гвоздика'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tsp Allspice', '1 ч.л. молотого всея', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'всея специи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Bay Leaf', '2 лавровых листа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 sprigs Parsley', '4 веточки петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 sprigs Dill', '4 веточки укропа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'укроп'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Pepper', '1 ч.л. перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Salt', '1 ст.л. соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53020' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52820', 'Katsu Chicken curry', 'Chicken', '["Prep:15min  ›  Cook:30min  ›  Ready in:45min","For the curry sauce: Heat oil in medium non-stick saucepan, add onion and garlic and cook until softened. Stir in carrots and cook over low heat for 10 to 12 minutes.","Add flour and curry powder; cook for 1 minute. Gradually stir in stock until combined; add honey, soy sauce and bay leaf. Slowly bring to the boil.","Turn down heat and simmer for 20 minutes or until sauce thickens but is still of pouring consistency. Stir in garam masala. Pour the curry sauce through a sieve; return to saucepan and keep on low heat until ready to serve.","For the chicken: Season both sides of chicken breasts with salt and pepper. Place flour, egg and breadcrumbs in separate bowls and arrange in a row. Coat the chicken breasts in flour, then dip them into the egg, then coat in breadcrumbs, making sure you cover both sides.","Heat oil in large frying pan over medium-high heat. Place chicken into hot oil and cook until golden brown, about 3 or 4 minutes each side. Once cooked, place on kitchen paper to absorb excess oil.","Pour curry sauce over chicken, serve with white rice and enjoy!"]'::jsonb,
    'Куриный карри в стиле Кацу', 'Курица', '["Подготовьте куриные филе: отбросьте до толщины 1 см, приправьте солью и перцем.","В отдельных мисках разместите пшеничную муку, взбитое яйцо и панировочные сухари. Обваляйте филе сначала в муке, затем окуните в яйцо, затем в сухари, покрывая обе стороны.","Разогрейте растительное масло в большой сковороде на среднем огне. Обжарьте куриные филе до золотистой корочки, примерно 3‑4 минуты с каждой стороны. Переложите на бумажное полотенце, чтобы удалить лишний жир.","Для соуса разогрейте подсолнечное масло в средней сковороде с антипригарным покрытием. Добавьте лук и чеснок, готовьте до мягкости.","Добавьте морковь и тушите на медленном огне 10‑12 минут.","Всыпьте пшеничную муку и карри порошок, обжаривайте 1 минуту.","Постепенно вливайте куриный бульон, постоянно помешивая, затем добавьте мед, соевый соус и лавровый лист. Доведите до кипения.","Убавьте огонь и тушите 20 минут, пока соус не загустеет, но останется жидким.","Добавьте гарм масала, перемешайте. Процедите соус через сито, верните в сковороду и держите на слабом огне до подачи.","Подавайте куриные филе, полив соусом, с белым рисом."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/vwrpps1503068729.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 pounded to 1cm thickness chicken breast', '4 куриных филе, отброшенных до толщины 1 см', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons plain flour', '2 столовые ложки пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 beaten egg', '1 яйцо, взбито', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'яйцо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g fine breadcrumbs', '100 г панировочных сухарей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'панировочные сухари'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '230ml frying vegetable oil', '230 мл растительного масла для жарки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons sunflower oil', '2 столовые ложки подсолнечного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'подсолнечное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced onions', '2 луковицы, нарезанные кольцами', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 chopped cloves garlic', '5 зубчиков чеснока, мелко нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced carrot', '2 морковки, нарезанные кружками', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons plain flour', '2 столовые ложки пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 teaspoons curry powder', '4 чайные ложки карри порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'карри порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '600ml chicken stock', '600 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 teaspoons honey', '2 чайные ложки меда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'мед'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 teaspoons soy sauce', '4 чайные ложки соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 bay leaf', '1 лавровый лист', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 teaspoon garam masala', '1 чайная ложка гарм масала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52820' AND LOWER(i.name) = 'гарм масала'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53142', 'Spiced tortilla', 'Vegetarian', '["step 1","Heat the oil in a large frying pan. Fry the onion and half the chilli for 5 mins until softened. Tip in the spices, fry for 1 min more, then add the cherry tomatoes, potatoes and coriander stalks to the pan. Season the eggs well, pour over the top of the veg and leave to cook gently for 8-10 mins until almost set.","step 2","Heat the grill and flash the tortilla underneath for 1-2 mins until the top is set. Scatter the coriander leaves and remaining chilli over the top, slice into wedges and serve with a green salad."]'::jsonb,
    'Приправленная тортилья', 'Вегетарианское блюдо', '["Нагрейте масло в большой сковороде. Обжарьте лук и половину чили 5 минут до мягкости.","Добавьте специи, обжаривайте еще 1 минуту, затем добавьте помидоры черри, картофель и стебли кориандра.","Хорошо приправьте яйца, вылейте их поверх овощей и тушите на медленном огне 8-10 минут до почти готовности.","Разогрейте гриль и быстро обжарьте тортилью снизу 1-2 минуты, пока верх не схватится.","Посыпьте листьями кориандра и оставшимся чили, нарежьте на дольки и подавайте с зеленым салатом."]'::jsonb,
    25, 'easy', 'https://www.themealdb.com/images/media/meals/7b862e1763194846.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Sunflower Oil', '1 столовая ложка подсолнечного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'подсолнечное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Onion', '1 луковица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Red Chilli', '1 красный чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'красный чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 teaspoon Curry Powder', '2 чайные ложки карри порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'карри порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Cherry Tomatoes', '300 г помидоров черри', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'помидоры черри'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Potatoes', '500 г картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Coriander', 'пучок кориандра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'кориандр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Egg', '8 яиц', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53142' AND LOWER(i.name) = 'яйцо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53520', 'Pastel de Choclo', 'Chicken', '["Place eggs in a saucepan and cover with water. Bring to a boil, remove from heat, and let eggs stand in hot water for 15 minutes.","Meanwhile, heat oil in a skillet over medium heat. Add onions, garlic, 1 pinch salt, ¼ teaspoon paprika, and black pepper; cook until fragrant, about 2 minutes. Add beef, remaining 1 teaspoon salt, remaining ¼ teaspoon paprika, and black pepper; cook and stir until beef mostly browned, about 5 minutes. Add chicken, raisins, and olives.","Remove eggs from hot water, cool under cold running water, and peel. Roughly chop; add to beef mixture. Keep pino warm.","Combine corn and basil in a blender or the bowl of a food processor; blend until smooth. Pour into a saucepan over medium heat. Add butter; cook and stir until thickened, 7 to 10 minutes. Stir in milk, 2 teaspoons sugar, and salt; cook until thickened to a paste, about 15 minutes more.","Preheat the oven to 350 degrees F (175 degrees C).","Spread pino into a baking dish. Cover with corn paste; sprinkle a little sugar on top.","Bake in the preheated oven until golden brown on top, about 20 minutes."]'::jsonb,
    'Кукурузный пастель', 'Курица', '["Положите яйца в кастрюлю и залейте холодной водой. Доведите до кипения, снимите с огня и оставьте яйца в горячей воде на 15 минут.","Тем временем разогрейте растительное масло в сковороде на среднем огне. Добавьте лук, чеснок, щепотку соли, ¼ чайной ложки паприки и черный перец; обжаривайте до появления аромата, около 2 минут. Добавьте говядину, оставшуюся 1 чайную ложку соли, оставшуюся ¼ чайной ложки паприки и черный перец; готовьте, помешивая, пока мясо почти не подрумянится, примерно 5 минут. Добавьте курицу, изюм и оливки.","Выньте яйца из горячей воды, охладите под холодной проточной водой и очистите от скорлупы. Разрежьте их крупными кусками и добавьте к мясной смеси. Держите пино (смесь) в тепле.","Смешайте кукурузу и базилик в блендере или чаше кухонного процессора; измельчите до однородной массы. Перелейте смесь в кастрюлю на среднем огне. Добавьте масло, готовьте, помешивая, пока масса не загустеет, 7–10 минут. Вмешайте молоко, 2 чайные ложки сахара и соль; готовьте, пока смесь не загустеет до пасты, примерно 15 минут.","Разогрейте духовку до 175 °C.","Выложите пино в форму для выпечки. Налейте сверху кукурузную пасту и слегка посыпьте сахаром.","Выпекайте в разогретой духовке до золотистой корочки сверху, примерно 20 минут."]'::jsonb,
    90, 'medium', 'https://www.themealdb.com/images/media/meals/47abic1782854326.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Eggs', '2 яйца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'яйца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chopped Onions', '2 луковицы, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves minced Garlic', '2 зубчика чеснока, измельченных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '1 чайная ложка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Paprika', '½ чайной ложки паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Black Pepper', 'по вкусу черный перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Ground Beef', '450 г говядины, фарша', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'говядина, фарш'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 Chicken', '½ курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Raisins', '2 ст. ложки изюма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'изюм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Green Olives', '2 ст. ложки зеленых оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'зеленые оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 cans Sweetcorn', '3 банки кукурузы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'кукуруза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Basil', '2 чайные ложки базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Butter', '1 ст. ложка сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Milk', '240 мл молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Sugar', '2 чайные ложки сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Salt', 'по вкусу соль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53520' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53201', 'Stir-fried chicken with chillies & basil', 'Chicken', '["Heat a wok or large frying pan until it is very hot, then add 1 tbsp of the oil. When it is very hot, add the chicken and stir-fry over a high heat for 8-10 minutes, until browned all over. Using a slotted spoon, take the chicken from the pan and set aside.","step 2","Reheat the wok and add the remaining oil. Toss in the garlic and shallots and stir fry for 3 minutes, until golden brown.","step 3","Return the chicken to the wok and add the chillies, fish sauce, dark soy sauce and sugar. Stir fry over a high heat for a further 8-10 minutes or until the chicken is cooked through. Stir in the basil leaves and serve at once."]'::jsonb,
    'Жареная курица с чили и базиликом', 'Курица', '["Разогрейте вок или большую сковороду до очень высокой температуры, затем добавьте 1 столовую ложку растительного масла. Когда масло станет очень горячим, добавьте курицу и жарьте на сильном огне 8–10 минут, пока она не подрумянится со всех сторон. С помощью шумовки выньте курицу из сковороды и отложите в сторону.","Перезагрейте вок и добавьте оставшееся растительное масло. Добавьте чеснок и шалот, жарьте 3 минуты до золотистого цвета.","Верните курицу в вок, добавьте красные чили, рыбный соус, темный соевый соус и сахар. Жарьте на сильном огне 8–10 минут, пока курица полностью не приготовится.","Добавьте листья базилика, перемешайте и подавайте немедленно."]'::jsonb,
    30, 'easy', 'https://www.themealdb.com/images/media/meals/el64dy1763483009.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Vegetable Oil', '2 столовые ложки растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '450g Chicken', '450 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tblsp chopped Garlic', '3 столовые ложки измельчённого чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tblsp chopped Shallots', '3 столовые ложки измельчённого шалота', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'шалот'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Red Chilli', '3 красных чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'красный чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Fish Sauce', '2 столовые ложки рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Soy Sauce', '2 чайные ложки соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Sugar', '2 чайные ложки сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Basil Leaves', 'горсть листьев базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53201' AND LOWER(i.name) = 'листья базилика'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53530', 'Creamy Mustard Chicken', 'Chicken', '["Pat the chicken dry and season the pieces with salt, pepper and paprika.","Heat a saucepan over medium high heat and add the oil. Let the oil heat for a few seconds. Add the chicken and cook to sear all the sides turning the pieces a couple of times until they are golden browned about 10 minutes.","Transfer the browned chicken to a plate and set a side. Add the onions and garlic to the skillet and cook for about 2 minutes or until soft. Add the chicken broth, mustard, honey and cream. Season with salt and black pepper.","Stir well and return the chicken pieces to the pan. Cover the pan and cook over medium low for about 45 minutes or until the chicken is cooked. The final temperature for chicken legs should be 170˚F.","Serve warm over white rice and garnish with chopped parsley."]'::jsonb,
    'Курица в горчичном креме', 'Курица', '["Промокните куриные ножки бумажным полотенцем и приправьте солью, перцем и паприкой.","Разогрейте сковороду на среднем огне, добавьте оливковое масло и дайте ему разогреться несколько секунд. Добавьте курицу и обжарьте до золотистой корочки со всех сторон, поворачивая куски несколько раз, примерно 10 минут.","Переложите обжаренную курицу на тарелку и отложите в сторону. В ту же сковороду добавьте лук и чеснок, готовьте около 2 минут до мягкости.","Влейте куриный бульон, горчицу, мёд и сливки. Приправьте солью и черным перцем.","Хорошо перемешайте и верните куриные ножки в сковороду. Накройте крышкой и тушите на медленном огне около 45 минут, пока курица не приготовится (температура внутренней части должна достигать 77 °C).","Подавайте горячим, полив белым рисом и украсив рубленой петрушкой."]'::jsonb,
    70, 'medium', 'https://www.themealdb.com/images/media/meals/4htbtm1783803558.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken Legs', '8 куриных ножек', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'куриные ножки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Paprika', '1 ч. л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '1 ч. л. соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Black Pepper', '1 ч. л. черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tablespoons Olive Oil', '4 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Cloves Crushed Garlic', '3 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Onion', '1/2 стакана лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups Chicken Stock', '2 стакана куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Mustard', '2 ст. л. горчицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'горчица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Heavy Cream', '1 стакан сливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'сливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Honey', '1 ст. л. мёда', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'мёд'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Garnish Parsley', 'петрушка для украшения', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53530' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52959', 'Baked salmon with fennel & tomatoes', 'Seafood', '["Heat oven to 180C/fan 160C/gas 4. Trim the fronds from the fennel and set aside. Cut the fennel bulbs in half, then cut each half into 3 wedges. Cook in boiling salted water for 10 mins, then drain well. Chop the fennel fronds roughly, then mix with the parsley and lemon zest.","Spread the drained fennel over a shallow ovenproof dish, then add the tomatoes. Drizzle with olive oil, then bake for 10 mins. Nestle the salmon among the veg, sprinkle with lemon juice, then bake 15 mins more until the fish is just cooked. Scatter over the parsley and serve."]'::jsonb,
    'Запечённый лосось с фенхелем и помидорами', 'Морепродукты', '["Разогрейте духовку до 180 °C.","Снимите листья с фенхеля и отложите в сторону. Разрежьте головки фенхеля пополам, затем каждую половину порежьте на три части. Варите в подсоленной кипящей воде 10 минут, затем слейте воду.","Нарежьте листья фенхеля крупно, смешайте с петрушкой и цедрой лимона.","Разложите отжатый фенхель на неглубокой жаропрочной форме, добавьте помидоры. Полейте оливковым маслом и запекайте 10 минут.","Положите лосось поверх овощей, сбрызните соком лимона, запекайте ещё 15 минут, пока рыба не станет готовой.","Посыпьте петрушкой и подавайте с черными оливками."]'::jsonb,
    35, 'easy', 'https://www.themealdb.com/images/media/meals/1548772327.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 medium Fennel', '2 средних фенхеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'фенхель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs chopped Parsley', '2 ст. л. рубленой петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 1 Lemon', 'сок 1 лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '175g Cherry Tomatoes', '175 г черри-помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'черри-помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Olive Oil', '1 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '350g Salmon', '350 г лосося', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'лосось'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'to serve Black Olives', 'черные оливки для подачи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52959' AND LOWER(i.name) = 'черные оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52846', 'Chicken & mushroom Hotpot', 'Chicken', '["Heat oven to 200C/180C fan/gas 6. Put the butter in a medium-size saucepan and place over a medium heat. Add the onion and leave to cook for 5 mins, stirring occasionally. Add the mushrooms to the saucepan with the onions.","Once the onion and mushrooms are almost cooked, stir in the flour – this will make a thick paste called a roux. If you are using a stock cube, crumble the cube into the roux now and stir well. Put the roux over a low heat and stir continuously for 2 mins – this will cook the flour and stop the sauce from having a floury taste.","Take the roux off the heat. Slowly add the fresh stock, if using, or pour in 500ml water if you’ve used a stock cube, stirring all the time. Once all the liquid has been added, season with pepper, a pinch of nutmeg and mustard powder. Put the saucepan back onto a medium heat and slowly bring it to the boil, stirring all the time. Once the sauce has thickened, place on a very low heat. Add the cooked chicken and vegetables to the sauce and stir well. Grease a medium-size ovenproof pie dish with a little butter and pour in the chicken and mushroom filling.","Carefully lay the potatoes on top of the hot-pot filling, overlapping them slightly, almost like a pie top.","Brush the potatoes with a little melted butter and cook in the oven for about 35 mins. The hot-pot is ready once the potatoes are cooked and golden brown."]'::jsonb,
    'Куриный и грибной горячий котелок', 'Блюдо из курицы', '["Разогрейте духовку до 200 °C. Растопите 50 г масла в средней кастрюле на среднем огне. Добавьте нарезанный лук и готовьте 5 минут, периодически помешивая. Затем добавьте грибы и готовьте до почти готовности лука и грибов.","Влейте 40 г пшеничной муки, перемешайте до образования густой пасты (ру). Если используете бульонный кубик, разломайте его в ру и хорошо перемешайте. Тушите на медленном огне 2 минут, постоянно помешивая, чтобы мука пропеклась.","Снимите кастрюлю с огня. Постепенно вливайте 500 мл воды (или свежий бульон, если не использовали кубик), постоянно помешивая. Добавьте щепотку мускатного ореха, щепотку горчичного порошка и перец по вкусу. Верните на средний огонь и доведите до кипения, постоянно помешивая. Когда соус загустеет, уменьшите огонь до минимума.","Добавьте предварительно отваренную курицу, кукурузу и овощи, хорошо перемешайте. Смажьте форму для запекания небольшим количеством масла и вылейте туда куриную смесь.","Выровняйте 2 больших картофеля, нарезанных кружками, поверх начинки, слегка перекрывая друг друга.","Смажьте картофель растопленным маслом и запекайте в духовке около 35 минут, пока картофель не станет золотистым и мягким.","Готовый горячий котелок подавайте горячим, украсив свежей зеленью по желанию."]'::jsonb,
    50, 'medium', 'https://www.themealdb.com/images/media/meals/uuuspp1511297945.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50g Butter', '50 г масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 луковица, нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Mushrooms', '100 г грибов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'грибы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '40g Plain Flour', '40 г пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Chicken Stock Cube', '1 куриный бульонный кубик', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'куриный бульонный кубик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Nutmeg', 'щепотка мускатного ореха', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'мускатный орех'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'pinch Mustard Powder', 'щепотка горчичного порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'горчичный порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Chicken', '250 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Handfuls Sweetcorn', '2 горсти кукурузы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'кукуруза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 large Potatoes', '2 больших картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 knob Butter', '1 крошка масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52846' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53207', 'Tom kha gai', 'Chicken', '["step 1","Pour the chicken stock and coconut milk into a large saucepan set over a medium heat. Tip in the galangal, lemongrass and lime leaves, and bring to a gentle simmer, around 6-8 mins. Keeping at a gentle simmer, add the chicken. Cook for 8-10 mins until tender and cooked through.","step 2","Stir in the mushrooms and chillies, and simmer for a further 3-5 mins until everything is cooked through. Sprinkle in the sugar and 3 tbsp each of the fish sauce and lime juice. Taste and add the remaining if required.","step 3","Remove the galangal, lemongrass and lime leaves before serving using a slotted spoon. Ladle into bowls and serve with coriander leaves sprinkled over and steamed rice on the side. Will keep chilled for up to three days. Leave to cool first."]'::jsonb,
    'Том-ка-гай', 'Куриный суп', '["В большой кастрюле разогрейте куриный бульон и кокосовое молоко на среднем огне. Добавьте пасту галангала, лимонную траву и листья лайма, доведите до лёгкого кипения и варите 6–8 минут. Затем добавьте куриные бедра и продолжайте готовить 8–10 минут, пока мясо не станет мягким и полностью прожаренным.","Добавьте устрицовые грибы и острые перцы, варите ещё 3–5 минут до готовности всех ингредиентов. Посыпьте сахаром и добавьте 3 ст.л. рыбного соуса и 3 ст.л. сока лайма. Попробуйте и при необходимости добавьте оставшиеся соус и сок.","Снимите с огня, выньте галангала, лимонную траву и листья лайма шумовкой. Переложите суп в тарелки, посыпьте кинзой и подавайте с отварным рисом. Суп можно хранить в холодильнике до трёх дней, но сначала дайте ему остыть."]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/ol2xxt1763582263.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '800ml Chicken Stock', '800 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '800g Coconut Milk', '800 г кокосового молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Galangal Paste', '2 ст.л. пасты галангала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'паста галангала'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Lemongrass Stalks', '2 стебля лимонной травы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'лимонная трава'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Lime Leaves', '8 листьев лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'листья лайма'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Chicken Thighs', '500 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Oyster Mushrooms', '300 г устрицовых грибов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'устрицовые грибы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Birds-eye Chillies', '6 острых перцев', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'острые перцы'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Caster Sugar', '1 ст.л. кристаллического сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'кристаллический сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 tablespoons Fish Sauce', '5 ст.л. рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 3 Lime', 'сок 3 лаймов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'сок лайма'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Coriander Leaves', 'для подачи кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Rice', 'для подачи риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53207' AND LOWER(i.name) = 'рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53028', 'Shawarma', 'Chicken', '["Combine the marinade ingredients in a large ziplock bag (or bowl).","Add the chicken and use your hands to make sure each piece is coated. If using a ziplock bag, I find it convenient to close the bag then massage the bag to disperse the rub all over each chicken piece.","Marinate overnight or up to 24 hours.","Combine the Yoghurt Sauce ingredients in a bowl and mix. Cover and put in the fridge until required (it will last for 3 days in the fridge).","Heat grill/BBQ (or large heavy based pan on stove) on medium high. You should not need to oil it because the marinade has oil in it and also thigh fillets have fat. But if you are worried then oil your hotplate/grill. (See notes for baking)","Place chicken on the grill and cook the first side for 4 to 5 minutes until nicely charred, then turn and cook the other side for 3 to 4 minutes (the 2nd side takes less time).","Remove chicken from the grill and cover loosely with foil. Set aside to rest for 5 minutes.","TO SERVE","Slice chicken and pile onto platter alongside flatbreads, Salad and the Yoghurt Sauce.","To make a wrap, get a piece of flatbread and smear with Yoghurt Sauce. Top with a bit of lettuce and tomato and Chicken Shawarma. Roll up and enjoy!"]'::jsonb,
    'Куриная шаурма', 'Блюдо из курицы', '["Смешайте ингредиенты для маринада в большой герметичной пакете (или миске).","Добавьте куриные бедра и при помощи рук убедитесь, что каждое кусок покрыт маринадом. Если используете пакет, удобно сначала закрыть его, а затем массировать, чтобы специи равномерно распределились по курице.","Оставьте мариноваться на ночь или до 24 часов.","Смешайте ингредиенты для йогуртового соуса в миске и перемешайте. Накройте и поставьте в холодильник до использования (соус хранится в холодильнике до 3 дней).","Разогрейте гриль/барбекю (или большую тяжелую сковороду на плите) на среднем‑высоком огне. Масло в маринаде и жир в бедрах обычно достаточно, но при необходимости можно слегка смазать гриль. (См. примечания по запеканию)","Положите курицу на гриль и готовьте первую сторону 4–5 минут до красивой корочки, затем переверните и готовьте вторую сторону 3–4 минуты (вторая сторона готовится быстрее).","Снимите курицу с гриля и слегка накройте фольгой. Оставьте отдыхать 5 минут.","Для подачи","Нарежьте курицу и выложите на блюдо рядом с лепешками, салатом и йогуртовым соусом.","Для приготовления шаурмы возьмите лепешку, намазать йогуртовым соусом, сверху положить немного салата и помидора, а также куриную шаурму. Сверните и наслаждайтесь!"]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/kcv6hj1598733479.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 kg Chicken Thighs', '1 кг куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Coriander', '1 ст.л. кориандра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'кориандр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Cumin', '1 ст.л. тмина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'тмин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Cardamom', '1 ст.л. кардамона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'кардамон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Cayenne Pepper', '1 ч.л. кайенского перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'кайненский перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Paprika', '2 ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Lemon Juice', '2 ст.л. лимонного сока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'лимонный сок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tbs Olive Oil', '3 ст.л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Greek Yogurt', '240 мл греческого йогурта', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'греческий йогурт'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Garlic Clove', '1 зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Cumin', '1 ч.л. тмина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'тмин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Splash Lemon Juice', 'небольшое количество лимонного сока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'лимонный сок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Sliced Lettuce', 'срезанный салат', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'салат'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Sliced Tomato', 'срезанный помидор', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'помидор'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Pita Bread', '6 лепешек питы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53028' AND LOWER(i.name) = 'пита'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52934', 'Chicken Basquaise', 'Chicken', '["Preheat the oven to 180°C/Gas mark 4. Have the chicken joints ready to cook. Heat the butter and 3 tbsp olive oil in a flameproof casserole or large frying pan. Brown the chicken pieces in batches on both sides, seasoning them with salt and pepper as you go. Don''t crowd the pan - fry the chicken in small batches, removing the pieces to kitchen paper as they are done.","Add a little more olive oil to the casserole and fry the onions over a medium heat for 10 minutes, stirring frequently, until softened but not browned. Add the rest of the oil, then the peppers and cook for another 5 minutes.","Add the chorizo, sun-dried tomatoes and garlic and cook for 2-3 minutes. Add the rice, stirring to ensure it is well coated in the oil. Stir in the tomato paste, paprika, bay leaves and chopped thyme. Pour in the stock and wine. When the liquid starts to bubble, turn the heat down to a gentle simmer. Press the rice down into the liquid if it isn''t already submerged and place the chicken on top. Add the lemon wedges and olives around the chicken.","Cover and cook in the oven for 50 minutes. The rice should be cooked but still have some bite, and the chicken should have juices that run clear when pierced in the thickest part with a knife. If not, cook for another 5 minutes and check again."]'::jsonb,
    'Курица Баска', 'Куриное блюдо', '["Разогрейте духовку до 180 °C. Подготовьте куриные куски. Разогрейте сливочное масло и 90 мл оливкового масла в огнеупорной кастрюле или большой сковороде. Обжарьте куриные куски партиями с обеих сторон, приправляя солью и перцем. Не загромождайте сковороду – жарьте небольшими порциями, вынимая готовые куски на бумажное полотенце.","Добавьте немного оливкового масла в кастрюлю и обжарьте лук на среднем огне 10 минут, часто помешивая, пока он не размягчится, но не подрумянится. Добавьте оставшееся масло, затем перцы и готовьте ещё 5 минут.","Добавьте чоризо, вяленые помидоры и чеснок, готовьте 2–3 минуты. Добавьте рис, перемешайте, чтобы он хорошо покрывался маслом. Вмешайте томатную пасту, паприку, лавровые листья и нарезанный тимьян. Влейте куриный бульон и сухое белое вино. Когда жидкость начнёт закипать, уменьшите огонь до слабого кипения. При необходимости прижмите рис к жидкости, чтобы он был полностью погружён, и разместите курицу сверху. Добавьте дольки лимона и оливки вокруг курицы.","Накройте крышкой и запекайте в духовке 50 минут. Рис должен быть готов, но ещё слегка упругим, а курица – соки должны выходить прозрачными при прокалывании ножом. Если не так, запекайте ещё 5 минут и проверьте снова."]'::jsonb,
    70, 'medium', 'https://www.themealdb.com/images/media/meals/wruvqv1511880994.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1.5kg Chicken', '1,5 кг курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '25g Butter', '25 г сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 tblsp Olive Oil', '90 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sliced Red Onions', '2 красных луковицы, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'красный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Large Red Pepper', '3 больших красных перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '130g Chorizo', '130 г чоризо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'чоризо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Sun-Dried Tomatoes', '8 вяленых помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'вяленые помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 cloves sliced Garlic', '6 зубчиков чеснока, нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Basmati Rice', '300 г басмати риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'рис басмати'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'drizzle Tomato Puree', 'пару ложек томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '½ tsp Paprika', '½ ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Bay Leaves', '4 лавровых листа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Thyme', 'горсть тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '350ml Chicken Stock', '350 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '180g Dry White Wine', '180 мл сухого белого вина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'сухое белое вино'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Lemons', '2 лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Black Olives', '100 г черных оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'черные оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'to serve Salt', 'соль по вкусу', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'to serve Pepper', 'перец по вкусу', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52934' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53497', 'Nom Banh Chok – Cambodian Noodle Soup', 'Chicken', '["1. Heat the vegetable oil in a large pot over medium heat until it shimmers, about 2 minutes.","2. Add the minced garlic and sauté until fragrant and lightly golden, about 1 minute, stirring constantly to prevent burning.","3. Add the chicken pieces and cook until they turn opaque on all sides, about 5 minutes, stirring occasionally.","4. Pour in the 8 cups of water and bring to a boil over high heat, which should take about 8 minutes.","5. Reduce the heat to low, stir in the fish sauce, salt, and sugar, and simmer uncovered for 20 minutes to develop the flavors.","6. While the broth simmers, cook the rice noodles according to package instructions until al dente, then drain and rinse under cold water to stop the cooking.","7. Divide the cooked noodles evenly among four bowls.","8. Ladle the hot broth and chicken over the noodles in each bowl.","9. Top each bowl with bean sprouts, chopped mint leaves, and optional red chili slices.","10. Serve immediately with lime wedges on the side for squeezing over the soup."]'::jsonb,
    'Ном Бань Кок – кхмерский суп с лапшой', 'Суп с курицей', '["Нагрейте растительное масло в большой кастрюле на среднем огне до блеска, около 2 минут.","Добавьте измельчённый чеснок и обжаривайте до аромата и лёгкого золотистого цвета, около 1 минуты, постоянно помешивая, чтобы не подгорело.","Добавьте куриные бедра и готовьте, пока они не станут непрозрачными со всех сторон, около 5 минут, время от времени помешивая.","Влейте 1,9 л воды и доведите до кипения на сильном огне, это займет примерно 8 минут.","Убавьте огонь до минимума, добавьте рыбный соус, соль и сахар, и томите без крышки 20 минут, чтобы ароматы раскрылись.","Пока бульон томится, отварите рисовые лапши согласно инструкции на упаковке до состояния al dente, затем слейте и промойте холодной водой, чтобы остановить процесс варки.","Разделите готовые лапши поровну по четырём тарелкам.","Налейте горячий бульон и курицу поверх лапши в каждой тарелке.","Посыпьте каждую тарелку молодым горошком, мелко нарезанной мятой и, при желании, ломтиками красного чили.","Подавайте сразу же с дольками лайма для сжатия по вкусу."]'::jsonb,
    55, 'medium', 'https://www.themealdb.com/images/media/meals/6g9gif1782688663.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 cups Water', '1,9 л воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1lb Chicken Thighs', '450 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Cloves Crushed Garlic', '4 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Vegetable Oil', '30 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Fish Sauce', '15 мл рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '5 мл соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Sugar', '5 мл сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 oz Rice Noodles', '227 г рисовых лапши', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'рисовые лапши'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups Bean Sprouts', '480 мл молодого горошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'молодой горошек'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Mint', '240 мл мяты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'мята'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Lime', '1 лайм', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Red Chilli', '1 красный перец чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53497' AND LOWER(i.name) = 'красный перец чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52806', 'Tandoori chicken', 'Chicken', '["Mix the lemon juice with the paprika and red onions in a large shallow dish. Slash each chicken thigh three times, then turn them in the juice and set aside for 10 mins.","Mix all of the marinade ingredients together and pour over the chicken. Give everything a good mix, then cover and chill for at least 1 hr. This can be done up to a day in advance.","Heat the grill. Lift the chicken pieces onto a rack over a baking tray. Brush over a little oil and grill for 8 mins on each side or until lightly charred and completely cooked through."]'::jsonb,
    'Тандури курица', 'Курица', '["Смешайте сок лимона с паприкой и красным луком в большой неглубокой миске. Сделайте три разреза в каждом бедре курицы, затем обмакните их в сок и отложите на 10 минут.","Смешайте все ингредиенты маринада и полейте ими курицу. Хорошо перемешайте, затем накройте и охладите минимум 1 час. Можно подготовить за день до готовки.","Разогрейте гриль. Положите куски курицы на решетку над противнем. Смажьте небольшим количеством растительного масла и жарьте 8 минут с каждой стороны или до лёгкой подгорания и полной готовности."]'::jsonb,
    100, 'medium', 'https://www.themealdb.com/images/media/meals/qptpvt1487339892.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Juice lemons', '2 лимона (сок)', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tsp paprika', '4 чайные ложки паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 finely chopped red onions', '2 мелко нарезанных красных луковицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'красный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '16 skinnless chicken thighs', '16 куриных бедер без кожи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'For brushing vegetable oil', 'растительное масло для смазывания', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300ml Greek yogurt', '300 мл греческого йогурта', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'греческий йогурт'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'large piece ginger', 'большой кусок имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 garlic clove', '4 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '¾ tsp garam masala', '¾ чайной ложки гарам масала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'гарам масала'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '¾ tsp ground cumin', '¾ чайной ложки молотого кумина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'кумин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '½ tsp chilli powder', '½ чайной ложки порошка чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'порошок чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '¼ tsp turmeric', '¼ чайной ложки куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52806' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53376', 'Sweet and Sour Chicken', 'Chicken', '["Coat the chicken with egg white:","In a bowl, combine the chicken with the egg white, 1/2 teaspoon kosher salt, and cornstarch. Stir to coat the chicken evenly. Let sit for 15 minutes at room temperature or up to overnight in the refrigerator.","Make the sweet and sour sauce:","Whisk together the pineapple juice, vinegar, ketchup, 1/2 teaspoon kosher salt, and brown sugar.","Stir-fry the chicken over high heat:","Heat a large frying pan or wok over high heat until a bead of water instantly sizzles and evaporates. Pour in 1 tablespoon of cooking oil and swirl to coat. It''s important that the pan is very hot.","Add the chicken and spread the pieces out in one layer. Let the chicken fry untouched for 1 minute, until the bottoms are browned.","Flip and fry the other side for 1 minute. The chicken should still be pinkish in the middle. Dish out the chicken onto a clean plate, leaving as much oil in the pan as possible.","Stir-fry the bell pepper and ginger:","Reduce the heat to medium and add the remaining 1 teaspoon of cooking oil. Let the oil heat up before adding the bell pepper chunks and ginger. Fry for 1 minute.","Add the pineapple, sauce, and then, the chicken:","Add the pineapple chunks and the sweet and sour sauce. Turn up the heat to high. When the sauce is simmering, add the chicken pieces back in.","Let simmer for 1 to 2 minutes, until the chicken is cooked through. Timing depends on how thick you''ve cut your chicken. The best way to tell if the chicken is done is to take a piece out and cut into it. If it''s pink, add another minute to the cooking.","Adjust the seasoning and serve:","Taste the sauce and add more brown sugar or vinegar to suit your tastes, if you’d like.","Serve hot with steamed white or brown rice."]'::jsonb,
    'Курица в кисло-сладком соусе', 'Блюдо из курицы', '["Обваляйте курицу в яичных белках:","В миске соедините курицу с яичным белком, 2,5 мл кошерной соли и 10 мл кукурузного крахмала. Перемешайте, чтобы курица равномерно покрылась. Оставьте на 15 минут при комнатной температуре или до 24 часов в холодильнике.","Приготовьте кисло-сладкий соус:","Взбейте вместе ананасовый сок, белый уксус, томатный кетчуп, 2,5 мл кошерной соли и коричневый сахар.","Обжарьте курицу на сильном огне:","Нагрейте большую сковороду или вок до высокой температуры, пока капля воды не мгновенно не испарится. Влейте 15 мл растительного масла и разровняйте. Очень важно, чтобы сковорода была очень горячей.","Добавьте курицу и разложите куски в один слой. Обжаривайте без перемешивания 1 минуту, пока нижняя сторона не подрумянится.","Переверните и обжарьте другую сторону 1 минуту. Курица должна оставаться розоватой внутри. Переложите курицу на чистую тарелку, оставив как можно больше масла в сковороде.","Обжарьте болгарский перец и имбирь:","Уменьшите огонь до среднего и добавьте оставшиеся 5 мл масла. Дайте маслу разогреться, прежде чем добавить куски красного и желтого перца и имбирь. Жарьте 1 минуту.","Добавьте ананас, соус и затем курицу:","Выложите куски ананаса и кисло-сладкий соус. Увеличьте огонь до высокого. Когда соус закипит, верните курицу в сковороду.","Дайте покипеть 1–2 минуты, пока курица полностью не приготовится. Время зависит от толщины кусков. Самый надёжный способ проверить готовность – вынуть кусок и разрезать: если внутри розовый, добавьте ещё минуту.","Приправьте по вкусу и подавайте:","Попробуйте соус и при необходимости добавьте больше коричневого сахара или уксуса.","Подавайте горячей с отварным белым или коричневым рисом."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/arzs741766434335.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Chicken Thighs', '453 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Egg White', '30 мл яичного белка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'яичный белок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Kosher Salt', '5 мл кошерной соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'кошерная соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Cornstarch', '10 мл кукурузного крахмала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'кукурузный крахмал'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '10 oz Pineapple Chunks', '283 г ананасовых кусочков', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'ананасовые кусочки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Pineapple Juice', '60 мл ананасового сока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'ананасовый сок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup White Vinegar', '60 мл белого уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'белый уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Tomato Ketchup', '60 мл томатного кетчупа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'томатный кетчуп'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Brown Sugar', '45 мл коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tsp Oil', '20 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Red Pepper', '1 красный болгарский перец, нарезанный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'красный болгарский перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Yellow Pepper', '1 желтый болгарский перец, нарезанный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'желтый болгарский перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Ginger', '5 мл имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53376' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53011', 'Chicken Quinoa Greek Salad', 'Chicken', '["Cook the quinoa following the pack instructions, then rinse in cold water and drain thoroughly.","Meanwhile, mix the butter, chilli and garlic into a paste. Toss the chicken fillets in 2 tsp of the olive oil with some seasoning. Lay in a hot griddle pan and cook for 3-4 mins each side or until cooked through. Transfer to a plate, dot with the spicy butter and set aside to melt.","Next, tip the tomatoes, olives, onion, feta and mint into a bowl. Toss in the cooked quinoa. Stir through the remaining olive oil, lemon juice and zest, and season well. Serve with the chicken fillets on top, drizzled with any buttery chicken juices."]'::jsonb,
    'Греческий салат с курицей и киноа', 'Салат', '["Приготовьте киноа согласно инструкции на упаковке, затем промойте холодной водой и тщательно обсушите.","В миске соедините сливочное масло, красный перец чили и чеснок, измельчите до пасты. Обваляйте куриное филе в 30 мл оливкового масла с приправами, разогрейте сковороду и обжарьте по 3-4 минуты с каждой стороны до полной готовности. Переложите на тарелку, полейте острым маслом и отложите.","В миске смешайте помидоры, черные оливки, красный лук, фету и мяту. Добавьте готовое киноа, полейте оставшимся оливковым маслом, соком половины лимона и цедрой, хорошо перемешайте и приправьте по вкусу.","Подавайте салат, сверху разместив куриные филе, полив соусом из остатков масла и куриного сока.","Наслаждайтесь!"]'::jsonb,
    30, 'medium', 'https://www.themealdb.com/images/media/meals/k29viq1585565980.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '225g Quinoa', '225 г киноа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'киноа'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '25g Butter', '25 г сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'масло сливочное'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Red Chilli', '1 нарезанный красный перец чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'красный перец чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove finely chopped Garlic', '1 зубчик мелко нарезанного чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Chicken Breast', '400 г куриного филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Olive Oil', '30 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Black Olives', 'горсть черных оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'черные оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Red Onions', '1 нарезанный красный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'красный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Feta', '100 г феты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'фета'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Chopped Mint', 'мята, нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'мята'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 1/2 Lemon', 'сок половины лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53011' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52879', 'Chicken Parmentier', 'Chicken', '["For the topping, boil the potatoes in salted water until tender. Drain and push through a potato ricer, or mash thoroughly. Stir in the butter, cream and egg yolks. Season and set aside.","For the filling, melt the butter in a large pan. Add the shallots, carrots and celery and gently fry until soft, then add the garlic. Pour in the wine and cook for 1 minute. Stir in the tomato purée, chopped tomatoes and stock and cook for 10–15 minutes, until thickened. Add the shredded chicken, olives and parsley. Season to taste with salt and pepper.","Preheat the oven to 180C/160C Fan/Gas 4.","Put the filling in a 20x30cm/8x12in ovenproof dish and top with the mashed potato. Grate over the Gruyère. Bake for 30–35 minutes, until piping hot and the potato is golden-brown."]'::jsonb,
    'Куриный парментиер', 'Куриное блюдо', '["Для начинки сварите картофель в подсоленной воде до мягкости. Слейте воду и пропустите картофель через пресс или разомните до пюре. Добавьте масло, двойной крем и желтки. Приправьте по вкусу и отложите в сторону.","Для начинки растопите масло в большой сковороде. Добавьте шалот, морковь и сельдерей, обжарьте до мягкости, затем добавьте чеснок. Влейте вино и готовьте 1 минуту. Добавьте томатную пасту, консервированные помидоры и бульон, тушите 10–15 минут до загустения. Вмешайте курицу, оливки и петрушку. Приправьте солью и перцем по вкусу.","Разогрейте духовку до 180 °C.","Выложите начинку в жаропрочную форму размером 20 × 30 см, сверху выложите картофельное пюре. Посыпьте тертым сыром грюйер. Запекайте 30–35 минут, пока блюдо не станет горячим, а картофель не подрумянится."]'::jsonb,
    55, 'medium', 'https://www.themealdb.com/images/media/meals/uwvxpv1511557015.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1.5kg Potatoes', '1.5 кг картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '30g Butter', '30 г масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 tblsp Double Cream', '5 ст.л. двойного крема', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'двойной крем'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Egg Yolks', '2 желтка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'яйца желтки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '30g Butter', '30 г масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '7 Shallots', '7 шалот', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'шалот'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 chopped Carrots', '3 морковки, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sticks Celery', '2 палочки сельдерея', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'сельдерей'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 finely chopped Garlic Clove', '1 мелко нарезанный зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tbsp White Wine', '4 ст.л. белого вина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'белое вино'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbls Tomato Puree', '1 ст.л. томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Tinned Tomatos', '400 г консервированных помидоров', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'консервированные помидоры'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '350ml Chicken Stock', '350 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '600g Chicken', '600 г курицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'курица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '16 Black Olives', '16 черных оливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'черные оливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Parsley', '2 ст.л. петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50g Gruyere cheese', '50 г сыра грюйер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52879' AND LOWER(i.name) = 'сыр грюйер'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53531', 'Chicken in Orange Sauce Recipe (Pollo a la Naranja)', 'Chicken', '["Place the olive oil and butter in a large sauce pan over medium heat. Add the chopped onions, red bell pepper and garlic. Cook for about 3 minutes, stirring often until the vegetables are soft.","Add the chicken legs and season with salt and pepper. Cook for about 1 minute on each side.","Add the chicken broth, orange juice and cook for about 2 minutes scraping the bottom of the pan with a wooden spoon. Add the brown sugar and cover the pot. Reduce the heat to medium and cook for about 45 minutes or until chicken is cooked.","Spoon the sauce over the chicken and serve over white rice. Garnish with fresh cilantro."]'::jsonb,
    'Курица в апельсиновом соусе', 'Блюдо из курицы', '["Нагрейте оливковое масло и сливочное масло в большой сковороде на среднем огне. Добавьте нарезанный лук, красный перец и чеснок. Готовьте около 3 минут, часто помешивая, пока овощи не станут мягкими.","Добавьте куриные бедра и приправьте солью и перцем. Готовьте около 1 минуты с каждой стороны.","Добавьте куриный бульон, апельсиновый сок и готовьте около 2 минут, снимая сковороду от дна деревянной ложкой. Добавьте коричневый сахар и накройте крышкой. Уменьшите огонь до среднего и готовьте около 45 минут или до готовности курицы.","Полейте соусом курицу и подавайте с белым рисом. Украсьте свежей кинзой."]'::jsonb,
    60, 'medium', 'https://www.themealdb.com/images/media/meals/uuns781783804024.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chicken Legs', '4 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Olive Oil', '30 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Butter', '30 г сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Onion', '120 мл лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Red Pepper', '1 красный перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 cloves Chopped Garlic', '3 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Salt', '5 мл соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Black Pepper', '2,5 мл черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Chicken Stock', '240 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Orange Juice', '120 мл апельсинового сока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'апельсиновый сок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Brown Sugar', '45 мл коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Cilantro', '60 мл кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53531' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53503', 'Samlar Machu Kreung – Cambodian Sour Stew', 'Chicken', '["1. Heat 1 tbsp vegetable oil in a large pot over medium-high heat until it shimmers, about 1 minute.","2. Add 1 lb boneless, skinless chicken thighs to the pot and cook until browned on all sides, approximately 5-7 minutes, stirring occasionally to prevent sticking.","3. Pour 4 cups water into the pot and bring to a boil, then reduce heat to a simmer.","4. Stir in 2 tbsp tamarind paste, 1 tbsp fish sauce, and 1 tsp sugar until fully dissolved, about 1 minute.","5. Add 1 stalk lemongrass and 2 kaffir lime leaves to the pot, then cover and simmer for 10 minutes to infuse the broth with flavor.","6. Tip: Bruising the lemongrass before adding helps release its essential oils for a more aromatic stew.","7. Add 1 cup pineapple chunks, 1 cup cherry tomatoes, and 1 cup green beans to the pot, stirring gently to combine.","8. Simmer uncovered for 10-12 minutes, or until the green beans are tender but still crisp and the tomatoes start to soften.","9. Tip: Avoid overcooking the vegetables to maintain their vibrant color and texture in the final dish.","10. Stir in 1 Thai chili and simmer for an additional 2 minutes to incorporate the heat.","11. Tip: Taste the broth and adjust with extra tamarind paste or fish sauce if desired, but do so gradually to avoid overpowering the balance.","12. Remove the pot from heat and discard the lemongrass and kaffir lime leaves before serving.","13. Present the stew hot in bowls, optionally garnished with fresh herbs like cilantro."]'::jsonb,
    'Самлар Машу Крунг – кхмерский кислый суп', 'Курица', '["Нагрейте 15 мл растительного масла в большой кастрюле на среднем огне до блеска, примерно 1 минуту.","Добавьте 450 г куриных бедер без костей и кожи, обжаривайте до золотистой корочки со всех сторон, примерно 5–7 минут, периодически помешивая, чтобы не прилипло.","Влейте 1 л воды, доведите до кипения, затем уменьшите огонь до слабого кипения.","Вмешайте 30 мл тамариндовой пасты, 15 мл рыбного соуса и 5 г сахара, пока смесь полностью не растворится, около 1 минуты.","Добавьте 1 стебель лемонграсса и 2 листа лайма каффир, накройте крышкой и тушите 10 минут, чтобы бульон пропитался ароматом.","Перед добавлением лемонграсса слегка раздавите его, чтобы высвободить эфирные масла и усилить аромат супа.","Влейте 150 г ананасовых кусочков, 150 г помидоров черри и 150 г зеленой фасоли, аккуратно перемешайте.","Тушите без крышки 10–12 минут, пока фасоль не станет мягкой, но сохраняет хруст, а помидоры начнут размягчаться.","Не пережаривайте овощи, чтобы сохранить яркий цвет и текстуру.","Добавьте 1 нарезанный перец чили, тушите еще 2 минуты, чтобы пропитать суп теплом.","Попробуйте бульон и при необходимости добавьте немного тамариндовой пасты или рыбного соуса, но делайте это постепенно, чтобы не переборщить с вкусом.","Снимите кастрюлю с огня, удалите лемонграсс и листья лайма каффир перед подачей.","Подавайте горячим в тарелках, при желании украсив свежими травами, например кинзой."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/bmbvjk1782770310.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lb Chicken Thighs', '450 г куриных бедер без костей и кожи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Vegetable Oil', '15 мл растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cups Water', '1 л воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Tamarind Paste', '30 мл тамариндовой пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'тамариндовая паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Fish Sauce', '15 мл рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Sugar', '5 г сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Pineapple Chunks', '150 г ананасовых кусочков', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'ананасовые кусочки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Cherry Tomatoes', '150 г помидоров черри', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'помидоры черри'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Green Beans', '150 г зеленой фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'зеленая фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Stalk Lemongrass', '1 стебель лемонграсса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'лемонграсс'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Kaffir Lime Leaves', '2 листа лайма каффир', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'лайм каффир'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 sliced Chilli', '1 нарезанный перец чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53503' AND LOWER(i.name) = 'перец чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53268', 'Roasted chicken with creamy walnut sauce', 'Chicken', '["step 1","Heat oven to 200C/180C fan/gas 6. In a roasting tin, toss together the chicken, cumin, paprika, 1 tbsp olive oil and seasoning. Cook for 40 mins until the chicken is crisp and cooked through.","step 2","Meanwhile, tear up 1 pitta bread and place in a small bowl. Pour over a couple of tbsp chicken stock and leave to soak. Dry-fry the walnuts in a frying pan for about 3 mins until golden and toasted. Set aside. Heat the remaining oil in the pan and cook the onion and garlic until softened. Place the softened pitta bread, onion mixture and most of the nuts into a blender. Pour over the rest of the chicken stock and whizz together until a rough paste forms. Return the mixture to the pan. Add the cream and lemon juice, season and keep warm.","step 3","When the chicken is cooked, arrange on a platter. Stir the coriander through the sauce and spoon into a bowl. Roughly chop the remaining walnuts and scatter over the chicken. Toast the pittas, cut into wedges and serve alongside"]'::jsonb,
    'Запечённая курица с кремовым ореховым соусом', 'Курица', '["Нагрейте духовку до 200 °C (180 °C с вентилятором/газ 6). В жаропрочную форму положите курицу, кумин, паприку, 1 ст.л. оливкового масла и приправы. Запекайте 40 минут, пока курица не станет хрустящей и полностью прожаренной.","В то же время разорвите 1 питы и положите в небольшую миску. Залейте пару ст.л. куриного бульона и оставьте на 2‑3 минуты, чтобы хлеб впитал жидкость. В сковороде обжарьте грецкие орехи около 3 минут до золотистого цвета. Отложите. В той же сковороде разогрейте оставшееся масло и обжарьте лук и чеснок до мягкости. В блендер положите размягчённый хлеб, луковую смесь и большую часть орехов. Добавьте оставшийся бульон и взбейте до получения грубой пасты. Переложите смесь обратно в сковороду. Добавьте сливки и лимонный сок, приправьте по вкусу и держите на медленном огне.","Когда курица готова, выложите её на блюдо. Перемешайте кориандр в соусе и вылейте в миску. Остатки орехов порубите и посыпьте курицу. Поджарьте питы, разрежьте на треугольники и подавайте рядом"]'::jsonb,
    55, 'medium', 'https://www.themealdb.com/images/media/meals/ro8mzj1763800655.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 Chicken Thighs', '8 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Cumin', '1 ч.л. кумина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'кумин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Paprika', '1/2 ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Olive Oil', '2 ст.л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Pita Bread', '6 питы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'пита'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150ml Chicken Stock', '150 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '175g Walnuts', '175 г грецких орехов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'грецкие орехи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 луковица, мелко нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves chopped Garlic', '2 зубчика чеснока, мелко нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50 ml Single Cream', '50 мл сливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'сливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 1 Lemon', 'сок 1 лимона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Handful Coriander', 'горсть кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53268' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52937', 'Jerk chicken with rice & peas', 'Chicken', '["To make the jerk marinade, combine all the ingredients in a food processor along with 1 tsp salt, and blend to a purée. If you’re having trouble getting it to blend, just keep turning off the blender, stirring the mixture, and trying again. Eventually it will start to blend up – don’t be tempted to add water, as you want a thick paste.","Taste the jerk mixture for seasoning – it should taste pretty salty, but not unpleasantly, puckering salty. You can now throw in more chillies if it’s not spicy enough for you. If it tastes too salty and sour, try adding in a bit more brown sugar until the mixture tastes well balanced.","Make a few slashes in the chicken thighs and pour the marinade over the meat, rubbing it into all the crevices. Cover and leave to marinate overnight in the fridge.","If you want to barbecue your chicken, get the coals burning 1 hr or so before you’re ready to cook. Authentic jerked meats are not exactly grilled as we think of grilling, but sort of smoke-grilled. To get a more authentic jerk experience, add some wood chips to your barbecue, and cook your chicken over slow, indirect heat for 30 mins. To cook in the oven, heat to 180C/160C fan/gas 4. Put the chicken pieces in a roasting tin with the lime halves and cook for 45 mins until tender and cooked through.","While the chicken is cooking, prepare the rice \u0026 peas. Rinse the rice in plenty of cold water, then tip it into a large saucepan with all the remaining ingredients except the kidney beans. Season with salt, add 300ml cold water and set over a high heat. Once the rice begins to boil, turn it down to a medium heat, cover and cook for 10 mins.","Add the beans to the rice, then cover with a lid. Leave off the heat for 5 mins until all the liquid is absorbed. Squeeze the roasted lime over the chicken and serve with the rice \u0026 peas, and some hot sauce if you like it really spicy."]'::jsonb,
    'Курица в стиле джерк с рисом и горошком', 'Блюдо из курицы', '["Приготовьте маринад: в блендере соедините все ингредиенты с 1 ч.л. соли и измельчите до однородной пасты. Если смесь не смешивается, выключайте блендер, размешивайте вручную и повторяйте до однородности. Не добавляйте воду, чтобы маринад оставался густым.","Проверьте вкус маринада: он должен быть слегка солёным, но не переусердствовать. При желании добавьте больше чили. Если вкус слишком солёный и кислый, добавьте немного коричневого сахара до баланса.","Сделайте несколько надрезов в куриных бедрах и полейте маринадом, тщательно втирая его в мясо. Накройте и оставьте мариноваться в холодильнике на ночь.","Если хотите приготовить на гриле, разогрейте угли за час до готовки. Для более аутентичного вкуса добавьте древесные чипсы и готовьте курицу при медленном, косвенном огне 30 мин. Для духовки разогрейте до 180 °C, положите курицу в форму с половинками лайма и запекайте 45 мин до готовности.","Пока курица готовится, приготовьте рис и горошек. Промойте 200 г басмати риса в холодной воде, затем переложите в большую кастрюлю, добавьте 300 мл холодной воды, соль по вкусу и доведите до кипения. Уменьшите огонь до среднего, накройте крышкой и варите 10 мин.","Добавьте 800 г фасоли, накройте крышкой и дайте настояться 5 мин, пока жидкость полностью не впитается.","Сбрызните готовую курицу соком лайма и подавайте с рисом и горошком, при желании добавьте острый соус."]'::jsonb,
    75, 'medium', 'https://www.themealdb.com/images/media/meals/tytyxu1515363282.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '12 Chicken Thighs', '12 куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 Lime', '½ лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1  bunch Spring Onions', '1 пучок зелёного лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'зелёный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs chopped Ginger', '1 ст.л. измельчённого имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 cloves Garlic', '3 зубчика чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 Onion', '½ луковицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 chopped Red Chilli', '3 нарезанных красных чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'красный чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon Thyme', '½ ч.л. тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 1 Lime', 'сок 1 лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'сок лайма'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Soy Sauce', '2 ст.л. соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Vegetable Oil', '2 ст.л. растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tbs Brown Sugar', '3 ст.л. коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Allspice', '1 ст.л. всех специй', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'все специи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '200g Basmati Rice', '200 г басмати риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'басмати рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g Coconut Milk', '400 г кокосового молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1  bunch Spring Onions', '1 пучок зелёного лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'зелёный лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 sprigs Thyme', '2 веточки тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves chopped Garlic', '2 зубчика измельчённого чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Allspice', '1 ст.л. всех специй', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'все специи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '800g Kidney Beans', '800 г фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52937' AND LOWER(i.name) = 'фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52827', 'Massaman Beef curry', 'Beef', '["Heat oven to 200C/180C fan/gas 6, then roast the peanuts on a baking tray for 5 mins until golden brown. When cool enough to handle, roughly chop. Reduce oven to 180C/160C fan/gas 4.","Heat 2 tbsp coconut cream in a large casserole dish with a lid. Add the curry paste and fry for 1 min, then stir in the beef and fry until well coated and sealed. Stir in the rest of the coconut with half a can of water, the potatoes, onion, lime leaves, cinnamon, tamarind, sugar, fish sauce and most of the peanuts. Bring to a simmer, then cover and cook for 2 hrs in the oven until the beef is tender.","Sprinkle with sliced chilli and the remaining peanuts, then serve straight from the dish with jasmine rice."]'::jsonb,
    'Говядина в массаман карри', 'Блюдо из говядины', '["Разогрейте духовку до 200 ��C, затем разложите арахис на противне и запекайте 5 минут до золотистого цвета. После остывания нарежьте крупно. Уменьшите температуру до 180 °C.","В глубокой кастрюле с крышкой разогрейте 2 ст. л. кокосового крема. Добавьте пасту массаман и обжаривайте 1 минуту, затем добавьте говядину и обжаривайте до того, как она станет коричневой и запечатана.","Влейте оставшийся кокосовый крем с половиной банки воды, добавьте картофель, лук, листья лайма, палочку корицы, пасту тамаринд, коричневый сахар, рыбный соус и большую часть арахиса. Доведите до кипения, затем накройте крышкой и запекайте 2 часа, пока говядина не станет мягкой.","Посыпьте сверху мелко нарезанным чили и оставшимся арахисом. Подавайте горячим с жасминовым рисом."]'::jsonb,
    125, 'medium', 'https://www.themealdb.com/images/media/meals/tvttqv1504640475.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '85g Peanuts', '85 г арахиса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'арахис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400ml can Coconut cream', '400 мл кокосового крема', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'кокосовый крем'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tbsp Massaman curry paste', '4 ст. л. пасты массаман', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'паста массаман'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '600g stewing cut into strips Beef', '600 г говядины, нарезанной полосками', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'говядина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '450g waxy Potatoes', '450 г картофеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cut thin wedges Onion', '1 луковица, нарезанная тонкими дольками', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 leaves Lime', '4 листа лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'лист лайма'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Cinnamon stick', '1 палочка корицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'корица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Tamarind paste', '1 ст. л. пасты тамаринд', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'паста тамаринд'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp palm or soft light Brown sugar', '1 ст. л. коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Fish Sauce', '1 ст. л. рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 red deseeded and finely sliced, to serve chilli', '1 красный чили, без семян и мелко нарезанный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'to serve Jasmine Rice', 'жасминовый рис, для подачи', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52827' AND LOWER(i.name) = 'жасминовый рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53014', 'Pizza Express Margherita', 'Miscellaneous', '["1 Preheat the oven to 230°C.","2 Add the sugar and crumble the fresh yeast into warm water.","3 Allow the mixture to stand for 10 – 15 minutes in a warm place (we find a windowsill on a sunny day works best) until froth develops on the surface.","4 Sift the flour and salt into a large mixing bowl, make a well in the middle and pour in the yeast mixture and olive oil.","5 Lightly flour your hands, and slowly mix the ingredients together until they bind.","6 Generously dust your surface with flour.","7 Throw down the dough and begin kneading for 10 minutes until smooth, silky and soft.","8 Place in a lightly oiled, non-stick baking tray (we use a round one, but any shape will do!)","9 Spread the passata on top making sure you go to the edge.","10 Evenly place the mozzarella (or other cheese) on top, season with the oregano and black pepper, then drizzle with a little olive oil.","11 Cook in the oven for 10 – 12 minutes until the cheese slightly colours.","12 When ready, place the basil leaf on top and tuck in!"]'::jsonb,
    'Пицца Маргарита Express', 'Разное', '["1. Разогрейте духовку до 230 °C.","2. Добавьте сахар и распустите свежие дрожжи в тёплой воде.","3. Оставьте смесь на 10–15 минут в тёплом месте (на подоконнике в солнечный день лучше всего), пока не появится пена.","4. Просейте муку и соль в большую миску, сделайте в середине углубление и влейте дрожжевую смесь и оливковое масло.","5. Порошком слегка присыпьте руки и медленно перемешивайте ингредиенты до однородности.","6. Сильно присыпьте рабочую поверхность мукой.","7. Выложите тесто и месите 10 минут, пока оно не станет гладким, шелковистым и мягким.","8. Положите тесто в слегка смазанную оливковым маслом противень с антипригарным покрытием (мы используем круглую форму, но подойдет любая).","9. Распределите пассату по поверхности, доходя до краёв.","10. Ровномерно выложите моцареллу (или другой сыр), посыпьте орегано и чёрным перцем, затем полейте небольшим количеством оливкового масла.","11. Выпекайте 10–12 минут, пока сыр слегка не подрумянится.","12. По готовности положите листик базилика сверху и укройте!"]'::jsonb,
    55, 'easy', 'https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150ml Water', '150 мл воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Sugar', '1 ч.л. сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '15g Yeast', '15 г дрожжей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'дрожжи'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '225g Plain Flour', '225 г пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 1/2 tsp Salt', '1 ½ ч.л. соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Drizzle Olive Oil', 'Небольшое количество оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '80g Passata', '80 г пассаты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'пассата'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '70g Mozzarella', '70 г моцареллы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'моцарелла'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Peeled and Sliced Oregano', 'Пелено и нарезанное орегано', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'орегано'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Leaves Basil', 'Листья базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Black Pepper', 'Щепотка чёрного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53014' AND LOWER(i.name) = 'чёрный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52818', 'Chicken Fajita Mac and Cheese', 'Chicken', '["Fry your onion, peppers and garlic in olive oil until nicely translucent. Make a well in your veg and add your chicken. Add your seasoning and salt. Allow to colour slightly.","Add your cream, stock and macaroni.","Cook on low for 20 minutes. Add your cheeses, stir to combine.","Top with roasted peppers and parsley."]'::jsonb,
    'Куриные фахитас макароны с сыром', 'Курица', '["Обжарьте лук, перец и чеснок в оливковом масле до прозрачности.","В центре овощей сделайте углубление и добавьте курицу.","Добавьте приправу и соль, слегка обжарьте до золотистого цвета.","Влейте сливки, куриный бульон и макароны.","Тушите на медленном огне 20 минут.","Добавьте сыр, перемешайте до расплавления.","Украсить жареным перцем и рубленой петрушкой."]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/qrqywr1503066605.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g macaroni', '500 г макарон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'макароны'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cups chicken stock', '480 мл куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup heavy cream', '240 мл сливок', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'сливки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 packet fajita seasoning', 'пакетик приправы для фахитас', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'приправы для фахитас'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp salt', '5 мл соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 diced chicken breast', '3 куриные грудки, нарезанные кубиками', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'куриная грудка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbsp olive oil', '30 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 small finely diced onion', '1 маленькая луковица, мелко нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 finely diced red pepper', '2 красных перца, мелко нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'красный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 cloves minced garlic', '2 зубчика чеснока, измельченных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup cheddar cheese', '100 г твердого сыра чеддер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'сыр чеддер'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'garnish chopped parsley', 'порция рубленой петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52818' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53264', 'Smoky chicken skewers', 'Chicken', '["step 1","You need 15 skewers: if wooden, soak in water for 10 mins. Cut chicken into 3cm pieces and place in a bowl. Add 1 tbsp olive oil, the spices, garlic and vinegar, toss well and season. You can do this up to a day before and refrigerate.","step 2","Thread 2-3 pieces on each skewer. Pour remaining oil in a frying pan or rub onto a griddle pan. Get the pan hot and sear the chicken for 3-4 mins on each side – you may have to do this in batches, keeping the cooked skewers warm in a low oven. Serve with smoky aïoli if you like."]'::jsonb,
    'Куриные шашлычки с дымным ароматом', 'Курица', '["Если шпажки деревянные, замочите их в воде 10 минут.","Нарежьте куриные бедра на куски длиной 3 см и положите в миску.","Добавьте 30 мл оливкового масла, 5 мл семян фенхеля, 5 мл молотого кумина, 5 мл сладкой копченой паприки, 1 зубчик чеснока, очищенный и раздавленный, 5 мл винного уксуса, хорошо перемешайте и приправьте по вкусу.","Можно замариновать до дня заранее и хранить в холодильнике.","На каждые шпажки нанизывайте 2–3 кусочка курицы.","Разогрейте сковороду или гриль, смазав оставшимся маслом.","Жарьте курицу 3–4 минуты с каждой стороны, при необходимости делая порциями, а готовые шашлычки держите в разогретой духовке при низкой температуре.","Подавайте с дымным айоли по желанию."]'::jsonb,
    35, 'easy', 'https://www.themealdb.com/images/media/meals/3um6il1763794322.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6 Chicken Thighs', '6 ��уриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tablespoons Olive Oil', '30 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Fennel Seeds', '5 мл семян фенхеля', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'семена фенхеля'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Ground Cumin', '5 мл молотого кумина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'молотый кумин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp sweet smoked paprika', '5 мл сладкой копченой паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'сладкая копченая паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove peeled crushed Garlic', '1 зубчик чеснока, очищенный и раздавленный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Red Wine Vinegar', '5 мл винного уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'винный уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Smoky Aïoli', 'Для подачи дымный айоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53264' AND LOWER(i.name) = 'дымный айоли'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53327', 'Venezuelan Coconut Chicken', 'Chicken', '["Cut the chicken up into bite size pieces. Peel and cut the onions, mince the garlic.","Assemble the rest of the ingredients and you are ready to start cooking.","Make the Dish","Heat up a fry pan over medium heat. Add the oil and when hot, sauté the onion until translucent. Remove from pan and transfer to a blender or food processor.","Add tomatoes, garlic, turmeric, cumin, sugar, ginger paste, coconut milk, water and blend smooth.","In the same pan you cooked the onion, add the chicken and brown all sides. This should take about 3 minutes.","Add the blender ingredients and bay leaves to the pan, bring to a simmer and cook until the chicken is white inside and the liquid is creamy. (15 to 20 minutes)","Remove the bay leaves and serve with white rice."]'::jsonb,
    'Курица в кокосовом соусе по-венесуэльски', 'Курица', '["Нарежьте куриные филе небольшими кусочками. Очистите и нарежьте лук, измельчите чеснок.","Подготовьте остальные ингредиенты, и вы готовы к приготовлению.","Разогрейте сковороду на среднем огне. Добавьте оливковое масло и, когда оно разогреется, обжарьте лук до прозрачности. Уберите лук из сковороды и переложите в блендер или кухонный комбайн.","Добавьте помидоры, чеснок, куркуму, тмин, сахар, имбирную пасту, кокосовое молоко и воду, и взбейте до однородной массы.","В ту же сковороду, где жарился лук, добавьте курицу и обжарьте со всех сторон до золотистой корочки. Это займет около 3 минут.","Добавьте смесь из блендера и лавровые листья в сковороду, доведите до кипения и тушите, пока курица не станет белой внутри, а соус не загустеет, примерно 15–20 минут.","Уберите лавровые листья и подавайте с белым рисом."]'::jsonb,
    30, 'medium', 'https://www.themealdb.com/images/media/meals/z2sw3o1764378271.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Chicken Breasts', '2 куриных филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chopped Onion', '2 луковицы, нарезанные', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove peeled crushed Garlic', '1 зубчик чеснока, измельченный', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Bay Leaves', '4 лавровых листа', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Black Pepper', 'щепотка черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Turmeric', 'щепотка куркумы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'куркума'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Cumin', 'щепотка тмина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'тмин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Salt', 'щепотка соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Sugar', '1 столовая ложка сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Tomato', '3 помидора', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'помидор'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Ginger Paste', '1 столовая ложка имбирной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'имбирная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/3 cup Olive Oil', '1/3 стакана оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Can Coconut Milk', '1 банка кокосового молока (около 400 мл)', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup Water', '1/2 стакана воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53327' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53181', 'Spanish beans with chicken & chorizo', 'Chicken', '["step 1","Soak the beans for at least 4 hrs or overnight in a large bowl with plenty of water to cover. Next day, rinse and drain, then put in a large heavy based pan with the onion, paprika, herb bundle and chicken. Pour over enough water or stock to cover, bring to the boil, then reduce the heat, cover and simmer for 45 mins.","step 2","Remove the chicken to a plate, then add the potatoes and chorizo to the pan. Continue cooking for 30 mins until the beans and potatoes are tender.","step 3","Discard the skin and bones from the chicken and tear into large chunks. Return the chicken to the pan with the spinach and simmer for 5 mins."]'::jsonb,
    'Испанская фасоль с курицей и чоризо', 'Курица', '["1. Замочите фасоль минимум 4 часа или на ночь в большой миске с достаточным количеством воды, чтобы она была полностью покрыта. На следующий день промойте и слейте воду, затем переложите фасоль в большую тяжелую кастрюлю вместе с луком, паприкой, веточками тимьяна, лавровыми листьями и курицей. Залейте достаточным количеством воды или бульона, чтобы покрыть ингредиенты, доведите до кипения, затем уменьшите огонь, накройте крышкой и тушите 45 минут.","2. Уберите курицу на тарелку, затем добавьте картофель и чоризо в кастрюлю. Продолжайте готовить 30 минут, пока фасоль и картофель не станут мягкими.","3. Снимите кожу и кости с курицы, порежьте на крупные куски. Верните курицу в кастрюлю с шпинатом и тушите 5 минут."]'::jsonb,
    80, 'medium', 'https://www.themealdb.com/images/media/meals/bpkxtw1763332446.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Pinto Beans', '300 г пинто фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'пинто фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 мелко нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Paprika', '1 столовая ложка паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Sprigs of fresh Thyme', 'Веточки свежего тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Bay Leaves', 'Щепотка лавровых листьев', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'лавровый лист'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Parsley', 'Пучок петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Chicken Thighs', '4 куриных бедра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Jersey Royal Potatoes', '250 г картофеля Джерси Роял', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'картофель джерси роял'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Chorizo', '250 г чоризо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'чоризо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Spinach', '100 г шпината', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53181' AND LOWER(i.name) = 'шпинат'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53549', 'Chicken Salad With Mushrooms and Bacon', 'Chicken', '["Place chicken breast in a saucepan and cover with water. Bring to a boil, add 1 tsp salt and simmer for approximately 15 minutes. Allow chicken to cool and then shred meat with two forks.","Finely chop shallot/red onion.","Stir mayonnaise, crème fraîche, Dijon mustard and apple cider vinegar to combine. Season with salt, pepper and extra Dijon mustard to taste. Combine with onion and chicken.","Fry bacon until crisp and transfer to plate lined with paper towels.","Rinse mushrooms, slice and fry in the same pan as bacon until golden (approximately 5 minutes). Season with a bit of salt and pepper.","Arrange your chicken salad in a serving dish, topped with crisp bacon, mushrooms and chopped parsley. Serve on a slice of light or dark bread."]'::jsonb,
    'Куриный салат с грибами и беконом', 'Блюдо из курицы', '["Положите куриное филе в кастрюлю, залейте водой. Доведите до кипения, добавьте 1 ч.л. соли и варите около 15 минут. Остудите и разберите мясо вилками.","Мелко нарежьте шалот.","Взбейте майонез, сметану, горчицу дижон и яблочный уксус до однородности. Приправьте солью, перцем и дополнительной горчицей по вкусу. Смешайте с луком и курицей.","Обжарьте бекон до хрустящего состояния и переложите на бумажное полотенце.","Промойте шампиньоны, нарежьте и обжарьте в той же сковороде, что и бекон, до золотистого цвета (около 5 минут). Приправьте солью и перцем.","Выложите куриный салат в сервировочную тарелку, сверху положите хрустящий бекон, шампиньоны и мелко нарезанную петрушку. Подавайте на ломтике легкого или темного хлеба."]'::jsonb,
    40, 'easy', 'https://www.themealdb.com/images/media/meals/t5rgav1784659936.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300g Chicken Breast', '300 г куриного филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Shallots', '1 шалот', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'шалот'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Mayonnaise', '45 мл майонеза', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'майонез'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tablespoons Creme Fraiche', '60 мл сметаны', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'сметана'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 tsp Dijon Mustard', '15 мл горчицы дижон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'горчика дижон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tablespoon Apple Cider Vinegar', '15 мл яблочного уксуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'яблочный уксус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100g Bacon', '100 г бекона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'бекон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Mushrooms', '250 г шампиньонов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'шампиньоны'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Sprigs of fresh Parsley', 'несколько веточек свежей петрушки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Salt', 'по вкусу соль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Pepper', 'по вкусу перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53549' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52906', 'Flamiche', 'Vegetarian', '["For the pastry, sift the flour and salt into the bowl of a food processor, add the butter and lard, then whizz together briefly until the mixture looks like fine breadcrumbs. Tip the mixture into a bowl, then stir in the cheese and enough of the water for the mixture to come together. Tip out onto a lightly floured surface and knead briefly until smooth. Roll out thinly and line a 23cm x 4cm loose-?bottomed fluted flan tin. Prick the base with a fork. Chill for 20 minutes.","02.Melt the 75g butter in a saucepan over a low heat, then add the leeks and the salt. Cover and cook for ?10 minutes until soft. Uncover the pan, increase the heat and cook ?for 2 minutes, stirring occasionally, until the liquid has evaporated. Spoon onto a plate and leave to cool.","03.Preheat the oven to 200°C/fan180°C/gas 6. Line the pastry case with baking paper and baking beans or rice and blind bake for 15-20 minutes until the edges are biscuit-coloured. Remove the paper and beans/rice and return the case to the oven for 7-10 minutes until the base is crisp and lightly golden. Remove and set aside. Reduce the oven temperature to 190°C/fan170°C/gas 5.","04.Put the crème fraîche into a bowl with the whole egg, egg yolks and nutmeg. Lightly beat together, then season. Stir in the leeks. Spoon ?the mixture into the tart case and bake for 35-40 minutes until set ?and lightly golden. Remove from ?the oven and leave for 10 minutes. Take out of the tin and serve."]'::jsonb,
    'Фламич', 'Вегетарианское блюдо', '["Для теста просейте муку и соль в чашу кух��нного процессора, добавьте масло и сало, быстро взбейте до состояния мелкой крошки. Переложите смесь в миску, добавьте сыр и достаточное количество воды, чтобы тесто соединилось. Переложите на слегка присыпанную мукой поверхность, замесите до гладкости. Раскатайте тонко и выложите в форму 23×4 см с низкой стенкой. Прикоснитесь к основанию вилкой. Охладите 20 минут.","Растопите 75 г масла в сотейнике на медленном огне, добавьте лук и соль. Накройте крышкой и готовьте 10 минут до мягкости. Снимите крышку, увеличьте огонь и готовьте 2 минуты, помешивая, пока жидкость не испарится. Переложите на тарелку и дайте остыть.","Разогрейте духовку до 200 °C. Выложите тесто в форму, застелите пергаментом и застелите фасолью или рисом, выпекайте 15–20 минут до ��оричневого цвета краев. Уберите пергамент и фасоль/рис, верните форму в духовку и выпекайте 7–10 минут до хрустящей корочки и лёгкого золотистого оттенка. Снимите и отложите в сторону. Снизьте температуру до 190 °C.","В миске взбейте кефир, целое яйцо, яичные желтки и мускатный орех. Приправьте по вкусу. Добавьте лук. Вылейте смесь в форму и запекайте 35–40 минут до застывания и лёгкого золотистого цвета. Дайте 10 минут остыть, выньте из формы и подавайте."]'::jsonb,
    110, 'medium', 'https://www.themealdb.com/images/media/meals/wssvvs1511785879.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '75g Butter', '75 г масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1kg Leek', '1 кг лука репчатого', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'лук репчатый'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '½ tsp Salt', '½ ч.л. соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '300ml Creme Fraiche', '300 мл кефира', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'кефир'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Egg', '1 яйцо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'яйцо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 Egg Yolks', '3 яичных желтка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'яичные желтки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '¼ teaspoon Nutmeg', '¼ ч.л. мускатного ореха', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'мускатный орех'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '225g Plain Flour', '225 г пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '½ tsp Salt', '½ ч.л. соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '60g Butter', '60 г масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '60g Lard', '60 г сала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'сало'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '50g Cheddar Cheese', '50 г чеддера', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'чеддер'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Water', '2 ст.л. воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52906' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53206', 'Thai chicken cakes with sweet chilli sauce', 'Chicken', '["step 1","Toss the chicken, garlic, ginger, onion, coriander and chilli into a food processor and season well. Blitz until the chicken is finely ground and everything is well mixed. Use your hands to shape six small cakes.","step 2","Heat the oil in a frying pan, then fry the cakes over a medium heat for about 6-8 mins, turning once. Serve hot, with sweet chilli sauce, lime wedges, coriander, shredded spring onion and red chilli."]'::jsonb,
    'Тайские куриные котлеты с сладким чили соусом', 'Курица', '["Смешайте курицу, чеснок, имбирь, лук, кинзу и зеленый чили в кухонном комбайне, приправьте по вкусу. Прожарите до мелкой консистенции, пока все не смешается. Сформируйте из полученной массы шесть небольших котлет.","Нагрейте оливковое масло в сковороде, затем обжаривайте котлеты на среднем огне около 6–8 минут, переворачивая один раз. Подавайте горячими с соусом сладкого чили, дольками лайма, кинзой, нарезанным зеленым луком и красным чили."]'::jsonb,
    20, 'medium', 'https://www.themealdb.com/images/media/meals/6s3i3p1763488540.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 large Chicken Breast', '2 больших куриных филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'куриное филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove Garlic', '1 зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 small Ginger', '1 маленький кусочек имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 мелко нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 tbs Coriander', '4 ст. л. кинзы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'кинза'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Green Chilli', '1 мелко нарезанный зеленый чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'зеленый чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Olive Oil', '2 ст. л. оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve sweet chilli sauce', 'для подачи сладкого чили соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'сладкий чили соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To serve Lime', 'для подачи лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Chopped Spring Onions', 'мелко нарезанный зеленый лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Chopped Red Chilli', 'мелко нарезанный красный чили', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53206' AND LOWER(i.name) = 'красный чили'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53345', 'Jamaican Curry Chicken Recipe', 'Chicken', '["Equipment","Dutch Oven","Instructions","Add chicken thighs, all-purpose seasoning, 1 tablespoon of curry powder, onion, green onions, green pepper, garlic cloves, scotch bonnet pepper (if using), and thyme to a large bowl and combine, making sure all chicken pieces are covered with the seasoning. Cover and refrigerate for at least 1 hour or up to overnight.","One the chicken is done marinating, remove onions, peppers, and garlic cloves from chicken and set aside.","Heat olive oil in a large heavy bottom pot over medium heat. Add remaining curry powder and stir, cooking for about 20-30 seconds. Add onions, green pepper, garlic cloves, thyme, and scotch bonnet pepper (if using) to pot and stir until onions have softened, about 3-5 minutes. If your onions and peppers are looking dry, add about 1 tablespoon of water.","Add chicken and ¼ cup of water to the pot. Cover and reduce heat to medium low. Cook, stirring occasionally, for 30-35 minutes.","When there is about 15 minutes remaining, stir in potato and continue to cook covered.","Once chicken is cooked and potatoes are softened, remove from heat. Salt and pepper to taste."]'::jsonb,
    'Ямайский карри с курицей', 'Курица', '["Подготовьте оборудование: кастрюлю с толстым дном (Dutch Oven).","В большой миске соедините куриные бедра, универсальную приправу, 37,5 мл карри порошка, лук, зеленый лук, зеленый перец, чеснок, Scotch Bonnet (если используете) и тимьян. Хорошо перемешайте, чтобы все куски курицы были покрыты приправой. Накройте и уберите в холодильник минимум на 1 час, можно оставить на ночь.","После маринования выньте лук, перец и чеснок из курицы и отложите в сторону.","Разогрейте оливковое масло в большой тяжелой кастрюле на среднем огне. Добавьте оставшийся карри порошок и обжаривайте 20–30 секунд, помешивая.","Добавьте лук, зеленый перец, чеснок, тимьян и Scotch Bonnet (если используете) в кастрюлю, помешивая до размягчения лука, примерно 3–5 минут. Если овощи выглядят сухими, добавьте 1 столовую ложку воды.","Добавьте курицу и 60 мл воды в кастрюлю. Накройте крышкой и уменьшите огонь до среднего‑низкого. Готовьте, периодически помешивая, 30–35 минут.","За 15 минут до окончания добавьте картофель и продолжайте готовить под крышкой.","Когда курица готова и картофель мягкий, снимите с огня. Посолите и поперчите по вкусу."]'::jsonb,
    60, 'medium', 'https://www.themealdb.com/images/media/meals/o5fuq51764789643.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Lbs Chicken Thighs', '900 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 1/2 Tbs Curry Powder', '37,5 мл карри порошка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'карри порошок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp All-purpose Seasoning', '5 мл универсальной приправы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'универсальная приправа'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 нарезанный лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 chopped Spring Onions', '3 нарезанных зеленых лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 Green Pepper', '1/2 зеленого перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'зеленый перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Cloves Chopped Garlic', '4 зубчика чеснока, нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Scotch Bonnet', '1 нарезанный Scotch Bonnet', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'scotch bonnet'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 sprigs Thyme', '3 веточки тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3  tablespoons Olive Oil', '45 мл оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup Water', '60 мл воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Russet Potato', '1 крупный картофель', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Salt', 'по вкусу соль', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'To taste Pepper', 'по вкусу перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53345' AND LOWER(i.name) = 'перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52772', 'Teriyaki Chicken Casserole', 'Chicken', '["Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray.","Combine soy sauce, ½ cup water, brown sugar, ginger and garlic in a small saucepan and cover. Bring to a boil over medium heat. Remove lid and cook for one minute once boiling.","Meanwhile, stir together the corn starch and 2 tablespoons of water in a separate dish until smooth. Once sauce is boiling, add mixture to the saucepan and stir to combine. Cook until the sauce starts to thicken then remove from heat.","Place the chicken breasts in the prepared pan. Pour one cup of the sauce over top of chicken. Place chicken in oven and bake 35 minutes or until cooked through. Remove from oven and shred chicken in the dish using two forks.","*Meanwhile, steam or cook the vegetables according to package directions.","Add the cooked vegetables and rice to the casserole dish with the chicken. Add most of the remaining sauce, reserving a bit to drizzle over the top when serving. Gently toss everything together in the casserole dish until combined. Return to oven and cook 15 minutes. Remove from oven and let stand 5 minutes before serving. Drizzle each serving with remaining sauce. Enjoy!"]'::jsonb,
    'Терияки курица запеканка', 'Блюдо из курицы', '["Разогрейте духовку до 180 °C. Спрейте противень 23 × 33 см антипригарным спреем.","Смешайте соевый соус, 1/2 стакана воды, коричневый сахар, молотый имбирь и измельчённый чеснок в маленькой кастрюле, накройте крышкой. Доведите до кипения на среднем огне. Снимите крышку и варите минуту после закипания.","В отдельной миске взбейте кукурузный крахмал с 2 столовыми ложками воды до однородной массы. Как только соус закипит, добавьте смесь, перемешайте. Готовьте, пока соус не загустеет, затем снимите с огня.","Выложите куриные грудки в подготовленный противень. Полейте одну чашку соуса сверху. Поставьте в духовку и запекайте 35 минут или до полной готовности. Снимите из духовки и распарьте курицу вилками прямо в блюде.","Тем временем приготовьте овощи на пару или согласно инструкции на упаковке.","Добавьте приготовленные овощи и рис в противень с курицей. Влейте большую часть оставшегося соуса, оставив немного для заправки при подаче. Аккуратно перемешайте всё в противне. Верните в духовку и готовьте 15 минут. Снимите из духовки и дайте настояться 5 минут перед подачей. Полейте каждую порцию оставшимся соусом. Приятного аппетита!"]'::jsonb,
    70, 'medium', 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3/4 cup soy sauce', '3/4 стакана соевого соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'соевый соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 cup water', '1/2 стакана воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 cup brown sugar', '1/4 стакана коричневого сахара', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'коричневый сахар'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon ground ginger', '1/2 чайной ложки молотого имбиря', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'молотый имбирь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 teaspoon minced garlic', '1/2 чайной ложки измельчённого чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'измельчённый чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 Tablespoons cornstarch', '4 столовые ложки кукурузного крахмала', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'кукурузный крахмал'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 chicken breasts', '2 куриные грудки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'куриные грудки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 (12 oz.) stir-fry vegetables', '340 г смешанных овощей для жарки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'смешанные овощи для жарки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '3 cups brown rice', '3 стакана коричневого риса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52772' AND LOWER(i.name) = 'коричневый рис'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52977', 'Corba', 'Side', '["Pick through your lentils for any foreign debris, rinse them 2 or 3 times, drain, and set aside.  Fair warning, this will probably turn your lentils into a solid block that you’ll have to break up later","In a large pot over medium-high heat, sauté the olive oil and the onion with a pinch of salt for about 3 minutes, then add the carrots and cook for another 3 minutes.","Add the tomato paste and stir it around for around 1 minute. Now add the cumin, paprika, mint, thyme, black pepper, and red pepper as quickly as you can and stir for 10 seconds to bloom the spices. Congratulate yourself on how amazing your house now smells.","Immediately add the lentils, water, broth, and salt. Bring the soup to a (gentle) boil.","After it has come to a boil, reduce heat to medium-low, cover the pot halfway, and cook for 15-20 minutes or until the lentils have fallen apart and the carrots are completely cooked.","After the soup has cooked and the lentils are tender, blend the soup either in a blender or simply use a hand blender to reach the consistency you desire. Taste for seasoning and add more salt if necessary.","Serve with crushed-up crackers, torn up bread, or something else to add some extra thickness.  You could also use a traditional thickener (like cornstarch or flour), but I prefer to add crackers for some texture and saltiness.  Makes great leftovers, stays good in the fridge for about a week."]'::jsonb,
    'Чечевичный суп', 'Суп', '["Проверьте чечевицу на наличие посторонних предметов, промойте 2–3 раза, откиньте на дуршлаг и отложите в сторону.","В большой кастрюле разогрейте оливковое масло на среднем–высоком огне, добавьте лук и щепотку соли, обжаривайте около 3 минут, затем добавьте морковь и готовьте ещё 3 минуты.","Добавьте томатную пасту, перемешайте и готовьте 1 минуту. Затем быстро добавьте тмин, паприку, мяту, тимьян, черный перец и хлопья красного перца, перемешайте 10 секунд, чтобы специи раскрылись.","Сразу добавьте чечевицу, воду, овощной бульон и соль. Доведите до лёгкого кипения.","После закипания уменьшите огонь до среднего–низкого, накройте кастрюлю наполовину крышкой и готовьте 15–20 минут, пока чечевица не разварится, а морковь не станет мягкой.","После того как суп готов и чечевица мягкая, измельчите его в блендере или погружной блендере до нужной консистенции. Попробуйте, при необходимости добавьте соль.","Подавайте с крошкой крекеров, порванным хлебом или другим дополнением, чтобы добавить густоты. Можно использовать традиционный загуститель, но я предпочитаю крекеры для текстуры и солёности. Суп хорошо хранится в холодильнике до недели."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Lentils', '200 г чечевицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'чечевица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Onion', '1 средний лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Carrots', '1 средняя морковь', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'морковь'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbs Tomato Puree', '1 ст.л. томатной пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'томатная паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tsp Cumin', '2 ч.л. тмина', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'тмин'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp Paprika', '1 ч.л. паприки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'паприка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Mint', '1/2 ч.л. мяты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'мята'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/2 tsp Thyme', '1/2 ч.л. тимьяна', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'тимьян'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 tsp Black Pepper', '1/4 ч.л. черного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'черный перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1/4 tsp Red Pepper Flakes', '1/4 ч.л. хлопьев красного перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'хлопья красного перца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 cups Vegetable Stock', '1 л овощного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'овощной бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 cup Water', '240 мл воды', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'вода'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Sea Salt', 'щепотка морской соли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52977' AND LOWER(i.name) = 'морская соль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52834', 'Beef stroganoff', 'Beef', '["Heat the olive oil in a non-stick frying pan then add the sliced onion and cook on a medium heat until completely softened, so around 15 mins, adding a little splash of water if they start to stick at all. Crush in the garlic and cook for a 2-3 mins further, then add the butter. Once the butter is foaming a little, add the mushrooms and cook for around 5 mins until completely softened. Season everything well, then tip onto a plate.","Tip the flour into a bowl with a big pinch of salt and pepper, then toss the steak in the seasoned flour. Add the steak pieces to the pan, splashing in a little oil if the pan looks particularly dry, and fry for 3-4 mins, until well coloured. Tip the onions and mushrooms back into the pan. Whisk the crème fraîche, mustard and beef stock together, then pour into the pan. Cook over a medium heat for around 5 mins. Scatter with parsley, then serve with pappardelle or rice."]'::jsonb,
    'Бефстроганов', 'Блюдо из говядины', '["Нагрейте оливковое масло в антипригарной сковороде, добавьте нарезанный лук и готовьте на среднем огне до мягкости, около 15 минут, при необходимости добавьте каплю воды, чтобы лук не прилипал.","Добавьте чеснок и готовьте ещё 2–3 минуты, затем добавьте сливочное масло. Как только масло начнет слегка пениться, добавьте грибы и готовьте 5 минут до мягкости.","Приправьте всё хорошо, переложите на тарелку.","В миске смешайте муку с щепоткой соли и перца, обваляйте в ней куски говядины. В сковороду добавьте говядину, при необходимости полейте небольшим количеством масла, обжарьте 3–4 минуты до коричневого цвета. Переложите лук и грибы обратно в сковороду.","Взбейте сметану, горчицу и говяжий бульон, затем вылейте в сковороду. Готовьте на среднем огне около 5 минут.","Посыпьте петрушкой и подавайте с пастой паппарделле или рисом."]'::jsonb,
    45, 'medium', 'https://www.themealdb.com/images/media/meals/svprys1511176755.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbls Olive Oil', '1 столовая ложка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 Onions', '1 луковица', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove Garlic', '1 зубчик чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp Butter', '1 столовая ложка сливочного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'сливочное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '250g Mushrooms', '250 г шампиньонов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'шампиньоны'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Beef Fillet', '500 г говяжьего филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'говядина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1tbsp Plain Flour', '1 столовая ложка пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'пшеничная мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150g Creme Fraiche', '150 г сметаны', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'сметана'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tbsp English Mustard', '1 столовая ложка английской горчицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'английская горчица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '100ml Beef Stock', '100 мл говяжьего бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'говяжий бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Topping Parsley', 'Топпинг петрушка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52834' AND LOWER(i.name) = 'петрушка'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52819', 'Cajun spiced fish tacos', 'Seafood', '["Cooking in a cajun spice and cayenne pepper marinade makes this fish super succulent and flavoursome. Top with a zesty dressing and serve in a tortilla for a quick, fuss-free main that''s delightfully summery.","On a large plate, mix the cajun spice and cayenne pepper with a little seasoning and use to coat the fish all over.","Heat a little oil in a frying pan, add in the fish and cook over a medium heat until golden. Reduce the heat and continue frying until the fish is cooked through, about 10 minutes. Cook in batches if you don’t have enough room in the pan.","Meanwhile, prepare the dressing by combining all the ingredients with a little seasoning.","Soften the tortillas by heating in the microwave for 5-10 seconds. Pile high with the avocado, lettuce and spring onion, add a spoonful of salsa, top with large flakes of fish and drizzle over the dressing."]'::jsonb,
    'Такос с рыбой в кэджунском стиле', 'Морепродукты', '["Маринад из кэджунской приправы и кайенского перца делает рыбу невероятно сочной и ароматной. Подавайте с ярким соусом и в тортилье — быстрое, беззаботное блюдо, идеально подходящее для летнего сезона.","На большой тарелке смешайте кэджунскую приправу и кайенский перец с небольшим количеством соли и перца, затем обваляйте в этом соусе рыбу со всех сторон.","Нагрейте небольшое количество растительного масла в сковороде, добавьте рыбу и обжаривайте на среднем огне до золотистой корочки. Уменьшите огонь и продолжайте жарить, пока рыба полностью не приготовится, примерно 10 минут. При необходимости готовьте порциями.","В это время приготовьте соус, смешав все ингредиенты с небольшим количеством соли и перца.","Разогрейте тортильи в микроволновке 5–10 секунд, чтобы они стали мягкими. Сложите в них ломтики авокадо, салат, зеленый лук, добавьте ложку сальсы, сверху выложите рыбу и полейте соусом."]'::jsonb,
    30, 'easy', 'https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbsp cajun', '2 ст.л. кэджун', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'каджун'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp cayenne pepper', '1 ч.л. красного перца кайенского', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'красный перец кайенский'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 fillets white fish', '4 филе белой рыбы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'белая рыба'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 tsp vegetable oil', '1 ч.л. растительного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'растительное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '8 flour tortilla', '8 тортилья из пшеничной муки', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'тортилья из пшеничной муки'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 sliced avocado', '1 нарезанное авокадо', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'авокадо'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 shredded little gem lettuce', '2 порции тертого салата little gem', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'салат little gem'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 shredded Spring Onions', '4 порции нарезанного зеленого лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 x 300ml salsa', '1 порция 300 мл сальсы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'сальса'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 pot sour cream', '1 порция сметаны', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'сметана'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 lemon', '1 лимон', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'лимон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 clove finely chopped garlic', '1 зубчик мелко нарезанного чеснока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52819' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52978', 'Kumpir', 'Side', '["If you order kumpir in Turkey, the standard filling is first, lots of butter mashed into the potato, followed by cheese. There’s then a row of other toppings that you can just point at to your heart’s content – sweetcorn, olives, salami, coleslaw, Russian salad, allsorts – and you walk away with an over-stuffed potato because you got ever-excited by the choices on offer.","Grate (roughly – you can use as much as you like) 150g of cheese.","Finely chop one onion and one sweet red pepper.","Put these ingredients into a large bowl with a good sprinkling of salt and pepper, chilli flakes (optional)."]'::jsonb,
    'Кумпир', 'Гарнир', '["Если заказываете кумпир в Турции, стандартная начинка состоит из большого количества масла, размешанного в картофеле, затем сыра. Далее идут различные топпинги, которые можно выбирать по вкусу – кукуруза, оливки, салями, квашеная капуста, русский салат и прочее – и вы получаете переполненный картофель из-за множества вариантов.","Натереть (примерно – сколько хотите) 150 г сыра.","Нарезать мелко 1 лук и 1 красный сладкий перец.","Ввести эти ингредиенты в большую миску с щепоткой соли, перца и хлопьев перца (по желанию)."]'::jsonb,
    45, 'easy', 'https://www.themealdb.com/images/media/meals/mlchx21564916997.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 large Potatoes', '2 больших картофелины', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'картофель'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tbs Butter', '2 ст. л. масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150g Cheese', '150 г сыра', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'сыр'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Onion', '1 большой лук', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 large Red Pepper', '1 большой красный сладкий перец', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'красный сладкий перец'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Pinch Red Chilli Flakes', 'щепотка красных хлопьев перца', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52978' AND LOWER(i.name) = 'красные хлопья перца'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '52803', 'Beef Wellington', 'Beef', '["Put the mushrooms into a food processor with some seasoning and pulse to a rough paste. Scrape the paste into a pan and cook over a high heat for about 10 mins, tossing frequently, to cook out the moisture from the mushrooms. Spread out on a plate to cool.","Heat in a frying pan and add a little olive oil. Season the beef and sear in the hot pan for 30 secs only on each side. (You don''t want to cook it at this stage, just colour it). Remove the beef from the pan and leave to cool, then brush all over with the mustard.","Lay a sheet of cling film on a work surface and arrange the Parma ham slices on it, in slightly overlapping rows. With a palette knife, spread the mushroom paste over the ham, then place the seared beef fillet in the middle. Keeping a tight hold of the cling film from the edge, neatly roll the Parma ham and mushrooms around the beef to form a tight barrel shape. Twist the ends of the cling film to secure. Chill for 15-20 mins to allow the beef to set and keep its shape.","Roll out the puff pastry on a floured surface to a large rectangle, the thickness of a £1 coin. Remove the cling film from the beef, then lay in the centre. Brush the surrounding pastry with egg yolk. Fold the ends over, the wrap the pastry around the beef, cutting off any excess. Turn over, so the seam is underneath, and place on a baking sheet. Brush over all the pastry with egg and chill for about 15 mins to let the pastry rest.","Heat the oven to 200C, 400F, gas 6.","Lightly score the pastry at 1cm intervals and glaze again with beaten egg yolk. Bake for 20 minutes, then lower the oven setting to 180C, 350F, gas 4 and cook for another 15 mins. Allow to rest for 10-15 mins before slicing and serving with the side dishes of your choice. The beef should still be pink in the centre when you serve it."]'::jsonb,
    'Биф Веллингтон', 'Блюдо из говядины', '["Сначала измельчите шампиньоны в кухонном комбайне с небольшим количеством приправ до грубой пасты. Переложите пасту в сковороду и обжаривайте на сильном огне около 10 минут, часто помешивая, чтобы выпарить влагу. Положите на тарелку и дайте остыть.","Нагрейте сковороду и добавьте щепотку оливкового масла. Приправьте говядину и обжарьте на горячей сковороде по 30 секунд с каждой стороны, чтобы получить только корочку. Не готовьте полностью, просто подсветите. Снимите говядину со сковороды и дайте остыть, затем смажьте её английской горчицей.","Разложите лист пищевой пленки на рабочей поверхности и выложите ломтики пармской ветчины, слегка перекрывая друг друга. С помощью ножа-распределителя нанесите пасту из шампиньонов на ветчину, затем положите обжаренное филе в центр. Сжимая края пленки, аккуратно сверните ветчину и шампиньоны вокруг говядины, образуя плотный цилиндр. Завяжите концы пленки и охладите 15–20 минут, чтобы говядина сохранила форму.","Раскатайте слоеное тесто на присыпанной мукой поверхности в большой прямоугольник толщиной около 1 см. Снимите пленку с говядины и разместите её в центре теста. Смажьте края теста взбитым желтком. Сложите края теста над говядиной, обернув её, и обрежьте лишнее. Переверните рулон так, чтобы шов оказался снизу, и выложите на противень. Смажьте всю поверхность теста желтком и охладите около 15 минут.","Разогрейте духовку до 200 °C. Легко разметьте тесто каждые 1 см и снова смажьте его взбитым желтком. Выпекайте 20 минут, затем уменьшите температуру до 180 °C и продолжайте выпекать 15 минут. Дайте рулону отдохнуть 10–15 минут перед нарезкой и подачей. Говядина должна оставаться розовой внутри."]'::jsonb,
    90, 'medium', 'https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400g mushrooms', '400 г шампиньонов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'шампиньоны'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1-2tbsp English Mustard', '1–2 ст.л. английской горчицы', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'английская горчица'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Dash Olive Oil', 'щепотка оливкового масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'оливковое масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '750g piece Beef Fillet', '750 г говяжьего филе', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'говяжье филе'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '6-8 slices Parma ham', '6–8 ломтиков пармской ветчины', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'пармская ветчина'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Puff Pastry', '500 г слоеного теста', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'слоеное тесто'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Dusting Flour', 'припылить мукой', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'мука'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Beaten Egg Yolks', '2 взбитых желтка', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '52803' AND LOWER(i.name) = 'желтки яиц'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

INSERT INTO recipes (
    external_id, title, description, instructions,
    localized_title, localized_description, localized_instructions,
    cooking_time_minutes, difficulty, image_url,
    translation_status, translation_retry_after
) VALUES (
    '53214', 'Thai green chicken soup', 'Chicken', '["step 1","Heat the oil in your largest pan, add the onion and fry for 3 mins to soften. Add the chicken and garlic, and cook until the chicken changes colour.","step 2","Add the curry paste, coconut milk, stock, lime leaves and fish sauce, then simmer for 12 mins. Add the chopped onion tops, green beans and bamboo shoots and cook for 4-6 mins, until the beans are just tender.","step 3","Meanwhile, put the lime juice and basil in a narrow jug and blitz with a hand blender to make a smooth green paste. Pour into the soup with the sliced spring onion and heat through. Serve with lime wedges for a light lunch or supper or as a make-ahead starter."]'::jsonb,
    'Тайский зеленый суп с курицей', 'Суп из курицы', '["Разогрейте 30 мл подсолнечного масла в самой большой сковороде, добавьте 1 луковицу, нарезанную, и обжаривайте 3 минуты до размягчения. Добавьте куриные бедра и 4 зубчика чеснока, нарезанных, и готовьте, пока курица не изменит цвет.","Добавьте 280 г тайского зеленого карри пасты, 400 мл кокосового молока, 2 л куриного бульона, 5 листьев лайма и 30 мл рыбного соуса, затем тушите 12 минут. Добавьте нарезанные верхушки лука, 280 г зеленой фасоли и 150 г бамбуковых стеблей, готовьте 4–6 минут, пока фасоль не станет слегка мягкой.","Пока суп готовится, выжмите сок 2 лаймов и положите базилик в узкую банку, затем взбейте ручным блендером до однородной зеленой пасты. Влейте пасту в суп вместе с нарезанным зеленым луком, прогрейте до горячего состояния. Подавайте с дольками лайма для легкого обеда, ужина или как блюдо на вынос."]'::jsonb,
    35, 'medium', 'https://www.themealdb.com/images/media/meals/7kb44y1763589084.jpg',
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

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Sunflower Oil', '30 мл подсолнечного масла', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'подсолнечное масло'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1 chopped Onion', '1 луковица, нарезанная', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '500g Chicken Thighs', '500 г куриных бедер', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'куриные бедра'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '4 sliced Garlic Clove', '4 зубчика чеснока, нарезанных', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'чеснок'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '280g Thai Green Curry Paste', '280 г тайского зеленого карри пасты', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'тайский зеленый карри паста'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '400ml Coconut Milk', '400 мл кокосового молока', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'кокосовое молоко'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 Litres Chicken Stock', '2 л куриного бульона', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'куриный бульон'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '5 Lime Leaves', '5 листьев лайма', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'лист лайма'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '2 tblsp Fish Sauce', '30 мл рыбного соуса', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'рыбный соус'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '1  bunch Spring Onions', '1 пучок зеленого лука', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'зеленый лук'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '280g Green Beans', '280 г зеленой фасоли', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'зеленая фасоль'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, '150g Bamboo Shoot', '150 г бамбуковых стеблей', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'бамбуковые стебли'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Juice of 2 Lime', 'сок 2 лаймов', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'лайм'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, display_text, localized_display_text, criticality)
SELECT r.id, i.id, 'Bunch Basil', '1 пучок базилика', 'critical'
FROM recipes r, ingredients i
WHERE r.external_id = '53214' AND LOWER(i.name) = 'базилик'
ORDER BY i.is_pantry_essential DESC, i.id ASC
LIMIT 1
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    display_text = EXCLUDED.display_text,
    localized_display_text = EXCLUDED.localized_display_text;

