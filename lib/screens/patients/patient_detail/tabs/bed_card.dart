import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_bed_assignment_model.dart';

class BedCard extends StatelessWidget {
  final PatientBedAssignment? assignment;
  final bool isEditing;
  final VoidCallback onAssign;
  final VoidCallback onRelease;

  const BedCard({
    super.key,
    required this.assignment,
    required this.isEditing,
    required this.onAssign,
    required this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    final assigned = assignment != null;
    final bed  = assignment?.bed;
    final room = bed?.room;

    return Container(
      decoration: BoxDecoration(
        color: assigned
            ? Colors.green.withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: assigned
              ? Colors.green.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.09),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: (assigned ? Colors.green : Colors.white)
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                assigned ? Icons.bed_rounded : Icons.bed_outlined,
                size: 22,
                color: (assigned ? Colors.green : Colors.white)
                    .withValues(alpha: assigned ? 0.75 : 0.30),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: assigned
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bed != null ? 'Cama ${bed.bedNumber}' : 'Sin cama asignada',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        if (room != null)
                          Text(
                            'Hab. ${room.number}'
                            '${room.floor != null ? ' · Piso ${room.floor}' : ''}',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 11),
                          ),
                      ],
                    )
                  : Text('Sin cama asignada',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 14)),
            ),
            assigned
                ? OutlinedButton.icon(
                    onPressed: isEditing ? null : onRelease,
                    icon: Icon(Icons.logout,
                        size: 14,
                        color: AppColors.error.withValues(alpha: 0.65)),
                    label: Text('Dar de alta',
                        style: TextStyle(
                            color: AppColors.error.withValues(alpha: 0.70),
                            fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.25)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: isEditing ? null : onAssign,
                    icon: const Icon(Icons.add, size: 14),
                    label:
                        const Text('Asignar', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A1240),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
