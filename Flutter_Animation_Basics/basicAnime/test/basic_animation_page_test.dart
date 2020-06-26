import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basicAnime/main.dart' show MyApp;
import 'package:basicAnime/pages/basic_animation_page.dart';
import 'package:basicAnime/animations/companion_cube_image.dart';

void main() {
  group('Asset files:', () {
    testWidgets('image file loads from assets', (WidgetTester tester) async {
      final Image image = Image.asset('assets/images/companion_cube.png');
      await tester.pumpWidget(image);
    });
  });

  group('App:', () {
    testWidgets('widget can settle when animations are finite',
        (WidgetTester tester) async {
      // ... well a widget with finite animations lasting less than 10 minutes.
      // https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html
      await tester.pumpWidget(MyApp(loopAnimations: false));
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('everything loads correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(MyApp), findsOneWidget);
      expect(find.byType(AnimationPage), findsOneWidget);
      expect(find.byType(CompanionCubeImage), findsOneWidget);
      expect(tester.hasRunningAnimations, isTrue);
    });
  });

  group('Golden tests -->', () {
    testWidgets('initial', (WidgetTester tester) async {
      // No longer works
      await tester.pumpWidget(MyApp(loopAnimations: false));
      await expectLater(find.byType(MyApp), matchesGoldenFile('main.png'));
    });
  });

  group('Supposed to fail -->', () {
    testWidgets('Widget with looping animations makes pumpAndSettle timeout',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(loopAnimations: true));
      await tester.pumpAndSettle();
    }, skip: true);
  });
}
