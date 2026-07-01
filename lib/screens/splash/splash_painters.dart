import 'dart:math';
import 'package:flutter/material.dart';


class SplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width * 2; i += 80) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height * 0.6, size.height), linePaint);
    }

    final arcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.1),
        width: size.width * 1.4,
        height: size.width * 1.4,
      ),
      0, pi, false, arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}


class CornerOrnamentPainter extends CustomPainter {
  final Color color;
  const CornerOrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const len = 36.0;
    const pad = 22.0;
    const gap = 6.0;

    void corner(double cx, double cy, double dx, double dy) {
      canvas.drawLine(Offset(cx, cy + gap * dy), Offset(cx, cy + len * dy), p);
      canvas.drawLine(Offset(cx + gap * dx, cy), Offset(cx + len * dx, cy), p);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, cy), width: 4, height: 4),
        p..style = PaintingStyle.fill,
      );
      p.style = PaintingStyle.stroke;
    }

    corner(pad, pad, 1, 1);
    corner(size.width - pad, pad, -1, 1);
    corner(pad, size.height - pad, 1, -1);
    corner(size.width - pad, size.height - pad, -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
