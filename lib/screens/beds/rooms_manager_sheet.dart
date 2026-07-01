import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/room_model.dart';
import 'package:app_geriatrico/data/repositories/room_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';

class RoomsManagerSheet extends StatefulWidget {
  final ApiService api;
  final List<Room> rooms;
  final VoidCallback onChanged;

  const RoomsManagerSheet({super.key, required this.api, required this.rooms, required this.onChanged});

  @override
  State<RoomsManagerSheet> createState() => RoomsManagerSheetState();
}

class RoomsManagerSheetState extends State<RoomsManagerSheet> {
  late final RoomRepository _repo;
  late List<Room> _rooms;
  bool _showForm = false;
  Room? _editing;

  final _formKey   = GlobalKey<FormState>();
  final _numberCtrl  = TextEditingController();
  final _nameCtrl    = TextEditingController();
  final _floorCtrl   = TextEditingController();
  final _capacityCtrl= TextEditingController(text: '1');
  String _type = 'shared';
  String _status = 'available';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _repo  = RoomRepository(widget.api);
    _rooms = List.from(widget.rooms);
  }

  @override
  void dispose() {
    _numberCtrl.dispose(); _nameCtrl.dispose();
    _floorCtrl.dispose(); _capacityCtrl.dispose();
    super.dispose();
  }

  void _startCreate() {
    _numberCtrl.clear(); _nameCtrl.clear();
    _floorCtrl.clear(); _capacityCtrl.text = '1';
    setState(() { _type = 'shared'; _status = 'available'; _editing = null; _showForm = true; });
  }

  void _startEdit(Room r) {
    _numberCtrl.text = r.number; _nameCtrl.text = r.name ?? '';
    _floorCtrl.text = r.floor ?? ''; _capacityCtrl.text = r.capacity.toString();
    setState(() { _type = r.type; _status = r.status; _editing = r; _showForm = true; });
  }

  void _cancelForm() {
    setState(() => _showForm = false);
    _numberCtrl.clear(); _nameCtrl.clear();
    _floorCtrl.clear(); _capacityCtrl.text = '1';
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final room = Room(
        id: _editing?.id ?? 0,
        number: _numberCtrl.text.trim(),
        name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        floor: _floorCtrl.text.trim().isEmpty ? null : _floorCtrl.text.trim(),
        capacity: int.tryParse(_capacityCtrl.text.trim()) ?? 1,
        type: _type, status: _status,
      );
      if (_editing != null) { await _repo.update(room); } else { await _repo.create(room); }
      final updated = await _repo.getAll();
      setState(() { _rooms = updated; _showForm = false; _saving = false; });
      _cancelForm();
      widget.onChanged();
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

  Future<void> _deleteRoom(Room r) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF3A0B32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.10))),
        title: const Text('Eliminar habitación',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        content: Text('¿Eliminar habitación ${r.number}?',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.60), fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.50)))),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text('Eliminar',
                  style: TextStyle(color: AppColors.error.withValues(alpha: 0.85)))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _repo.delete(r.id);
      final updated = await _repo.getAll();
      setState(() => _rooms = updated);
      widget.onChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.error.withValues(alpha: 0.85),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error.withValues(alpha: 0.65))),
        errorStyle: TextStyle(color: AppColors.error.withValues(alpha: 0.80), fontSize: 11),
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A0825),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
              child: Row(
                children: [
                  Icon(Icons.meeting_room_outlined, size: 17,
                      color: Colors.white.withValues(alpha: 0.45)),
                  const SizedBox(width: 8),
                  const Text('Habitaciones',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,
                          color: Colors.white)),
                  const Spacer(),
                  if (!_showForm)
                    TextButton.icon(
                      onPressed: _startCreate,
                      icon: Icon(Icons.add_rounded, size: 15,
                          color: Colors.white.withValues(alpha: 0.65)),
                      label: Text('Nueva',
                          style: TextStyle(fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.65))),
                    ),
                ],
              ),
            ),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
            if (_showForm)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_editing != null ? 'Editar habitación' : 'Nueva habitación',
                          style: TextStyle(fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.35), letterSpacing: 1.2)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2,
                              child: TextFormField(
                                controller: _numberCtrl,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                                decoration: _inputDeco('Número de habitación *'),
                              )),
                          const SizedBox(width: 12),
                          Expanded(flex: 1,
                              child: TextFormField(
                                controller: _floorCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: _inputDeco('Piso'),
                              )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2,
                              child: TextFormField(
                                controller: _nameCtrl,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: _inputDeco('Nombre (opcional)'),
                              )),
                          const SizedBox(width: 12),
                          Expanded(flex: 1,
                              child: TextFormField(
                                controller: _capacityCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Requerido';
                                  if ((int.tryParse(v) ?? 0) < 1) return 'Min. 1';
                                  return null;
                                },
                                decoration: _inputDeco('Capacidad *'),
                              )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _type,
                                dropdownColor: const Color(0xFF2A0825),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _inputDeco('Tipo'),
                                items: const [
                                  DropdownMenuItem(value: 'shared',  child: Text('Compartida')),
                                  DropdownMenuItem(value: 'private', child: Text('Privada')),
                                ],
                                onChanged: (v) => setState(() => _type = v ?? 'shared'),
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _status,
                                dropdownColor: const Color(0xFF2A0825),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _inputDeco('Estado'),
                                items: const [
                                  DropdownMenuItem(value: 'available',    child: Text('Disponible')),
                                  DropdownMenuItem(value: 'maintenance',  child: Text('Mantenimiento')),
                                  DropdownMenuItem(value: 'inactive',     child: Text('Inactiva')),
                                ],
                                onChanged: (v) => setState(() => _status = v ?? 'available'),
                              )),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelForm,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white.withValues(alpha: 0.50),
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Cancelar', style: TextStyle(fontSize: 13)),
                              )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                                onPressed: _saving ? null : _saveRoom,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryDark,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _saving
                                    ? const SizedBox(width: 16, height: 16,
                                        child: CircularProgressIndicator(
                                            color: Colors.white54, strokeWidth: 1.5))
                                    : Text(_editing != null ? 'Guardar' : 'Crear',
                                        style: const TextStyle(fontSize: 13)),
                              )),
                        ],
                      ),
                      Container(height: 1, color: Colors.white.withValues(alpha: 0.06),
                          margin: const EdgeInsets.only(top: 14)),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: _rooms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.meeting_room_outlined, size: 40,
                              color: Colors.white.withValues(alpha: 0.10)),
                          const SizedBox(height: 10),
                          Text('No hay habitaciones todavía',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.30), fontSize: 13)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _startCreate,
                            child: Text('Crear la primera',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.50), fontSize: 12)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: _rooms.length,
                      itemBuilder: (ctx, i) {
                        final r = _rooms[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark.withValues(alpha: 0.60),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.meeting_room_outlined, size: 16,
                                  color: Colors.white.withValues(alpha: 0.60)),
                            ),
                            title: Text('Hab. ${r.number}',
                                style: const TextStyle(color: Colors.white, fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                            subtitle: r.floor != null
                                ? Text('Piso ${r.floor}',
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.35),
                                        fontSize: 11))
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _startEdit(r),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.edit_outlined, size: 15,
                                        color: Colors.white.withValues(alpha: 0.35)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _deleteRoom(r),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.delete_outline, size: 15,
                                        color: AppColors.error.withValues(alpha: 0.35)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
