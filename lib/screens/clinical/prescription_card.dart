import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/date_utils.dart';
import 'package:app_geriatrico/data/models/medical_prescription_model.dart';

class PrescriptionCard extends StatelessWidget {
  final MedicalPrescription prescription;
  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final active = prescription.isActive;
    final med    = prescription.medication;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(med?.name ?? 'Medicamento desconocido',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF5BB57A).withValues(alpha: 0.18)
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: active
                        ? const Color(0xFF5BB57A).withValues(alpha: 0.40)
                        : Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Text(active ? 'Activa' : 'Suspendida',
                      style: TextStyle(
                          color: active ? const Color(0xFF5BB57A) : Colors.white.withValues(alpha: 0.40),
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _chip(Icons.straighten_outlined, prescription.dose),
                    const SizedBox(width: 8),
                    _chip(Icons.schedule_outlined, prescription.frequency),
                    if (prescription.route != null) ...[
                      const SizedBox(width: 8),
                      _chip(Icons.route_outlined, prescription.route!),
                    ],
                  ],
                ),
                if (prescription.instructions != null && prescription.instructions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(prescription.instructions!,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
                ],
                if (prescription.startDate != null) ...[
                  const SizedBox(height: 8),
                  Text('Desde ${AppDateUtils.format(prescription.startDate)}'
                      '${prescription.endDate != null ? ' · Hasta ${AppDateUtils.format(prescription.endDate)}' : ''}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.45)),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.70))),
        ],
      ),
    );
  }
}