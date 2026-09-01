// import 'package:flutter/material.dart';

// class UpcomingStatistics extends StatelessWidget {
//   final Color accentColor;
//   final Quiz quiz;

//   const UpcomingStatistics({
//     super.key,
//     required this.accentColor,
//     required this.quiz,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatistic(
//             icon: Icons.help_outline_rounded,
//             value: quiz.questionsCount.toString(),
//             label: 'Questions',
//           ),
//         ),

//         _divider(),

//         Expanded(
//           child: _buildStatistic(
//             icon: Icons.emoji_events_outlined,
//             value: quiz.totalMarks.toString(),
//             label: 'Total Marks',
//           ),
//         ),

//         _divider(),

//         Expanded(
//           child: _buildStatistic(
//             icon: Icons.access_time_rounded,
//             value: quiz.durationMinutes.toString(),
//             label: 'Minutes',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _divider() {
//     return Container(
//       height: 32,
//       width: 1,
//       color: const Color(0xFFE1E5EA),
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//     );
//   }

//   Widget _buildStatistic({
//     required IconData icon,
//     required String value,
//     required String label,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: accentColor, size: 24),

//         const SizedBox(width: 7),

//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF172033),
//                 ),
//               ),

//               const SizedBox(height: 2),

//               Text(
//                 label,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 10.5,
//                   color: Color(0xFF667085),
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class UpcomingStatistics extends StatelessWidget {
  final int questions;
  final int totalMarks;
  final int minutes;

  const UpcomingStatistics({
    super.key,
    required this.questions,
    required this.totalMarks,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          icon: Icons.question_answer_outlined,
          value: '$questions',
          label: 'الأسئلة',
        ),
        _StatItem(
          icon: Icons.stars_outlined,
          value: '$totalMarks',
          label: 'العلامة الكلية',
        ),
        _StatItem(
          icon: Icons.timer_outlined,
          value: '$minutes',
          label: 'الدقائق',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
