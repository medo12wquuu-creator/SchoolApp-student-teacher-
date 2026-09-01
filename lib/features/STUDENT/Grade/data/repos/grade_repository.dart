import '../datasource/grade_remote_data_source.dart';
import '../models/grade_model.dart';

class GradeRepository {
  final GradeRemoteDataSource remote;

  GradeRepository(this.remote);

  Future<GradePageModel> getGrades(String token) async {
    final data = await remote.getGrade(token);
    return GradePageModel.fromJson(data);
  }
}
