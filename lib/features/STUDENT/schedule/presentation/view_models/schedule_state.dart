import 'package:equatable/equatable.dart';
import '../../data/models/schedule_model.dart';

class ScheduleState extends Equatable {
  final bool scheduleLoading;
  final String? scheduleError;
  final List<ScheduleModel>? schedule;

  const ScheduleState({
    this.scheduleLoading = false,
    this.scheduleError,
    this.schedule,
  });

  ScheduleState copyWith({
    bool? scheduleLoading,
    String? scheduleError,
    List<ScheduleModel>? schedule,
  }) {
    return ScheduleState(
      scheduleLoading: scheduleLoading ?? this.scheduleLoading,
      scheduleError: scheduleError,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [scheduleLoading, scheduleError, schedule];
}
