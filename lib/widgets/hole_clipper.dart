import 'package:flutter/material.dart';
import 'dart:math';

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start from half the height at the left
    path.moveTo(0, size.height / 2);
    // Go to half the height at the right passing through the bottom center
    // using an arc
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );
    path.lineTo(0, -1000);

    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BlackHoleClipper oldClipper) => true;
}
