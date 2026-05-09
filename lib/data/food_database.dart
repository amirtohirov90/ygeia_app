import '../models/food_item.dart';

const List<FoodItem> foodDatabase = [
  // ── Мясо и птица ───────────────────────────────────
  FoodItem(id: 'chicken_breast', name: 'Куриная грудка', category: 'Мясо', calories: 165, protein: 31, fat: 3.6, carbs: 0),
  FoodItem(id: 'chicken_thigh', name: 'Куриное бедро', category: 'Мясо', calories: 209, protein: 26, fat: 11, carbs: 0),
  FoodItem(id: 'beef', name: 'Говядина', category: 'Мясо', calories: 250, protein: 26, fat: 16, carbs: 0),
  FoodItem(id: 'pork', name: 'Свинина', category: 'Мясо', calories: 290, protein: 25, fat: 21, carbs: 0),
  FoodItem(id: 'turkey', name: 'Индейка', category: 'Мясо', calories: 135, protein: 28, fat: 2, carbs: 0),
  FoodItem(id: 'lamb', name: 'Баранина', category: 'Мясо', calories: 294, protein: 25, fat: 21, carbs: 0),
  FoodItem(id: 'minced_beef', name: 'Фарш говяжий', category: 'Мясо', calories: 260, protein: 18, fat: 20, carbs: 0),
  FoodItem(id: 'sausage', name: 'Сосиски', category: 'Мясо', calories: 256, protein: 12, fat: 22, carbs: 2),
  FoodItem(id: 'kolbasa', name: 'Колбаса варёная', category: 'Мясо', calories: 257, protein: 12, fat: 22, carbs: 2),
  FoodItem(id: 'bacon', name: 'Бекон', category: 'Мясо', calories: 400, protein: 12, fat: 38, carbs: 1),

  // ── Рыба и морепродукты ────────────────────────────
  FoodItem(id: 'salmon', name: 'Лосось', category: 'Рыба', calories: 206, protein: 20, fat: 13, carbs: 0),
  FoodItem(id: 'cod', name: 'Треска', category: 'Рыба', calories: 82, protein: 18, fat: 0.7, carbs: 0),
  FoodItem(id: 'tuna', name: 'Тунец', category: 'Рыба', calories: 130, protein: 28, fat: 1, carbs: 0),
  FoodItem(id: 'herring', name: 'Сельдь', category: 'Рыба', calories: 218, protein: 18, fat: 16, carbs: 0),
  FoodItem(id: 'mackerel', name: 'Скумбрия', category: 'Рыба', calories: 262, protein: 18, fat: 20, carbs: 0),
  FoodItem(id: 'shrimp', name: 'Креветки', category: 'Рыба', calories: 85, protein: 18, fat: 1.2, carbs: 0),
  FoodItem(id: 'pollock', name: 'Минтай', category: 'Рыба', calories: 70, protein: 16, fat: 0.5, carbs: 0),
  FoodItem(id: 'carp', name: 'Карп', category: 'Рыба', calories: 127, protein: 18, fat: 5.6, carbs: 0),

  // ── Яйца ───────────────────────────────────────────
  FoodItem(id: 'egg', name: 'Яйцо куриное', category: 'Яйца', calories: 157, protein: 13, fat: 11, carbs: 1),
  FoodItem(id: 'egg_white', name: 'Белок яичный', category: 'Яйца', calories: 52, protein: 11, fat: 0.2, carbs: 0.7),
  FoodItem(id: 'egg_yolk', name: 'Желток яичный', category: 'Яйца', calories: 322, protein: 16, fat: 27, carbs: 1),

  // ── Молочные продукты ──────────────────────────────
  FoodItem(id: 'milk', name: 'Молоко 3.2%', category: 'Молочные', calories: 60, protein: 3.2, fat: 3.2, carbs: 4.7),
  FoodItem(id: 'kefir', name: 'Кефир 1%', category: 'Молочные', calories: 40, protein: 3, fat: 1, carbs: 4),
  FoodItem(id: 'cottage_cheese', name: 'Творог 5%', category: 'Молочные', calories: 121, protein: 17, fat: 5, carbs: 2.7),
  FoodItem(id: 'cottage_cheese_0', name: 'Творог 0%', category: 'Молочные', calories: 71, protein: 16, fat: 0.5, carbs: 1.8),
  FoodItem(id: 'yogurt', name: 'Йогурт натуральный', category: 'Молочные', calories: 60, protein: 5, fat: 3.2, carbs: 3.5),
  FoodItem(id: 'sour_cream', name: 'Сметана 20%', category: 'Молочные', calories: 206, protein: 2.8, fat: 20, carbs: 3.2),
  FoodItem(id: 'cheese', name: 'Сыр твёрдый', category: 'Молочные', calories: 380, protein: 26, fat: 30, carbs: 0),
  FoodItem(id: 'cheese_mozzarella', name: 'Моцарелла', category: 'Молочные', calories: 280, protein: 22, fat: 20, carbs: 2),
  FoodItem(id: 'butter', name: 'Масло сливочное', category: 'Молочные', calories: 748, protein: 0.8, fat: 82, carbs: 0.6),

  // ── Крупы и злаки ──────────────────────────────────
  FoodItem(id: 'rice', name: 'Рис варёный', category: 'Крупы', calories: 130, protein: 2.7, fat: 0.3, carbs: 28),
  FoodItem(id: 'buckwheat', name: 'Гречка варёная', category: 'Крупы', calories: 110, protein: 4.2, fat: 1.1, carbs: 21),
  FoodItem(id: 'oatmeal', name: 'Овсянка варёная', category: 'Крупы', calories: 88, protein: 3.2, fat: 1.7, carbs: 15),
  FoodItem(id: 'pasta', name: 'Макароны варёные', category: 'Крупы', calories: 157, protein: 5.6, fat: 0.9, carbs: 30),
  FoodItem(id: 'millet', name: 'Пшено варёное', category: 'Крупы', calories: 119, protein: 4.7, fat: 1.2, carbs: 23),
  FoodItem(id: 'barley', name: 'Перловка варёная', category: 'Крупы', calories: 109, protein: 3.3, fat: 0.4, carbs: 22),
  FoodItem(id: 'bulgur', name: 'Булгур варёный', category: 'Крупы', calories: 83, protein: 3.1, fat: 0.2, carbs: 19),
  FoodItem(id: 'quinoa', name: 'Киноа варёная', category: 'Крупы', calories: 120, protein: 4.4, fat: 1.9, carbs: 22),

  // ── Хлеб и выпечка ─────────────────────────────────
  FoodItem(id: 'bread_white', name: 'Хлеб белый', category: 'Хлеб', calories: 265, protein: 8, fat: 3.2, carbs: 49),
  FoodItem(id: 'bread_rye', name: 'Хлеб ржаной', category: 'Хлеб', calories: 220, protein: 7, fat: 1.5, carbs: 44),
  FoodItem(id: 'bread_whole', name: 'Хлеб цельнозерновой', category: 'Хлеб', calories: 247, protein: 9, fat: 3, carbs: 43),
  FoodItem(id: 'crispbread', name: 'Хлебцы', category: 'Хлеб', calories: 355, protein: 11, fat: 2.3, carbs: 72),

  // ── Овощи ──────────────────────────────────────────
  FoodItem(id: 'potato', name: 'Картофель варёный', category: 'Овощи', calories: 82, protein: 2, fat: 0.1, carbs: 17),
  FoodItem(id: 'carrot', name: 'Морковь', category: 'Овощи', calories: 35, protein: 1.3, fat: 0.1, carbs: 7),
  FoodItem(id: 'cabbage', name: 'Капуста белокочанная', category: 'Овощи', calories: 28, protein: 1.8, fat: 0.1, carbs: 5),
  FoodItem(id: 'cucumber', name: 'Огурец', category: 'Овощи', calories: 15, protein: 0.8, fat: 0.1, carbs: 3),
  FoodItem(id: 'tomato', name: 'Помидор', category: 'Овощи', calories: 20, protein: 1, fat: 0.2, carbs: 3.5),
  FoodItem(id: 'onion', name: 'Лук репчатый', category: 'Овощи', calories: 41, protein: 1.4, fat: 0.2, carbs: 8.2),
  FoodItem(id: 'broccoli', name: 'Брокколи', category: 'Овощи', calories: 34, protein: 2.8, fat: 0.4, carbs: 7),
  FoodItem(id: 'spinach', name: 'Шпинат', category: 'Овощи', calories: 23, protein: 2.9, fat: 0.4, carbs: 2),
  FoodItem(id: 'bell_pepper', name: 'Болгарский перец', category: 'Овощи', calories: 31, protein: 1, fat: 0.3, carbs: 6),
  FoodItem(id: 'zucchini', name: 'Кабачок', category: 'Овощи', calories: 24, protein: 1.5, fat: 0.3, carbs: 4.6),
  FoodItem(id: 'eggplant', name: 'Баклажан', category: 'Овощи', calories: 24, protein: 1.2, fat: 0.2, carbs: 5),
  FoodItem(id: 'beetroot', name: 'Свёкла', category: 'Овощи', calories: 43, protein: 1.5, fat: 0.1, carbs: 9.6),
  FoodItem(id: 'garlic', name: 'Чеснок', category: 'Овощи', calories: 149, protein: 6, fat: 0.5, carbs: 33),
  FoodItem(id: 'corn', name: 'Кукуруза варёная', category: 'Овощи', calories: 123, protein: 4, fat: 2, carbs: 25),
  FoodItem(id: 'avocado', name: 'Авокадо', category: 'Овощи', calories: 160, protein: 2, fat: 15, carbs: 9),

  // ── Фрукты и ягоды ─────────────────────────────────
  FoodItem(id: 'apple', name: 'Яблоко', category: 'Фрукты', calories: 52, protein: 0.3, fat: 0.2, carbs: 14),
  FoodItem(id: 'banana', name: 'Банан', category: 'Фрукты', calories: 89, protein: 1.1, fat: 0.3, carbs: 23),
  FoodItem(id: 'orange', name: 'Апельсин', category: 'Фрукты', calories: 47, protein: 0.9, fat: 0.1, carbs: 12),
  FoodItem(id: 'pear', name: 'Груша', category: 'Фрукты', calories: 57, protein: 0.4, fat: 0.3, carbs: 15),
  FoodItem(id: 'grape', name: 'Виноград', category: 'Фрукты', calories: 67, protein: 0.6, fat: 0.2, carbs: 17),
  FoodItem(id: 'strawberry', name: 'Клубника', category: 'Фрукты', calories: 32, protein: 0.7, fat: 0.3, carbs: 7.7),
  FoodItem(id: 'blueberry', name: 'Черника', category: 'Фрукты', calories: 57, protein: 0.7, fat: 0.3, carbs: 14),
  FoodItem(id: 'watermelon', name: 'Арбуз', category: 'Фрукты', calories: 30, protein: 0.6, fat: 0.1, carbs: 7.5),
  FoodItem(id: 'mango', name: 'Манго', category: 'Фрукты', calories: 60, protein: 0.8, fat: 0.4, carbs: 15),
  FoodItem(id: 'kiwi', name: 'Киви', category: 'Фрукты', calories: 61, protein: 1.1, fat: 0.5, carbs: 15),
  FoodItem(id: 'peach', name: 'Персик', category: 'Фрукты', calories: 39, protein: 0.9, fat: 0.1, carbs: 10),
  FoodItem(id: 'plum', name: 'Слива', category: 'Фрукты', calories: 46, protein: 0.7, fat: 0.3, carbs: 11),

  // ── Бобовые ────────────────────────────────────────
  FoodItem(id: 'lentils', name: 'Чечевица варёная', category: 'Бобовые', calories: 116, protein: 9, fat: 0.4, carbs: 20),
  FoodItem(id: 'chickpea', name: 'Нут варёный', category: 'Бобовые', calories: 164, protein: 8.9, fat: 2.6, carbs: 27),
  FoodItem(id: 'beans', name: 'Фасоль варёная', category: 'Бобовые', calories: 123, protein: 8.7, fat: 0.5, carbs: 22),
  FoodItem(id: 'edamame', name: 'Эдамаме', category: 'Бобовые', calories: 121, protein: 11, fat: 5, carbs: 9),

  // ── Орехи и семена ─────────────────────────────────
  FoodItem(id: 'almond', name: 'Миндаль', category: 'Орехи', calories: 579, protein: 21, fat: 50, carbs: 22),
  FoodItem(id: 'walnut', name: 'Грецкий орех', category: 'Орехи', calories: 654, protein: 15, fat: 65, carbs: 14),
  FoodItem(id: 'peanut', name: 'Арахис', category: 'Орехи', calories: 567, protein: 26, fat: 49, carbs: 16),
  FoodItem(id: 'cashew', name: 'Кешью', category: 'Орехи', calories: 553, protein: 18, fat: 44, carbs: 30),
  FoodItem(id: 'sunflower_seeds', name: 'Семечки подсолнечника', category: 'Орехи', calories: 584, protein: 21, fat: 51, carbs: 20),
  FoodItem(id: 'chia', name: 'Семена чиа', category: 'Орехи', calories: 486, protein: 17, fat: 31, carbs: 42),
  FoodItem(id: 'peanut_butter', name: 'Арахисовая паста', category: 'Орехи', calories: 588, protein: 25, fat: 50, carbs: 20),

  // ── Масла и жиры ───────────────────────────────────
  FoodItem(id: 'olive_oil', name: 'Масло оливковое', category: 'Масла', calories: 884, protein: 0, fat: 100, carbs: 0),
  FoodItem(id: 'sunflower_oil', name: 'Масло подсолнечное', category: 'Масла', calories: 884, protein: 0, fat: 100, carbs: 0),

  // ── Сладости ───────────────────────────────────────
  FoodItem(id: 'sugar', name: 'Сахар', category: 'Сладости', calories: 387, protein: 0, fat: 0, carbs: 100),
  FoodItem(id: 'honey', name: 'Мёд', category: 'Сладости', calories: 304, protein: 0.3, fat: 0, carbs: 82),
  FoodItem(id: 'dark_chocolate', name: 'Шоколад тёмный 70%', category: 'Сладости', calories: 598, protein: 8, fat: 43, carbs: 46),
  FoodItem(id: 'jam', name: 'Джем', category: 'Сладости', calories: 250, protein: 0.4, fat: 0.1, carbs: 65),
  FoodItem(id: 'ice_cream', name: 'Мороженое', category: 'Сладости', calories: 207, protein: 3.5, fat: 11, carbs: 24),

  // ── Готовые блюда ──────────────────────────────────
  FoodItem(id: 'borscht', name: 'Борщ', category: 'Блюда', calories: 50, protein: 2, fat: 2, carbs: 5),
  FoodItem(id: 'pelmeni', name: 'Пельмени варёные', category: 'Блюда', calories: 275, protein: 12, fat: 12, carbs: 29),
  FoodItem(id: 'cutlet', name: 'Котлета куриная', category: 'Блюда', calories: 170, protein: 17, fat: 9, carbs: 5),
  FoodItem(id: 'soup', name: 'Суп куриный', category: 'Блюда', calories: 40, protein: 3, fat: 1.5, carbs: 4),
  FoodItem(id: 'salad_caesar', name: 'Салат Цезарь', category: 'Блюда', calories: 180, protein: 8, fat: 14, carbs: 7),
  FoodItem(id: 'fried_eggs', name: 'Яичница', category: 'Блюда', calories: 196, protein: 13, fat: 16, carbs: 1),
  FoodItem(id: 'omelette', name: 'Омлет', category: 'Блюда', calories: 154, protein: 10, fat: 12, carbs: 2),
  FoodItem(id: 'pancakes', name: 'Блины', category: 'Блюда', calories: 206, protein: 6, fat: 9, carbs: 26),
  FoodItem(id: 'pizza', name: 'Пицца', category: 'Блюда', calories: 266, protein: 11, fat: 10, carbs: 33),
  FoodItem(id: 'sushi', name: 'Суши (ролл)', category: 'Блюда', calories: 140, protein: 6, fat: 2, carbs: 25),

  // ── Напитки ────────────────────────────────────────
  FoodItem(id: 'juice_orange', name: 'Сок апельсиновый', category: 'Напитки', calories: 45, protein: 0.7, fat: 0.2, carbs: 10),
  FoodItem(id: 'juice_apple', name: 'Сок яблочный', category: 'Напитки', calories: 46, protein: 0.1, fat: 0.1, carbs: 11),
  FoodItem(id: 'coffee', name: 'Кофе (эспрессо)', category: 'Напитки', calories: 9, protein: 0.6, fat: 0.2, carbs: 1.7),
  FoodItem(id: 'green_tea', name: 'Чай зелёный', category: 'Напитки', calories: 1, protein: 0, fat: 0, carbs: 0.2),
];

List<FoodItem> searchFood(String query) {
  if (query.isEmpty) return foodDatabase;
  final q = query.toLowerCase();
  return foodDatabase
      .where((f) =>
          f.name.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q))
      .toList();
}

List<String> get foodCategories {
  final cats = foodDatabase.map((f) => f.category).toSet().toList();
  cats.sort();
  return ['Все', ...cats];
}
