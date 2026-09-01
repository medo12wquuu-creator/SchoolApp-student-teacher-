import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/announcements_repository.dart';
import 'announcements_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementsRepository repo;

  AnnouncementsCubit(this.repo) : super(const AnnouncementsState());

  Future<void> getAnnouncements(String token) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final data = await repo.getAnnouncements(token);
      if (isClosed) return; // ← أضف هذا
      emit(state.copyWith(isLoading: false, announcements: data));
    } catch (e) {
      if (isClosed) return; // ← أضف هذا
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
