import 'package:flutter/material.dart';

class NavModule {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const NavModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });
}


const adminModules = [
  NavModule(
    id: 'pacientes',
    title: 'Pacientes',
    subtitle: 'Gestión de residentes',
    icon: Icons.elderly_outlined,
    accent: Color(0xFF9C5BB5),
  ),
  NavModule(
    id: 'familiares',
    title: 'Familiares',
    subtitle: 'Contactos a cargo',
    icon: Icons.family_restroom_outlined,
    accent: Color(0xFF5B8FB5),
  ),
  NavModule(
    id: 'personal',
    title: 'Personal',
    subtitle: 'Empleados y profesionales',
    icon: Icons.badge_outlined,
    accent: Color(0xFF5BB57A),
  ),
  NavModule(
    id: 'habitaciones',
    title: 'Habitaciones',
    subtitle: 'Cuartos del establecimiento',
    icon: Icons.door_front_door_outlined,
    accent: Color(0xFF5BB5B0),
  ),
  NavModule(
    id: 'camas',
    title: 'Camas',
    subtitle: 'Control de ocupación',
    icon: Icons.bed_outlined,
    accent: Color(0xFFB55B5B),
  ),
  NavModule(
    id: 'medicamentos',
    title: 'Medicamentos',
    subtitle: 'Catálogo de fármacos',
    icon: Icons.medication_outlined,
    accent: Color(0xFF5B8FB5),
  ),
];

const profesionalModules = [
  NavModule(
    id: 'mis_pacientes',
    title: 'Mis Pacientes',
    subtitle: 'Residentes a cargo',
    icon: Icons.elderly_outlined,
    accent: Color(0xFF9C5BB5),
  ),
  NavModule(
    id: 'evoluciones',
    title: 'Evoluciones',
    subtitle: 'Notas clínicas',
    icon: Icons.assignment_outlined,
    accent: Color(0xFF5B8FB5),
  ),
  NavModule(
    id: 'prescripciones',
    title: 'Prescripciones',
    subtitle: 'Medicación activa',
    icon: Icons.medication_outlined,
    accent: Color(0xFF5BB57A),
  ),
  NavModule(
    id: 'estudios',
    title: 'Estudios',
    subtitle: 'Resultados e informes',
    icon: Icons.science_outlined,
    accent: Color(0xFFB5875B),
  ),
  NavModule(
    id: 'signos_vitales',
    title: 'Signos Vitales',
    subtitle: 'Registro de constantes',
    icon: Icons.monitor_heart_outlined,
    accent: Color(0xFFB55B5B),
  ),
  NavModule(
    id: 'medicamentos',
    title: 'Medicamentos',
    subtitle: 'Catálogo de fármacos',
    icon: Icons.medication_outlined,
    accent: Color(0xFF5B8FB5),
  ),
];

const empleadoModules = [
  NavModule(
    id: 'pacientes',
    title: 'Pacientes',
    subtitle: 'Ver residentes',
    icon: Icons.elderly_outlined,
    accent: Color(0xFF9C5BB5),
  ),
  NavModule(
    id: 'camas',
    title: 'Camas',
    subtitle: 'Estado de camas',
    icon: Icons.bed_outlined,
    accent: Color(0xFFB55B5B),
  ),
];

const familiarModules = [
  NavModule(
    id: 'mi_familiar',
    title: 'Mi Familiar',
    subtitle: 'Estado y evolución',
    icon: Icons.favorite_outline_rounded,
    accent: Color(0xFF9C5BB5),
  ),
];


List<NavModule> modulesForRoles(List<String> roles) {
  final isAdmin      = roles.contains('admin');
  final isFamiliar   = roles.contains('familiar');
  final isProfesional = roles.any((r) =>
      ['doctor', 'nurse', 'kinesiologist', 'nutritionist', 'social_worker']
          .contains(r));

  if (isAdmin) return adminModules;
  if (isProfesional) return profesionalModules;
  if (isFamiliar) return familiarModules;
  return empleadoModules;
}


String roleLabelFor(List<String> roles) {
  if (roles.contains('admin'))         return 'Administrador';
  if (roles.contains('doctor'))        return 'Médico/a';
  if (roles.contains('nurse'))         return 'Enfermero/a';
  if (roles.contains('kinesiologist')) return 'Kinesiólogo/a';
  if (roles.contains('nutritionist'))  return 'Nutricionista';
  if (roles.contains('social_worker')) return 'Trab. Social';
  if (roles.contains('familiar'))      return 'Familiar';
  return 'Empleado';
}