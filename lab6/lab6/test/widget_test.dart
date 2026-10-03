import 'package:flutter_test/flutter_test.dart';
import 'package:lab6/main.dart';

void main() {
  testWidgets('Movie app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ResponsiveMovieApp(),
    );

    expect(
      find.text('Find a Movie'),
      findsOneWidget,
    );
  });
}