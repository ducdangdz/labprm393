import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_2_real_api_login/main.dart';

void main() {
  testWidgets('App renders real api login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealApiLoginApp());
    expect(find.text('Lab 10.2: Real REST API Login'), findsOneWidget);
  });
}
