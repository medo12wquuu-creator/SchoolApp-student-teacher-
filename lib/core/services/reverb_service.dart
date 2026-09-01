
import 'package:pusher_client_socket/pusher_client_socket.dart';

class _PendingSubscription {
  final String channelName;
  final void Function(PrivateChannel channel) onSubscribed;

  _PendingSubscription(this.channelName, this.onSubscribed);
}

class ReverbService {
  PusherClient? _client;
  bool _clientConnected = false;
  bool _connecting = false;
  final Set<String> _subscribedChannels = {};
  final List<_PendingSubscription> _pending = [];

  final String appKey;
  final String wssHost;
  final String httpHost;
  final String token;

  ReverbService({
    required this.appKey,
    required this.wssHost,
    required this.httpHost,
    required this.token,
  });

  // ── الشات: نفس السلوك السابق تماماً ──────────────────
  void listenToConversation(
    int conversationId,
    Function(Map<String, dynamic>) onMessage, {
    Function(Map<String, dynamic>)? onRead,
  }) {
    _subscribeChannel('conversation.$conversationId', (channel) {
      channel.bind('message.sent', (data) {
        print("WS MESSAGE: $data");
        onMessage(data as Map<String, dynamic>);
      });

      channel.bind('messages.read', (data) {
        print("WS READ: $data");
        onRead?.call(data as Map<String, dynamic>);
      });
    });
  }

  // ── الكويزات: قناة student.$userId + الأحداث الأربعة ──
  void listenToExams({
    required int userId,
    required void Function(Map<String, dynamic>) onExamPublished,
    required void Function(Map<String, dynamic>) onExamClosed,
    required void Function(Map<String, dynamic>) onExamTimeEnded,
    required void Function(Map<String, dynamic>) onExamResultReady,
    required void Function(Map<String, dynamic>) onExamCompleted,
    required void Function(Map<String, dynamic>) onExamAvailable,
  }) {
    _subscribeChannel('student.$userId', (channel) {
      channel.bind('exam.published', (data) {
        print("WS EXAM PUBLISHED: $data");
        onExamPublished(data as Map<String, dynamic>);
      });

      channel.bind('exam.closed', (data) {
        print("WS EXAM CLOSED: $data");
        onExamClosed(data as Map<String, dynamic>);
      });

      channel.bind('exam.time_ended', (data) {
        print("WS EXAM TIME_ENDED: $data");
        onExamTimeEnded(data as Map<String, dynamic>);
      });

      channel.bind('exam.result_ready', (data) {
        print("WS EXAM RESULT_READY: $data");
        onExamResultReady(data as Map<String, dynamic>);
      });
      channel.bind('exam.completed', (data) {
        // ← جديد: حدث انتهاء وقت الطالب
        print("WS EXAM COMPLETED: $data");
        onExamCompleted(data as Map<String, dynamic>);
      });
      channel.bind('exam.available', (data) {
        // ← جديد: حدث انتهاء وقت الطالب
        print("WS EXAM AVAILABLE: $data");
        onExamAvailable(data as Map<String, dynamic>);
      });
    });
  }

  void _subscribeChannel(
    String channelName,
    void Function(PrivateChannel channel) onSubscribed,
  ) {
    if (_clientConnected && _client != null) {
      _subscribeNow(channelName, onSubscribed);
      return;
    }

    _pending.add(_PendingSubscription(channelName, onSubscribed));
    if (_connecting) return;
    _connecting = true;

    try {
      final wsUri = Uri.parse(wssHost);
      final isTls = wsUri.scheme == 'wss';

      final options = PusherOptions(
        key: appKey,
        host: wsUri.host,
        wsPort: 81,
        wssPort: wsUri.hasPort ? wsUri.port : 443,
        encrypted: isTls,
        enableLogging: true,
        authOptions: PusherAuthOptions(
          '$httpHost/broadcasting/auth',
          headers: () async => {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        autoConnect: false,
      );

      final client = PusherClient(options: options);

      client.onConnectionEstablished((data) {
        print("PUSHER CONNECTED: socketId=${client.socketId}");
        _clientConnected = true;
        _connecting = false;

        final toSubscribe = List<_PendingSubscription>.from(_pending);
        _pending.clear();
        for (final p in toSubscribe) {
          _subscribeNow(p.channelName, p.onSubscribed);
        }
      });

      client.onConnectionError((error) {
        print("PUSHER CONNECTION ERROR: $error");
        _clientConnected = false;
        _connecting = false;
        _subscribedChannels.clear();
        Future.delayed(const Duration(seconds: 3), () {
          if (!_clientConnected) client.connect();
        });
      });

      client.onError((error) {
        print("PUSHER ERROR: $error");
      });

      client.connect();
      _client = client;
    } catch (e) {
      print("PUSHER INIT ERROR: $e");
      _connecting = false;
    }
  }

  void _subscribeNow(
    String channelName,
    void Function(PrivateChannel channel) onSubscribed,
  ) {
    if (_subscribedChannels.contains(channelName)) return;

    final channel = _client!.private(channelName, subscribe: true);
    onSubscribed(channel);
    _subscribedChannels.add(channelName);
    print("SUBSCRIBED TO private-$channelName");
  }

  void disconnect() {
    try {
      _client?.disconnect();
    } catch (_) {}
    _clientConnected = false;
    _connecting = false;
    _subscribedChannels.clear();
    _pending.clear();
    _client = null;
  }
}
