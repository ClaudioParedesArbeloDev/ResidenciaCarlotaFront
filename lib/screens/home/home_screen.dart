import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/repositories/auth_repository.dart';
import 'package:app_geriatrico/screens/home/home_modules.dart';
import 'package:app_geriatrico/screens/home/home_avatar.dart';
import 'package:app_geriatrico/screens/home/home_sidebar.dart';
import 'package:app_geriatrico/screens/home/home_dashboard.dart';
import 'package:app_geriatrico/screens/home/home_mobile_appbar.dart';
import 'package:app_geriatrico/screens/employees/employees_screen.dart';
import 'package:app_geriatrico/screens/patients/patients_screen.dart';
import 'package:app_geriatrico/screens/beds/beds_screen.dart';
import 'package:app_geriatrico/screens/rooms/rooms_screen.dart';
import 'package:app_geriatrico/screens/medications/medications_screen.dart';
import 'package:app_geriatrico/screens/clinical/evolutions_screen.dart';
import 'package:app_geriatrico/screens/clinical/prescriptions_screen.dart';
import 'package:app_geriatrico/screens/clinical/studies_screen.dart';
import 'package:app_geriatrico/screens/clinical/vital_signs_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? avatar;
  final String token;
  final int institutionId;
  final List<String> roles;

  const HomeScreen({
    super.key,
    required this.userName,
    this.avatar,
    required this.token,
    required this.institutionId,
    this.roles = const [],
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;



  String get _firstName => widget.userName.split(' ').first;
  String get _roleLabel => roleLabelFor(widget.roles);
  List<NavModule> get _modules => modulesForRoles(widget.roles);



  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }



  Future<void> _logout() async {
    final success = await AuthRepository().logout(widget.token);
    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error al cerrar sesión'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
    }
  }



  void _navigate(NavModule module) {
    final screen = _screenFor(module.id);
    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Módulo "${module.title}" próximamente'),
        backgroundColor: AppColors.primaryDark.withValues(alpha: 0.92),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget? _screenFor(String id) {
    switch (id) {
      case 'pacientes':
      case 'mis_pacientes':
        return PatientsScreen(token: widget.token, institutionId: widget.institutionId);
      case 'habitaciones':
        return RoomsScreen(token: widget.token, institutionId: widget.institutionId);
      case 'camas':
        return BedsScreen(token: widget.token, institutionId: widget.institutionId);
      case 'personal':
        return EmployeesScreen(token: widget.token, institutionId: widget.institutionId);
      case 'medicamentos':
        return MedicationsScreen(token: widget.token, institutionId: widget.institutionId, roles: widget.roles);
      case 'evoluciones':
        return EvolutionsScreen(token: widget.token, institutionId: widget.institutionId);
      case 'prescripciones':
        return PrescriptionsScreen(token: widget.token, institutionId: widget.institutionId);
      case 'estudios':
        return StudiesScreen(token: widget.token, institutionId: widget.institutionId);
      case 'signos_vitales':
        return VitalSignsScreen(token: widget.token, institutionId: widget.institutionId, roles: widget.roles);
      default:
        return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth > 900 ? _buildDesktop() : _buildMobile(),
      ),
    );
  }



  Widget _buildDesktop() {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          Row(children: [
            HomeSidebar(
              modules:       _modules,
              selectedIndex: _selectedIndex,
              roleLabel:     _roleLabel,
              avatarUrl:     widget.avatar,
              onModuleTap:   (mod, index) {
                setState(() => _selectedIndex = index);
                _navigate(mod);
              },
              onLogout: _logout,
            ),
            Expanded(child: _DesktopMainContent(
              firstName:     _firstName,
              avatarUrl:     widget.avatar,
              modules:       _modules,
              onModuleTap:   _navigate,
            )),
          ]),
        ],
      ),
    );
  }



  Widget _buildMobile() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.4,
                colors: [Color(0xFF6A1B5D), Color(0xFF3A0B32), Color(0xFF1E0619)],
                stops: [0.0, 0.50, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(children: [
              HomeMobileAppBar(
                firstName: _firstName,
                avatarUrl: widget.avatar,
                onLogout:  _logout,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      HomeMobileRoleBadge(roleLabel: _roleLabel),
                      const SizedBox(height: 20),
                      HomeDashboard(
                        modules:     _modules,
                        onModuleTap: _navigate,
                        isMobile:    true,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}



class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E0619), Color(0xFF2A0825), Color(0xFF1A051A)],
        ),
      ),
    );
  }
}

class _DesktopMainContent extends StatelessWidget {
  final String firstName;
  final String? avatarUrl;
  final List<NavModule> modules;
  final void Function(NavModule) onModuleTap;

  const _DesktopMainContent({
    required this.firstName,
    required this.modules,
    required this.onModuleTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _TopBar(firstName: firstName, avatarUrl: avatarUrl),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: HomeDashboard(
                modules:     modules,
                onModuleTap: onModuleTap,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _TopBar extends StatelessWidget {
  final String firstName;
  final String? avatarUrl;

  const _TopBar({required this.firstName, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bienvenido de vuelta',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.45),
                  letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(firstName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 0.5)),
        ]),
        const Spacer(),
 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.circle, size: 8, color: Color(0xFF4CAF50)),
            const SizedBox(width: 6),
            Text('En línea',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.65))),
          ]),
        ),
        const SizedBox(width: 12),
        HomeAvatar(avatarUrl: avatarUrl, radius: 18),
      ]),
    );
  }
}