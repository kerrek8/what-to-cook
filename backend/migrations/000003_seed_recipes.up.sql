-- 000003_seed_recipes.up.sql

-- 1. Рецепт: Классический борщ с говядиной
INSERT INTO recipes (id, title, description, instructions, cooking_time_minutes, difficulty, image_url)
VALUES (
    1,
    'Классический борщ с говядиной',
    'Супы',
    '["Говядину залейте холодной водой, доведите до кипения, снимите пену и варите бульон 1,5 часа.", "Свеклу натрите на крупной терке и потушите с томатной пастой на сковороде 15 минут.", "Картофель нарежьте кубиками, капусту нашинкуйте и добавьте в кипящий бульон.", "Сделайте зажарку из лука и моркови, добавьте ее вместе со свеклой в кастрюлю.", "Варите еще 10 минут, добавьте лавровый лист, посолите и дайте настояться 20 минут."]'::jsonb,
    150,
    'средне',
    'https://vkuso.ru/upload/recipes/borsch.jpg'
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit, display_text, criticality) VALUES
(1, (SELECT id FROM ingredients WHERE name = 'говядина'), 500, 'г', '500 г', 'основной'),
(1, (SELECT id FROM ingredients WHERE name = 'свекла'), 2, 'шт', '2 шт.', 'важный'),
(1, (SELECT id FROM ingredients WHERE name = 'картофель'), 4, 'шт', '4 шт.', 'основной'),
(1, (SELECT id FROM ingredients WHERE name = 'капуста белокочанная'), 300, 'г', '300 г', 'важный'),
(1, (SELECT id FROM ingredients WHERE name = 'морковь'), 1, 'шт', '1 шт.', 'важный'),
(1, (SELECT id FROM ingredients WHERE name = 'лук репчатый'), 1, 'шт', '1 шт.', 'важный'),
(1, (SELECT id FROM ingredients WHERE name = 'томатная паста'), 2, 'ст. л.', '2 ст. л.', 'важный'),
(1, (SELECT id FROM ingredients WHERE name = 'лавровый лист'), 2, 'шт', '2 шт.', 'опциональный'),
(1, (SELECT id FROM ingredients WHERE name = 'соль'), NULL, NULL, 'по вкусу', 'опциональный');

-- 2. Рецепт: Сырники из творога на сковороде
INSERT INTO recipes (id, title, description, instructions, cooking_time_minutes, difficulty, image_url)
VALUES (
    2,
    'Сырники из творога на сковороде',
    'Завтраки',
    '["Творог разомните вилкой, добавьте яйцо, сахар и щепотку соли.", "Всыпьте муку и замесите мягкое творожное тесто.", "Сформируйте круглые сырники и обваляйте в небольшом количестве муки.", "Обжаривайте на среднем огне по 4–5 минут с каждой стороны до золотистой корочки."]'::jsonb,
    25,
    'средне',
    'https://vkuso.ru/upload/recipes/syrniki.jpg'
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit, display_text, criticality) VALUES
(2, (SELECT id FROM ingredients WHERE name = 'творог'), 400, 'г', '400 г', 'основной'),
(2, (SELECT id FROM ingredients WHERE name = 'яйца куриные'), 1, 'шт', '1 шт.', 'важный'),
(2, (SELECT id FROM ingredients WHERE name = 'мука пшеничная'), 3, 'ст. л.', '3 ст. л.', 'важный'),
(2, (SELECT id FROM ingredients WHERE name = 'сахар'), 2, 'ст. л.', '2 ст. л.', 'важный'),
(2, (SELECT id FROM ingredients WHERE name = 'масло растительное'), 2, 'ст. л.', '2 ст. л.', 'опциональный'),
(2, (SELECT id FROM ingredients WHERE name = 'соль'), NULL, NULL, 'щепотка', 'опциональный');

