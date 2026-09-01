import 'dart:async';
import 'dart:developer';
import 'package:pusher_client_socket/pusher_client_socket.dart';

class ChatSocketService {
  // ⚠️ يجب تعديل الـ Host عند تغيير نفق الـ WebSocket (يتغير بكل تشغيل للباك)
  static const String _host = "lead-sql-slim-trust.trycloudflare.com";
  static const String _appKey = "suph6ug028gzlw8wdwib";
  static const String _httpHost =
      "https://diving-settle-careless.ngrok-free.dev";

  /// مهلة قصوى للاتصال — إن لم يُفتح السوكت خلالها نُنشئ الاتصال ولا نعلق التطبيق
  static const Duration _connectTimeout = Duration(seconds: 10);

  PusherClient? _client;
  bool _clientConnected = false;
  bool _connecting = false;
  String? _currentToken;
  Timer? _connectWatchdog;

  final Set<int> _subscribedChannels = {};
  // 🆕 محادثة واحدة قد يكون لها أكثر من مستمع (شاشة المحادثات + شاشة الدردشة)
  final Map<int, List<ChatSubscription>> _listeners = {};
  final Map<int, List<ChatSubscription>> _pending = {};

  // 🏫 قناة المعلم (private-teacher.{user_id}) — أحداث الكويزات
  int? _teacherUserId;
  bool _teacherSubscribed = false;
  final List<TeacherChannelSubscription> _teacherListeners = [];
  final List<TeacherChannelSubscription> _teacherPending = [];

  bool get isConnected => _clientConnected;

  /// الاتصال بالـ Reverb عبر بروتوكول Pusher مع المصادقة على القنوات الخاصة
  /// لا يرفع أي استثناء أبداً حتى لو الباك مو شغال — يبقى التطبيق يعمل بشكل طبيعي
  void connect({required String token}) {
    if (_currentToken == token && (_clientConnected || _connecting)) return;

    _currentToken = token;

    if (_client != null && (_clientConnected || _connecting)) return;
    if (_connecting) return;

    _connecting = true;
    _connectWatchdog?.cancel();

    try {
      final options = PusherOptions(
        key: _appKey,
        host: _host,
        wsPort: 80,
        wssPort: 443,
        encrypted: true,
        enableLogging: true,
        autoConnect: false,
        // تقليل محاولات إعادة الاتصال حتى لا تبقى المحاولات خلفية طوال الوقت
        maxReconnectionAttempts: 3,
        reconnectGap: const Duration(seconds: 3),
        authOptions: PusherAuthOptions(
          '$_httpHost/broadcasting/auth',
          headers: () async {
            return {
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
              'Authorization': 'Bearer $_currentToken',
            };
          },
        ),
      );

      final client = PusherClient(options: options);

      client.onConnectionEstablished((data) {
        log('✅ تم الاتصال بالـ Reverb بنجاح (socketId=${client.socketId})');
        _cancelWatchdog();
        _clientConnected = true;
        _connecting = false;

        // تطبيق كل الاشتراكات المعلقة بعد نجاح الاتصال
        final pending = Map<int, List<ChatSubscription>>.from(_pending);
        _pending.clear();
        for (final entry in pending.entries) {
          final subs = entry.value;
          for (final sub in subs) {
            _subscribe(entry.key, sub);
          }
        }
        // تطبيق اشتراكات قناة المعلم المعلقة بعد نجاح الاتصال
        if (_teacherPending.isNotEmpty) {
          final pendingTeacher = List<TeacherChannelSubscription>.from(
            _teacherPending,
          );
          _teacherPending.clear();
          for (final sub in pendingTeacher) {
            _subscribeTeacher(sub);
          }
        }
      });

      client.onConnectionError((error) {
        log('❌ خطأ في اتصال الـ Reverb: $error');
        _cancelWatchdog();
        _clientConnected = false;
        _connecting = false;
        _subscribedChannels.clear();
        // المكتبة تعيد المحاولة تلقائياً
      });

      client.onError((error) {
        log('❌ خطأ في الـ Reverb: $error');
      });

      client.connect();
      _client = client;

      // ⏱️ إن لم يتصل السوكت خلال المهلة (الباك مو شغال/نفق ميت) نلغيه فوراً
      // حتى لا يعلق التطبيق ويبقى عاملاً بشكل طبيعي
      _connectWatchdog = Timer(_connectTimeout, () {
        if (_connecting && !_clientConnected) {
          log(
            '⏱️ لم يتصل الـ Reverb خلال $_connectTimeout — إلغاء محاولة الاتصال',
          );
          _cancelWatchdog();
          _connecting = false;
          try {
            client.disconnect();
          } catch (_) {}
        }
      });
    } catch (e) {
      log('❌ تعذر إنشاء عميل الـ Reverb: $e');
      _cancelWatchdog();
      _connecting = false;
    }
  }

