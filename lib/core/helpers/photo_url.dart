/// تحويل مسار صورة من الباك إلى رابط كامل قابل للتحميل
///
/// - لو المسار رابط كامل (http/https) يُرجع كما هو
/// - لو مسار نسبي (مثل storage/personal_photos/x.jpg) يُضاف له الـ base URL
/// - يصلح الروابط المكررة التي قد يخزّنها السيرفر مثل:
///   http://domain/storage/http://domain/storage/user2_photo/x.jpg
/// - يوحّد البروتوكول على https لتجنب حجب cleartext على أندرويد
String buildPhotoUrl(String? photo) {
  if (photo == null || photo.trim().isEmpty) return '';
  var value = photo.trim();

  // 🔧 أخذ آخر رابط كامل داخل السلسلة (يتجاوز أي بادئة مكررة من السيرفر)
  final lastHttps = value.lastIndexOf('https://');
  final lastHttp = value.lastIndexOf('http://');
  final start = lastHttps > lastHttp ? lastHttps : lastHttp;
  if (start > 0) {
    value = value.substring(start);
  }

  // 🛡️ توحيد البروتوكول على https (ngrok يدعمه على نفس النطاق)
  if (value.startsWith('http://')) {
    value = 'https://${value.substring('http://'.length)}';
  }
  if (value.startsWith('https://')) {
    return value;
  }

  const base = 'https://diving-settle-careless.ngrok-free.dev';
  if (value.startsWith('/')) return '$base$value';
  return '$base/$value';
}

/// إضافة كاش-باستر للرابط لتجنب عرض الصورة القديمة المخزنة محلياً
String cacheBustedPhotoUrl(String? photo, DateTime? updatedAt) {
  final url = buildPhotoUrl(photo);
  if (url.isEmpty) return '';
  final buster = updatedAt?.millisecondsSinceEpoch;
  if (buster == null) return url;
  return url.contains('?') ? '$url&v=$buster' : '$url?v=$buster';
}