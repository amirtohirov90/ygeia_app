import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/pillar_app_bar.dart';

enum BreathPhase { idle, inhale, hold, exhale, completed }

class Breathing478Screen extends StatefulWidget {
  const Breathing478Screen({super.key});

  @override
  State<Breathing478Screen> createState() => _Breathing478ScreenState();
}

class _Breathing478ScreenState extends State<Breathing478Screen> {
  static const int _totalCycles = 4;
  static const int _inhaleSec = 4;
  static const int _holdSec = 7;
  static const int _exhaleSec = 8;

  static const double _sizeMin = 180.0;
  static const double _sizeMax = 280.0;
  static const double _opacityMin = 0.3;
  static const double _opacityMax = 0.8;

  BreathPhase _phase = BreathPhase.idle;
  int _currentCycle = 1;
  int _secondsRemaining = 0;
  Timer? _timer;

  double _circleSize = _sizeMin;
  double _circleOpacity = _opacityMin;
  Duration _animDuration = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _currentCycle = 1;
    _startInhale();
  }

  void _startInhale() {
    HapticFeedback.lightImpact();
    setState(() {
      _phase = BreathPhase.inhale;
      _secondsRemaining = _inhaleSec;
      _animDuration = const Duration(seconds: _inhaleSec);
      _circleSize = _sizeMax;
      _circleOpacity = _opacityMax;
    });
    _runTimer(_inhaleSec, _startHold);
  }

  void _startHold() {
    HapticFeedback.lightImpact();
    setState(() {
      _phase = BreathPhase.hold;
      _secondsRemaining = _holdSec;
      _animDuration = Duration.zero;
    });
    _runTimer(_holdSec, _startExhale);
  }

  void _startExhale() {
    HapticFeedback.lightImpact();
    setState(() {
      _phase = BreathPhase.exhale;
      _secondsRemaining = _exhaleSec;
      _animDuration = const Duration(seconds: _exhaleSec);
      _circleSize = _sizeMin;
      _circleOpacity = _opacityMin;
    });
    _runTimer(_exhaleSec, _onExhaleComplete);
  }

  void _onExhaleComplete() {
    if (_currentCycle < _totalCycles) {
      _currentCycle++;
      _startInhale();
    } else {
      HapticFeedback.lightImpact();
      setState(() {
        _phase = BreathPhase.completed;
        _animDuration = Duration.zero;
      });
    }
  }

  void _runTimer(int seconds, VoidCallback onComplete) {
    _timer?.cancel();
    int elapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      elapsed++;
      if (elapsed >= seconds) {
        t.cancel();
        onComplete();
      } else {
        setState(() => _secondsRemaining = seconds - elapsed);
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _phase = BreathPhase.idle;
      _currentCycle = 1;
      _secondsRemaining = 0;
      _animDuration = const Duration(milliseconds: 700);
      _circleSize = _sizeMin;
      _circleOpacity = _opacityMin;
    });
  }

  String get _phaseLabel {
    switch (_phase) {
      case BreathPhase.idle:
        return 'Готовы?';
      case BreathPhase.inhale:
        return 'Вдох';
      case BreathPhase.hold:
        return 'Задержка';
      case BreathPhase.exhale:
        return 'Выдох';
      case BreathPhase.completed:
        return 'Завершено';
    }
  }

  Color get _labelColor {
    if (_phase == BreathPhase.idle || _phase == BreathPhase.completed) {
      return YgeiaColors.accent;
    }
    return YgeiaColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: const PillarAppBar(
        title: 'Дыхание',
        italicFromIndex: 1,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: YgeiaSpacing.xl),
            Text(
              (_phase == BreathPhase.idle || _phase == BreathPhase.completed)
                  ? ' '
                  : 'Цикл $_currentCycle из $_totalCycles',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: YgeiaColors.textSecondary,
              ),
            ),
            const SizedBox(height: YgeiaSpacing.xl),
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: _animDuration,
                  curve: Curves.easeInOut,
                  width: _circleSize,
                  height: _circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: YgeiaColors.accent.withOpacity(_circleOpacity),
                    border: Border.all(
                      color: const Color(0xFF4A6B58),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _phaseLabel,
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: _labelColor,
                        ),
                      ),
                      if (_phase != BreathPhase.idle &&
                          _phase != BreathPhase.completed)
                        Text(
                          '$_secondsRemaining',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: YgeiaColors.white.withOpacity(0.85),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: YgeiaSpacing.lg),
              child: _buildButtons(),
            ),
            const SizedBox(height: YgeiaSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (_phase == BreathPhase.idle) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _start,
          style: ElevatedButton.styleFrom(
            backgroundColor: YgeiaColors.accent,
            foregroundColor: YgeiaColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Text(
            'Начать',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (_phase == BreathPhase.completed) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _stop,
              style: OutlinedButton.styleFrom(
                foregroundColor: YgeiaColors.accent,
                side: const BorderSide(color: YgeiaColors.accent),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Закончить',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: YgeiaSpacing.sm),
          Expanded(
            child: ElevatedButton(
              onPressed: _start,
              style: ElevatedButton.styleFrom(
                backgroundColor: YgeiaColors.accent,
                foregroundColor: YgeiaColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Ещё раз',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _stop,
        style: OutlinedButton.styleFrom(
          foregroundColor: YgeiaColors.accent,
          side: const BorderSide(color: YgeiaColors.accent),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Остановить',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
