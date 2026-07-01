import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_evolution_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';
import 'package:app_geriatrico/screens/clinical/evolution_card.dart';

class EvolutionTab extends StatelessWidget {
  final List<PatientEvolution> evolutions;
  final String? filterSpecialty;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback onAdd;
  final VoidCallback onReload;

  const EvolutionTab({
    super.key,
    required this.evolutions,
    required this.filterSpecialty,
    required this.onFilterChanged,
    required this.onAdd,
    required this.onReload,
  });

  List<PatientEvolution> get _filtered {
    if (filterSpecialty == null || filterSpecialty!.isEmpty) return evolutions;
    return evolutions.where((e) {
      final specs =
          e.professional?.specialties.map((s) => s.name) ?? const Iterable.empty();
      return specs.contains(filterSpecialty);
    }).toList();
  }

  Set<String> get _allSpecialties {
    final set = <String>{};
    for (final ev in evolutions) {
      for (final sp in ev.professional?.specialties ?? []) {
        set.add(sp.name);
      }
    }
    return set;
  }

  String _typeLabel(String type) {
    const map = {
      'medical':     'Médica',
      'nursing':     'Enfermería',
      'kinesiology': 'Kinesiología',
      'nutrition':   'Nutrición',
      'social':      'Social',
      'general':     'General',
    };
    return map[type] ?? type;
  }

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
    final filtered    = _filtered;
    final specialties = _allSpecialties;

    return Stack(
      children: [
        Column(
          children: [
            if (specialties.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todas',
                        selected: filterSpecialty == null,
                        onTap: () => onFilterChanged(null),
                      ),
                      ...specialties.map((s) => _FilterChip(
                            label: s,
                            selected: filterSpecialty == s,
                            onTap: () => onFilterChanged(s),
                          )),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: filtered.isEmpty
                  ? PatientEmptyState(
                      message: 'Sin evoluciones registradas',
                      icon: Icons.history_edu_outlined,
                      subtitle: 'Tocá + para registrar una nueva evolución',
                      onReload: onReload,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final ev    = filtered[i];
                        final specs = ev.professional?.specialties
                                .map((s) => s.name)
                                .join(', ') ??
                            '';
                        return EvolutionCard(
                          evolution:   ev,
                          specialties: specs,
                          typeLabel:   _typeLabel(ev.type),
                          dateLabel:   _formatDate(ev.recordedAt),
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'fab_evolution',
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 6),
        padding:
            const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryDark.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.20)
                : Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Colors.white
                    .withValues(alpha: selected ? 0.90 : 0.45))),
      ),
    );
  }
}

