import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/nutrition_profile.dart';
import '../../services/nutrition_service.dart';
import '../../theme/colors.dart';

class NutritionOnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const NutritionOnboardingScreen({super.key, required this.onDone});

  @override
  State<NutritionOnboardingScreen> createState() =>
      _NutritionOnboardingScreenState();
}

class _NutritionOnboardingScreenState
    extends State<NutritionOnboardingScreen> {
  final PageController _ctrl = PageController();
  int _step = 0;

  String _gender = 'female';
  int _age = 25;
  double _height = 165;
  double _weight = 60;
  double _targetWeight = 55;
  int _activityLevel = 2;
  String _goal = 'lose';

  void _next() {
    if (_step < 6) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final profile = NutritionProfile(
      gender: _gender,
      age: _age,
      height: _height,
      weight: _weight,
      targetWeight: _targetWeight,
      activityLevel: _activityLevel,
      goal: _goal,
    );
    await NutritionService().saveProfile(profile);
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            _ProgressBar(step: _step, total: 7),
            Expanded(
              child: PageView(
                controller: _ctrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _GenderStep(
                    selected: _gender,
                    onChanged: (v) => setState(() => _gender = v),
                  ),
                  _NumberStep(
                    title: 'Сколько тебе лет?',
                    icon: Icons.cake_outlined,
                    value: _age.toDouble(),
                    min: 14,
                    max: 80,
                    unit: 'лет',
                    decimals: 0,
                    onChanged: (v) => setState(() => _age = v.round()),
                  ),
                  _NumberStep(
                    title: 'Твой рост',
                    icon: Icons.height,
                    value: _height,
                    min: 140,
                    max: 220,
                    unit: 'см',
                    decimals: 0,
                    onChanged: (v) => setState(() => _height = v),
                  ),
                  _NumberStep(
                    title: 'Текущий вес',
                    icon: Icons.monitor_weight_outlined,
                    value: _weight,
                    min: 35,
                    max: 200,
                    unit: 'кг',
                    decimals: 1,
                    onChanged: (v) => setState(() => _weight = v),
                  ),
                  _NumberStep(
                    title: 'Желаемый вес',
                    icon: Icons.flag_outlined,
                    value: _targetWeight,
                    min: 35,
                    max: 200,
                    unit: 'кг',
                    decimals: 1,
                    onChanged: (v) => setState(() => _targetWeight = v),
                  ),
                  _ActivityStep(
                    selected: _activityLevel,
                    onChanged: (v) => setState(() => _activityLevel = v),
                  ),
                  _GoalStep(
                    selected: _goal,
                    onChanged: (v) => setState(() => _goal = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YgeiaColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Text(
                    _step < 6 ? 'Далее' : 'Рассчитать',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? YgeiaColors.accent : YgeiaColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _GenderStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _GenderStep({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.user, size: 64, color: YgeiaColors.accent),
          const SizedBox(height: 24),
          Text('Твой пол',
              style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: YgeiaColors.textPrimary)),
          const SizedBox(height: 40),
          Row(
            children: [
              _GenderCard(
                label: 'Женщина',
                icon: LucideIcons.user,
                iconColor: YgeiaColors.accentSecondary,
                selected: selected == 'female',
                onTap: () => onChanged('female'),
              ),
              const SizedBox(width: 16),
              _GenderCard(
                label: 'Мужчина',
                icon: LucideIcons.user,
                iconColor: YgeiaColors.accent,
                selected: selected == 'male',
                onTap: () => onChanged('male'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool selected;
  final VoidCallback onTap;
  const _GenderCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: selected ? YgeiaColors.accent : YgeiaColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? YgeiaColors.accent : YgeiaColors.divider,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 40,
                  color: selected ? Colors.white : iconColor),
              const SizedBox(height: 8),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : YgeiaColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberStep extends StatelessWidget {
  final String title;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final String unit;
  final int decimals;
  final ValueChanged<double> onChanged;

  const _NumberStep({
    required this.title,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.decimals,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: YgeiaColors.accent),
          const SizedBox(height: 24),
          Text(title,
              style: GoogleFonts.fraunces(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: YgeiaColors.textPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                decimals == 0
                    ? value.round().toString()
                    : value.toStringAsFixed(1),
                style: GoogleFonts.fraunces(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: YgeiaColors.accent),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 8),
                child: Text(unit,
                    style: GoogleFonts.inter(
                        fontSize: 20, color: YgeiaColors.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: YgeiaColors.accent,
              inactiveTrackColor: YgeiaColors.accent.withOpacity(0.15),
              thumbColor: YgeiaColors.accent,
              overlayColor: YgeiaColors.accent.withOpacity(0.15),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 14),
              trackHeight: 6,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: decimals == 0
                  ? (max - min).round()
                  : ((max - min) * 10).round(),
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.round()} $unit',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: YgeiaColors.textMuted)),
              Text('${max.round()} $unit',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: YgeiaColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityStep extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _ActivityStep({required this.selected, required this.onChanged});

  static const _levels = [
    {'label': 'Сидячий', 'sub': 'Офис, мало движения', 'icon': '🪑'},
    {'label': 'Лёгкая', 'sub': '1-2 тренировки в неделю', 'icon': '🚶'},
    {'label': 'Умеренная', 'sub': '3-5 тренировок в неделю', 'icon': '🏃'},
    {'label': 'Высокая', 'sub': '6-7 тренировок в неделю', 'icon': '🏋️'},
    {'label': 'Очень высокая', 'sub': 'Спортсмен или физ. труд', 'icon': '🔥'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Уровень активности',
              style: GoogleFonts.fraunces(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: YgeiaColors.textPrimary),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ..._levels.asMap().entries.map((e) {
            final i = e.key + 1;
            final level = e.value;
            final isSelected = selected == i;
            return GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? YgeiaColors.accent
                      : YgeiaColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? YgeiaColors.accent
                          : YgeiaColors.divider),
                ),
                child: Row(
                  children: [
                    Text(level['icon']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(level['label']!,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : YgeiaColors.textPrimary)),
                          Text(level['sub']!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white70
                                      : YgeiaColors.textMuted)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _GoalStep({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 56, color: YgeiaColors.accent),
          const SizedBox(height: 24),
          Text('Твоя цель',
              style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: YgeiaColors.textPrimary)),
          const SizedBox(height: 40),
          _GoalCard(
            label: 'Похудеть',
            sub: 'Дефицит ~400 ккал/день',
            icon: '📉',
            selected: selected == 'lose',
            onTap: () => onChanged('lose'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            label: 'Поддержать вес',
            sub: 'Норма калорий для твоего типа',
            icon: '⚖️',
            selected: selected == 'maintain',
            onTap: () => onChanged('maintain'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            label: 'Набрать массу',
            sub: 'Профицит ~300 ккал/день',
            icon: '📈',
            selected: selected == 'gain',
            onTap: () => onChanged('gain'),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String label;
  final String sub;
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  const _GoalCard({
    required this.label,
    required this.sub,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? YgeiaColors.accent : YgeiaColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? YgeiaColors.accent : YgeiaColors.divider,
              width: 2),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : YgeiaColors.textPrimary)),
                  Text(sub,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: selected
                              ? Colors.white70
                              : YgeiaColors.textSecondary)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}
