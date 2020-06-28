import 'package:flutter/material.dart';

import 'package:basicAnime/pages/basic_animation_page.dart';

void main() => runApp(MyApp(loopAnimations: false));

class MyApp extends StatelessWidget {
  final bool loopAnimations;
  const MyApp({
    this.loopAnimations: false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Anime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationPage(loopAnimations: this.loopAnimations),
    );
  }
}
