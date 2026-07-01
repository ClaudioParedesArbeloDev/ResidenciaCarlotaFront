import 'package:flutter/material.dart';
import 'package:app_geriatrico/screens/home/home_modules.dart';



class HomeSidebar extends StatelessWidget {
  final List<NavModule> modules;
  final int selectedIndex;
  final String roleLabel;
  final String? avatarUrl;
  final void Function(NavModule, int) onModuleTap;
  final VoidCallback onLogout;

  const HomeSidebar({
    super.key,
    required this.modules,
    required this.selectedIndex,
    required this.roleLabel,
    required this.onModuleTap,
    required this.onLogout,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A1240), Color(0xFF3A0B32), Color(0xFF2A0825)],
        ),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          _Logo(),
          const SizedBox(height: 20),
          _divider(),
          const SizedBox(height: 12),
          _RoleBadge(label: roleLabel),
          const SizedBox(height: 16),
          _sectionLabel('MENÚ'),
          const SizedBox(height: 6),
          ...modules.asMap().entries.map((e) => _SidebarItem(
                module: e.value,
                index: e.key,
                selectedIndex: selectedIndex,
                onTap: () => onModuleTap(e.value, e.key),
              )),
          const Spacer(),
          _divider(),
          const SizedBox(height: 4),
          _LogoutItem(onTap: onLogout),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white.withValues(alpha: 0.08),
      );

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 9,
                letterSpacing: 2.5,
                color: Colors.white.withValues(alpha: 0.30),
                fontWeight: FontWeight.w500),
          ),
        ),
      );
}


class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ],
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.85), width: 1.5),
            ),
            padding: const EdgeInsets.all(7),
            child: Image.asset('assets/images/LogoCarlota.png',
                fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Residencia',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.45),
                        letterSpacing: 1.5)),
                const Text('Carlota',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  const _RoleBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.shield_outlined,
              size: 11, color: Colors.white.withValues(alpha: 0.50)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.55),
                letterSpacing: 0.5),
          ),
        ]),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final NavModule module;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.module,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? module.accent.withValues(alpha: 0.12)
            : Colors.transparent,
        border: isSelected
            ? Border.all(color: module.accent.withValues(alpha: 0.20))
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(module.icon,
            size: 20,
            color: isSelected
                ? module.accent
                : Colors.white.withValues(alpha: 0.50)),
        title: Text(module.title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.50),
                letterSpacing: 0.2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}

class _LogoutItem extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.logout_rounded,
            size: 20, color: Colors.white.withValues(alpha: 0.50)),
        title: Text('Cerrar sesión',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white.withValues(alpha: 0.50),
                letterSpacing: 0.2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}
