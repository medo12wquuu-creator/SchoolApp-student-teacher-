import '../datasource/tasks_remote_data_source.dart';
import '../models/task_model.dart';

class TasksRepository {
  final TasksRemoteDataSource remote;

  TasksRepository(this.remote);

  Future<List<TaskModel>> getTasks(String token) async {
    final result = await remote.getTasks(token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final List<dynamic> list = result["tasks"] ?? [];
      return list.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "فشل في حميل المهام . تأكد من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }
}
