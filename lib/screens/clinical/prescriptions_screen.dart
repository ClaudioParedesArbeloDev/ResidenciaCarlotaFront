import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/data/models/medical_prescription_model.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/repositories/medical_prescription_repository.dart';
import 'package:app_geriatrico/data/repositories/patient_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';
import 'package:app_geriatrico/screens/clinical/prescription_card.dart';

class PrescriptionsScreen extends StatefulWidget {
  final String token;
  final int institutionId;

  const PrescriptionsScreen({
    super.key,
    required this.token,
    required this.institutionId,
  });

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  late final MedicalPrescriptionRepository _repo;
  late final PatientRepository _patientRepo;

  List<Patient> _patients = [];
  List<MedicalPrescription> _prescriptions = [];
  Patient? _selectedPatient;
  bool _loadingPatients = true;
  bool _loadingPrescriptions = false;
  bool _activeOnly = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final api = ApiService(
      baseUrl: ApiConfig.baseUrl,
      token: widget.token,
      institutionId: widget.institutionId,
    );
    _repo        = MedicalPrescriptionRepository(api);
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

  Future<void> _loadPrescriptions(Patient patient) async {
    setState(() { _loadingPrescriptions = true; _prescriptions = []; _error = null; });
    try {
      final list = await _repo.getByPatient(patient.id, activeOnly: _activeOnly ? true : null);
      setState(() { _prescriptions = list; _loadingPrescriptions = false; });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loadingPrescriptions = false;
      });
    }
  }

  void _selectPatient(Patient p) {
    setState(() => _selectedPatient = p);
    _loadPrescriptions(p);
  }

  void _toggleFilter() {
    setState(() => _activeOnly = !_activeOnly);
    if (_selectedPatient != null) _loadPrescriptions(_selectedPatient!);
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
        title: const Text('Prescripciones',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
        actions: [
          if (_selectedPatient != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(_activeOnly ? 'Activas' : 'Todas',
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                selected: _activeOnly,
                onSelected: (_) => _toggleFilter(),
                selectedColor: AppColors.primary.withValues(alpha: 0.40),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                checkmarkColor: Colors.white,
              ),
            ),
        ],
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
        Expanded(child: _prescriptionsPanel()),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        _patientDropdown(),
        Expanded(child: _prescriptionsPanel()),
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

  Widget _prescriptionsPanel() {
    if (_selectedPatient == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medication_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Seleccioná un paciente para ver sus prescripciones',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13)),
          ],
        ),
      );
    }
    if (_loadingPrescriptions) {
      return const Center(child: CircularProgressIndicator(color: Colors.white38));
    }
    if (_error != null) return _errorState(_error!);
    if (_prescriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medication_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Sin prescripciones ${_activeOnly ? 'activas' : ''}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _prescriptions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) => PrescriptionCard(prescription: _prescriptions[i]),
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

