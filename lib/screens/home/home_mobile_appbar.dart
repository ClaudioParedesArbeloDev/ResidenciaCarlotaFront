import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/screens/home/home_avatar.dart';


class HomeMobileAppBar extends StatelessWidget {
  final String firstName;
  final String? avatarUrl;
  final VoidCallback onLogout;

  const HomeMobileAppBar({
    super.key,
    required this.firstName,
    required this.onLogout,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.90), width: 1.5),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/images/LogoCarlota.png',
                fit: BoxFit.contain),
          ),
          const SizedBox(width: 10),
          // Saludo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, $firstName',
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                'Residencia Carlota',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.45),
                    letterSpacing: 0.5),
              ),
            ],
          ),
          const Spacer(),
        
          PopupMenuButton<String>(
            color: const Color(0xFF3A0B32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side:
                  BorderSide(color: Colors.white.withValues(alpha: 0.10)),
            ),
            icon: HomeAvatar(avatarUrl: avatarUrl, radius: 18),
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(children: [
                  Icon(Icons.logout_rounded,
                      size: 16,
                      color: AppColors.error.withValues(alpha: 0.80)),
                  const SizedBox(width: 8),
                  Text('Cerrar sesión',
                      style: TextStyle(
                          color: AppColors.error.withValues(alpha: 0.80))),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class HomeMobileRoleBadge extends StatelessWidget {
  final String roleLabel;

  const HomeMobileRoleBadge({super.key, required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.shield_outlined,
            size: 13, color: Colors.white.withValues(alpha: 0.50)),
        const SizedBox(width: 6),
        Text(
          roleLabel,
          style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.60),
              letterSpacing: 0.4),
        ),
      ]),
    );
  }
}
