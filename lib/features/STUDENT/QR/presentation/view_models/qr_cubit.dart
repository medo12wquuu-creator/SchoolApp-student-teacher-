import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/QR/data/repositories/qr_reposiotry.dart';
import '../../data/models/qr_response.dart';
import 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  final QrRepository repository;
  QrCubit(this.repository) : super(QrInitial());

  Future<void> scan(String content) async {
    emit(QrLoading());
    try {
      QrResponse response = await repository.processQr(content);
      if (response.success) {
        emit(QrSuccess(response.message));
      } else {
        emit(QrError(response.message));
      }
    } catch (e) {
      emit(QrError(e.toString()));
    }
  }
}
