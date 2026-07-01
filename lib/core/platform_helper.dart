import 'package:flutter/foundation.dart';

enum AppPlatformType { mobile, desktop }

class PlatformHelper {
  static bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  static AppPlatformType get type =>
      isMobile ? AppPlatformType.mobile : AppPlatformType.desktop;
}
