import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/medical_prescription_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';
import 'package:app_geriatrico/screens/clinical/prescription_card.dart';

class PrescriptionTab extends StatelessWidget {
  final List<MedicalPrescription> prescriptions;
  final VoidCallback onAdd;
  final VoidCallback onReload;

  const PrescriptionTab({
    super.key,
    required this.prescriptions,
    required this.onAdd,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        prescriptions.isEmpty
            ? PatientEmptyState(
                message: 'Sin medicamentos recetados',
                icon: Icons.medication_outlined,
                subtitle: 'Tocá + para agregar una prescripción',
                onReload: onReload,
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
                itemCount: prescriptions.length,
                itemBuilder: (context, i) =>
                    PrescriptionCard(prescription: prescriptions[i]),
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'fab_prescription',
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

