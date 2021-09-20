// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DropAnimationWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Color animateColor;
  DropAnimationWidget(
      {Key? key,
      required this.animateColor,
      required this.controller,
      required this.screenHeight,
      required this.screenWidth})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        height = Tween<double>(
          begin: 0,
          end: screenHeight,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              1.0,
              curve: Curves.slowMiddle,
            ),
          ),
        ),
        borderRadius = Tween<double>(
          begin: 700,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              1.0,
              curve: Curves.slowMiddle,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> height;
  final Animation<double?> borderRadius;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: 1,
        child: Container(
          width: screenWidth,
          height: height.value,
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
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius.value!),
                topLeft: Radius.circular(borderRadius.value!)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
