// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_bed_assignment_model.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_form_fields.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/bed_card.dart';

class PersonalTab extends StatelessWidget {
  final Patient patient;
  final bool isEditing;

 
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController dni;
  final TextEditingController birthDate;
  final TextEditingController admissionDate;
  final TextEditingController emergencyPhone;
  final TextEditingController notes;

  
  final String gender;
  final String bloodType;
  final String mobilityStatus;
  final String dependencyLevel;
  final String status;


  final List<String> genders;
  final List<String> bloodTypes;
  final List<String> mobilityOptions;
  final List<String> dependencyOptions;
  final List<String> statusOptions;


  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onBloodTypeChanged;
  final ValueChanged<String?> onMobilityChanged;
  final ValueChanged<String?> onDependencyChanged;
  final ValueChanged<String?> onStatusChanged;


  final VoidCallback onPickBirthDate;
  final VoidCallback onPickAdmissionDate;


  final PatientBedAssignment? currentAssignment;
  final VoidCallback onAssignBed;
  final VoidCallback onReleaseBed;


  final VoidCallback onDelete;

  const PersonalTab({
    super.key,
    required this.patient,
    required this.isEditing,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.birthDate,
    required this.admissionDate,
    required this.emergencyPhone,
    required this.notes,
    required this.gender,
    required this.bloodType,
    required this.mobilityStatus,
    required this.dependencyLevel,
    required this.status,
    required this.genders,
    required this.bloodTypes,
    required this.mobilityOptions,
    required this.dependencyOptions,
    required this.statusOptions,
    required this.onGenderChanged,
    required this.onBloodTypeChanged,
    required this.onMobilityChanged,
    required this.onDependencyChanged,
    required this.onStatusChanged,
    required this.onPickBirthDate,
    required this.onPickAdmissionDate,
    required this.currentAssignment,
    required this.onAssignBed,
    required this.onReleaseBed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              BedCard(
                assignment: currentAssignment,
                isEditing: isEditing,
                onAssign: onAssignBed,
                onRelease: onReleaseBed,
              ),
              const SizedBox(height: 14),

              PatientSection(title: 'Identificación', rows: [
                PatientFieldRow(
                  label: 'Nombre', controller: firstName,
                  isEditing: isEditing, required: true,
                ),
                PatientFieldRow(
                  label: 'Apellido', controller: lastName,
                  isEditing: isEditing, required: true,
                ),
                PatientFieldRow(
                  label: 'DNI', controller: dni,
                  isEditing: isEditing, required: true,
                  keyboardType: TextInputType.number,
                ),
                PatientFieldRow(
                  label: 'Fecha de nacimiento', controller: birthDate,
                  isEditing: isEditing, isDate: true,
                  onPickDate: onPickBirthDate,
                ),
                PatientDropdownRow(
                  label: 'Género', value: gender,
                  options: genders, isEditing: isEditing,
                  onChanged: onGenderChanged,
                ),
                PatientDropdownRow(
                  label: 'Grupo sanguíneo', value: bloodType,
                  options: bloodTypes, isEditing: isEditing,
                  onChanged: onBloodTypeChanged, isLast: true,
                ),
              ]),

              const SizedBox(height: 14),

              PatientSection(title: 'Internación', rows: [
                PatientFieldRow(
                  label: 'Fecha de ingreso', controller: admissionDate,
                  isEditing: isEditing, isDate: true,
                  onPickDate: onPickAdmissionDate,
                ),
                PatientDropdownRow(
                  label: 'Movilidad', value: mobilityStatus,
                  options: mobilityOptions, isEditing: isEditing,
                  onChanged: onMobilityChanged,
                ),
                PatientDropdownRow(
                  label: 'Dependencia', value: dependencyLevel,
                  options: dependencyOptions, isEditing: isEditing,
                  onChanged: onDependencyChanged,
                ),
                PatientDropdownRow(
                  label: 'Estado', value: status,
                  options: statusOptions, isEditing: isEditing,
                  onChanged: onStatusChanged, isLast: true,
                ),
              ]),

              const SizedBox(height: 14),

              PatientSection(title: 'Contacto y notas', rows: [
                PatientFieldRow(
                  label: 'Tel. de emergencia', controller: emergencyPhone,
                  isEditing: isEditing,
                  keyboardType: TextInputType.phone,
                ),
                PatientFieldRow(
                  label: 'Notas', controller: notes,
                  isEditing: isEditing, maxLines: 3, isLast: true,
                ),
              ]),

              if (!isEditing) ...[
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.error.withValues(alpha: 0.70)),
                    label: Text('Eliminar paciente',
                        style: TextStyle(
                            color: AppColors.error.withValues(alpha: 0.70),
                            fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.25)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

