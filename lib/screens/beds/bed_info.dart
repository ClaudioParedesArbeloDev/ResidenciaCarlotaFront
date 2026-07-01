import 'package:app_geriatrico/data/models/bed_model.dart';

class BedInfo {
  final Bed bed;
  final String? patientName;
  final String? patientGender;
  final String? mobilityStatus;
  final int? assignmentId;   
  final int? patientId;      

  const BedInfo({
    required this.bed,
    this.patientName,
    this.patientGender,
    this.mobilityStatus,
    this.assignmentId,
    this.patientId,
  });
}
