import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/journal_entry.dart';
import '../../services/journal_service.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late final TextEditingController _controller;
  final _service = JournalService();
  int _refresh = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await _service.addEntry(text);
    if (!mounted) return;
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() => _refresh++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Записано',
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

  Future<void> _confirmDelete(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: YgeiaColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Удалить запись?',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: YgeiaColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Отмена',
              style: GoogleFonts.inter(color: YgeiaColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Удалить',
              style: GoogleFonts.inter(color: YgeiaColors.accentSecondary),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _service.deleteEntry(entry.id);
      if (!mounted) return;
      setState(() => _refresh++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: YgeiaColors.textPrimary,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Ж',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: YgeiaColors.textPrimary,
                ),
              ),
              TextSpan(
                text: 'урнал',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  color: YgeiaColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            YgeiaSpacing.md,
            YgeiaSpacing.md,
            YgeiaSpacing.md,
            YgeiaSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(),
              const SizedBox(height: YgeiaSpacing.lg),
              Text(
                'Последние записи',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: YgeiaColors.textSecondary,
                ),
              ),
              const SizedBox(height: YgeiaSpacing.md),
              StreamBuilder<List<JournalEntry>>(
                key: ValueKey(_refresh),
                stream: _service.getRecentEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(YgeiaSpacing.lg),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: YgeiaColors.accent,
                          ),
                        ),
                      ),
                    );
                  }
                  final entries = snapshot.data!;
                  if (entries.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: YgeiaSpacing.lg,
                      ),
                      child: Text(
                        'Пока пусто',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: YgeiaColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: entries
                        .map(
                          (e) => _EntryRow(
                            entry: e,
                            onLongPress: () => _confirmDelete(e),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(YgeiaSpacing.md),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Запиши что в голове',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: YgeiaColors.textMuted,
              ),
              border: InputBorder.none,
              counterStyle: GoogleFonts.inter(
                fontSize: 11,
                color: YgeiaColors.textMuted,
              ),
            ),
            style: GoogleFonts.fraunces(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: YgeiaColors.textPrimary,
            ),
            maxLines: null,
            minLines: 4,
            maxLength: 1000,
          ),
          const SizedBox(height: YgeiaSpacing.sm),
          Row(
            children: [
              const Spacer(),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  final hasText = value.text.trim().isNotEmpty;
                  return TextButton.icon(
                    icon: const Icon(LucideIcons.send, size: 18),
                    label: Text(
                      'Записать',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    onPressed: hasText ? _save : null,
                    style: TextButton.styleFrom(
                      foregroundColor: hasText
                          ? YgeiaColors.accent
                          : YgeiaColors.textMuted,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.onLongPress});

  final JournalEntry entry;
  final VoidCallback onLongPress;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(dt.year, dt.month, dt.day);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    if (entryDay == today) return 'Сегодня $h:$m';
    if (entryDay == today.subtract(const Duration(days: 1))) {
      return 'Вчера $h:$m';
    }
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$d.${mo}.${dt.year} $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: YgeiaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _formatDate(entry.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: YgeiaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: YgeiaSpacing.xs),
                Text(
                  entry.text,
                  style: GoogleFonts.fraunces(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: YgeiaColors.textPrimary,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: YgeiaColors.divider,
          ),
        ],
      ),
    );
  }
}
