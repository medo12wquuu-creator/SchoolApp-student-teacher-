import 'package:flutter/material.dart';

class FailedToLoadWidget extends StatelessWidget {
  final String itemName;
  final VoidCallback? onRetry;

  const FailedToLoadWidget({super.key, required this.itemName, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, color: Colors.red.shade400, size: 30),
          const SizedBox(height: 10),
          Text(
            'فشل في تحميل $itemName.\n'
            'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade400,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            // TextButton.icon(
            //   onPressed: onRetry,
            //   icon: const Icon(Icons.refresh, size: 18),
            //   label: const Text('Try again'),
            // ),
          ],
        ],
      ),
    );
  }
}
