abstract class QrState {}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrSuccess extends QrState {
  final String result;
  QrSuccess(this.result);
}

class QrError extends QrState {
  final String message;
  QrError(this.message);
}
