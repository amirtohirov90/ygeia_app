class RitualStep {
  final String id;
  final String text;
  final String? hint;

  const RitualStep({
    required this.id,
    required this.text,
    this.hint,
  });
}

class Ritual {
  final String id;
  final String title;
  final List<RitualStep> steps;

  const Ritual({
    required this.id,
    required this.title,
    required this.steps,
  });
}

const List<Ritual> kRituals = [
  Ritual(
    id: 'morning',
    title: 'Утренний ритуал',
    steps: [
      RitualStep(
        id: 'water',
        text: 'Стакан воды',
        hint: 'Перед кофе или чем-либо ещё',
      ),
      RitualStep(id: 'breath', text: '5 глубоких вдохов'),
      RitualStep(id: 'no_phone', text: '5 минут без телефона'),
      RitualStep(
        id: 'stretch',
        text: 'Лёгкая растяжка',
        hint: '3-5 минут хватит',
      ),
      RitualStep(
        id: 'intention',
        text: 'Намерение дня',
        hint: 'Одна фраза: что хочешь почувствовать сегодня',
      ),
    ],
  ),
  Ritual(
    id: 'evening',
    title: 'Вечерний ритуал',
    steps: [
      RitualStep(
        id: 'no_screens',
        text: 'Без экранов за час до сна',
        hint: 'Это самое важное',
      ),
      RitualStep(id: 'water', text: 'Стакан воды'),
      RitualStep(
        id: 'gratitude',
        text: '3 благодарности',
        hint: 'Можно мысленно, можно в Журнал',
      ),
      RitualStep(
        id: 'cleanup',
        text: 'Уборка пространства',
        hint: 'Минимально — чтобы утром не встречать вчерашний беспорядок',
      ),
      RitualStep(
        id: 'breathing',
        text: 'Дыхание 4-7-8',
        hint: 'Один цикл из раздела Тело',
      ),
    ],
  ),
  Ritual(
    id: 'digital',
    title: 'Цифровая гигиена',
    steps: [
      RitualStep(
        id: 'no_phone_hour',
        text: 'Час без телефона',
        hint: 'После пробуждения и перед сном',
      ),
      RitualStep(
        id: 'delete_unused',
        text: 'Удалить отложенные приложения',
        hint: 'Те что не использовал больше 30 дней',
      ),
      RitualStep(
        id: 'mute_notifications',
        text: 'Уведомления только важные',
        hint: 'Отключить почту, новости, маркетинг',
      ),
      RitualStep(
        id: 'one_screen',
        text: 'Один экран — одна задача',
        hint: 'Без вкладок-параллелей',
      ),
      RitualStep(
        id: 'dark_evening',
        text: 'Тёмный режим вечером',
        hint: 'Защита глаз и качество сна',
      ),
      RitualStep(
        id: 'digital_sabbath',
        text: 'День без соцсетей',
        hint: 'Один день в неделю — цифровой шаббат',
      ),
    ],
  ),
];
