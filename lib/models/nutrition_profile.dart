import 'dart:convert';

class NutritionProfile {
  final String gender; // male / female
  final int age;
  final double height; // cm
  final double weight; // kg
  final double targetWeight; // kg
  final int activityLevel; // 1-5
  final String goal; // lose / maintain / gain

  NutritionProfile({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.activityLevel,
    required this.goal,
  });

  // Mifflin-St Jeor BMR
  double get bmr {
    if (gender == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  // Activity multiplier
  double get activityMultiplier {
    switch (activityLevel) {
      case 1: return 1.2;  // сидячий
      case 2: return 1.375; // лёгкая активность
      case 3: return 1.55;  // умеренная
      case 4: return 1.725; // высокая
      case 5: return 1.9;   // очень высокая
      default: return 1.375;
    }
  }

  // TDEE (Total Daily Energy Expenditure)
  double get tdee => bmr * activityMultiplier;

  // Target calories
  double get targetCalories {
    switch (goal) {
      case 'lose': return tdee - 400;
      case 'gain': return tdee + 300;
      default: return tdee;
    }
  }

  // Macros in grams
  double get targetProtein => (targetCalories * 0.30) / 4;
  double get targetFat => (targetCalories * 0.25) / 9;
  double get targetCarbs => (targetCalories * 0.45) / 4;

  String get activityLabel {
    switch (activityLevel) {
      case 1: return 'Сидячий образ жизни';
      case 2: return 'Лёгкая активность (1-2 раза/нед)';
      case 3: return 'Умеренная (3-5 раз/нед)';
      case 4: return 'Высокая (6-7 раз/нед)';
      case 5: return 'Очень высокая (спортсмен)';
      default: return '';
    }
  }

  String get goalLabel {
    switch (goal) {
      case 'lose': return 'Похудеть';
      case 'gain': return 'Набрать массу';
      default: return 'Поддержать вес';
    }
  }

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiLabel {
    if (bmi < 18.5) return 'Недостаточный вес';
    if (bmi < 25) return 'Норма';
    if (bmi < 30) return 'Избыточный вес';
    return 'Ожирение';
  }

  Map<String, dynamic> toMap() => {
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
        'targetWeight': targetWeight,
        'activityLevel': activityLevel,
        'goal': goal,
      };

  String toJson() => jsonEncode(toMap());

  factory NutritionProfile.fromMap(Map<String, dynamic> map) =>
      NutritionProfile(
        gender: map['gender'],
        age: map['age'],
        height: (map['height'] as num).toDouble(),
        weight: (map['weight'] as num).toDouble(),
        targetWeight: (map['targetWeight'] as num).toDouble(),
        activityLevel: map['activityLevel'],
        goal: map['goal'],
      );

  factory NutritionProfile.fromJson(String json) =>
      NutritionProfile.fromMap(jsonDecode(json));
}
