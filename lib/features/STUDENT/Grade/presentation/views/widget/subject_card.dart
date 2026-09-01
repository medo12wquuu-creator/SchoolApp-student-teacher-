import 'package:flutter/material.dart';
import 'metric_item.dart';
import 'mastery_bar.dart';

class SubjectCard extends StatelessWidget {
  final String subject;
  final String subtitle;
  final String grade;
  final double total_score;
  final double total_max;
  final List<Map<String, dynamic>> metrics;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.subtitle,
    required this.grade,
    required this.total_score,
    required this.total_max,
    required this.metrics,
  });

  double get mastery => total_max == 0 ? 0 : (total_score / total_max).clamp(0, 1);

  Color colorGrade(double value) {
    if (value <= 0.5) return const Color(0xFFF91818);
    if (value <= 0.6) return const Color(0xFFF49223);
    if (value <= 0.7) return const Color(0xFFF4D523);
    if (value <= 0.8) return const Color(0xFF3BBBF6);
    if (value < 1) return const Color(0xFF3B82F6);
    return const Color(0xFF06CC27);
  }

  @override
  Widget build(BuildContext context) {
    final double masteryValue = mastery;
    final Color barColor = colorGrade(masteryValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;
    final totalTextColor = isDark ? Colors.grey.shade300 : Colors.black87;
    final iconBg = isDark ? const Color(0xFF1A2A4A) : Colors.blue.shade50;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  subject.isEmpty
                      ? '??'
                      : subject.substring(
                          0,
                          subject.length < 2 ? subject.length : 2,
                        ),
                  style: TextStyle(
                    color: barColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.isEmpty ? 'Untitled subject' : subject,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      subtitle.isEmpty ? 'No details available' : subtitle,
                      style: TextStyle(color: subtitleColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  grade.isEmpty ? '0.00 / 0.00' : grade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          if (metrics.isNotEmpty) ...[
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 40,
                mainAxisSpacing: 16,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                return MetricItem(
                  icon: metrics[index]['icon'],
                  label: metrics[index]['label'],
                  score: metrics[index]['score'],
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Subject total: ${total_score.toStringAsFixed(2)} / ${total_max.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: totalTextColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          MasteryBar(value: masteryValue, color: barColor),
        ],
      ),
    );
  }
}
