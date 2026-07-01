import 'package:flutter/material.dart';
import 'package:app_geriatrico/screens/splash/splash_animations.dart';
import 'package:app_geriatrico/screens/splash/splash_logo_badge.dart';
import 'package:app_geriatrico/screens/splash/splash_painters.dart';
import 'package:app_geriatrico/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashAnimations _anim;

  @override
  void initState() {
    super.initState();
    _anim = SplashAnimations(vsync: this);
    _runSequence();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _runSequence() async {
    await _anim.runSequence();
    if (!mounted) return;
    await _anim.runExit();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size    = MediaQuery.of(context).size;
    final isSmall = size.height < 680;

    return AnimatedBuilder(
      animation: _anim.exitOpacity,
      builder: (context, child) =>
          Opacity(opacity: _anim.exitOpacity.value, child: child),
      child: Scaffold(
        body: Stack(
          children: [
            _Background(bgOpacity: _anim.bgOpacity, size: size),
            _GlowCircle(glowPulse: _anim.glowPulse),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isSmall ? 8 : 16),
                          child: _ContentColumn(
                            anim: _anim,
                            isSmall: isSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _Footer(taglineOpacity: _anim.taglineOpacity),
                  _ProgressBar(barProgress: _anim.barProgress),
                ],
              ),
            ),
            FadeTransition(
              opacity: _anim.bgOpacity,
              child: CustomPaint(
                size: size,
                painter: CornerOrnamentPainter(
                    color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Background extends StatelessWidget {
  final Animation<double> bgOpacity;
  final Size size;

  const _Background({required this.bgOpacity, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: bgOpacity,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.4,
                colors: [
                  Color(0xFF7B2268),
                  Color(0xFF6A1B5D),
                  Color(0xFF3A0B32),
                  Color(0xFF1E0619),
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: bgOpacity,
          child: CustomPaint(
            size: size,
            painter: SplashPatternPainter(),
          ),
        ),
      ],
    );
  }
}


class _GlowCircle extends StatelessWidget {
  final Animation<double> glowPulse;
  const _GlowCircle({required this.glowPulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowPulse,
      builder: (context, child) => Center(
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.07 * glowPulse.value),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _ContentColumn extends StatelessWidget {
  final SplashAnimations anim;
  final bool isSmall;

  const _ContentColumn({required this.anim, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        AnimatedBuilder(
          animation: anim.logoController,
          builder: (context, child) => Opacity(
            opacity: anim.logoOpacity.value,
            child: Transform.scale(scale: anim.logoScale.value, child: child),
          ),
          child: SplashLogoBadge(size: isSmall ? 120 : 160),
        ),

        SizedBox(height: isSmall ? 20 : 32),

        // Línea decorativa larga
        AnimatedBuilder(
          animation: anim.ruleWidth,
          builder: (context, child) => Container(
            width: 200 * anim.ruleWidth.value,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.35),
                  Colors.white.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: isSmall ? 14 : 22),

        // Subtítulo superior
        FadeTransition(
          opacity: anim.taglineOpacity,
          child: Text(
            'RESIDENCIA PARA ADULTOS MAYORES',
            style: TextStyle(
              fontSize: isSmall ? 8 : 9,
              letterSpacing: 3.5,
              color: Colors.white.withValues(alpha: 0.55),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        SizedBox(height: isSmall ? 8 : 12),

        SlideTransition(
          position: anim.titleSlide,
          child: FadeTransition(
            opacity: anim.titleOpacity,
            child: Text(
              'Carlota',
              style: TextStyle(
                fontSize: isSmall ? 44 : 56,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: 8,
                height: 1,
              ),
            ),
          ),
        ),

        SizedBox(height: isSmall ? 10 : 16),

        AnimatedBuilder(
          animation: anim.ruleWidth,
          builder: (context, child) => Container(
            width: 64 * anim.ruleWidth.value,
            height: 1.5,
            color: Colors.white.withValues(alpha: 0.40),
          ),
        ),

        SizedBox(height: isSmall ? 12 : 18),

  
        FadeTransition(
          opacity: anim.taglineOpacity,
          child: Text(
            'Cuidado · Respeto · Bienestar',
            style: TextStyle(
              fontSize: isSmall ? 10 : 12,
              letterSpacing: 2.2,
              color: Colors.white.withValues(alpha: 0.50),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}


class _Footer extends StatelessWidget {
  final Animation<double> taglineOpacity;
  const _Footer({required this.taglineOpacity});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: taglineOpacity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15), width: 1),
              ),
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            Text(
              'CODE & LENS SOLUTIONS',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2.8,
                color: Colors.white.withValues(alpha: 0.60),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ProgressBar extends StatelessWidget {
  final Animation<double> barProgress;
  const _ProgressBar({required this.barProgress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: barProgress,
      builder: (context, child) => LinearProgressIndicator(
        value: barProgress.value,
        minHeight: 2,
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        valueColor:
            AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.45)),
      ),
    );
  }
}
