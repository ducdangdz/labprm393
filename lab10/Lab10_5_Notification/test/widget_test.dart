import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  testWidgets('App renders notification screen test', (WidgetTester tester) async {
    final service = NotificationService();
    await tester.pumpWidget(NotificationApp(notificationService: service));
    expect(find.text('Lab 10.5: Local Notification (LO7)'), findsOneWidget);
  });
}
