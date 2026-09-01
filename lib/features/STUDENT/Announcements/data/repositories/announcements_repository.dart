import '../datasource/announcements_remote_data_source.dart';
import '../models/announcement_model.dart';

class AnnouncementsRepository {
  final AnnouncementsRemoteDataSource remote;

  AnnouncementsRepository(this.remote);

  Future<List<AnnouncementModel>> getAnnouncements(String token) async {
    final data = await remote.getAnnouncements(token);
    return data.map((e) => AnnouncementModel.fromJson(e)).toList();
  }
}
