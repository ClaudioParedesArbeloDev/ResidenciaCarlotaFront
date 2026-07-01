import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/date_utils.dart';
import 'package:app_geriatrico/data/models/patient_evolution_model.dart';

class EvolutionCard extends StatelessWidget {
  final PatientEvolution evolution;
  final String? specialties;
  final String? typeLabel;
  final String? dateLabel;

  const EvolutionCard({
    super.key,
    required this.evolution,
    this.specialties,
    this.typeLabel,
    this.dateLabel,
  });

  static const _typeColors = {
    'medical':     Color(0xFF9C5BB5),
    'nursing':     Color(0xFF5B8FB5),
    'kinesiology': Color(0xFF5BB57A),
    'nutrition':   Color(0xFFB5875B),
    'social':      Color(0xFF5BB5B0),
    'general':     Color(0xFF888888),
  };

  @override
  Widget build(BuildContext context) {
    final color      = _typeColors[evolution.type] ?? const Color(0xFF888888);
    final prof       = evolution.professional;
    final label      = typeLabel ?? evolution.typeLabel;
    final dateText   = dateLabel ?? AppDateUtils.formatDateTime(evolution.recordedAt);
    final specsText  = specialties;

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.40)),
                  ),
                  child: Text(label,
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                if (specsText != null && specsText.isNotEmpty)
                  Text(specsText,
                      style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.35))),
                if (dateText.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(dateText,
                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35))),
                ],
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(evolution.evolution,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 13, height: 1.5)),
                if (prof != null) ...[
                  const SizedBox(height: 10),
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