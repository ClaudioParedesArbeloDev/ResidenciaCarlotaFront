import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/data/models/medical_study_model.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/repositories/medical_study_repository.dart';
import 'package:app_geriatrico/data/repositories/patient_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';
import 'package:app_geriatrico/screens/clinical/study_card.dart';

class StudiesScreen extends StatefulWidget {
  final String token;
  final int institutionId;

  const StudiesScreen({
    super.key,
    required this.token,
    required this.institutionId,
  });

  @override
  State<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends State<StudiesScreen> {
  late final MedicalStudyRepository _repo;
  late final PatientRepository _patientRepo;

  List<Patient> _patients = [];
  List<MedicalStudy> _studies = [];
  Patient? _selectedPatient;
  bool _loadingPatients = true;
  bool _loadingStudies = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final api = ApiService(
      baseUrl: ApiConfig.baseUrl,
      token: widget.token,
      institutionId: widget.institutionId,
    );
    _repo        = MedicalStudyRepository(api);
    _patientRepo = PatientRepository(api);
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() { _loadingPatients = true; _error = null; });
    try {
      final list = await _patientRepo.getPatients();
      setState(() { _patients = list; _loadingPatients = false; });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loadingPatients = false;
      });
    }
  }

  Future<void> _loadStudies(Patient patient) async {
    setState(() { _loadingStudies = true; _studies = []; _error = null; });
    try {
      final list = await _repo.getByPatient(patient.id);
      setState(() { _studies = list; _loadingStudies = false; });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loadingStudies = false;
      });
    }
  }

  void _selectPatient(Patient p) {
    setState(() => _selectedPatient = p);
    _loadStudies(p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E0619),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E0619),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Estudios',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
      ),
      body: _loadingPatients
          ? const Center(child: CircularProgressIndicator(color: Colors.white38))
          : _error != null && _patients.isEmpty
              ? _errorState(_error!)
              : LayoutBuilder(
                  builder: (ctx, constraints) => constraints.maxWidth > 700
                      ? _desktopLayout()
                      : _mobileLayout(),
                ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        SizedBox(width: 280, child: _patientPanel()),
        const VerticalDivider(width: 1, color: Colors.white10),
        Expanded(child: _studiesPanel()),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        _patientDropdown(),
        Expanded(child: _studiesPanel()),
      ],
    );
  }

  Widget _patientDropdown() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Patient>(
          isExpanded: true,
          hint: Text('Seleccioná un paciente',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 14)),
          value: _selectedPatient,
          dropdownColor: const Color(0xFF2A0825),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: _patients.map((p) => DropdownMenuItem(
            value: p, child: Text('${p.firstName} ${p.lastName}'),
          )).toList(),
          onChanged: (p) { if (p != null) _selectPatient(p); },
        ),
      ),
    );
  }

  Widget _patientPanel() {
    return Container(
      color: const Color(0xFF1A0416),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Pacientes',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11, letterSpacing: 1.5)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _patients.length,
              itemBuilder: (_, i) {
                final p = _patients[i];
                final selected = _selectedPatient?.id == p.id;
                return ListTile(
                  selected: selected,
                  selectedColor: Colors.white,
                  selectedTileColor: Colors.white.withValues(alpha: 0.08),
                  title: Text('${p.firstName} ${p.lastName}',
                      style: TextStyle(fontSize: 13,
                          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.70))),
                  subtitle: Text(p.dni,
                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35))),
                  onTap: () => _selectPatient(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _studiesPanel() {
    if (_selectedPatient == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Seleccioná un paciente para ver sus estudios',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13)),
          ],
        ),
      );
    }
    if (_loadingStudies) {
      return const Center(child: CircularProgressIndicator(color: Colors.white38));
    }
    if (_error != null) return _errorState(_error!);
    if (_studies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Sin estudios registrados',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _studies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) => StudyCard(study: _studies[i]),
    );
  }

  Widget _errorState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error.withValues(alpha: 0.60), size: 40),
          const SizedBox(height: 10),
          Text(msg, textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.50), fontSize: 13)),
          const SizedBox(height: 12),
          TextButton(onPressed: _loadPatients, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

