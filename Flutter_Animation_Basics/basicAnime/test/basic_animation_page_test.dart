import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basicAnime/main.dart' show MyApp;
import 'package:basicAnime/pages/basic_animation_page.dart';
import 'package:basicAnime/animations/companion_cube_image.dart';

void main() {
  String goldensDir = 'animation_goldens';
  int animLengthInSeconds = 5;
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
      await tapEncourageButton(tester);
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

    testWidgets('User input buttons', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(RaisedButton), findsOneWidget);
    });
  });

  group('user input', () {
    testWidgets('tapping the button starts animation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tapEncourageButton(tester);
      expect(tester.hasRunningAnimations, isTrue);
    });
  });

  group('Golden tests:', () {
    testWidgets('forward animation', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createGoldenTestWidget());
        await preloadImage(tester);
      });
      await tapEncourageButton(tester);

      int numCheckFrames = 5;
      double checkTimeStepInSeconds = (animLengthInSeconds / numCheckFrames);
      int checkTimeStepInMilliseconds = (checkTimeStepInSeconds * 1000).round();
      for (int i = 0; i < numCheckFrames; i++) {
        await tester.pump(Duration(milliseconds: checkTimeStepInMilliseconds));
        await expectLater(
            find.byType(MyApp),
            matchesGoldenFile(
                '$goldensDir/milliseconds_${checkTimeStepInMilliseconds * i}.png'));
      }
    });

    testWidgets('animation loops', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createGoldenTestWidget());
        await preloadImage(tester);
      });
      await tapEncourageButton(tester);

      await expectLater(
          find.byType(MyApp), matchesGoldenFile('$goldensDir/seconds_0.png'));

      int numLoops = 2;
      for (int i = 0; i < numLoops; i++) {
        await tester.pump(Duration(seconds: animLengthInSeconds));
        await expectLater(
            find.byType(MyApp), matchesGoldenFile('$goldensDir/0_seconds.png'));
      }
    });
  });

  group('Supposed to fail:', () {
    testWidgets('Widget with looping animations makes pumpAndSettle timeout',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tapEncourageButton(tester);
      await tester.pumpAndSettle();
    }, skip: true);
  });
}

// Ensure that image sizes will match.
Widget createGoldenTestWidget() {
  return Center(
    child: RepaintBoundary(
      child: MyApp(),
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

Future<void> tapEncourageButton(WidgetTester tester) async {
  Finder encourageButtonFinder = find.byWidgetPredicate((widget) {
    if (widget is RaisedButton && widget.child is Text) {
      Text text = widget.child;
      if (text.data == 'Encourage Me') {
        return true;
      }
    }
    return false;
  });
  await tester.tap(encourageButtonFinder);
}
