import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoginLeftPanel extends StatelessWidget {
  const LoginLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 25,
                    spreadRadius: 4),
              ],
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15), width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: Lottie.asset('assets/animations/doctor.json',
                fit: BoxFit.contain),
          ),

          const Spacer(),

          const Text(
            'Gestión\nIntegral',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w200,
              color: Colors.white,
              letterSpacing: 2,
              height: 1.12,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 50, height: 1.5,
            color: Colors.white.withValues(alpha: 0.40),
          ),

          const SizedBox(height: 22),

          Text(
            'Residencia Carlota centraliza el cuidado,\n'
            'el bienestar y la gestión de la residencia\n'
            'en un solo lugar.',
            style: TextStyle(
              fontSize: 14,
              height: 1.75,
              color: Colors.white.withValues(alpha: 0.55),
              letterSpacing: 0.2,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
