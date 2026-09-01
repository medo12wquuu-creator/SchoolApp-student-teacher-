// import 'package:flutter/material.dart';

// class UpcomingCountdown extends StatelessWidget {
//   final String label;
//   final int seconds;
//   final Color accentColor;

//   const UpcomingCountdown({
//     super.key,
//     required this.label,
//     required this.seconds,
//     required this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hours = seconds ~/ 3600;
//     final minutes = (seconds % 3600) ~/ 60;
//     final secs = seconds % 60;

//     final time =
//         '${hours.toString().padLeft(2, '0')} : '
//         '${minutes.toString().padLeft(2, '0')} : '
//         '${secs.toString().padLeft(2, '0')}';

//     return Align(
//       alignment: Alignment.centerRight,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.timer_outlined, size: 25, color: accentColor),

//           const SizedBox(width: 8),

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF667085),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               const SizedBox(height: 2),

//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: accentColor,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';

class UpcomingCountdown extends StatefulWidget {
  final int seconds;

  const UpcomingCountdown({super.key, required this.seconds});

  @override
  State<UpcomingCountdown> createState() => _UpcomingCountdownState();
}

class _UpcomingCountdownState extends State<UpcomingCountdown> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _startTicking();
  }

  @override
  void didUpdateWidget(UpcomingCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا جاءت قيمة جديدة من الأب (تحديث/refresh) أعد ضبط العدّاد
    if (oldWidget.seconds != widget.seconds) {
      _remaining = widget.seconds;
    }
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) _remaining--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.hourglass_empty, size: 16, color: Color(0xFF4B5563)),
          const SizedBox(width: 8),
          Text(
            'يبدأ في ',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(width: 6),
          Text(
            _format(_remaining),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  String _format(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
