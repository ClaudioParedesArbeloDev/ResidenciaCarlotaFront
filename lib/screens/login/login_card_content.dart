import 'package:flutter/material.dart';
import 'package:app_geriatrico/screens/login/login_form.dart';
import 'package:app_geriatrico/screens/login/login_google_button.dart';


class LoginCardContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoogleLogin;

  const LoginCardContent({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onGoogleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.20),
                    blurRadius: 30,
                    spreadRadius: 4),
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8)),
              ],
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.90), width: 2.5),
            ),
            padding: const EdgeInsets.all(16),
            child: Image.asset('assets/images/LogoCarlota.png',
                fit: BoxFit.contain),
          ),
        ),

        const SizedBox(height: 24),

        // Institución
        Center(
          child: Text(
            'RESIDENCIA CARLOTA',
            style: TextStyle(
                fontSize: 9,
                letterSpacing: 3.5,
                color: Colors.white.withValues(alpha: 0.55),
                fontWeight: FontWeight.w400),
          ),
        ),

        const SizedBox(height: 8),

        const Center(
          child: Text(
            'Bienvenido',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: 2),
          ),
        ),

        const SizedBox(height: 6),

        Center(
          child: Text(
            'Ingresá para continuar',
            style: TextStyle(
                fontSize: 13, color: Colors.white.withValues(alpha: 0.45)),
          ),
        ),

        const SizedBox(height: 28),

        Center(
          child: Container(
              width: 40,
              height: 1,
              color: Colors.white.withValues(alpha: 0.25)),
        ),

        const SizedBox(height: 24),


        LoginForm(
          formKey: formKey,
          emailController: emailController,
          passwordController: passwordController,
          obscurePassword: obscurePassword,
          loading: loading,
          onTogglePassword: onTogglePassword,
          onLogin: onLogin,
          onForgotPassword: onForgotPassword,
        ),

        const SizedBox(height: 16),


        Row(children: [
          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.20))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('o',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.40), fontSize: 12)),
          ),
          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.20))),
        ]),

        const SizedBox(height: 16),


        LoginGoogleButton(onPressed: onGoogleLogin),

        const SizedBox(height: 28),


        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15), width: 1),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
              Text(
                'Code & Lens Solutions',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.8,
                    color: Colors.white.withValues(alpha: 0.68)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
      ],
    );
  }
}
