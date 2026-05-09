import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/english_models.dart';
import '../../services/english_service.dart';
import 'lesson_complete_screen.dart';

class LessonScreen extends StatefulWidget {
  final EnglishLesson lesson;
  final Color unitColor;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.unitColor,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _hearts = 3;
  int _mistakes = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  // For choice exercises
  String? _selectedOption;

  // For word order exercises
  List<String> _bankWords = [];
  List<String> _selectedWords = [];

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _feedbackController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));
    _feedbackController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _initExercise();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Exercise get _exercise => widget.lesson.exercises[_currentIndex];
  int get _total => widget.lesson.exercises.length;

  void _initExercise() {
    _isAnswered = false;
    _isCorrect = false;
    _selectedOption = null;
    _feedbackController.reset();

    if (_exercise.type == ExerciseType.wordOrder) {
      _bankWords = List<String>.from(_exercise.options)..shuffle();
      _selectedWords = [];
    } else {
      _bankWords = [];
      _selectedWords = [];
    }
  }

  bool get _canCheck {
    if (_isAnswered) return false;
    if (_exercise.type == ExerciseType.wordOrder) {
      return _selectedWords.isNotEmpty;
    }
    return _selectedOption != null;
  }

  void _checkAnswer() {
    bool correct;
    if (_exercise.type == ExerciseType.wordOrder) {
      correct = _selectedWords.join(' ') == _exercise.correctAnswer;
    } else {
      correct = _selectedOption == _exercise.correctAnswer;
    }

    setState(() {
      _isAnswered = true;
      _isCorrect = correct;
      if (!correct) {
        _mistakes++;
        if (_hearts > 0) _hearts--;
        _shakeController.forward(from: 0);
      }
      _feedbackController.forward();
    });
  }

  void _nextExercise() {
    if (_currentIndex < _total - 1) {
      setState(() {
        _currentIndex++;
        _initExercise();
      });
    } else {
      _completeLesson();
    }
  }

  Future<void> _completeLesson() async {
    final service = EnglishService();
    await service.completeLesson(widget.lesson.id, _mistakes);

    final xp = _mistakes <= 1 ? 15 : _mistakes <= 3 ? 10 : 5;
    final stars = _mistakes <= 1 ? 3 : _mistakes <= 3 ? 2 : 1;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonCompleteScreen(
            lessonTitle: widget.lesson.title,
            mistakes: _mistakes,
            totalExercises: _total,
            xpEarned: xp,
            stars: stars,
            unitColor: widget.unitColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildPrompt(),
                    const SizedBox(height: 28),
                    _buildExerciseBody(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomArea(),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: () => _showQuitDialog(),
            child: const Icon(Icons.close, color: Color(0xFF888888)),
          ),
          const SizedBox(width: 12),
          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_currentIndex) / _total,
                minHeight: 10,
                backgroundColor: const Color(0xFFDDD5C8),
                valueColor:
                    AlwaysStoppedAnimation<Color>(widget.unitColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Hearts
          Row(
            children: List.generate(3, (i) {
              return Icon(
                i < _hearts ? Icons.favorite : Icons.favorite_border,
                color: i < _hearts
                    ? const Color(0xFFE63946)
                    : const Color(0xFFDDD5C8),
                size: 20,
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Prompt ──────────────────────────────────────────────────────────────────
  Widget _buildPrompt() {
    String label;
    switch (_exercise.type) {
      case ExerciseType.chooseTranslation:
        label = 'Переведи на русский:';
        break;
      case ExerciseType.chooseEnglish:
        label = 'Переведи на английский:';
        break;
      case ExerciseType.wordOrder:
        label = 'Составь предложение:';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF888888),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            final offset = _shakeController.isAnimating
                ? Offset(
                    6 * (0.5 - _shakeAnimation.value).abs() *
                        (_shakeAnimation.value < 0.5 ? 1 : -1),
                    0)
                : Offset.zero;
            return Transform.translate(offset: offset, child: child);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF4EC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isAnswered
                    ? (_isCorrect
                        ? const Color(0xFF52B788)
                        : const Color(0xFFE63946))
                    : const Color(0xFFDDD5C8),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                if (_exercise.emoji.isNotEmpty)
                  Text(_exercise.emoji,
                      style: const TextStyle(fontSize: 40)),
                if (_exercise.emoji.isNotEmpty) const SizedBox(height: 8),
                Text(
                  _exercise.prompt,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Exercise body ────────────────────────────────────────────────────────────
  Widget _buildExerciseBody() {
    switch (_exercise.type) {
      case ExerciseType.chooseTranslation:
      case ExerciseType.chooseEnglish:
        return _buildChoiceOptions();
      case ExerciseType.wordOrder:
        return _buildWordOrder();
    }
  }

  // ── Multiple choice ──────────────────────────────────────────────────────────
  Widget _buildChoiceOptions() {
    final options = List<String>.from(_exercise.options);
    // Shuffle once per exercise init (options list is already shuffled in exercise
    // but we shuffle display order here for variety — stable per rebuild).
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      children: options.map((opt) => _OptionCard(
        text: opt,
        isSelected: _selectedOption == opt,
        isAnswered: _isAnswered,
        isCorrect: opt == _exercise.correctAnswer,
        onTap: _isAnswered ? null : () => setState(() => _selectedOption = opt),
      )).toList(),
    );
  }

  // ── Word order ───────────────────────────────────────────────────────────────
  Widget _buildWordOrder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected words area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF4EC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isAnswered
                  ? (_isCorrect
                      ? const Color(0xFF52B788)
                      : const Color(0xFFE63946))
                  : const Color(0xFFDDD5C8),
              width: 1.5,
            ),
          ),
          child: _selectedWords.isEmpty
              ? Text('Нажми на слова ниже',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFFBBBBBB)))
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selectedWords.asMap().entries.map((e) {
                    return GestureDetector(
                      onTap: _isAnswered
                          ? null
                          : () => setState(() {
                                _bankWords.add(_selectedWords.removeAt(e.key));
                              }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.unitColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: widget.unitColor.withOpacity(0.4)),
                        ),
                        child: Text(e.value,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.unitColor)),
                      ),
                    );
                  }).toList(),
                ),
        ),
        // Show correct answer if wrong
        if (_isAnswered && !_isCorrect) ...[
          const SizedBox(height: 8),
          Text('Правильно: ${_exercise.correctAnswer}',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFE63946),
                  fontStyle: FontStyle.italic)),
        ],
        const SizedBox(height: 16),
        // Word bank
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _bankWords.map((word) {
            return GestureDetector(
              onTap: _isAnswered
                  ? null
                  : () => setState(() {
                        _selectedWords.add(_bankWords.remove(_bankWords.indexOf(word)));
                      }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF4EC),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xFFDDD5C8), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Text(word,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A))),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Bottom area ──────────────────────────────────────────────────────────────
  Widget _buildBottomArea() {
    if (_isAnswered) {
      return AnimatedBuilder(
        animation: _feedbackController,
        builder: (context, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: _feedbackController, curve: Curves.easeOut)),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: _isCorrect
                ? const Color(0xFF52B788).withOpacity(0.12)
                : const Color(0xFFE63946).withOpacity(0.1),
            border: Border(
              top: BorderSide(
                color: _isCorrect
                    ? const Color(0xFF52B788)
                    : const Color(0xFFE63946),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    _isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: _isCorrect
                        ? const Color(0xFF2D6A4F)
                        : const Color(0xFFE63946),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect ? 'Верно! 🎉' : 'Не совсем...',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _isCorrect
                              ? const Color(0xFF2D6A4F)
                              : const Color(0xFFE63946),
                        ),
                      ),
                      if (!_isCorrect &&
                          _exercise.type != ExerciseType.wordOrder)
                        Text(
                          'Ответ: ${_exercise.correctAnswer}',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF888888)),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCorrect
                        ? const Color(0xFF2D6A4F)
                        : const Color(0xFFE63946),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentIndex < _total - 1 ? 'Продолжить' : 'Завершить',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Check button
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _canCheck ? _checkAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.unitColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFDDD5C8),
            disabledForegroundColor: const Color(0xFF999999),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text('Проверить',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFAF4EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Выйти из урока?',
            style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text('Прогресс этого урока не сохранится.',
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF666666))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Остаться',
                style: GoogleFonts.inter(
                    color: widget.unitColor, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // lesson screen
            },
            child: Text('Выйти',
                style: GoogleFonts.inter(
                    color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFFFAF4EC);
    Color borderColor = const Color(0xFFDDD5C8);
    Color textColor = const Color(0xFF1A1A1A);

    if (isAnswered && isCorrect) {
      bgColor = const Color(0xFF52B788).withOpacity(0.15);
      borderColor = const Color(0xFF52B788);
      textColor = const Color(0xFF2D6A4F);
    } else if (isAnswered && isSelected && !isCorrect) {
      bgColor = const Color(0xFFE63946).withOpacity(0.1);
      borderColor = const Color(0xFFE63946);
      textColor = const Color(0xFFE63946);
    } else if (isSelected) {
      bgColor = const Color(0xFF2D6A4F).withOpacity(0.08);
      borderColor = const Color(0xFF2D6A4F);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
