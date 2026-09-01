import 'package:flutter/material.dart';

class MetricsRow extends StatelessWidget {
  final double attendance;
  final int absences;

  const MetricsRow({
    super.key,
    required this.attendance,
    required this.absences,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final subtitleColor = isDark
        ? Colors.grey.shade500
        : const Color(0xFF64748B);
    final labelColor = isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8);

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {},
            child: _buildAttendanceCard(cardColor, labelColor, subtitleColor),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {},
            child: _buildAbsencesCard(cardColor, labelColor, subtitleColor),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(
    Color cardColor,
    Color labelColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(cardColor),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  value: attendance,
                  strokeWidth: 6,
                  backgroundColor: const Color(0xFFE3F2FD),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF1E88E5)),
                ),
              ),
              Text(
                "${(attendance * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "النسبة المئوية",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          Text("للحضور", style: TextStyle(fontSize: 14, color: subtitleColor)),
        ],
      ),
    );
  }

  Widget _buildAbsencesCard(
    Color cardColor,
    Color labelColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(cardColor),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$absences",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "إجمالي أيام",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          Text("الغياب", style: TextStyle(fontSize: 14, color: subtitleColor)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(Color cardColor) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
