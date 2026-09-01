import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/AllTasks/data/datasource/tasks_remote_data_source.dart';
import 'package:schooly/features/STUDENT/AllTasks/data/repositories/tasks_repository.dart';
import 'package:schooly/features/STUDENT/AllTasks/presentation/view_models/tasks_cubit.dart';
import 'package:schooly/features/STUDENT/AllTasks/presentation/view_models/tasks_state.dart';
import 'package:schooly/features/STUDENT/AllTasks/presentation/widgets/task_card.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit(
        TasksRepository(TasksRemoteDataSource(Dio())),
        context.read<UserCubit>(),
      )..getTasks(),
      child: Scaffold(
        appBar: AppBar(title: const Text('All Tasks')),
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            if (state.isLoading && state.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.tasks.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.tasks.isEmpty) {
              return const Center(child: Text('لا توجد مهام'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (_, index) {
                final task = state.tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TaskCard(task: task),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
