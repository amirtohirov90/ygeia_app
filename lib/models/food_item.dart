class FoodItem {
  final String id;
  final String name;
  final String category;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'calories': calories,
        'protein': protein,
        'fat': fat,
        'carbs': carbs,
      };
}

class MealEntry {
  final String id;
  final String foodId;
  final String name;
  final double amount; // grams
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String mealType; // breakfast/lunch/dinner/snack

  MealEntry({
    required this.id,
    required this.foodId,
    required this.name,
    required this.amount,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.mealType,
  });

  factory MealEntry.fromFood(
      FoodItem food, double amount, String mealType) {
    final factor = amount / 100;
    return MealEntry(
      id: '${food.id}_${DateTime.now().millisecondsSinceEpoch}',
      foodId: food.id,
      name: food.name,
      amount: amount,
      calories: food.calories * factor,
      protein: food.protein * factor,
      fat: food.fat * factor,
      carbs: food.carbs * factor,
      mealType: mealType,
    );
  }

  factory MealEntry.fromMap(Map<String, dynamic> map) => MealEntry(
        id: map['id'],
        foodId: map['foodId'],
        name: map['name'],
        amount: (map['amount'] as num).toDouble(),
        calories: (map['calories'] as num).toDouble(),
        protein: (map['protein'] as num).toDouble(),
        fat: (map['fat'] as num).toDouble(),
        carbs: (map['carbs'] as num).toDouble(),
        mealType: map['mealType'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'foodId': foodId,
        'name': name,
        'amount': amount,
        'calories': calories,
        'protein': protein,
        'fat': fat,
        'carbs': carbs,
        'mealType': mealType,
      };
}
