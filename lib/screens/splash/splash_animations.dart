import 'package:flutter/material.dart';


class SplashAnimations {
  final AnimationController bgController;
  final AnimationController logoController;
  final AnimationController ruleController;
  final AnimationController titleController;
  final AnimationController taglineController;
  final AnimationController barController;
  final AnimationController exitController;

  late final Animation<double> bgOpacity;
  late final Animation<double> logoOpacity;
  late final Animation<double> logoScale;
  late final Animation<double> glowPulse;
  late final Animation<double> ruleWidth;
  late final Animation<double> titleOpacity;
  late final Animation<Offset>  titleSlide;
  late final Animation<double> taglineOpacity;
  late final Animation<double> barProgress;
  late final Animation<double> exitOpacity;

  SplashAnimations({required TickerProvider vsync})
      : bgController      = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 600)),
        logoController    = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 600)),
        ruleController    = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 500)),
        titleController   = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 500)),
        taglineController = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 400)),
        barController     = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 1200)),
        exitController    = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 400)) {
    _build();
  }

  void _build() {
    bgOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: bgController, curve: Curves.easeOut));

    logoOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: logoController,
            curve: const Interval(0, 0.7, curve: Curves.easeOut)));
    logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
        CurvedAnimation(parent: logoController, curve: Curves.easeOutCubic));
    glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: logoController, curve: Curves.easeOut));

    ruleWidth = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: ruleController, curve: Curves.easeOut));

    titleOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: titleController, curve: Curves.easeOut));
    titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: titleController, curve: Curves.easeOutCubic));

    taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: taglineController, curve: Curves.easeOut));

    barProgress = CurvedAnimation(parent: barController, curve: Curves.easeInOut);

    exitOpacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: exitController, curve: Curves.easeIn));
  }

  
  Future<void> runSequence() async {
    await Future.delayed(const Duration(milliseconds: 60));
    bgController.forward();

    await Future.delayed(const Duration(milliseconds: 150));
    logoController.forward();

    await Future.delayed(const Duration(milliseconds: 350));
    ruleController.forward();

    await Future.delayed(const Duration(milliseconds: 250));
    titleController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    barController.forward();

    await Future.delayed(const Duration(milliseconds: 1350));
  }

  Future<void> runExit() => exitController.forward();

  void dispose() {
    bgController.dispose();
    logoController.dispose();
    ruleController.dispose();
    titleController.dispose();
    taglineController.dispose();
    barController.dispose();
    exitController.dispose();
  }
}
