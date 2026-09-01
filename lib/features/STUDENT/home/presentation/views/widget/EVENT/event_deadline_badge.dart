// import 'package:flutter/material.dart';

// class EventDeadlineBadge extends StatelessWidget {
//   final String registration_deadline;

//   const EventDeadlineBadge({super.key, required this.registration_deadline});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFE9E9),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline, size: 16, color: Color(0xFFD32F2F)),
//           const SizedBox(width: 6),
//           Text(
//             registration_deadline,// هنا اريدك ان تاخذ deadline الذي تجلبه من الباك وتعرضه هنا بدل التاريخ الثابت
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFFD32F2F),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class EventDeadlineBadge extends StatelessWidget {
  final String deadline;

  const EventDeadlineBadge({super.key, required this.deadline});

  // تحويل النص ISO إلى تاريخ وتنسيقه بشكل مقروء
  String get _formatted {
    final dt = DateTime.tryParse(deadline);
    if (dt == null) return deadline;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');

    return '${months[dt.month - 1]} ${dt.day} • $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Color(0xFFD32F2F)),
          const SizedBox(width: 6),
          Text(
            _formatted,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }
}
