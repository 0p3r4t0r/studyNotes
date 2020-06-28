import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:basicAnime/main.dart' show MyApp;
import 'package:basicAnime/pages/basic_animation_page.dart';
import 'package:basicAnime/animations/companion_cube_image.dart';

void main() {
  String goldensDir = 'animation_goldens';
  int animLengthInSeconds = 5;
  group('Asset files:', () {
    test('loads/parses phrases', () async {
      String data = await rootBundle.loadString('assets/phrases/phrases.json');
      final phraseMap = jsonDecode(data);
      expect(phraseMap.values.toList(), isA<List>());
    });

    testWidgets('loads image file', (WidgetTester tester) async {
      final Image image = Image.asset('assets/images/companion_cube.png');
      await tester.pumpWidget(image);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('App:', () {
    testWidgets('widget can settle when animations are finite',
        (WidgetTester tester) async {
      // ... well a widget with finite animations lasting less than 10 minutes.
      // https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html
      await tester.pumpWidget(MyApp());
      await tester.tap(findEncourageButton());
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('Everything loads', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(MyApp), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(AnimationPage), findsOneWidget);
      expect(find.byType(CompanionCubeImage), findsOneWidget);
    });

    testWidgets('Appbar title text', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.text('Companion Cube'), findsOneWidget);
    });

    testWidgets('User input button', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(RaisedButton), findsOneWidget);
    });
  });

  group('user input', () {
    testWidgets('tapping the button starts animation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.tap(findEncourageButton());
      expect(tester.hasRunningAnimations, isTrue);
    });
  });

  group('Golden tests:', () {
    testWidgets('forward animation', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createGoldenTestWidget());
        await preloadImage(tester);
      });
      await tester.tap(findEncourageButton());
      int numCheckFrames = 5;
      double checkTimeStepInSeconds = (animLengthInSeconds / numCheckFrames);
      int checkTimeStepInMilliseconds = (checkTimeStepInSeconds * 1000).round();
      for (int i = 0; i < numCheckFrames; i++) {
        await tester.pump(Duration(milliseconds: checkTimeStepInMilliseconds));
        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile(
              '$goldensDir/milliseconds_${checkTimeStepInMilliseconds * i}.png'),
        );
      }
    });

    testWidgets('multiple animations on multiple button presses',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createGoldenTestWidget());
        await preloadImage(tester);
      });

      int numLoops = 2;
      for (int i = 0; i < numLoops; i++) {
        await expectLater(
          find.byType(MyApp),
          matchesGoldenFile('$goldensDir/seconds_0.png'),
        );
        await tester.tap(findEncourageButton());
        await tester.pumpAndSettle();
      }
    });
  });

  group('Supposed to fail:', () {
    testWidgets('Widget with looping animations makes pumpAndSettle timeout',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(loopAnimations: true));
      await tester.tap(findEncourageButton());
      await tester.pumpAndSettle();
    }, skip: true);
  });
}

// Ensure that image sizes will match.
// Disable flutter_tts (speach) for golden tests.
Widget createGoldenTestWidget() {
  return Center(
    child: RepaintBoundary(
      child: MyApp(canSpeak: false),
    ),
  );
}

// Preload companion cube image
Future<void> preloadImage(WidgetTester tester) async {
  Element imageElement = tester.element(find.byType(Image));
  Image image = find.byType(Image).evaluate().first.widget;
  await precacheImage(
    image.image,
    imageElement,
  );
  await tester.pump();
}

Finder findEncourageButton() {
  Finder encourageButtonFinder = find.byWidgetPredicate((widget) {
    if (widget is RaisedButton && widget.child is Text) {
      Text text = widget.child;
      if (text.data == 'Encourage Me') {
        return true;
      }
    }
    return false;
  });
  return encourageButtonFinder;
}
