import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/data/models/vital_sign_model.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/repositories/vital_sign_repository.dart';
import 'package:app_geriatrico/data/repositories/patient_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';
import 'package:app_geriatrico/screens/clinical/vital_sign_card.dart';
import 'package:app_geriatrico/screens/clinical/add_vital_sign_sheet.dart';

class VitalSignsScreen extends StatefulWidget {
  final String token;
  final int institutionId;
  final List<String> roles;

  const VitalSignsScreen({
    super.key,
    required this.token,
    required this.institutionId,
    this.roles = const [],
  });

  @override
  State<VitalSignsScreen> createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  late final VitalSignRepository _repo;
  late final PatientRepository _patientRepo;

  List<Patient> _patients = [];
  List<VitalSign> _signs = [];
  Patient? _selectedPatient;
  bool _loadingPatients = true;
  bool _loadingSigns = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final api = ApiService(
      baseUrl: ApiConfig.baseUrl,
      token: widget.token,
      institutionId: widget.institutionId,
    );
    _repo        = VitalSignRepository(api);
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

  Future<void> _loadSigns(Patient patient) async {
    setState(() { _loadingSigns = true; _signs = []; _error = null; });
    try {
      final list = await _repo.getByPatient(patient.id);
      setState(() { _signs = list; _loadingSigns = false; });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loadingSigns = false;
      });
    }
  }

  void _selectPatient(Patient p) {
    setState(() => _selectedPatient = p);
    _loadSigns(p);
  }

  void _showAddSheet() {
    if (_selectedPatient == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddVitalSignSheet(
        patient: _selectedPatient!,
        repo: _repo,
        onSaved: () => _loadSigns(_selectedPatient!),
      ),
    );
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
        title: const Text('Signos Vitales',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
      ),
      floatingActionButton: _selectedPatient != null &&
              widget.roles.any((r) => ['doctor', 'nurse'].contains(r))
          ? FloatingActionButton(
              onPressed: _showAddSheet,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
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
        Expanded(child: _signsPanel()),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        _patientDropdown(),
        Expanded(child: _signsPanel()),
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

  Widget _signsPanel() {
    if (_selectedPatient == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_heart_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Seleccioná un paciente para ver sus signos vitales',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13)),
          ],
        ),
      );
    }
    if (_loadingSigns) {
      return const Center(child: CircularProgressIndicator(color: Colors.white38));
    }
    if (_error != null) return _errorState(_error!);
    if (_signs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_heart_outlined, size: 48, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Sin registros de signos vitales',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 14)),
            const SizedBox(height: 6),
            Text('Tocá + para registrar',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 12)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _signs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) => VitalSignCard(sign: _signs[i]),
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