  void _cancelWatchdog() {
    _connectWatchdog?.cancel();
    _connectWatchdog = null;
  }

  /// الاشتراك بقناة محادثة خاصة (يدعم عدة مستمعين للمحادثة الواحدة)
  void listenToConversation(
    int conversationId,
    Function(Map<String, dynamic>) onMessage, {
    Function(Map<String, dynamic>)? onRead,
  }) {
    final sub = ChatSubscription(onMessage, onRead);

    if (_clientConnected && _client != null && _client!.connected) {
      _subscribe(conversationId, sub);
      return;
    }

    (_pending[conversationId] ??= []).add(sub);
  }

  void _subscribe(int conversationId, ChatSubscription sub) {
    if (_client == null || !_client!.connected) {
      // الاتصال انقطع — نعيد تخزين الاستماع ليطبق بعد إعادة الاتصال
      (_pending[conversationId] ??= []).add(sub);
      return;
    }

    // لو القناة مشترك فيها مسبقاً، نضيف المستمع فقط دون إعادة الربط
    if (_subscribedChannels.contains(conversationId)) {
      (_listeners[conversationId] ??= []).add(sub);
      log(
        '🔁 محادثة $conversationId مشتركة مسبقاً (مستمعون: ${_listeners[conversationId]!.length})',
      );
      return;
    }

    // 🛡️ الاشتراك بالقناة داخل منطقة محمية — دالة subscribe() في المكتبة
    // fire-and-forget async بلا try/catch، فأي فشل auth/شبكة يرمي استثناءً
    // غير معالج قد يوقف التطبيق. نلتقطه هنا ونُعكس الاشتراك بأمان.
    try {
      runZonedGuarded(
        () {
          final channel = _client!.private(
            'conversation.$conversationId',
            subscribe: true,
          );

          channel.bind('message.sent', (data) {
            log('📩 رسالة جديدة في محادثة $conversationId: $data');
            final subs = List<ChatSubscription>.from(
              _listeners[conversationId] ?? const [],
            );
            for (final s in subs) {
              try {
                s.onMessage(data as Map<String, dynamic>);
              } catch (e) {
                log(
                  '⚠️ فشل معالجة message.sent في محادثة $conversationId: $e\n$data',
                );
              }
            }
          });

          channel.bind('messages.read', (data) {
            log('👁️ تمت قراءة محادثة $conversationId: $data');
            final subs = List<ChatSubscription>.from(
              _listeners[conversationId] ?? const [],
            );
            for (final s in subs) {
              try {
                s.onRead?.call(data as Map<String, dynamic>);
              } catch (e) {
                log(
                  '⚠️ فشل معالجة messages.read في محادثة $conversationId: $e\n$data',
                );
              }
            }
          });
        },
        (error, stack) {
          log(
            '🛡️ فشل الاشتراك بقناة conversation.$conversationId (شبكة/auth): $error',
          );
          // عكس الاشتراك حتى تُعاد المحاولة لاحقاً عند استقرار الاتصال
          _subscribedChannels.remove(conversationId);
        },
      );
    } catch (e) {
      log('⚠️ خطأ أثناء إنشاء الاشتراك في محادثة $conversationId: $e');
      _subscribedChannels.remove(conversationId);
      (_pending[conversationId] ??= []).add(sub);
      return;
    }

    _subscribedChannels.add(conversationId);
    (_listeners[conversationId] ??= []).add(sub);
    log(
      '🔔 تم الاشتراك بقناة private-conversation.$conversationId (مستمعون: ${_listeners[conversationId]!.length})',
    );
  }

  void stopListeningToConversation(int conversationId) {
    _pending.remove(conversationId);
    _listeners.remove(conversationId);
    if (_subscribedChannels.remove(conversationId)) {
      try {
        _client?.unsubscribe('conversation.$conversationId');
      } catch (_) {}
    }
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (_clientConnected && _client != null) {
      try {
        final conversationId = payload['conversation_id'] as int?;
        if (conversationId != null) {
          _client!
              .private('conversation.$conversationId')
              .trigger('client-message', payload);
        }
      } catch (e) {
        log('⚠️ تعذر الإرسال عبر الـ Socket: $e');
      }
    } else {
      log('⚠️ الـ Socket غير متصل، تعذر الإرسال!');
    }
  }

