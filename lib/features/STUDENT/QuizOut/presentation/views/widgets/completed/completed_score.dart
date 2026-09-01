
import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/views/exam_review_page.dart';

class CompletedScore extends StatelessWidget {
  final num? score;
  final num? totalMarks;
  final num? percentage;
  final int? attemptId;

  const CompletedScore({
    super.key,
    this.score,
    this.totalMarks,
    this.percentage,
    this.attemptId,
  });

  @override
  Widget build(BuildContext context) {
    if (score != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              size: 28,
              color: Color(0xFF7C3AED),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'النتيجة',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    '$score / $totalMarks (${percentage?.toStringAsFixed(0) ?? '0'}%)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                ],
              ),
            ),
            if (attemptId != null)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 133, 68, 237),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamReviewPage(attemptId: attemptId!),
                      ),
                    );
                  },
                  child: const Text(
                    'مراجعة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 24, color: Color(0xFF6B7280)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'تم تقديم الاختبار. ستتوفر النتائج بعد انتهاء فترة الاختبار.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
