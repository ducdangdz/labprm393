import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_3_auto_login_logout/main.dart';

void main() {
  testWidgets('App renders splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoLoginApp());
    expect(find.text('Lab 10.3: Auto Login & Logout'), findsOneWidget);
  });
}
