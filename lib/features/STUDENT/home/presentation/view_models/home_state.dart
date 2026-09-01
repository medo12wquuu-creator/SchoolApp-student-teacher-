// import 'package:equatable/equatable.dart';
// import '../../data/models/attendance_absences_model.dart';
// import '../../data/models/event_model.dart';
// import '../../data/models/task_model.dart';
// import '../../data/models/schedule_model.dart';

// class HomeState extends Equatable {
//   final bool isLoading;
//   final String? errorMessage;
//   final String? successMessage;

//   final bool attendanceLoading;
//   final String? attendanceError;
//   final bool tasksLoading;
//   final String? tasksError;
//   final bool scheduleLoading;
//   final String? scheduleError;
//   final bool eventsLoading;
//   final String? eventsError;

//   final AttendanceAbsencesModel? attendance;
//   final List<EventsModel>? events;
//   final List<TaskModel>? tasks;
//   final List<ScheduleModel>? schedule;

//   const HomeState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.successMessage,
//     this.attendanceLoading = false,
//     this.attendanceError,
//     this.tasksLoading = false,
//     this.tasksError,
//     this.scheduleLoading = false,
//     this.scheduleError,
//     this.eventsLoading = false,
//     this.eventsError,
//     this.attendance,
//     this.events,
//     this.tasks,
//     this.schedule,
//   });

//   HomeState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     String? successMessage,
//     bool? attendanceLoading,
//     String? attendanceError,
//     bool? tasksLoading,
//     String? tasksError,
//     bool? scheduleLoading,
//     String? scheduleError,
//     bool? eventsLoading,
//     String? eventsError,
//     AttendanceAbsencesModel? attendance,
//     List<EventsModel>? events,
//     List<TaskModel>? tasks,
//     List<ScheduleModel>? schedule,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//       attendanceLoading: attendanceLoading ?? this.attendanceLoading,
//       attendanceError: attendanceError,
//       tasksLoading: tasksLoading ?? this.tasksLoading,
//       tasksError: tasksError,
//       scheduleLoading: scheduleLoading ?? this.scheduleLoading,
//       scheduleError: scheduleError,
//       eventsLoading: eventsLoading ?? this.eventsLoading,
//       eventsError: eventsError,
//       attendance: attendance ?? this.attendance,
//       events: events ?? this.events,
//       tasks: tasks ?? this.tasks,
//       schedule: schedule ?? this.schedule,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     isLoading,
//     errorMessage,
//     successMessage,
//     attendanceLoading,
//     attendanceError,
//     tasksLoading,
//     tasksError,
//     scheduleLoading,
//     scheduleError,
//     eventsLoading,
//     eventsError,
//     attendance,
//     events,
//     tasks,
//     schedule,
//   ];
// }

import 'package:equatable/equatable.dart';
import '../../data/models/attendance_absences_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/schedule_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  final bool attendanceLoading;
  final String? attendanceError;
  final bool tasksLoading;
  final String? tasksError;
  final bool scheduleLoading;
  final String? scheduleError;
  final bool eventsLoading;
  final String? eventsError;

  final AttendanceAbsencesModel? attendance;
  final List<EventsModel>? events;
  final List<TaskModel>? tasks;
  final List<ScheduleModel>? schedule;

  // الأحداث التي سجّل الطالب عليها (محفوظة محلياً)
  final Set<int> registeredEvents;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.attendanceLoading = false,
    this.attendanceError,
    this.tasksLoading = false,
    this.tasksError,
    this.scheduleLoading = false,
    this.scheduleError,
    this.eventsLoading = false,
    this.eventsError,
    this.attendance,
    this.events,
    this.tasks,
    this.schedule,
    this.registeredEvents = const {},
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? attendanceLoading,
    String? attendanceError,
    bool? tasksLoading,
    String? tasksError,
    bool? scheduleLoading,
    String? scheduleError,
    bool? eventsLoading,
    String? eventsError,
    AttendanceAbsencesModel? attendance,
    List<EventsModel>? events,
    List<TaskModel>? tasks,
    List<ScheduleModel>? schedule,
    Set<int>? registeredEvents,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      attendanceLoading: attendanceLoading ?? this.attendanceLoading,
      attendanceError: attendanceError,
      tasksLoading: tasksLoading ?? this.tasksLoading,
      tasksError: tasksError,
      scheduleLoading: scheduleLoading ?? this.scheduleLoading,
      scheduleError: scheduleError,
      eventsLoading: eventsLoading ?? this.eventsLoading,
      eventsError: eventsError,
      attendance: attendance ?? this.attendance,
      events: events ?? this.events,
      tasks: tasks ?? this.tasks,
      schedule: schedule ?? this.schedule,
      registeredEvents: registeredEvents ?? this.registeredEvents,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    successMessage,
    attendanceLoading,
    attendanceError,
    tasksLoading,
    tasksError,
    scheduleLoading,
    scheduleError,
    eventsLoading,
    eventsError,
    attendance,
    events,
    tasks,
    schedule,
    registeredEvents,
  ];
}
