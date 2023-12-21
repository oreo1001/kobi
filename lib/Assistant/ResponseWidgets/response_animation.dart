import 'package:flutter/material.dart';

class SlideFromLeftAnimation extends StatelessWidget {
  final Widget child;
  final int durationSeconds;

  SlideFromLeftAnimation({required this.child, this.durationSeconds = 1});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(-100, 0), end: Offset(0, 0)),
      duration: Duration(seconds: durationSeconds),
      child: child,
      builder: (context, Offset value, Widget? child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
    );
  }
}
