import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/allergy_model.dart';
import 'package:app_geriatrico/data/models/medical_prescription_model.dart';
import 'package:app_geriatrico/data/models/medical_study_model.dart';
import 'package:app_geriatrico/data/models/patient_diagnosis_model.dart';
import 'package:app_geriatrico/data/models/patient_evolution_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/diagnosis_tab.dart';
import 'package:app_geriatrico/screens/clinical/evolution_tab.dart';
import 'package:app_geriatrico/screens/clinical/prescription_tab.dart';
import 'package:app_geriatrico/screens/clinical/studies_tab.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/allergy_tab.dart';


class ClinicalTab extends StatelessWidget {
  final bool loading;


  final List<PatientDiagnosis>      diagnoses;
  final List<PatientEvolution>      evolutions;
  final List<MedicalPrescription>   prescriptions;
  final List<MedicalStudy>          studies;
  final List<Allergy>               allergies;


  final String? filterSpecialty;
  final ValueChanged<String?> onFilterChanged;


  final VoidCallback                        onAddDiagnosis;
  final void Function(PatientDiagnosis)     onEditDiagnosis;
  final void Function(PatientDiagnosis)     onDeleteDiagnosis;


  final VoidCallback onAddEvolution;


  final VoidCallback onAddPrescription;


  final VoidCallback onAddStudy;


  final VoidCallback                   onAddAllergy;
  final void Function(Allergy)         onEditAllergy;
  final void Function(Allergy)         onDeleteAllergy;


  final VoidCallback onReload;

  const ClinicalTab({
    super.key,
    required this.loading,
    required this.diagnoses,
    required this.evolutions,
    required this.prescriptions,
    required this.studies,
    required this.allergies,
    required this.filterSpecialty,
    required this.onFilterChanged,
    required this.onAddDiagnosis,
    required this.onEditDiagnosis,
    required this.onDeleteDiagnosis,
    required this.onAddEvolution,
    required this.onAddPrescription,
    required this.onAddStudy,
    required this.onAddAllergy,
    required this.onEditAllergy,
    required this.onDeleteAllergy,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
          child: CircularProgressIndicator(
              color: Colors.white38, strokeWidth: 1.5));
    }

    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Container(
            color: Colors.white.withValues(alpha: 0.02),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF9C4E8A),
              indicatorWeight: 1.5,
              labelColor: Colors.white.withValues(alpha: 0.85),
              unselectedLabelColor: Colors.white.withValues(alpha: 0.30),
              labelStyle:
                  const TextStyle(fontSize: 11, letterSpacing: 0.3),
              tabs: [
                _tabItem(Icons.biotech_outlined,      'Diagnósticos', diagnoses.length),
                _tabItem(Icons.history_edu_outlined,  'Evoluciones',  evolutions.length),
                _tabItem(Icons.medication_outlined,   'Medicamentos', prescriptions.length),
                _tabItem(Icons.science_outlined,      'Estudios',     studies.length),
                _tabItem(Icons.warning_amber_outlined,'Alergias',     allergies.length),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                DiagnosisTab(
                  diagnoses: diagnoses,
                  onAdd: onAddDiagnosis,
                  onEdit: onEditDiagnosis,
                  onDelete: onDeleteDiagnosis,
                  onReload: onReload,
                ),
                EvolutionTab(
                  evolutions: evolutions,
                  filterSpecialty: filterSpecialty,
                  onFilterChanged: onFilterChanged,
                  onAdd: onAddEvolution,
                  onReload: onReload,
                ),
                PrescriptionTab(
                  prescriptions: prescriptions,
                  onAdd: onAddPrescription,
                  onReload: onReload,
                ),
                StudiesTab(
                  studies: studies,
                  onAdd: onAddStudy,
                  onReload: onReload,
                ),
                AllergyTab(
                  allergies: allergies,
                  onAdd: onAddAllergy,
                  onEdit: onEditAllergy,
                  onDelete: onDeleteAllergy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tab _tabItem(IconData icon, String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 5),
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(count.toString(),
                  style:
                      const TextStyle(fontSize: 9, color: Colors.white60)),
            ),
          ],
        ],
      ),
    );
  }
}
