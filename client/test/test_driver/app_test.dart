import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('description', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null) {
        driver?.close();
      }
    });

    var logginButton = find.byType("RoundButton");

    test('description', () async {
      Future.delayed(Duration(seconds: 5));
      await driver!.tap(logginButton);
    });
  });
}
