import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/date_utils.dart';
import 'package:app_geriatrico/data/models/medical_study_model.dart';

class StudyCard extends StatelessWidget {
  final MedicalStudy study;
  const StudyCard({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    final prof = study.professional;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                const Icon(Icons.science_outlined, size: 15, color: Color(0xFFB5875B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(study.studyType,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                if (study.performedAt != null)
                  Text(AppDateUtils.format(study.performedAt),
                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (study.conclusion != null && study.conclusion!.isNotEmpty)
                  Text(study.conclusion!,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13, height: 1.5)),
                if (study.hasFile) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_file_rounded, size: 13, color: Colors.white.withValues(alpha: 0.40)),
                      const SizedBox(width: 4),
                      Text('Archivo adjunto',
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45))),
                    ],
                  ),
                ],
                if (prof != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 13, color: Colors.white.withValues(alpha: 0.30)),
                      const SizedBox(width: 4),
                      Text('${prof.name} ${prof.lastName ?? ''}',
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.40))),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}