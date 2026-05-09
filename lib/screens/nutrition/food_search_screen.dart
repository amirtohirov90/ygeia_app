import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/food_database.dart';
import '../../models/food_item.dart';

class FoodSearchScreen extends StatefulWidget {
  final String mealType;
  const FoodSearchScreen({super.key, required this.mealType});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';
  String _category = 'Все';

  List<FoodItem> get _filtered {
    var list = searchFood(_query);
    if (_category != 'Все') {
      list = list.where((f) => f.category == _category).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final categories = foodCategories;

    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: GoogleFonts.inter(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Поиск продукта...',
            hintStyle: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = _category == cat;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2D6A4F)
                          : const Color(0xFFFAF4EC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2D6A4F)
                              : const Color(0xFFDDD5C8)),
                    ),
                    child: Text(cat,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF666666))),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final food = _filtered[i];
                return _FoodTile(
                  food: food,
                  onSelected: (amount) {
                    final entry = MealEntry.fromFood(
                        food, amount, widget.mealType);
                    Navigator.pop(context, entry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodTile extends StatelessWidget {
  final FoodItem food;
  final ValueChanged<double> onSelected;

  const _FoodTile({required this.food, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(food.name,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A))),
        subtitle: Text(
          '${food.calories.round()} ккал · Б:${food.protein.round()} Ж:${food.fat.round()} У:${food.carbs.round()} · на 100г',
          style: GoogleFonts.inter(
              fontSize: 11, color: const Color(0xFF999999)),
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF2D6A4F),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 18),
        ),
        onTap: () => _showAmountPicker(context),
      ),
    );
  }

  void _showAmountPicker(BuildContext context) {
    double amount = 100;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFAF4EC),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDD5C8),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Text(food.name,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A))),
              const SizedBox(height: 8),
              Text(
                '${(food.calories * amount / 100).round()} ккал · '
                'Б:${(food.protein * amount / 100).toStringAsFixed(1)}г · '
                'Ж:${(food.fat * amount / 100).toStringAsFixed(1)}г · '
                'У:${(food.carbs * amount / 100).toStringAsFixed(1)}г',
                style: GoogleFonts.inter(
                    fontSize: 13, color: const Color(0xFF2D6A4F),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amount.round().toString(),
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D6A4F))),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 6),
                    child: Text('г',
                        style: TextStyle(
                            fontSize: 18, color: Color(0xFF999999))),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(ctx).copyWith(
                  activeTrackColor: const Color(0xFF2D6A4F),
                  inactiveTrackColor:
                      const Color(0xFF2D6A4F).withOpacity(0.15),
                  thumbColor: const Color(0xFF2D6A4F),
                  trackHeight: 6,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 14),
                ),
                child: Slider(
                  value: amount,
                  min: 5,
                  max: 500,
                  divisions: 99,
                  onChanged: (v) => setS(() => amount = v),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onSelected(amount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A4F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Добавить',
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
