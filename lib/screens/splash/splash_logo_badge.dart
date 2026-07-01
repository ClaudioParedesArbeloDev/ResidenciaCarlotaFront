import 'package:flutter/material.dart';

class SplashLogoBadge extends StatelessWidget {
  final double size;

  const SplashLogoBadge({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            blurRadius: 50,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: const Color(0xFF6A1B5D).withValues(alpha: 0.50),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.80),
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(size * 0.175),
      child: Image.asset(
        'assets/images/LogoCarlota.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
