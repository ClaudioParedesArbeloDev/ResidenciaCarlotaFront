import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/platform_helper.dart';
import 'package:app_geriatrico/data/repositories/auth_repository.dart';
import 'package:app_geriatrico/data/models/auth_response.dart';
import 'package:app_geriatrico/services/google_auth_service.dart';
import 'package:app_geriatrico/services/deep_link_service.dart';
import 'package:app_geriatrico/screens/home/home_screen.dart';
import 'package:app_geriatrico/screens/forgot_password/forgot_password_screen.dart';
import 'package:app_geriatrico/screens/login/login_bg_painter.dart';
import 'package:app_geriatrico/screens/login/login_card_content.dart';
import 'package:app_geriatrico/screens/login/login_glass_card.dart';
import 'package:app_geriatrico/screens/login/login_left_panel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authRepo     = AuthRepository();
  final _googleSvc    = GoogleAuthService();
  final _formKey      = GlobalKey<FormState>();


  bool _obscurePassword = true;
  bool _loading         = false;

  
  late final AnimationController _entryCtrl;
  late final Animation<double>   _entryOpacity;
  late final Animation<Offset>   _entrySlide;

 
  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initDeepLink();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _entryCtrl.dispose();
    if (PlatformHelper.isDesktop) {
      DeepLinkService.onTokenReceived = null;
      DeepLinkService.onError         = null;
    }
    super.dispose();
  }

  void _initAnimation() {
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _entryOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entrySlide = Tween<Offset>(
            begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  void _initDeepLink() {
    if (!PlatformHelper.isDesktop) return;
    DeepLinkService.onTokenReceived = _handleDesktopToken;
    DeepLinkService.onError = (error) {
      if (mounted) {
        setState(() => _loading = false);
        _showError('Error de Google: $error');
      }
    };
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final response = await _authRepo.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
      if (!mounted) return;
      _emailCtrl.clear();
      _passwordCtrl.clear();
      _navigateHome(response);
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    try {
      final response = await _googleSvc.signIn();
      if (!mounted) return;
      if (response != null) _navigateHome(response);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      final msg = e.toString().replaceAll('Exception: ', '');
      if (!msg.contains('cancelado') && !msg.contains('canceled')) {
        _showError(msg);
      }
    }
  }

  Future<void> _handleDesktopToken(String token) async {
    if (!mounted) return;
    try {
      final response = await _authRepo.loginWithToken(token);
      if (!mounted) return;
      _navigateHome(response);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showError('No se pudo verificar la sesión de Google');
    }
  }


  void _navigateHome(AuthResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bienvenido ${response.user['name']}')),
    );

    final rawInstitutions = response.institutions;
    final institutionId   = rawInstitutions.isNotEmpty
        ? (rawInstitutions.first as Map<String, dynamic>)['id'] as int
        : 1;
    final roles = <String>{
      for (final i in rawInstitutions)
        if ((i as Map<String, dynamic>)['role'] is Map)
          ((i)['role'] as Map<String, dynamic>)['name'] as String,
    }.toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userName:      response.user['name'] as String,
          avatar:        response.user['avatar'] as String?,
          token:         response.accessToken,
          institutionId: institutionId,
          roles:         roles,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.6,
                colors: [
                  Color(0xFF7B2268),
                  Color(0xFF6A1B5D),
                  Color(0xFF3A0B32),
                  Color(0xFF1E0619),
                ],
                stops: [0.0, 0.30, 0.65, 1.0],
              ),
            ),
          ),
          // Patrón de líneas
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: LoginBgPainter(),
          ),
          // Layout responsive
          LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > 900
                ? _buildDesktop()
                : _buildMobile(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        Expanded(flex: 5, child: LoginLeftPanel()),
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _animatedCard(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _animatedCard(),
          ),
        ),
      ),
    );
  }

  Widget _animatedCard() {
    return SlideTransition(
      position: _entrySlide,
      child: FadeTransition(
        opacity: _entryOpacity,
        child: LoginGlassCard(
          child: LoginCardContent(
            formKey:            _formKey,
            emailController:    _emailCtrl,
            passwordController: _passwordCtrl,
            obscurePassword:    _obscurePassword,
            loading:            _loading,
            onTogglePassword:   () => setState(() => _obscurePassword = !_obscurePassword),
            onLogin:            _login,
            onForgotPassword:   () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
            onGoogleLogin:      _loginWithGoogle,
          ),
        ),
      ),
    );
  }
}
