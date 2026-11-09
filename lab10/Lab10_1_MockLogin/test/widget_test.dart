import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_1_mock_login/main.dart';

void main() {
  testWidgets('App renders login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MockLoginApp());
    expect(find.text('Lab 10.1: Mock Login'), findsOneWidget);
  });
}
