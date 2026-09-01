// import 'package:flutter/material.dart';
// import 'horizontal_events_list.dart';

// class EventsScreen extends StatelessWidget {
//   const EventsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: SafeArea(child: HorizontalEventsList()));
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/home/presentation/view_models/home_cubit.dart';
import 'package:schooly/features/STUDENT/home/presentation/view_models/home_state.dart';
import 'event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (prev, curr) =>
            prev.events != curr.events ||
            prev.registeredEvents != curr.registeredEvents ||
            prev.isLoading != curr.isLoading,
        builder: (context, state) {
          final events = state.events ?? [];

          if (events.isEmpty) {
            return const Center(child: Text('لا توجد فعاليات'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (_, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EventCard(
                  event: event,
                  isRegistered: state.registeredEvents.contains(event.id),
                  isRegistering: state.isLoading,
                  onRegister: () {
                    context.read<HomeCubit>().registerCompetition(event.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
