import 'package:flutter/material.dart';

class ClassStudentsStatesSection extends StatelessWidget {
  final String studentCount;
  final String successRate;
  final String topScore;

  const ClassStudentsStatesSection({
    super.key,
    this.studentCount = '0',
    this.successRate = '0%',
    this.topScore = '0',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMiniStateCard(
          Icons.people_outline,
          Colors.blue,
          'الطلاب',
          studentCount,
        ),
        const SizedBox(width: 8),
        _buildMiniStateCard(
          Icons.trending_up,
          Colors.green,
          'النجاح',
          '$successRate%',
        ),
        const SizedBox(width: 8),
        _buildMiniStateCard(
          Icons.school_outlined,
          Colors.purple,
          'أعلى درجة',
          topScore,
        ),
      ],
    );
  }

  Widget _buildMiniStateCard(
    IconData icon,
    Color color,
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
