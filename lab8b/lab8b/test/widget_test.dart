import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b/main.dart';

void main() {
  testWidgets('Weather app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherCompanionApp());
    expect(find.text('Weather Companion'), findsOneWidget);
  });
}
