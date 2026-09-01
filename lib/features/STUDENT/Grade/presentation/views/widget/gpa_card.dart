import 'package:flutter/material.dart';

class GPACard extends StatelessWidget {
  final double studentTotal;
  final double totalMax;
  final int rankSection;
  final int sectionSize;
  final int rankClassroom;
  final int classSize;
  final String sectionName;
  final String classroomName;

  const GPACard({
    super.key,
    required this.studentTotal,
    required this.totalMax,
    required this.rankSection,
    required this.sectionSize,
    required this.rankClassroom,
    required this.classSize,
    required this.sectionName,
    required this.classroomName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final infoBg = isDark ? const Color(0xFF1A2A4A) : Colors.blue.shade50;
    final infoText = isDark ? const Color(0xFF90CAF9) : Colors.blue.shade700;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  Text(
                    totalMax == 0
                        ? '0.0%'
                        : "${(studentTotal * 100 / totalMax).toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: totalMax == 0
                          ? 0
                          : (studentTotal / totalMax).clamp(0, 1),
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFFE8F0FE),
                      color: const Color(0xFF1E40AF),
                    ),
                  ),
                  const Icon(Icons.stars, color: Color(0xFF1E40AF), size: 28),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: infoBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.grade_sharp, size: 16, color: infoText),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${sectionName.isEmpty ? 'Section' : sectionName} • ${classroomName.isEmpty ? 'Class' : classroomName}',
                        style: TextStyle(
                          color: infoText,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: $studentTotal / $totalMax',
                  style: TextStyle(
                    color: infoText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Rank: #$rankSection/$sectionSize section • #$rankClassroom/$classSize class',
                  style: TextStyle(
                    color: infoText,
                    fontWeight: FontWeight.w600,
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
}
