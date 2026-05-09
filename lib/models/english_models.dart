enum ExerciseType { chooseTranslation, chooseEnglish, wordOrder }

class Exercise {
  final String id;
  final ExerciseType type;

  /// For chooseTranslation: English word/phrase shown to user.
  /// For chooseEnglish: Russian word/phrase shown to user.
  /// For wordOrder: Russian sentence to translate shown to user.
  final String prompt;

  /// The correct answer string.
  /// For choice types: must be one of [options].
  /// For wordOrder: the correct English sentence (words joined by space).
  final String correctAnswer;

  /// For choice types: 4 options including the correct answer.
  /// For wordOrder: the individual words to arrange (will be shuffled on screen).
  final List<String> options;

  /// Emoji shown alongside the prompt for visual context.
  final String emoji;

  const Exercise({
    required this.id,
    required this.type,
    required this.prompt,
    required this.correctAnswer,
    required this.options,
    this.emoji = '',
  });
}

class EnglishLesson {
  final String id;
  final String title;
  final String emoji;
  final List<Exercise> exercises;

  const EnglishLesson({
    required this.id,
    required this.title,
    required this.emoji,
    required this.exercises,
  });
}

class EnglishUnit {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int colorValue; // ARGB int, e.g. 0xFF1565C0
  final List<EnglishLesson> lessons;

  const EnglishUnit({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.colorValue,
    required this.lessons,
  });
}
