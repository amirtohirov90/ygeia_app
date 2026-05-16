import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/mood_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/mood_scale.dart';
import '../../widgets/mood_history_list.dart';

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({super.key});

  @override
  State<EmotionsScreen> createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  final _service = MoodService();
  final _noteController = TextEditingController();

  int? _selectedLevel;
  bool _loadingToday = true;
  bool _saving = false;
  int _historyRefresh = 0;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadToday() async {
    final entry = await _service.getMoodToday();
    if (!mounted) return;
    setState(() {
      if (entry != null) {
        _selectedLevel = entry.level;
        _noteController.text = entry.note ?? '';
      }
      _loadingToday = false;
    });
  }

  Future<void> _save() async {
    if (_selectedLevel == null) return;
    setState(() => _saving = true);
    await _service.saveMoodToday(_selectedLevel!, _noteController.text);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _historyRefresh++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Сохранено',
          style: GoogleFonts.inter(fontSize: 14, color: YgeiaColors.textPrimary),
        ),
        backgroundColor: YgeiaColors.bgCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(),
              const SizedBox(height: 24),
              MoodHistoryList(
                key: ValueKey(_historyRefresh),
                service: _service,
              ),
              const SizedBox(height: 24),
              Text(
                'Скоро · журнал мыслей, колесо эмоций',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: YgeiaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Как ты сейчас?', style: YgeiaTypography.h2),
          const SizedBox(height: 24),
          if (_loadingToday)
            const SizedBox(height: 56)
          else
            MoodScale(
              selected: _selectedLevel,
              onChanged: (v) => setState(() => _selectedLevel = v),
            ),
          if (_selectedLevel != null) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Опционально · одна короткая фраза',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: YgeiaColors.textMuted,
                ),
                filled: true,
                fillColor: YgeiaColors.bgBase,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                counterStyle: GoogleFonts.inter(
                  fontSize: 11,
                  color: YgeiaColors.textMuted,
                ),
              ),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: YgeiaColors.textPrimary,
              ),
              maxLength: 200,
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: (_selectedLevel != null && !_saving) ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: YgeiaColors.accent,
                disabledBackgroundColor: YgeiaColors.divider,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: YgeiaColors.white,
                      ),
                    )
                  : Text(
                      'Сохранить',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: YgeiaColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
