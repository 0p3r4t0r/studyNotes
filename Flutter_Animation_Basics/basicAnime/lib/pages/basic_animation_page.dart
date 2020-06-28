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
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();

    _isButtonDisabled = false;
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
        if (status == AnimationStatus.completed) {
          animController.reverse();
        } else if (widget.loopAnimations &&
            status == AnimationStatus.dismissed) {
          animController.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text('Companion Cube'),
      ),
      body: Column(
        children: [
          Container(
            child: RotatingTransition(
              angle: animation,
              child: CompanionCubeImage(),
            ),
            height: MediaQuery.of(context).size.height * (3 / 5),
          ),
          Container(
            child: Center(
              child: _buildButton(),
            ),
            height: MediaQuery.of(context).size.height * (1 / 7),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildButton() {
    animation
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _isButtonDisabled = false;
          });
        }
      });

    _onPressed() {
      animController.forward();
      setState(() {
        _isButtonDisabled = true;
      });
    }

    return RaisedButton(
      child: Text('Encourage Me'),
      onPressed: _isButtonDisabled ? null : () => _onPressed(),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
