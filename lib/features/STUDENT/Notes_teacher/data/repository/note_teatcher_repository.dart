import 'package:schooly/core/constants/api_constants.dart';
import '../datasource/note_teacher_remote_data_source.dart';
import '../model/model.dart';

class NoteTeacherRepository {
  final NoteTeacherRemoteDataSource remote;

  NoteTeacherRepository(this.remote);

  String? _buildPhotoUrl(dynamic personalPhotoValue) {
    if (personalPhotoValue == null) return null;
    final filename = personalPhotoValue.toString();
    if (filename.startsWith('http')) return filename;
    return '${ApiConstants.baseUrl.replaceAll('/api', '/storage')}/$filename';
  }

  TeacherNoteModel _parseNote(Map<String, dynamic> item) {
    final teacher = item['teacher'] is Map
        ? Map<String, dynamic>.from(item['teacher'])
        : null;
    final employee = teacher != null && teacher['employee'] is Map
        ? Map<String, dynamic>.from(teacher['employee'])
        : null;
    final user = employee != null && employee['user'] is Map
        ? Map<String, dynamic>.from(employee['user'])
        : null;
    final person = user != null && user['person'] is Map
        ? Map<String, dynamic>.from(user['person'])
        : null;

    final photoUrl = _buildPhotoUrl(person?['personal_photo']);
    return TeacherNoteModel.fromJson(item, downloadedPhotoUrl: photoUrl);
  }

  Future<Map<String, List<TeacherNoteModel>>> fetchNotes(String token) async {
    final data = await remote.fetchNotes(token);

    print('📋 Repository raw keys: ${data.keys.toList()}');
    print('📋 positive_notes type: ${data['positive_notes'].runtimeType}');
    print('📋 positive_notes value: ${data['positive_notes']}');

    final List<TeacherNoteModel> positive = <TeacherNoteModel>[];
    final List<TeacherNoteModel> negative = <TeacherNoteModel>[];

    if (data['positive_notes'] is List) {
      for (final item in data['positive_notes']) {
        positive.add(_parseNote(Map<String, dynamic>.from(item)));
      }
    }

    if (data['negative_notes'] is List) {
      for (final item in data['negative_notes']) {
        negative.add(_parseNote(Map<String, dynamic>.from(item)));
      }
    }

    print('📋 Parsed positive: ${positive.length} | negative: ${negative.length}');

    return {'positive': positive, 'negative': negative};
  }
}
