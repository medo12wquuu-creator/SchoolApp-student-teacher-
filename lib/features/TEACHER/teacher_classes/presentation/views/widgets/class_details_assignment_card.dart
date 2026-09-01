
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassDetailsAssignmentCard extends StatelessWidget {
  final String title;
  final String subject;
  final String date;
  final VoidCallback? onDelete;

  const ClassDetailsAssignmentCard({
    super.key,
    required this.title,
    required this.subject,
    required this.date,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ktextColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: ktextColor.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: klightSecoderyColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.assignment_sharp,
              color: kprimeryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ktextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: klightPrimeryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subject.isEmpty ? 'واجب' : subject,
                        style: const TextStyle(
                          color: kprimeryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: ktextColor.withOpacity(0.45),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      date,
                      style: TextStyle(
                        color: ktextColor.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ktextColor.withOpacity(0.4)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: kRedColor),
                    SizedBox(width: 8),
                    Text('حذف', style: TextStyle(color: kRedColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
