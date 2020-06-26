import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basicAnime/main.dart' show MyApp;

void main() {
  testWidgets('image file loads from assets', (WidgetTester tester) async {
    final Image image = Image.asset('assets/images/companion_cube.png');
    await tester.pumpWidget(image);
  });

  testWidgets('Widget with finite animations can pumpAndSettle',
      (WidgetTester tester) async {
    // ... well a widget with finite animations lasting less than 10 minutes.
    // https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html
    await tester.pumpWidget(MyApp(loopAnimations: false));
    await tester.pumpAndSettle();
  });

  group('these tests are supposed to fail', () {
    testWidgets('Widget with looping animations makes pumpAndSettle timeout',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(loopAnimations: true));
      await tester.pumpAndSettle();
    });
  });
}
