import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

class TasksState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<TaskModel> tasks;

  const TasksState({
    this.isLoading = false,
    this.errorMessage,
    this.tasks = const [],
  });

  TasksState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<TaskModel>? tasks,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, tasks];
}
