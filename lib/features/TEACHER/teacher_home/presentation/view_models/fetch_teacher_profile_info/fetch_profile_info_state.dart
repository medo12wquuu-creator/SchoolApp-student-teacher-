part of 'fetch_profile_info_cubit.dart';

sealed class FetchProfileInfoState {}

final class FetchProfileInfoInitial extends FetchProfileInfoState {}

final class FetchProfileInfoLoading extends FetchProfileInfoState {}

final class FetchProfileInfoSuccess extends FetchProfileInfoState {
  final FetchTeacherProfileModel profile;
  FetchProfileInfoSuccess({required this.profile});
}

final class FetchProfileInfoFailure extends FetchProfileInfoState {
  final String errMassage;
  FetchProfileInfoFailure(this.errMassage);
}
