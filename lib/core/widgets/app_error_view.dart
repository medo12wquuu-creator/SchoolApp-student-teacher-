import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

/// ويدجت خطأ مميز موحّد: أيقونة متدرجة + رسالة واضحة للمستخدم
/// + تفاصيل تقنية قابلة للطي (تظهر فقط في الـ Debug mode) + زر إعادة المحاولة.
class AppErrorView extends StatelessWidget {
  final String message;
  final String? debugDetails;
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    required this.message,
    this.debugDetails,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة متدرجة بتصميم مميز
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kLightRedColor, kRedColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kRedColor.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: kwhiteColor,
                size: 44,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'تعذر تحميل البيانات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: ktextColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
            if (kDebugMode &&
                debugDetails != null &&
                debugDetails!.isNotEmpty) ...[
              const SizedBox(height: 18),
              _DebugDetailsBox(details: debugDetails!),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: kprimeryColor,
                  foregroundColor: kwhiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// صندوق تفاصيل الخطأ التقنية (يظهر فقط بالـ Debug mode)
class _DebugDetailsBox extends StatelessWidget {
  final String details;

  const _DebugDetailsBox({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: const Row(
            children: [
              Icon(
                Icons.bug_report_rounded,
                size: 18,
                color: Colors.orangeAccent,
              ),
              SizedBox(width: 8),
              Text(
                'تفاصيل الخطأ (Debug)',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SelectableText(
                details,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
