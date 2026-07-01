import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/repositories/vital_sign_repository.dart';


class AddVitalSignSheet extends StatefulWidget {
  final Patient patient;
  final VitalSignRepository repo;
  final Future<void> Function() onSaved;

  const AddVitalSignSheet({super.key, 
    required this.patient,
    required this.repo,
    required this.onSaved,
  });

  @override
  State<AddVitalSignSheet> createState() => _AddVitalSignSheetState();
}

class _AddVitalSignSheetState extends State<AddVitalSignSheet> {
  final _formKey     = GlobalKey<FormState>();
  final _sysCtrl     = TextEditingController();
  final _diaCtrl     = TextEditingController();
  final _hrCtrl      = TextEditingController();
  final _tempCtrl    = TextEditingController();
  final _satCtrl     = TextEditingController();
  final _glucoseCtrl = TextEditingController();
  final _weightCtrl  = TextEditingController();
  final _rrCtrl      = TextEditingController();
  final _notesCtrl   = TextEditingController();
  bool _saving       = false;

  @override
  void dispose() {
    for (final c in [_sysCtrl, _diaCtrl, _hrCtrl, _tempCtrl, _satCtrl,
                     _glucoseCtrl, _weightCtrl, _rrCtrl, _notesCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = <String, dynamic>{'patient_id': widget.patient.id};
    if (_sysCtrl.text.isNotEmpty)     data['blood_pressure_systolic']  = int.tryParse(_sysCtrl.text);
    if (_diaCtrl.text.isNotEmpty)     data['blood_pressure_diastolic'] = int.tryParse(_diaCtrl.text);
    if (_hrCtrl.text.isNotEmpty)      data['heart_rate']               = int.tryParse(_hrCtrl.text);
    if (_tempCtrl.text.isNotEmpty)    data['temperature']              = double.tryParse(_tempCtrl.text);
    if (_satCtrl.text.isNotEmpty)     data['oxygen_saturation']        = double.tryParse(_satCtrl.text);
    if (_glucoseCtrl.text.isNotEmpty) data['blood_glucose']            = int.tryParse(_glucoseCtrl.text);
    if (_weightCtrl.text.isNotEmpty)  data['weight']                   = double.tryParse(_weightCtrl.text);
    if (_rrCtrl.text.isNotEmpty)      data['respiratory_rate']         = int.tryParse(_rrCtrl.text);
    if (_notesCtrl.text.isNotEmpty)   data['notes']                    = _notesCtrl.text.trim();

    if (data.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá al menos un valor')));
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.repo.create(data);
      await widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.error,
        ));
        setState(() => _saving = false);
      }
    }
  }

  Widget _numField(String label, TextEditingController ctrl, {bool decimal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      decoration: BoxDecoration(
        color: const Color(0xFF2A0825),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Signos Vitales — ${widget.patient.firstName} ${widget.patient.lastName}',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Text('Completá los campos que correspondan',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12)),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _numField('PA sistólica (mmHg)', _sysCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _numField('PA diastólica (mmHg)', _diaCtrl)),
              ]),
              Row(children: [
                Expanded(child: _numField('Frec. cardíaca (lpm)', _hrCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _numField('Temperatura (°C)', _tempCtrl, decimal: true)),
              ]),
              Row(children: [
                Expanded(child: _numField('SatO₂ (%)', _satCtrl, decimal: true)),
                const SizedBox(width: 12),
                Expanded(child: _numField('Glucemia (mg/dL)', _glucoseCtrl)),
              ]),
              Row(children: [
                Expanded(child: _numField('Peso (kg)', _weightCtrl, decimal: true)),
                const SizedBox(width: 12),
                Expanded(child: _numField('Frec. resp. (rpm)', _rrCtrl)),
              ]),
              _numField('Observaciones', _notesCtrl),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(height: 18, width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Guardar registro',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
