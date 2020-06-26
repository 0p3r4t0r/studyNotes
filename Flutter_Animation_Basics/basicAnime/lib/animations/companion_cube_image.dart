import 'package:flutter/material.dart';

class RotatingTransition extends StatelessWidget {
  final Animation<double> angle;
  final Widget child;

  RotatingTransition({
    @required this.angle,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      builder: (context, child) {
        return Transform.rotate(
          angle: angle.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class CompanionCubeImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/companion_cube.png',
      ),
      padding: EdgeInsets.all(30),
    );
  }
}
