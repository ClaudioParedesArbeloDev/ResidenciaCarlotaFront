// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/allergy_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/allergy_card.dart';

class AllergyTab extends StatelessWidget {
  final List<Allergy> allergies;
  final VoidCallback onAdd;
  final void Function(Allergy) onEdit;
  final void Function(Allergy) onDelete;

  const AllergyTab({
    super.key,
    required this.allergies,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  static Color _severityColor(String? severity) {
    switch (severity) {
      case 'severe':   return const Color(0xFFEF5350);
      case 'moderate': return const Color(0xFFFF9800);
      default:         return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        allergies.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 44,
                        color: Colors.green.withValues(alpha: 0.25)),
                    const SizedBox(height: 12),
                    Text('Sin alergias registradas',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 13)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                itemCount: allergies.length,
                itemBuilder: (context, i) => AllergyCard(
                  allergy: allergies[i],
                  onEdit: onEdit,
                  onDelete: onDelete,
                  severityColor: _severityColor(allergies[i].severity),
                ),
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'fab_allergy',
            mini: true,
            backgroundColor: AppColors.primaryDark,
            onPressed: onAdd,
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

