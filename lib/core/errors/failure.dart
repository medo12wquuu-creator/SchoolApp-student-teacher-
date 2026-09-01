import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// الخطأ الموحّد: رسالة واضحة للمستخدم + تفاصيل تقنية للـ debug
abstract class Failure {
  final String errMassage;
  final String? debugDetails;

  const Failure(this.errMassage, {this.debugDetails});
}

class ServerFailure extends Failure {
  ServerFailure(super.errMassage, {super.debugDetails});

  /// طباعة تفاصيل الخطأ في الـ debug بصيغة منظمة
  static void _log(String userMessage, String details) {
    debugPrint('🔴 [API Failure] $userMessage');
    debugPrint('   $details');
  }

  factory ServerFailure.fromDioError(DioException dioException) {
    final details = _buildDebugDetails(dioException);
    final message = _userMessage(dioException);
    _log(message, details);
    return ServerFailure(message, debugDetails: details);
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    final serverMsg = _extractServerMessage(response);
    if (serverMsg.isNotEmpty) {
      return ServerFailure(
        serverMsg,
        debugDetails: 'Status: $statusCode\nResponse: $response',
      );
    }
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return ServerFailure(
          'الطلب مرفوض أو غير مصرح به',
          debugDetails: 'Status: $statusCode\nResponse: $response',
        );
      case 404:
        return ServerFailure(
          'العنصر المطلوب غير موجود',
          debugDetails: 'Status: $statusCode\nResponse: $response',
        );
      case 422:
        return ServerFailure(
          'البيانات المدخلة غير صحيحة، راجع الحقول',
          debugDetails: 'Status: $statusCode\nResponse: $response',
        );
      case 500:
        return ServerFailure(
          'خطأ في الخادم، حاول لاحقاً',
          debugDetails: 'Status: $statusCode\nResponse: $response',
        );
      default:
        return ServerFailure(
          'حدث خطأ، حاول مجدداً',
          debugDetails: 'Status: $statusCode\nResponse: $response',
        );
    }
  }

  /// استخراج رسالة الخطأ الفعلية المرسلة من الباك (أنماط Laravel الشائعة)
  static String _extractServerMessage(dynamic response) {
    if (response is! Map) return '';
    // أخطاء التحقق (422): نفضّل رسائل الحقول المحددة
    final errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final parts = <String>[];
      errors.forEach((field, value) {
        if (value is List && value.isNotEmpty) {
          parts.add('${value.first}');
        } else if (value is String && value.trim().isNotEmpty) {
          parts.add(value.trim());
        }
      });
      if (parts.isNotEmpty) return parts.take(3).join('\n');
    }
    // message المباشر (الأكثر شيوعاً في Laravel)
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    // error كنص أو ككائن
    final error = response['error'];
    if (error is String && error.trim().isNotEmpty) {
      return error.trim();
    }
    if (error is Map && error['message'] is String) {
      final nested = error['message'] as String;
      if (nested.trim().isNotEmpty) return nested.trim();
    }
    return '';
  }

  /// رسالة واضحة للمستخدم حسب نوع الخطأ
  static String _userMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم، حاول مجدداً';

      case DioExceptionType.badCertificate:
        return 'تعذر تأمين الاتصال بالخادم';

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        ).errMassage;

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
        case DioExceptionType.unknown:
        if (e.message?.contains('SocketException') ?? false) {
          return 'لا يوجد اتصال بالإنترنت';
        }
        return 'حدث خطأ غير متوقع، حاول مجدداً';
    }
  }

  /// تفاصيل تقنية كاملة (للـ debug فقط)
  static String _buildDebugDetails(DioException e) {
    final request = e.requestOptions;
    final details = StringBuffer()
      ..writeln('Type: ${e.type}')
      ..writeln('Method: ${request.method}')
      ..writeln('URL: ${request.uri}')
      ..writeln('Status: ${e.response?.statusCode}');
    final data = e.response?.data;
    if (data != null) {
      details
        ..writeln('Response:')
        ..writeln('$data');
    }
    return details.toString().trim();
  }
}