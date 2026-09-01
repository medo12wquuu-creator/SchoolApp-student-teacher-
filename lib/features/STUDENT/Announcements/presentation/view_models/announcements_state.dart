import 'package:equatable/equatable.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementsState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<AnnouncementModel> announcements;

  const AnnouncementsState({
    this.isLoading = false,
    this.errorMessage,
    this.announcements = const [],
  });

  AnnouncementsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AnnouncementModel>? announcements,
  }) {
    return AnnouncementsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      announcements: announcements ?? this.announcements,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, announcements];
}
