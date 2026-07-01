import 'package:app_geriatrico/data/models/employee_model.dart';

class VitalSign {
  final int id;
  final int patientId;

  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final int? heartRate;
  final double? temperature;
  final double? oxygenSaturation;
  final int? bloodGlucose;
  final double? weight;
  final int? respiratoryRate;

  final String? notes;
  final String? recordedAt;

  final Employee? registeredBy;

  const VitalSign({
    required this.id,
    required this.patientId,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.oxygenSaturation,
    this.bloodGlucose,
    this.weight,
    this.respiratoryRate,
    this.notes,
    this.recordedAt,
    this.registeredBy,
  });

  String? get bloodPressure {
    if (bloodPressureSystolic != null && bloodPressureDiastolic != null) {
      return '$bloodPressureSystolic/$bloodPressureDiastolic';
    }
    return null;
  }

  factory VitalSign.fromJson(Map<String, dynamic> json) {
    return VitalSign(
      id:        _parseInt(json['id'])!,
      patientId: _parseInt(json['patient_id'])!,
      bloodPressureSystolic:  _parseInt(json['blood_pressure_systolic']),
      bloodPressureDiastolic: _parseInt(json['blood_pressure_diastolic']),
      heartRate:        _parseInt(json['heart_rate']),
      temperature:      _parseDouble(json['temperature']),
      oxygenSaturation: _parseDouble(json['oxygen_saturation']),
      bloodGlucose:     _parseInt(json['blood_glucose']),
      weight:           _parseDouble(json['weight']),
      respiratoryRate:  _parseInt(json['respiratory_rate']),
      notes:      json['notes'] as String?,
      recordedAt: json['recorded_at'] as String?,
      registeredBy: json['registered_by'] != null
          ? Employee.fromJson(json['registered_by'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'patient_id': patientId,
        if (bloodPressureSystolic != null)
          'blood_pressure_systolic': bloodPressureSystolic,
        if (bloodPressureDiastolic != null)
          'blood_pressure_diastolic': bloodPressureDiastolic,
        if (heartRate != null)        'heart_rate': heartRate,
        if (temperature != null)      'temperature': temperature,
        if (oxygenSaturation != null) 'oxygen_saturation': oxygenSaturation,
        if (bloodGlucose != null)     'blood_glucose': bloodGlucose,
        if (weight != null)           'weight': weight,
        if (respiratoryRate != null)  'respiratory_rate': respiratoryRate,
        if (notes != null)            'notes': notes,
        if (recordedAt != null)       'recorded_at': recordedAt,
      };


  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}