import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(NotificationApp(notificationService: notificationService));
}

/// Service managing Flutter Local Notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init({Function(String?)? onNotificationClicked}) async {
    if (_isInitialized) return;

    // Android initialization
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / macOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (onNotificationClicked != null) {
          onNotificationClicked(response.payload);
        }
      },
    );

    _isInitialized = true;
  }

  /// Request runtime notification permission on Android 13+ (API 33+)
  Future<bool> requestPermission() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted =
          await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Show standard instant notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lab10_channel_id',
      'Lab 10 Notifications',
      channelDescription: 'Kênh thông báo kiểm thử cho bài thực hành Lab 10',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }
}

class NotificationApp extends StatelessWidget {
  final NotificationService notificationService;

  const NotificationApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 - Local Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: NotificationHomeScreen(notificationService: notificationService),
    );
  }
}

class NotificationHomeScreen extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationHomeScreen({super.key, required this.notificationService});

  @override
  State<NotificationHomeScreen> createState() => _NotificationHomeScreenState();
}

class _NotificationHomeScreenState extends State<NotificationHomeScreen> {
  final List<String> _logs = [];
  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    // Register click listener
    widget.notificationService.init(
      onNotificationClicked: (payload) {
        _addLog('Người dùng nhấn vào thông báo với Payload: $payload');
        _showPayloadDialog(payload);
      },
    );
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await widget.notificationService.requestPermission();
    if (mounted) {
      setState(() => _permissionGranted = granted);
    }
  }

  void _addLog(String message) {
    if (mounted) {
      setState(() {
        final time = DateTime.now().toLocal().toString().split('.').first;
        _logs.insert(0, '[$time] $message');
      });
    }
  }

  void _showPayloadDialog(String? payload) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đã mở từ thông báo!'),
        content: Text('Dữ liệu đính kèm (Payload):\n${payload ?? "Không có"}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerInstantNotification() async {
    const id = 101;
    const title = '🔔 Thông báo tức thì (Lab 10.5)';
    const body = 'Xin chào! Hệ thống Local Notification đang hoạt động chính xác.';
    const payload = 'instant_notification_test';

    await widget.notificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );

    _addLog('Đã kích hoạt: $title');
  }

  Future<void> _triggerLoginSuccessNotification() async {
    const id = 102;
    const title = '🎉 Đăng nhập thành công (LO7 Action)';
    const body = 'Chào mừng bạn Emily Johnson (emilys) đã đăng nhập vào hệ thống!';
    const payload = 'user_login_success_emilys';

    await widget.notificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );

    _addLog('Đã kích hoạt thông báo sau hành động đăng nhập (LO7)');
  }

  Future<void> _triggerCustomNotification(String customTitle, String customBody) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await widget.notificationService.showNotification(
      id: id,
      title: customTitle,
      body: customBody,
      payload: 'custom_payload_$id',
    );

    _addLog('Đã kích hoạt thông báo tùy chỉnh ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5: Local Notification (LO7)'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _permissionGranted == true ? Icons.notifications_active : Icons.notifications_off,
                      size: 40,
                      color: _permissionGranted == true ? Colors.green : Colors.deepOrange,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quyền gửi thông báo (Notification Permission)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _permissionGranted == true
                                ? 'Đã được cấp phép (Android 13+ POST_NOTIFICATIONS)'
                                : 'Chưa được cấp phép hoặc đang chờ phê duyệt',
                            style: TextStyle(
                              color: _permissionGranted == true ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Xin lại quyền',
                      icon: const Icon(Icons.refresh),
                      onPressed: _checkPermission,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Thao tác kích hoạt thông báo (Triggers):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Button 1: Instant notification
            ElevatedButton.icon(
              onPressed: _triggerInstantNotification,
              icon: const Icon(Icons.bolt),
              label: const Text('Gửi thông báo tức thì (Instant Notification)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),

            // Button 2: Action notification (Required for LO7 integration)
            ElevatedButton.icon(
              onPressed: _triggerLoginSuccessNotification,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mô phỏng thông báo sau khi đăng nhập (LO7)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),

            // Button 3: Custom notification
            OutlinedButton.icon(
              onPressed: () {
                _triggerCustomNotification(
                  '📢 Thông báo cập nhật hệ thống',
                  'Dữ liệu hồ sơ của bạn đã được đồng bộ hóa thành công.',
                );
              },
              icon: const Icon(Icons.edit_notifications),
              label: const Text('Gửi thông báo tùy biến (Custom Payload)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),

            // Log Section
            const Text(
              'Nhật ký sự kiện (Notification Event Logs):',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _logs.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có sự kiện nào. Hãy nhấn các nút ở trên để gửi thông báo!',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
