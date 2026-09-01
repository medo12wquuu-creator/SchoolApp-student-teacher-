import '../datasource/schedule_remote_data_source.dart';
import '../models/schedule_model.dart';

class ScheduleRepository {
  final ScheduleRemoteDataSource remote;

  ScheduleRepository(this.remote);

  Future<List<ScheduleModel>> getSchedule(String token, int dayOfWeek) async {
    final result = await remote.getSchedule(token);
    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final list = result["schedule"] as List<dynamic>? ?? [];
      final filtered = list.where((item) {
        final json = item as Map<String, dynamic>;
        final itemDay = json["day_of_week"] as int?;
        return itemDay == dayOfWeek;
      }).toList();

      return filtered
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        "فشل في تحميل البرنامج الأسبوعي. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }
}
