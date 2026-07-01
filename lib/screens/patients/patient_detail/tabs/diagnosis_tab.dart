// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/patient_diagnosis_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/diagnosis_card.dart';

class DiagnosisTab extends StatelessWidget {
  final List<PatientDiagnosis> diagnoses;
  final VoidCallback onAdd;
  final void Function(PatientDiagnosis) onEdit;
  final void Function(PatientDiagnosis) onDelete;
  final VoidCallback onReload;

  const DiagnosisTab({
    super.key,
    required this.diagnoses,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        diagnoses.isEmpty
            ? PatientEmptyState(
                message: 'Sin diagnósticos registrados',
                icon: Icons.biotech_outlined,
                subtitle: 'Tocá + para agregar un diagnóstico',
                onReload: onReload,
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
                itemCount: diagnoses.length,
                itemBuilder: (context, i) => DiagnosisCard(
                  diagnosis: diagnoses[i],
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'fab_diagnosis',
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

