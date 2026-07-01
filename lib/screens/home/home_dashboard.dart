import 'package:flutter/material.dart';
import 'package:app_geriatrico/screens/home/home_modules.dart';


class HomeDashboard extends StatelessWidget {
  final List<NavModule> modules;
  final void Function(NavModule) onModuleTap;
  final bool isMobile;

  const HomeDashboard({
    super.key,
    required this.modules,
    required this.onModuleTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panel principal',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            letterSpacing: isMobile ? 0.8 : 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isMobile ? 'Seleccioná un módulo' : 'Seleccioná un módulo para continuar',
          style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              color: Colors.white.withValues(alpha: 0.40)),
        ),
        Container(
          width: 40,
          height: 1,
          color: Colors.white.withValues(alpha: 0.20),
          margin: const EdgeInsets.symmetric(vertical: 18),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: isMobile
              ? const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                )
              : const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 230,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
          itemBuilder: (context, i) => _ModuleCard(
            module: modules[i],
            onTap: () => onModuleTap(modules[i]),
          ),
        ),
      ],
    );
  }
}


class _ModuleCard extends StatelessWidget {
  final NavModule module;
  final VoidCallback onTap;

  const _ModuleCard({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: module.accent.withValues(alpha: 0.20), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: module.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                    color: module.accent.withValues(alpha: 0.30)),
              ),
              child: Icon(module.icon,
                  size: 21, color: module.accent.withValues(alpha: 0.90)),
            ),
            const Spacer(),
            Text(module.title,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3)),
            const SizedBox(height: 4),
            Text(module.subtitle,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.40))),
          ],
        ),
      ),
    );
  }
}
