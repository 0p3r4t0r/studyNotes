import 'package:flutter/material.dart';

import 'package:basicAnime/pages/basic_animation_page.dart';

void main() => runApp(MyApp(loopAnimations: false));

class MyApp extends StatelessWidget {
  final bool canSpeak;
  final bool loopAnimations;

  const MyApp({
    this.canSpeak: true,
    this.loopAnimations: false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Anime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationPage(
        canSpeak: this.canSpeak,
        loopAnimations: this.loopAnimations,
      ),
    );
  }
}