  // ─────────────────────────────────────────────────────
  // 🏫 قناة المعلم (private-teacher.{user_id}) — أحداث الكويزات
  // ─────────────────────────────────────────────────────

  /// الاشتراك بقناة المعلم الخاصة لاستقبال أحداث الكويزات (مثل exam.time_ended)
  /// يدعم عدة مستمعين (شاشة القائمة + شاشة التفاصيل معاً)
  TeacherChannelSubscription listenToTeacherChannel({
    required int userId,
    required Function(Map<String, dynamic>) onExamTimeEnded,
  }) {
    final sub = TeacherChannelSubscription(onExamTimeEnded);
    _teacherUserId = userId;

    if (_clientConnected && _client != null && _client!.connected) {
      _subscribeTeacher(sub);
      return sub;
    }
    _teacherPending.add(sub);
    return sub;
  }

  void _subscribeTeacher(TeacherChannelSubscription sub) {
    final userId = _teacherUserId;
    if (userId == null || _client == null || !_client!.connected) {
      _teacherPending.add(sub);
      return;
    }

    // القناة مشتركة مسبقاً — نضيف المستمع فقط دون إعادة الربط
    if (_teacherSubscribed) {
      _teacherListeners.add(sub);
      return;
    }

    // 🛡️ الاشتراك داخل منطقة محمية حتى لا يوقف فشل auth/الشبكة التطبيق
    try {
      runZonedGuarded(
        () {
          final channel = _client!.private('teacher.$userId', subscribe: true);
          channel.bind('exam.time_ended', (data) {
            log('⏰ حدث exam.time_ended في قناة teacher.$userId: $data');
            final listeners = List<TeacherChannelSubscription>.from(
              _teacherListeners,
            );
            for (final l in listeners) {
              try {
                l.onExamTimeEnded(data as Map<String, dynamic>);
              } catch (e) {
                log('⚠️ فشل معالجة exam.time_ended: $e\n$data');
              }
            }
          });
        },
        (error, stack) {
          log('🛡️ فشل الاشتراك بقناة teacher.$userId: $error');
          _teacherSubscribed = false;
        },
      );
    } catch (e) {
      log('⚠️ خطأ أثناء الاشتراك بقناة teacher.$userId: $e');
      _teacherSubscribed = false;
      _teacherPending.add(sub);
      return;
    }

    _teacherSubscribed = true;
    _teacherListeners.add(sub);
    log('🔔 تم الاشتراك بقناة private-teacher.$userId');
  }

  /// إلغاء اشتراك مستمع معيّن؛ عند عدم بقاء أي مستمع تُغلق القناة
  void unlistenToTeacherChannel(TeacherChannelSubscription sub) {
    _teacherListeners.remove(sub);
    _teacherPending.remove(sub);
    if (_teacherListeners.isEmpty && _teacherPending.isEmpty) {
      _teacherSubscribed = false;
      final userId = _teacherUserId;
      if (userId != null) {
        try {
          _client?.unsubscribe('teacher.$userId');
        } catch (_) {}
      }
    }
  }

  void unlistenToTeacherChannelAll() {
    _teacherListeners.clear();
    _teacherPending.clear();
    _teacherSubscribed = false;
    final userId = _teacherUserId;
    _teacherUserId = null;
    if (userId != null) {
      try {
        _client?.unsubscribe('teacher.$userId');
      } catch (_) {}
    }
  }

  void disconnect() {
    _cancelWatchdog();
    _pending.clear();
    _listeners.clear();
    _subscribedChannels.clear();
    _teacherListeners.clear();
    _teacherPending.clear();
    _teacherSubscribed = false;
    _teacherUserId = null;
    _clientConnected = false;
    _connecting = false;
    _currentToken = null;

    try {
      _client?.disconnect();
    } catch (_) {}
    _client = null;
    log('🔌 تم فصل اتصال الـ Reverb بنجاح');
  }
}

class ChatSubscription {
  final Function(Map<String, dynamic>) onMessage;
  final Function(Map<String, dynamic>)? onRead;

  ChatSubscription(this.onMessage, this.onRead);
}

/// اشتراك بقناة المعلم لاستقبال أحداث الكويزات
class TeacherChannelSubscription {
  final Function(Map<String, dynamic>) onExamTimeEnded;

  TeacherChannelSubscription(this.onExamTimeEnded);
}
