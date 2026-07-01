import 'package:flutter/material.dart';


class LoginGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginGoogleButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.30), width: 1),
          backgroundColor: Colors.white.withValues(alpha: 0.07),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  SizedBox(
                    width: 20, height: 20,
                    child: CustomPaint(painter: _GoogleIconPainter()),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continuar con Google',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0.3,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}


class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2;


    _drawArc(canvas, cx, cy, r, -0.2, 1.4, const Color(0xFFEA4335));

    _drawArc(canvas, cx, cy, r, 1.2, 1.2, const Color(0xFFFBBC05));

    _drawArc(canvas, cx, cy, r, 2.4, 1.2, const Color(0xFF34A853));

    _drawArc(canvas, cx, cy, r, 3.6, 1.2, const Color(0xFF4285F4));


    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.height * 0.28
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.85, cy),
      barPaint,
    );


    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.45,
      Paint()..color = Colors.white.withValues(alpha: 0.0),
    );
  }

  void _drawArc(Canvas canvas, double cx, double cy, double r,
      double startAngle, double sweepAngle, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = r * 0.30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}