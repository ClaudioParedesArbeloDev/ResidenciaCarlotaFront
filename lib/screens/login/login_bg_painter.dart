import 'package:flutter/material.dart';


class LoginBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width * 2; i += 70) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * 0.55, size.height),
        p,
      );
    }

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.75),
      size.width * 0.60,
      p..color = Colors.white.withValues(alpha: 0.025),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
