import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_diagnosis_model.dart';

class DiagnosisCard extends StatelessWidget {
  final PatientDiagnosis diagnosis;
  final void Function(PatientDiagnosis) onEdit;
  final void Function(PatientDiagnosis) onDelete;

  const DiagnosisCard({
    super.key,
    required this.diagnosis,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '—';
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = diagnosis;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.biotech_outlined,
                      size: 17, color: Color(0xFF9C6FFF)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.diagnosis,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      if (d.cie10Code != null) ...[
                        const SizedBox(height: 5),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C4DFF)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(d.cie10Code!,
                                style: const TextStyle(
                                    color: Color(0xFFBB99FF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                          if (d.cie10Label != null) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(d.cie10Label!,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white
                                          .withValues(alpha: 0.45)),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ]),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      size: 17,
                      color: Colors.white.withValues(alpha: 0.30)),
                  color: const Color(0xFF3A0B32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  onSelected: (action) {
                    if (action == 'edit')   onEdit(d);
                    if (action == 'delete') onDelete(d);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.60)),
                        const SizedBox(width: 10),
                        Text('Editar',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 13)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline,
                            size: 15,
                            color: AppColors.error.withValues(alpha: 0.70)),
                        const SizedBox(width: 10),
                        Text('Eliminar',
                            style: TextStyle(
                                color: AppColors.error.withValues(alpha: 0.80),
                                fontSize: 13)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (d.notes != null && d.notes!.isNotEmpty) ...[
            Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Text(d.notes!,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.55),
                      height: 1.5)),
            ),
          ],
          if (d.diagnosedAt != null || d.professional != null) ...[
            Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 7, 14, 8),
              child: Row(children: [
                if (d.diagnosedAt != null) ...[
                  Icon(Icons.calendar_today_outlined,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.25)),
                  const SizedBox(width: 4),
                  Text(_formatDate(d.diagnosedAt),
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.35))),
                ],
                const Spacer(),
                if (d.professional != null) ...[
                  Icon(Icons.person_outline,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.25)),
                  const SizedBox(width: 4),
                  Text(
                    '${d.professional!.name} ${d.professional!.lastName ?? ""}',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35)),
                  ),
                ],
              ]),
            ),
          ],
        ],
      ),
    );
  }
}