-- 3. Рецепт: Картофельная запеканка с мясным фаршем
INSERT INTO recipes (id, title, description, instructions, cooking_time_minutes, difficulty, image_url)
VALUES (
    3,
    'Картофельная запеканка с мясным фаршем',
    'Вторые блюда',
    '["Картофель очистите, отварите до готовности и разомните в пюре с теплым молоком и сливочным маслом.", "Лук мелко нарежьте и обжарьте на сковороде с фаршем до полуготовности, посолите и поперчите.", "В форму для запекания выложите половину пюре, затем слой фарша и накройте оставшимся пюре.", "Запекайте в духовке при 180 °C около 30–35 минут до аппетитной корочки."]'::jsonb,
    45,
    'легко',
    'https://vkuso.ru/upload/recipes/zapekanka.jpg'
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit, display_text, criticality) VALUES
(3, (SELECT id FROM ingredients WHERE name = 'картофель'), 500, 'г', '500 г', 'основной'),
(3, (SELECT id FROM ingredients WHERE name = 'молоко'), 100, 'мл', '100 мл', 'важный'),
(3, (SELECT id FROM ingredients WHERE name = 'масло сливочное'), 30, 'г', '30 г', 'важный'),
(3, (SELECT id FROM ingredients WHERE name = 'фарш домашний'), 400, 'г', '400 г', 'основной'),
(3, (SELECT id FROM ingredients WHERE name = 'лук репчатый'), 1, 'шт', '1 шт.', 'важный'),
(3, (SELECT id FROM ingredients WHERE name = 'соль'), NULL, NULL, 'по вкусу', 'опциональный'),
(3, (SELECT id FROM ingredients WHERE name = 'перец черный молотый'), NULL, NULL, 'по вкусу', 'опциональный');

-- 4. Рецепт: Салат Оливье домашний
INSERT INTO recipes (id, title, description, instructions, cooking_time_minutes, difficulty, image_url)
VALUES (
    4,
    'Салат Оливье домашний',
    'Салаты',
    '["Отварите картофель и яйца до готовности, остудите и очистите.", "Нарежьте картофель, яйца, колбасу и огурцы одинаковыми мелкими кубиками.", "Слейте жидкость с консервированного горошка и добавьте его к нарезанным ингредиентам.", "Заправьте салат майонезом, аккуратно перемешайте и охладите перед подачей."]'::jsonb,
    35,
    'легко',
    'https://vkuso.ru/upload/recipes/olivie.jpg'
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit, display_text, criticality) VALUES
(4, (SELECT id FROM ingredients WHERE name = 'колбаса вареная'), 300, 'г', '300 г', 'важный'),
(4, (SELECT id FROM ingredients WHERE name = 'картофель'), 3, 'шт', '3 шт.', 'основной'),
(4, (SELECT id FROM ingredients WHERE name = 'яйца куриные'), 3, 'шт', '3 шт.', 'основной'),
(4, (SELECT id FROM ingredients WHERE name = 'огурцы соленые'), 2, 'шт', '2 шт.', 'важный'),
(4, (SELECT id FROM ingredients WHERE name = 'горошек консервированный'), 200, 'г', '1 банка (200 г)', 'важный'),
(4, (SELECT id FROM ingredients WHERE name = 'майонез'), 3, 'ст. л.', '3-4 ст. л.', 'опциональный');

-- 5. Рецепт: Куриное филе, запеченное с помидорами и сыром
INSERT INTO recipes (id, title, description, instructions, cooking_time_minutes, difficulty, image_url)
VALUES (
    5,
    'Куриное филе, запеченное с помидорами и сыром',
    'Вторые блюда',
    '["Куриное филе промойте, слегка отбейте, посолите и натрите специями.", "Выложите филе на противень, смажьте сметаной с измельченным чесноком.", "Сверху выложите кружочки помидоров и щедро посыпьте тертым сыром.", "Запекайте в духовке при 180 °C в течение 25–30 минут до расплавления и подрумянивания сыра."]'::jsonb,
    30,
    'легко',
    'https://vkuso.ru/upload/recipes/chicken_cheese.jpg'
);

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit, display_text, criticality) VALUES
(5, (SELECT id FROM ingredients WHERE name = 'куриное филе'), 500, 'г', '500 г', 'основной'),
(5, (SELECT id FROM ingredients WHERE name = 'помидоры'), 2, 'шт', '2 шт.', 'важный'),
(5, (SELECT id FROM ingredients WHERE name = 'сыр твердый'), 100, 'г', '100 г', 'важный'),
(5, (SELECT id FROM ingredients WHERE name = 'чеснок'), 2, 'шт', '2 зубчика', 'опциональный'),
(5, (SELECT id FROM ingredients WHERE name = 'сметана'), 2, 'ст. л.', '2 ст. л.', 'опциональный'),
(5, (SELECT id FROM ingredients WHERE name = 'соль'), NULL, NULL, 'по вкусу', 'опциональный');

-- Сброс автоинкремента последовательности recipes
SELECT setval('recipes_id_seq', (SELECT MAX(id) FROM recipes));
