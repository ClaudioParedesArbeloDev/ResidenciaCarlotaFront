import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/platform_helper.dart';
import 'package:app_geriatrico/services/deep_link_service.dart';
import 'package:app_geriatrico/services/google_auth_service.dart';
import 'package:app_geriatrico/screens/splash/splash_screen.dart';
import 'package:app_geriatrico/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformHelper.isMobile) {
    await GoogleAuthService.initialize();
  }

  if (PlatformHelper.isDesktop) {
    await DeepLinkService.initialize();
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1E0619),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ResidenciaCarlotaApp());
}

class ResidenciaCarlotaApp extends StatelessWidget {
  const ResidenciaCarlotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Residencia Carlota',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E0619),
        fontFamily: 'Roboto',
        useMaterial3: true,

        // Botones OK / Cancel en diálogos nativos (DatePicker, TimePicker, etc.)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),

        // DatePicker: colores del calendario
        datePickerTheme: DatePickerThemeData(
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
          backgroundColor: const Color(0xFF2A0825),
          headerBackgroundColor: AppColors.primaryDark,
          headerForegroundColor: Colors.white,
          weekdayStyle: TextStyle(color: Colors.white.withValues(alpha: 0.50)),
          dayStyle: const TextStyle(color: Colors.white),
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.25);
            }
            return Colors.white.withValues(alpha: 0.85);
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return Colors.transparent;
          }),
          todayForegroundColor: WidgetStateProperty.all(AppColors.primaryLight),
          todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
          todayBorder: BorderSide(color: AppColors.primaryLight),
          yearStyle: const TextStyle(color: Colors.white),
          rangePickerBackgroundColor: const Color(0xFF2A0825),
          dividerColor: Colors.white24,
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF3A0B32),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),

        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primaryLight,
          onSecondary: Colors.white,
          surface: const Color(0xFF2A0825),
          error: AppColors.error,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();