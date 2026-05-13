import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/nutrition_profile.dart';
import '../../models/food_item.dart';
import '../../services/nutrition_service.dart';
import '../../theme/colors.dart';
import 'nutrition_onboarding_screen.dart';
import 'food_search_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final NutritionService _service = NutritionService();
  NutritionProfile? _profile;
  List<MealEntry> _entries = [];
  int _waterGlasses = 0;
  DateTime _date = DateTime.now();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final profile = await _service.getProfile();
    final entries = await _service.getEntries(_date);
    final water = await _service.getWaterGlasses(_date);
    setState(() {
      _profile = profile;
      _entries = entries;
      _waterGlasses = water;
      _loading = false;
    });
  }

  Future<void> _addEntry(String mealType) async {
    final entry = await Navigator.push<MealEntry>(
      context,
      MaterialPageRoute(
          builder: (_) => FoodSearchScreen(mealType: mealType)),
    );
    if (entry != null) {
      await _service.addEntry(entry, _date);
      await _load();
    }
  }

  Future<void> _deleteEntry(String id) async {
    await _service.deleteEntry(id, _date);
    await _load();
  }

  Future<void> _setWater(int glasses) async {
    await _service.setWaterGlasses(glasses, _date);
    setState(() => _waterGlasses = glasses);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: YgeiaColors.bgBase,
        body: Center(
            child: CircularProgressIndicator(color: YgeiaColors.accent)),
      );
    }

    if (_profile == null) {
      return NutritionOnboardingScreen(onDone: _load);
    }

    final summary = _service.calcSummary(_entries);
    final targetCal = _profile!.targetCalories;
    final remaining = targetCal - summary.calories;

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: RefreshIndicator(
        color: YgeiaColors.accent,
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: YgeiaColors.textPrimary,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, size: 20, color: YgeiaColors.accent),
                  const SizedBox(width: 8),
                  Text('КБЖУ',
                      style: GoogleFonts.fraunces(
                          color: YgeiaColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: YgeiaColors.textSecondary),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NutritionOnboardingScreen(
                            onDone: () {
                              Navigator.pop(context);
                              _load();
                            }),
                      ),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DateSelector(
                      date: _date,
                      onChanged: (d) {
                        setState(() => _date = d);
                        _load();
                      },
                    ),
                    const SizedBox(height: 16),
                    _CalorieWidget(
                      consumed: summary.calories,
                      target: targetCal,
                      remaining: remaining,
                    ),
                    const SizedBox(height: 12),
                    _MacroRow(
                      protein: summary.protein,
                      targetProtein: _profile!.targetProtein,
                      fat: summary.fat,
                      targetFat: _profile!.targetFat,
                      carbs: summary.carbs,
                      targetCarbs: _profile!.targetCarbs,
                    ),
                    const SizedBox(height: 16),
                    _WaterWidget(
                      glasses: _waterGlasses,
                      onChanged: _setWater,
                    ),
                    const SizedBox(height: 16),
                    ..._mealTypes.map((meal) => _MealSection(
                          mealType: meal.key,
                          title: meal.title,
                          icon: meal.icon,
                          entries: _entries
                              .where((e) => e.mealType == meal.key)
                              .toList(),
                          onAdd: () => _addEntry(meal.key),
                          onDelete: _deleteEntry,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealDef {
  final String key;
  final String title;
  final IconData icon;
  const _MealDef(
      {required this.key, required this.title, required this.icon});
}

const _mealTypes = [
  _MealDef(key: 'breakfast', title: 'Завтрак', icon: LucideIcons.sunrise),
  _MealDef(key: 'lunch', title: 'Обед', icon: LucideIcons.sun),
  _MealDef(key: 'dinner', title: 'Ужин', icon: LucideIcons.moon),
  _MealDef(key: 'snack', title: 'Перекус', icon: LucideIcons.apple),
];

class _DateSelector extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DateSelector({required this.date, required this.onChanged});

  String _label(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(d.year, d.month, d.day);
    if (selected == today) return 'Сегодня';
    if (selected == today.subtract(const Duration(days: 1))) return 'Вчера';
    return '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: YgeiaColors.accent),
          onPressed: () =>
              onChanged(date.subtract(const Duration(days: 1))),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: YgeiaColors.accent),
                ),
                child: child!,
              ),
            );
            if (picked != null) onChanged(picked);
          },
          child: Text(
            _label(date),
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: YgeiaColors.textPrimary),
          ),
        ),
        IconButton(
          icon:
              const Icon(Icons.chevron_right, color: YgeiaColors.accent),
          onPressed: () {
            final next = date.add(const Duration(days: 1));
            if (next
                .isBefore(DateTime.now().add(const Duration(days: 1)))) {
              onChanged(next);
            }
          },
        ),
      ],
    );
  }
}

class _CalorieWidget extends StatelessWidget {
  final double consumed;
  final double target;
  final double remaining;

