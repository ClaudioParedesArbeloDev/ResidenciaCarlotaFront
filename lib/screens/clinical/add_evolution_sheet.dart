import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/repositories/patient_evolution_repository.dart';


class AddEvolutionSheet extends StatefulWidget {
  final Patient patient;
  final PatientEvolutionRepository evoRepo;
  final Future<void> Function() onSaved;

  const AddEvolutionSheet({
    super.key,
    required this.patient,
    required this.evoRepo,
    required this.onSaved,
  });

  @override
  State<AddEvolutionSheet> createState() => _AddEvolutionSheetState();
}

class _AddEvolutionSheetState extends State<AddEvolutionSheet> {
  final _formKey  = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  String _type    = 'general';
  bool _saving    = false;

  static const _types = [
    ('general',     'General'),
    ('medical',     'Médica'),
    ('nursing',     'Enfermería'),
    ('kinesiology', 'Kinesiología'),
    ('nutrition',   'Nutrición'),
    ('social',      'Social'),
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.evoRepo.create({
        'patient_id': widget.patient.id,
        'type':       _type,
        'evolution':  _textCtrl.text.trim(),
      });
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(child: Container(width: 36, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Nueva evolución — ${widget.patient.firstName} ${widget.patient.lastName}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
            // Tipo
            DropdownButtonFormField<String>(
              value: _type,
              dropdownColor: const Color(0xFF2A0825),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Tipo',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
              ),
              items: _types.map((t) => DropdownMenuItem(
                value: t.$1,
                child: Text(t.$2),
              )).toList(),
              onChanged: (v) { if (v != null) setState(() => _type = v); },
            ),
            const SizedBox(height: 16),
            // Texto
            TextFormField(
              controller: _textCtrl,
              maxLines: 5,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
              decoration: InputDecoration(
                labelText: 'Evolución *',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.error.withValues(alpha: 0.65))),
              ),
            ),
            const SizedBox(height: 24),
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
                    : const Text('Guardar evolución',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}