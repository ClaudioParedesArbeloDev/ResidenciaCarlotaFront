import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/medical_study_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';

class StudiesTab extends StatelessWidget {
  final List<MedicalStudy> studies;
  final VoidCallback onAdd;
  final VoidCallback onReload;

  const StudiesTab({
    super.key,
    required this.studies,
    required this.onAdd,
    required this.onReload,
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
    return Stack(
      children: [
        studies.isEmpty
            ? PatientEmptyState(
                message: 'Sin estudios registrados',
                icon: Icons.science_outlined,
                subtitle: 'Tocá + para agregar un estudio',
                onReload: onReload,
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
                itemCount: studies.length,
                itemBuilder: (context, i) {
                  final s = studies[i];
                  return _ClinicalCard(
                    icon: Icons.science_outlined,
                    accentColor: const Color(0xFFFF6F00),
                    title: s.studyType,
                    subtitle: s.conclusion,
                    date: s.performedAt != null ? _formatDate(s.performedAt) : null,
                    professional: s.professional != null
                        ? '${s.professional!.name} ${s.professional!.lastName ?? ''}'
                        : null,
                  );
                },
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'fab_study',
            backgroundColor: const Color(0xFF4A1240),
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: onAdd,
            child: const Icon(Icons.add, size: 24),
          ),
        ),
      ],
    );
  }
}

class _ClinicalCard extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String? subtitle;
  final String? date;
  final String? professional;

  const _ClinicalCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    this.subtitle,
    this.date,
    this.professional,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon,
                    size: 17, color: accentColor.withValues(alpha: 0.75)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ),
              if (date != null)
                Text(date!,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.35))),
            ]),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.60),
                      height: 1.5)),
            ],
            if (professional != null) ...[
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.person_outline,
                    size: 11,
                    color: Colors.white.withValues(alpha: 0.25)),
                const SizedBox(width: 4),
                Text(professional!,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.38))),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
