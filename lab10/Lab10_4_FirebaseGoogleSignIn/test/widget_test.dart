import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_4_firebase_google_sign_in/main.dart';

void main() {
  testWidgets('App renders google sign in screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const FirebaseGoogleSignInApp());
    expect(find.text('Lab 10.4: Firebase Google Sign-In'), findsOneWidget);
  });
}
