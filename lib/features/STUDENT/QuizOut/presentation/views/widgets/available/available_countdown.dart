// import 'package:flutter/material.dart';

// class AvailableCountdown extends StatelessWidget {
//   final int seconds;

//   const AvailableCountdown({super.key, required this.seconds});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F5E9),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF2E7D32)),
//           const SizedBox(width: 8),
//           Text(
//             'ينتهي في',
//             style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             _format(seconds),
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2E7D32),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _format(int totalSeconds) {
//     final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
//     final s = (totalSeconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

class AvailableCountdown extends StatefulWidget {
  final int seconds;

  const AvailableCountdown({super.key, required this.seconds});

  @override
  State<AvailableCountdown> createState() => _AvailableCountdownState();
}

class _AvailableCountdownState extends State<AvailableCountdown> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel();
      }
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
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(
            'ينتهي في',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(width: 6),
          Text(
            _format(_seconds),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
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