  const _CalorieWidget({
    required this.consumed,
    required this.target,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    final isOver = consumed > target;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(100, 100),
                  painter: _CircleProgressPainter(
                    progress: progress,
                    isOver: isOver,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remaining > 0
                          ? remaining.round().toString()
                          : '+${(-remaining).round()}',
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isOver
                              ? const Color(0xFFE07A5F)
                              : YgeiaColors.accent),
                    ),
                    Text(
                      isOver ? 'сверх' : 'осталось',
                      style: GoogleFonts.inter(
                          fontSize: 9, color: YgeiaColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CalRow(
                    label: 'Норма',
                    value: '${target.round()} ккал',
                    color: YgeiaColors.textMuted),
                const SizedBox(height: 8),
                _CalRow(
                    label: 'Съедено',
                    value: '${consumed.round()} ккал',
                    color: YgeiaColors.accent),
                const SizedBox(height: 8),
                _CalRow(
                    label: remaining > 0 ? 'Осталось' : 'Перебор',
                    value: '${remaining.abs().round()} ккал',
                    color: isOver
                        ? const Color(0xFFE07A5F)
                        : YgeiaColors.textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _CalRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13, color: YgeiaColors.textSecondary)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color)),
      ],
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final bool isOver;

  _CircleProgressPainter({required this.progress, required this.isOver});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;

    final bgPaint = Paint()
      ..color = YgeiaColors.accent.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = isOver ? const Color(0xFFE07A5F) : YgeiaColors.accent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MacroRow extends StatelessWidget {
  final double protein;
  final double targetProtein;
  final double fat;
  final double targetFat;
  final double carbs;
  final double targetCarbs;

  const _MacroRow({
    required this.protein,
    required this.targetProtein,
    required this.fat,
    required this.targetFat,
    required this.carbs,
    required this.targetCarbs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          _MacroBar(
              label: 'Белки',
              value: protein,
              target: targetProtein,
              color: YgeiaColors.accent),
          const SizedBox(width: 12),
          _MacroBar(
              label: 'Жиры',
              value: fat,
              target: targetFat,
              color: YgeiaColors.accentSecondary),
          const SizedBox(width: 12),
          _MacroBar(
              label: 'Углеводы',
              value: carbs,
              target: targetCarbs,
              color: YgeiaColors.textMuted),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / target).clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        children: [
          Text('${value.round()}г',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11, color: YgeiaColors.textMuted)),
          Text('из ${target.round()}г',
              style: GoogleFonts.inter(
                  fontSize: 10, color: YgeiaColors.textMuted)),
        ],
      ),
    );
  }
}

class _WaterWidget extends StatelessWidget {
  final int glasses;
  final ValueChanged<int> onChanged;

  const _WaterWidget({required this.glasses, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const target = 8;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.droplet,
                      size: 18, color: YgeiaColors.accent),
                  const SizedBox(width: 8),
                  Text('Вода',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: YgeiaColors.textPrimary)),
                ],
              ),
              Text('$glasses / $target стаканов',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: glasses >= target
                          ? YgeiaColors.accent
                          : YgeiaColors.textMuted,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(target, (i) {
              final filled = i < glasses;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i + 1 == glasses ? i : i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      LucideIcons.droplet,
                      size: 26,
                      color: filled
                          ? YgeiaColors.accent
                          : YgeiaColors.accent.withOpacity(0.25),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String mealType;
  final String title;
  final IconData icon;
  final List<MealEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  const _MealSection({
    required this.mealType,
    required this.title,
    required this.icon,
    required this.entries,
    required this.onAdd,
    required this.onDelete,
  });

  double get _totalCal => entries.fold(0, (s, e) => s + e.calories);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: YgeiaColors.accent),
                    const SizedBox(width: 8),
                    Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: YgeiaColors.textPrimary)),
                    if (entries.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text('${_totalCal.round()} ккал',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: YgeiaColors.accent,
                              fontWeight: FontWeight.w600)),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: YgeiaColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          if (entries.isNotEmpty)
            const Divider(height: 1, color: YgeiaColors.divider),
          ...entries.map((e) =>
              _EntryTile(entry: e, onDelete: () => onDelete(e.id))),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback onDelete;

  const _EntryTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: const Color(0xFFE07A5F).withOpacity(0.15),
        child: const Icon(Icons.delete_outline, color: Color(0xFFE07A5F)),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: YgeiaColors.textPrimary)),
                  Text(
                      '${entry.amount.round()}г · '
                      'Б:${entry.protein.toStringAsFixed(1)} '
                      'Ж:${entry.fat.toStringAsFixed(1)} '
                      'У:${entry.carbs.toStringAsFixed(1)}',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: YgeiaColors.textMuted)),
                ],
              ),
            ),
            Text('${entry.calories.round()} ккал',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: YgeiaColors.accent)),
          ],
        ),
      ),
    );
  }
}
