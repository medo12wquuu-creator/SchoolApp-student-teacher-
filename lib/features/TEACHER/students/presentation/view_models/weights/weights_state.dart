part of 'weights_cubit.dart';

@immutable
abstract class WeightsState {}

final class WeightsInitial extends WeightsState {}

final class WeightsLoading extends WeightsState {}

final class WeightsSuccess extends WeightsState {
  final List<FetchWeightsModel> weights;
  WeightsSuccess({required this.weights});
}

final class WeightsFailure extends WeightsState {
  final String errMassage;
  WeightsFailure(this.errMassage);
}
