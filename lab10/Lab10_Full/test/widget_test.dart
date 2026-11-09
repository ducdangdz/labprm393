import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_full/main.dart';

void main() {
  testWidgets('App renders splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab10FullApp());
    expect(find.text('Lab 10 – Full Application'), findsOneWidget);
  });
}
