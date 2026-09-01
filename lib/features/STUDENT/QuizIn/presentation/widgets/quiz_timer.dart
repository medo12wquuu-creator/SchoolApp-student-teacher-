import 'dart:async';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onExpired;

  const QuizTimer({super.key, required this.initialSeconds, this.onExpired});

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  late int _seconds;
  Timer? _timer;
  bool _hasExpired = false;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    if (_seconds > 0) {
      _startTimer();
    }
  }

  // لما توصل قيمة remaining_seconds الحقيقية من الباك اند بعد التحميل
  @override
  void didUpdateWidget(covariant QuizTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSeconds != widget.initialSeconds) {
      _seconds = widget.initialSeconds;
      _hasExpired = false;
      if (_seconds > 0) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
        if (!_hasExpired) {
          _hasExpired = true;
          widget.onExpired?.call();
        }
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _seconds ~/ 3600;
    final m = (_seconds % 3600) ~/ 60;
    final s = _seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = _seconds <= 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16,
            color: isUrgent ? const Color(0xFFD32F2F) : const Color(0xFF1E88E5),
          ),
          const SizedBox(width: 6),
          Text(
            _formatted,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isUrgent
                  ? const Color(0xFFD32F2F)
                  : const Color(0xFF1E88E5),
            ),
          ),
        ],
      ),
    );
  }
}
