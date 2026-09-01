//////////////////////////////////
library;

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schooly/features/STUDENT/home/data/models/event_model.dart';
// import 'event_image.dart';
// import 'event_title.dart';
// import 'event_description.dart';
// import 'event_icon_text.dart';
// import 'event_deadline_badge.dart';

// class EventCard extends StatelessWidget {
//   final EventsModel event;
//   final VoidCallback onRegister;
//   final bool isRegistered;
//   final bool isRegistering;

//   const EventCard({
//     super.key,
//     required this.event,
//     required this.onRegister,
//     this.isRegistered = false,
//     this.isRegistering = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool capacityFull = event.capacity <= 0;

//     return Container(
//       width: 320,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           EventImage(file: event.imageFile, imageUrl: event.imageUrl),

//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 EventTitle(title: event.title),
//                 const SizedBox(height: 12),

//                 EventDescription(description: event.description),
//                 const SizedBox(height: 20),

//                 EventIconText(
//                   icon: Icons.calendar_today_outlined,
//                   text: event.eventDate.isNotEmpty
//                       ? DateFormat(
//                           'dd-MM-yyyy',
//                         ).format(DateTime.parse(event.eventDate))
//                       : '',
//                   // هنا التاريخ يكون شكله 2026-07-30T12:19:10.000000Z
//                 ),
//                 const SizedBox(height: 10),

//                 EventIconText(
//                   icon: Icons.location_on_outlined,
//                   text: event.location,
//                 ),
//                 const SizedBox(height: 24),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     EventDeadlineBadge(deadline: event.registrationDeadline),

//                     if (capacityFull)
//                       const Text(
//                         'لقد اكتمل العدد',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFD32F2F),
//                         ),
//                       )
//                     else if (isRegistered)
//                       const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.check_circle,
//                             size: 16,
//                             color: Color(0xFF22C55E),
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             'تم التسجيل',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF22C55E),
//                             ),
//                           ),
//                         ],
//                       )
//                     else
//                       ElevatedButton(
//                         onPressed: isRegistering ? null : onRegister,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1E88E5),
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                         ),
//                         child: isRegistering
//                             ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 'Register',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schooly/features/STUDENT/home/data/models/event_model.dart';

import 'event_image.dart';
import 'event_title.dart';
import 'event_description.dart';
import 'event_icon_text.dart';
import 'event_deadline_badge.dart';

class EventCard extends StatelessWidget {
  final EventsModel event;
  final VoidCallback onRegister;
  final bool isRegistered;
  final bool isRegistering;

  const EventCard({
    super.key,
    required this.event,
    required this.onRegister,
    this.isRegistered = false,
    this.isRegistering = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool capacityFull = event.capacity <= 0;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // Image
          // ----------------------------------------------------------
          EventImage(file: event.imageFile, imageUrl: event.imageUrl),

          // ----------------------------------------------------------
          // Content
          // ----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------
                // Title
                // ----------------------------------------------------
                EventTitle(title: event.title),

                const SizedBox(height: 12),

                // ----------------------------------------------------
                // Description
                // ----------------------------------------------------
                EventDescription(description: event.description),

                const SizedBox(height: 20),

                // ----------------------------------------------------
                // Date
                // ----------------------------------------------------
                EventIconText(
                  icon: Icons.calendar_today_outlined,
                  text: _formatDate(event.eventDate),
                ),

                const SizedBox(height: 10),

                // ----------------------------------------------------
                // Location
                // ----------------------------------------------------
                EventIconText(
                  icon: Icons.location_on_outlined,
                  text: event.location,
                ),

                const SizedBox(height: 24),

                // ----------------------------------------------------
                // Deadline
                // ----------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: EventDeadlineBadge(
                    deadline: event.registrationDeadline,
                  ),
                ),

                const SizedBox(height: 14),

                // ----------------------------------------------------
                // Registration status / button
                // ----------------------------------------------------
                _buildRegistrationSection(capacityFull: capacityFull),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // Date formatter
  // ================================================================

  String _formatDate(String date) {
    if (date.isEmpty) {
      return '';
    }

    try {
      final DateTime parsedDate = DateTime.parse(date);

      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (_) {
      // إذا كانت قيمة التاريخ غير صحيحة
      // لا نجعل التطبيق ينهار
      return date;
    }
  }

  // ================================================================
  // Registration section
  // ================================================================

  Widget _buildRegistrationSection({required bool capacityFull}) {
    // --------------------------------------------------------------
    // Capacity full
    // --------------------------------------------------------------
    if (capacityFull) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off_outlined, size: 17, color: Color(0xFFD32F2F)),
            SizedBox(width: 7),
            Flexible(
              child: Text(
                'لقد اكتمل العدد',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------------
    // Already registered
    // --------------------------------------------------------------
    if (isRegistered) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 17, color: Color(0xFF22C55E)),
            SizedBox(width: 7),
            Text(
              'تم التسجيل',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22C55E),
              ),
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------------
    // Register button
    // --------------------------------------------------------------
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isRegistering ? null : onRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF90CAF9),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isRegistering
              ? const SizedBox(
                  key: ValueKey('loading'),
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Register',
                  key: ValueKey('register'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    inherit: false,
                  ),
                ),
        ),
      ),
    );
  }
}
