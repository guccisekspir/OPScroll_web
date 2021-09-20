// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CircleAnimation extends StatelessWidget {
  final Animation<double> animationController;
  final Color animateColor;
  final double screenHeight;
  final double screenWidth;
  CircleAnimation(
      {Key? key,
      required this.animationController,
      required this.animateColor,
      required this.screenHeight,
      required this.screenWidth})
      : scaleAnimation = Tween<double>(
          begin: 0,
          end: 2.2,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.0,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> scaleAnimation;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: animateColor,
              blurRadius: 16,
              spreadRadius: 8,
              offset: const Offset(0, 10),
            ),
          ],
          color: animateColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController, builder: _buildAnimation);
  }
}
