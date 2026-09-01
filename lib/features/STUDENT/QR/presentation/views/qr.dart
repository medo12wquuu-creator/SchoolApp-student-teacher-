import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:schooly/features/STUDENT/QR/data/datasources/qr_remote_data_source.dart';
import 'package:schooly/features/STUDENT/QR/data/repositories/qr_reposiotry.dart';
import 'package:schooly/features/STUDENT/QR/presentation/views/widget/qr_body.dart';
import 'package:schooly/features/STUDENT/QR/presentation/views/widget/qr_header.dart';
import '../view_models/qr_cubit.dart';
import '../view_models/qr_state.dart';
import 'package:dio/dio.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final remote = QrRemoteDataSource(dio);
    final repository = QrRepository(remote);

    return BlocProvider(
      create: (_) => QrCubit(repository),
      child: Scaffold(
        appBar: AppBar(title: const Text("QR Scanner")),
        body: Column(
          children: [
            const QrHeader(),
            // الكاميرا تأخذ نصف الشاشة
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: BlocConsumer<QrCubit, QrState>(
                listener: (context, state) {
                  if (state is QrSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Result: ${state.result}")),
                    );
                  } else if (state is QrError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${state.message}")),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is QrLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return MobileScanner(
                    onDetect: (BarcodeCapture capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String? code = barcodes.first.rawValue;
                        if (code != null) {
                          context.read<QrCubit>().scan(code);
                        }
                      }
                    },
                  );
                },
              ),
            ),
            // النصف الثاني لعرض النتيجة أو أي محتوى إضافي
            Expanded(
              child: BlocBuilder<QrCubit, QrState>(
                builder: (context, state) {
                  if (state is QrSuccess) {
                    return QrBody(result: state.result);
                  } else if (state is QrError) {
                    return QrBody(result: "Error: ${state.message}");
                  } else {
                    return const QrBody(
                      result:
                          "ضع الكود داخل الكاميرا لإثبات حضورك عزيزي الطالب",
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
