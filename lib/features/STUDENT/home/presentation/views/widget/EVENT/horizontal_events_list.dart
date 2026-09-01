// import 'package:flutter/material.dart';
// import 'package:schooly/features/STUDENT/home/presentation/views/widget/EVENT/event_card.dart';

// class HorizontalEventsList extends StatelessWidget {
//   const HorizontalEventsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final events = [
//       {
//         'title': 'Annual Spring Concert',
//         'body': 'Join us for the biggest musical event of the semester! Local bands and a...',
//         'event_date': 'Oct 15, 2023 • 4:00 PM',
//         'location': 'Main Campus Green',
//         'registration_deadline': 'Register by Oct 10',
//         'image':
//             'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&q=80&w=800',
//       },
//     ];

//     return SizedBox(
//       height: 520,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         itemCount: events.length,
//         separatorBuilder: (_, _) => const SizedBox(width: 16),
//         itemBuilder: (_, index) => EventCard(event: events[index]),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:schooly/features/STUDENT/home/data/models/event_model.dart';
// import 'event_card.dart';

// class HorizontalEventsList extends StatelessWidget {
//   final List<EventsModel> events;
//   final void Function(EventsModel) onRegister;
//   final Set<int> registeredEvents;
//   final bool isRegistering;

//   const HorizontalEventsList({
//     super.key,
//     required this.events,
//     required this.onRegister,
//     this.registeredEvents = const {},
//     this.isRegistering = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 520,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         itemCount: events.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (_, index) {
//           final event = events[index];
//           return EventCard(
//             event: event,
//             isRegistered: registeredEvents.contains(event.id),
//             isRegistering: isRegistering,
//             onRegister: () => onRegister(event),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/home/data/models/event_model.dart';
import 'event_card.dart';

class HorizontalEventsList extends StatelessWidget {
  final List<EventsModel> events;
  final void Function(EventsModel) onRegister;
  final Set<int> registeredEvents;
  final bool isRegistering;

  const HorizontalEventsList({
    super.key,
    required this.events,
    required this.onRegister,
    this.registeredEvents = const {},
    this.isRegistering = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final event in events) ...[
            EventCard(
              event: event,
              isRegistered: registeredEvents.contains(event.id),
              isRegistering: isRegistering,
              onRegister: () => onRegister(event),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}
