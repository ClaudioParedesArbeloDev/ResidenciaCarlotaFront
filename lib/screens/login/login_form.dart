import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';


class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: _inputDecoration(
              label: 'Usuario o Email',
              icon: Icons.person_outline_rounded,
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingresá tu usuario' : null,
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: _inputDecoration(
              label: 'Contraseña',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
                onPressed: onTogglePassword,
              ),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingresá tu contraseña' : null,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.70),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              ),
              child: const Text('¿Olvidaste tu contraseña?',
                  style: TextStyle(fontSize: 12.5, letterSpacing: 0.2)),
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: loading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.25),
                foregroundColor: AppColors.primaryDark,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: loading
                  ? SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  : Text('Ingresar',
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          fontSize: 13.5,
          color: Colors.white.withValues(alpha: 0.50),
          letterSpacing: 0.2),
      prefixIcon:
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.50)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.10),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.18), width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.60), width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    );
  }
}
