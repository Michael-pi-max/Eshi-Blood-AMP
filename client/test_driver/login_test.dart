import 'package:eshiblood/src/auth/screens/login_screen.dart';
import 'package:eshiblood/src/user/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "valid auth doctor",
    (WidgetTester tester) async {
      await tester.pumpWidget(LoginScreen());

      final inputPhoneNumber = "0909090909";
      final inputPassword = "testPassword";

      await tester.enterText(find.byKey(Key("phoneNumber")), inputPhoneNumber);
      await tester.enterText(find.byKey(Key("Password")), inputPassword);

      await tester.tap(find.byKey(Key("LoginBtn")));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );
}
