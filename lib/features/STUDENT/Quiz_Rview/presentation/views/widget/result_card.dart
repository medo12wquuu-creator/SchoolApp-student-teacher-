// import 'package:flutter/material.dart';

// class ResultCard extends StatelessWidget {
//   const ResultCard({super.key, required this.isCorrect});

//   final bool isCorrect;

//   @override
//   Widget build(BuildContext context) {
//     final Color color = isCorrect
//         ? const Color(0xFF2ECC71)
//         : const Color(0xFFE74C3C);

//     final IconData icon = isCorrect
//         ? Icons.check_circle_outline_rounded
//         : Icons.info_outline_rounded;

//     final String title = isCorrect ? 'Correct Answer' : 'Answer Review';

//     final String description = isCorrect
//         ? 'Great job! Your answer matches the correct answer.'
//         : 'Your answer was incorrect. Review the correct answer above.';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F7FF),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.10),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 27),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 7),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     color: Color(0xFF172B4D),
//                     fontSize: 15,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.score,
    required this.total,
    required this.percentage,
    required this.status,
  });

  final num score;
  final num total;
  final num percentage;
  final String status;

  bool get _isPassing => percentage >= 50;

  @override
  Widget build(BuildContext context) {
    final Color color = _isPassing
        ? const Color(0xFF2ECC71)
        : const Color(0xFFE74C3C);
    final IconData icon = _isPassing
        ? Icons.emoji_events_outlined
        : Icons.info_outline_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 27),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'النتيجة النهائية',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$score / $total (${percentage.toStringAsFixed(0)}%)',
                  style: const TextStyle(
                    color: Color(0xFF172B4D),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusLabel(status),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'timeout':
        return 'انتهى الوقت قبل إكمال الإجابة على كل الأسئلة';
      case 'graded':
        return 'تم تصحيح الاختبار';
      case 'submitted':
        return 'تم تسليم الاختبار';
      default:
        return status;
    }
  }
}
