import 'package:flutter/material.dart';

class NowPlayingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 16.0;
    final path = Path()
      ..moveTo(size.width / 2, 0) // start at top middle
      ..lineTo(size.width - radius, 0) // stop at top right curve start
      ..arcToPoint(Offset(size.width, radius),
          radius: const Radius.circular(radius)) // arc to top right curve end
      ..lineTo(size.width,
          size.height - 5 * radius) // line to bottom right 1st curve start
      ..arcToPoint(
        Offset(size.width - radius, size.height - 4 * radius),
        radius: const Radius.circular(radius),
      ) // arc to draw 1st curve on bottom right
      ..arcToPoint(
        Offset(size.width - 4 * radius, size.height - radius),
        radius: const Radius.circular(2.8 * radius),
        clockwise: false,
      ) // arc to draw the 2nd curve on bottom right anti-clockwise
      ..arcToPoint(
        Offset(size.width - 5 * radius, size.height),
        radius: const Radius.circular(radius),
      ) // arc to draw the 3rd curve on bottom right
      ..lineTo(radius, size.height) // line to arc start of bottom left
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      ) // arc to line to start to top left
      ..lineTo(0, 3 * radius) // line to top left arc start
      ..arcToPoint(const Offset(radius, 2 * radius),
          radius: const Radius.circular(radius)) //arc to top left gap start
      ..lineTo(size.width / 2 - 2 * radius, 2 * radius) // line to center curves
      ..arcToPoint(Offset(size.width / 2 - radius, radius),
          radius: const Radius.circular(radius),
          clockwise: false) // arc to 1st center curve
      ..arcToPoint(Offset(size.width / 2, 0),
          radius: const Radius.circular(
              radius)) // arc to 2nd center curve connecting and finishing
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
