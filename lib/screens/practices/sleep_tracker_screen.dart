import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/sleep_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/mood_scale.dart';
import '../../widgets/sleep_history_list.dart';
import '../../widgets/pillar_app_bar.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  final _service = SleepService();
  final _noteController = TextEditingController();

  int? _selectedQuality;
  TimeOfDay? _bedtime;
  TimeOfDay? _wakeup;
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
    final entry = await _service.getSleepToday();
    if (!mounted) return;
    setState(() {
      if (entry != null) {
        _selectedQuality = entry.quality;
        _bedtime = entry.bedtime;
        _wakeup = entry.wakeup;
        _noteController.text = entry.note ?? '';
      }
      _loadingToday = false;
    });
  }

  Future<void> _pickBedtime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _bedtime ?? const TimeOfDay(hour: 23, minute: 0),
    );
    if (t != null) setState(() => _bedtime = t);
  }

  Future<void> _pickWakeup() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _wakeup ?? const TimeOfDay(hour: 7, minute: 0),
    );
    if (t != null) setState(() => _wakeup = t);
  }

  Future<void> _save() async {
    if (_selectedQuality == null) return;
    setState(() => _saving = true);
    await _service.saveSleepToday(
      _selectedQuality!,
      _bedtime,
      _wakeup,
      _noteController.text,
    );
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

  String? get _durationText {
    if (_bedtime == null || _wakeup == null) return null;
    final bed = _bedtime!.hour * 60 + _bedtime!.minute;
    final wake = _wakeup!.hour * 60 + _wakeup!.minute;
    final mins = wake > bed ? wake - bed : (24 * 60 - bed) + wake;
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h == 0) return '${m}м';
    if (m == 0) return '${h}ч';
    return '${h}ч ${m}м';
  }

  static String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: const PillarAppBar(
        title: 'Сон',
        italicFromIndex: 1,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(),
              const SizedBox(height: 24),
              SleepHistoryList(
                key: ValueKey(_historyRefresh),
                service: _service,
              ),
              const SizedBox(height: 24),
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
          Text('Как ты спал?', style: YgeiaTypography.h2),
          const SizedBox(height: 24),
          if (_loadingToday)
            const SizedBox(height: 56)
          else
            MoodScale(
              selected: _selectedQuality,
              onChanged: (v) => setState(() => _selectedQuality = v),
              labels: const ['Ужасно', 'Плохо', 'Нормально', 'Хорошо', 'Отлично'],
            ),
          if (_selectedQuality != null) ...[
            const SizedBox(height: 20),
            _buildTimePickers(),
            const SizedBox(height: 8),
            Text(
              _durationText ?? 'Опционально',
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: YgeiaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
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
              onPressed: (_selectedQuality != null && !_saving) ? _save : null,
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

  Widget _buildTimePickers() {
    return Row(
      children: [
        _buildTimeButton(
          icon: LucideIcons.moon,
          label: 'Лёг',
          value: _bedtime,
          onTap: _pickBedtime,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            LucideIcons.arrowRight,
            size: 16,
            color: YgeiaColors.textMuted,
          ),
        ),
        _buildTimeButton(
          icon: LucideIcons.sun,
          label: 'Встал',
          value: _wakeup,
          onTap: _pickWakeup,
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required IconData icon,
    required String label,
    required TimeOfDay? value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: YgeiaColors.bgBase,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 13, color: YgeiaColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: YgeiaColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value != null ? _formatTime(value) : '—  —',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: value != null
                      ? YgeiaColors.textPrimary
                      : YgeiaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
