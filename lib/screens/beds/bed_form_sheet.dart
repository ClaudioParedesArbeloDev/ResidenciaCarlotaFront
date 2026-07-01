import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/bed_model.dart';
import 'package:app_geriatrico/data/models/room_model.dart';
import 'package:app_geriatrico/data/repositories/bed_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';

class BedFormSheet extends StatefulWidget {
  final String token;
  final int institutionId;
  final ApiService api;
  final List<Room> rooms;
  final Bed? existing;
  final VoidCallback onSaved;

  const BedFormSheet({super.key, 
    required this.token,
    required this.institutionId,
    required this.api,
    required this.rooms,
    this.existing,
    required this.onSaved,
  });

  @override
  State<BedFormSheet> createState() => BedFormSheetState();
}

class BedFormSheetState extends State<BedFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bedNumberCtrl = TextEditingController();
  int? _selectedRoomId;
  String _status = 'available';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _bedNumberCtrl.text = widget.existing!.bedNumber;
      _selectedRoomId = widget.existing!.roomId;
      _status = widget.existing!.status;
    } else if (widget.rooms.isNotEmpty) {
      _selectedRoomId = widget.rooms.first.id;
    }
  }

  @override
  void dispose() {
    _bedNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoomId == null) return;
    setState(() => _saving = true);
    final bedRepo = BedRepository(widget.api);
    try {
      final bed = Bed(
        id:        widget.existing?.id ?? 0,
        roomId:    _selectedRoomId!,
        bedNumber: _bedNumberCtrl.text.trim(),
        status:    _status,
      );
      if (widget.existing != null) {
        await bedRepo.update(bed);
      } else {
        await bedRepo.create(bed);
      }
      widget.onSaved();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.error.withValues(alpha: 0.85),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  InputDecoration _deco(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 13),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
        focusedBorder:
            const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error.withValues(alpha: 0.65))),
      );

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: const Color(0xFF2A0825),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(isEdit ? 'Editar cama' : 'Nueva cama',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300,
                          color: Colors.white)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: Colors.white.withValues(alpha: 0.40), size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.06),
                  margin: const EdgeInsets.only(bottom: 20)),
              TextFormField(
                controller: _bedNumberCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo requerido' : null,
                decoration: _deco('Número de cama'),
              ),
              const SizedBox(height: 16),
              widget.rooms.isEmpty
                  ? Text('No hay habitaciones disponibles.',
                      style: TextStyle(
                          color: Colors.orange.withValues(alpha: 0.65), fontSize: 12))
                  : DropdownButtonFormField<int>(
                      initialValue: _selectedRoomId,
                      dropdownColor: const Color(0xFF2A0825),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _deco('Habitación'),
                      items: widget.rooms
                          .map((r) => DropdownMenuItem(
                                value: r.id,
                                child: Text(
                                  'Hab. ${r.number}${r.floor != null ? ' — Piso ${r.floor}' : ''}',
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRoomId = v),
                      validator: (v) => v == null ? 'Seleccioná una habitación' : null,
                    ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                dropdownColor: const Color(0xFF2A0825),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: _deco('Estado'),
                items: const [
                  DropdownMenuItem(value: 'available',   child: Text('Disponible')),
                  DropdownMenuItem(value: 'occupied',    child: Text('Ocupada')),
                  DropdownMenuItem(value: 'maintenance', child: Text('Mantenimiento')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'available'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white54, strokeWidth: 1.5))
                      : Text(isEdit ? 'Guardar cambios' : 'Crear cama',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



