// import 'package:flutter/material.dart';

// class UpcomingActionButton extends StatelessWidget {
//   const UpcomingActionButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: null,
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: const Color(0xFFB7BCC4),
//           disabledForegroundColor: Colors.white,
//           disabledBackgroundColor: const Color(0xFFB7BCC4),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: const Text(
//           'Starts in...',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class UpcomingActionButton extends StatelessWidget {
  const UpcomingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: null,
        child: const Text(
          'قيد الانتظار....',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
