import 'package:eshiblood/src/app.dart';
import 'package:eshiblood/src/auth/screens/welcome_screen.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/auth/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget tests', () {
    testWidgets("Checking the entry screen", (WidgetTester tester) async {
      await tester.pumpWidget(App());
      var welcomeScreen = find.byType(WelcomeScreen);
      expect(welcomeScreen, findsOneWidget);
    });

    testWidgets("Checking the entry screen", (WidgetTester tester) async {
      await tester.pumpWidget(WelcomeScreen());
      var welcomeScreen = find.byType(RoundButton);
      expect(welcomeScreen, findsWidgets);
    });

    testWidgets("Checking the availability of custom RoundButton",
        (WidgetTester tester) async {
      await tester.pumpWidget(App());
      var roundButton = find.byType(RoundButton);
      expect(roundButton, findsWidgets);
    });

    testWidgets("Checking there is no use of Elevated button",
        (WidgetTester tester) async {
      await tester.pumpWidget(App());
      var elevatedButton = find.byType(ElevatedButton);
      expect(elevatedButton, findsNothing);
    });
    testWidgets("Checking there is no use of Text Input",
        (WidgetTester tester) async {
      await tester.pumpWidget(App());
      var elevatedButton = find.byType(TextInput);
      expect(elevatedButton, findsNothing);
    });
  });
}
