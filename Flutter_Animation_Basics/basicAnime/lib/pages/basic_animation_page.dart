import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:basicAnime/animations/companion_cube_image.dart';

class AnimationPage extends StatefulWidget {
  final bool loopAnimations;

  const AnimationPage({
    this.loopAnimations: true,
  });

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOut,
    );

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(curvedAnimation)
      ..addStatusListener((status) {
        if ((widget.loopAnimations)) {
          if (status == AnimationStatus.completed) {
            animController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            animController.forward();
          }
        }
      });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatingTransition(
        angle: animation,
        child: CompanionCubeImage(),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
