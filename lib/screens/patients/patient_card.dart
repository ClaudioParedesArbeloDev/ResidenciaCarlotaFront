import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = patient;
    final genderIcon  = p.gender.toLowerCase() == 'female' ? Icons.female : Icons.male;
    final genderColor = p.gender.toLowerCase() == 'female'
        ? const Color(0xFFE91E9C)
        : const Color(0xFF2196F3);
    final statusColor = p.status == 'active'
        ? Colors.green
        : p.status == 'deceased'
            ? Colors.grey
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryDark.withValues(alpha: 0.85),
                    child: Text(
                      p.firstName.isNotEmpty ? p.firstName[0].toUpperCase() : '?',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: genderColor.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2A0825), width: 1.5),
                      ),
                      child: Icon(genderIcon,
                          size: 10, color: genderColor.withValues(alpha: 0.85)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.fullName,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1)),
                    const SizedBox(height: 3),
                    Text('DNI: ${p.dni}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.38))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      p.status == 'active'
                          ? 'Activo'
                          : p.status == 'deceased'
                              ? 'Fallecido'
                              : 'Inactivo',
                      style: TextStyle(
                          fontSize: 10,
                          color: statusColor.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        p.mobilityStatus == 'ambulatorio'
                            ? Icons.directions_walk
                            : Icons.accessible,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.30),
                      ),
                      const SizedBox(width: 3),
                      Text(p.mobilityStatus,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.30))),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.20), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
