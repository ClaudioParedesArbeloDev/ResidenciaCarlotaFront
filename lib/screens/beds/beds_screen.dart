import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/data/models/patient_model.dart';
import 'package:app_geriatrico/data/models/room_model.dart';
import 'package:app_geriatrico/data/repositories/bed_repository.dart';
import 'package:app_geriatrico/data/repositories/patient_bed_assignment_repository.dart';
import 'package:app_geriatrico/data/repositories/patient_repository.dart';
import 'package:app_geriatrico/data/repositories/room_repository.dart';
import 'package:app_geriatrico/services/api_services.dart';
import 'package:app_geriatrico/screens/beds/bed_info.dart';
import 'package:app_geriatrico/screens/beds/bed_form_sheet.dart';
import 'package:app_geriatrico/screens/beds/rooms_manager_sheet.dart';

class BedsScreen extends StatefulWidget {
  final String token;
  final int institutionId;
  const BedsScreen({super.key, required this.token, required this.institutionId});

  @override
  State<BedsScreen> createState() => _BedsScreenState();
}

class _BedsScreenState extends State<BedsScreen> {
  late final BedRepository _bedRepo;
  late final RoomRepository _roomRepo;
  late final PatientRepository _patientRepo;
  late final PatientBedAssignmentRepository _assignmentRepo;
  late final ApiService _api;

  List<BedInfo> _beds = [];
  List<Room> _rooms = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = ApiService(baseUrl: ApiConfig.baseUrl, token: widget.token, institutionId: widget.institutionId);
    _bedRepo       = BedRepository(_api);
    _roomRepo      = RoomRepository(_api);
    _patientRepo   = PatientRepository(_api);
    _assignmentRepo= PatientBedAssignmentRepository(_api);
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final beds  = await _bedRepo.getAll();
      final rooms = await _roomRepo.getAll();

      final Map<int, Map<String, dynamic>> assignmentByBedId = {};
      try {
        final res = await _api.get('/patient-bed-assignments');
        final List raw = jsonDecode(res.body);
        for (final a in raw) {
          final bedId      = a['bed_id'] as int?;
          final releasedAt = a['released_at'];
          if (bedId != null && releasedAt == null) {
            assignmentByBedId[bedId] = a;
          }
        }
      } catch (_) {}

      final bedInfos = beds.map((b) {
        final assignment = assignmentByBedId[b.id];
        final patient = assignment?['patient'] as Map<String, dynamic>?;
        return BedInfo(
          bed:           b,
          assignmentId:  assignment?['id'] as int?,
          patientId:     patient?['id'] as int?,
          patientName:   patient != null
              ? '${patient['first_name'] ?? ''} ${patient['last_name'] ?? ''}'.trim()
              : null,
          patientGender: patient?['gender'] as String?,
          mobilityStatus:patient?['mobility_status'] as String?,
        );
      }).toList();

      bedInfos.sort((a, b) {
        if (a.bed.isOccupied && !b.bed.isOccupied) return -1;
        if (!a.bed.isOccupied && b.bed.isOccupied) return 1;
        return (a.bed.room?.number ?? '').compareTo(b.bed.room?.number ?? '');
      });

      if (mounted) {
        setState(() {
          _beds    = bedInfos;
          _rooms   = rooms;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
      }
    }
  }

 

  Future<void> _showAssignPatientSheet(BedInfo info) async {
    
    List<Patient> available = [];

    try {
      final all = await _patientRepo.getPatients();
      
      final occupiedPatientIds = _beds
          .where((b) => b.patientId != null)
          .map((b) => b.patientId!)
          .toSet();
      available = all
          .where((p) => p.status == 'active' && !occupiedPatientIds.contains(p.id))
          .toList();
      available.sort((a, b) => a.fullName.compareTo(b.fullName));
    } catch (_) {}

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<Patient> filtered = List.from(available);

        return StatefulBuilder(
          builder: (ctx, setModalState) => Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Color(0xFF2A0825),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.bed_outlined, size: 16,
                            color: Colors.green.withValues(alpha: 0.70)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Asignar paciente',
                              style: const TextStyle(color: Colors.white, fontSize: 15,
                                  fontWeight: FontWeight.w300)),
                          Text('Cama ${info.bed.bedNumber}'
                              '${info.bed.room != null ? ' · Hab. ${info.bed.room!.number}' : ''}',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.40), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Buscador
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: searchCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    onChanged: (q) {
                      setModalState(() {
                        filtered = available
                            .where((p) => p.fullName.toLowerCase().contains(q.toLowerCase())
                                || p.dni.contains(q))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o DNI...',
                      hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25), fontSize: 13),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.white.withValues(alpha: 0.30), size: 18),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
                if (available.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.person_off_outlined,
                            color: Colors.white.withValues(alpha: 0.12), size: 40),
                        const SizedBox(height: 12),
                        Text('No hay pacientes activos sin cama asignada',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.35), fontSize: 13)
                                ),
                      ],
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.45),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        final isFemale = p.gender.toLowerCase() == 'female';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryDark.withValues(alpha: 0.70),
                              child: Text(
                                p.firstName.isNotEmpty ? p.firstName[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                            title: Text(p.fullName,
                                style: const TextStyle(color: Colors.white, fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                            subtitle: Text('DNI: ${p.dni}',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: 11)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFemale ? Icons.female : Icons.male,
                                  size: 14,
                                  color: (isFemale
                                      ? const Color(0xFFE91E9C)
                                      : const Color(0xFF2196F3))
                                      .withValues(alpha: 0.60),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    await _doAssign(info, p);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A1240),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Asignar',
                                      style: TextStyle(fontSize: 12)),
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
      },
    );
  }

  Future<void> _doAssign(BedInfo info, Patient patient) async {
    try {
      await _assignmentRepo.assign(patient.id, info.bed.id);
      _showSnack('${patient.firstName} asignado/a a cama ${info.bed.bedNumber}',
          success: true);
      _load();
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  

  Future<void> _releaseBed(BedInfo info) async {
    if (info.assignmentId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF3A0B32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        title: const Text('¿Dar de alta al paciente?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        content: Text(
          '${info.patientName ?? 'El paciente'} será dado/a de alta de la cama '
          '${info.bed.bedNumber} y la cama quedará disponible.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.60), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.50))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Dar de alta',
                style: TextStyle(color: AppColors.error.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _assignmentRepo.release(info.assignmentId!);
      _showSnack('Cama ${info.bed.bedNumber} liberada', success: true);
      _load();
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showBedForm({BedInfo? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2A0825),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BedFormSheet(
        token: widget.token,
        institutionId: widget.institutionId,
        api: _api,
        rooms: _rooms,
        existing: existing?.bed,
        onSaved: () { Navigator.pop(context); _load(); },
      ),
    );
  }

  Future<void> _confirmDelete(BedInfo info) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF3A0B32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        title: const Text('Eliminar cama',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        content: Text('¿Eliminar cama ${info.bed.bedNumber}?',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.60), fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.50))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar',
                style: TextStyle(color: AppColors.error.withValues(alpha: 0.85))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _bedRepo.delete(info.bed.id);
        _load();
      } catch (e) {
        if (mounted) _showSnack(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 13)),
      backgroundColor: success
          ? Colors.green.withValues(alpha: 0.85)
          : AppColors.error.withValues(alpha: 0.85),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E0619), Color(0xFF2A0825), Color(0xFF1A051A)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildStats(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBedForm(),
        backgroundColor: AppColors.primaryDark,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withValues(alpha: 0.65), size: 17),
            onPressed: () => Navigator.pop(context),
          ),
          const Text('Camas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300,
                  color: Colors.white, letterSpacing: 0.3)),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.meeting_room_outlined,
                color: Colors.white.withValues(alpha: 0.45), size: 19),
            onPressed: _showRoomsManager,
            tooltip: 'Habitaciones',
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: Colors.white.withValues(alpha: 0.45), size: 19),
            onPressed: _load,
          ),
        ],
      ),
    );
  }

  void _showRoomsManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2A0825),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => RoomsManagerSheet(api: _api, rooms: _rooms, onChanged: _load),
    );
  }

  Widget _buildStats() {
    final total    = _beds.length;
    final occupied = _beds.where((b) => b.bed.isOccupied).length;
    final free     = total - occupied;
    final pct      = total > 0 ? (occupied / total * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          _statCard('Total',    total.toString(),    Icons.bed_outlined,      Colors.white38),
          const SizedBox(width: 10),
          _statCard('Ocupadas', occupied.toString(), Icons.person_rounded,    const Color(0xFFEF5350)),
          const SizedBox(width: 10),
          _statCard('Libres',   free.toString(),     Icons.bed_outlined,      Colors.green),
          const SizedBox(width: 10),
          _statCard('Ocupación','$pct%',             Icons.pie_chart_outline, const Color(0xFFFF9800)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: color.withValues(alpha: 0.70)),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, color: color,
                fontWeight: FontWeight.w300)),
            Text(label, style: TextStyle(fontSize: 9,
                color: Colors.white.withValues(alpha: 0.30), letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 1.5));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error.withValues(alpha: 0.50), size: 32),
            const SizedBox(height: 10),
            Text(_error!, textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (_beds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bed_outlined, color: Colors.white.withValues(alpha: 0.12), size: 48),
            const SizedBox(height: 12),
            Text('No hay camas registradas',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.30), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      children: [
        _tableHeader(),
        const SizedBox(height: 4),
        ..._beds.map((b) => _bedRow(b)),
      ],
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _headerCell('Cama',       flex: 1),
          _headerCell('Habitación', flex: 1),
          _headerCell('Paciente',   flex: 2),
          _headerCell('Movilidad',  flex: 2),
          const SizedBox(width: 100),
        ],
      ),
    );
  }

  Widget _headerCell(String label, {int flex = 1}) => Expanded(
        flex: flex,
        child: Text(label.toUpperCase(),
            style: TextStyle(fontSize: 9, letterSpacing: 1.2,
                color: Colors.white.withValues(alpha: 0.28), fontWeight: FontWeight.w500)),
      );

  Widget _bedRow(BedInfo info) {
    final isOccupied = info.bed.isOccupied;
    final statusColor = info.bed.status == 'occupied'
        ? const Color(0xFFEF5350)
        : info.bed.status == 'maintenance'
            ? Colors.orange
            : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isOccupied
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOccupied
              ? Colors.white.withValues(alpha: 0.09)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
           
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withValues(alpha: 0.75)),
                  ),
                  const SizedBox(width: 7),
                  Text(info.bed.bedNumber,
                      style: TextStyle(fontSize: 13,
                          color: Colors.white.withValues(alpha: isOccupied ? 0.85 : 0.45),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            
            Expanded(
              flex: 1,
              child: Text(info.bed.room?.number ?? '—',
                  style: TextStyle(fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.55))),
            ),
            
            Expanded(
              flex: 2,
              child: Text(
                info.patientName ?? (info.bed.status == 'maintenance' ? 'Mantenimiento' : '—'),
                style: TextStyle(fontSize: 12,
                    color: isOccupied
                        ? Colors.white.withValues(alpha: 0.80)
                        : Colors.white.withValues(alpha: 0.22)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            Expanded(
              flex: 2,
              child: info.mobilityStatus != null
                  ? Row(
                      children: [
                        Icon(_mobilityIcon(info.mobilityStatus!),
                            size: 12, color: Colors.white.withValues(alpha: 0.35)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(_mobilityLabel(info.mobilityStatus!),
                              style: TextStyle(fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.50)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )
                  : Text('—',
                      style: TextStyle(fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.20))),
            ),
           
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  if (!isOccupied && info.bed.status == 'available')
                    _actionBtn(
                      icon: Icons.person_add_outlined,
                      color: Colors.green,
                      tooltip: 'Asignar paciente',
                      onTap: () => _showAssignPatientSheet(info),
                    ),
                  
                  if (isOccupied && info.assignmentId != null)
                    _actionBtn(
                      icon: Icons.logout,
                      color: AppColors.error,
                      tooltip: 'Dar de alta',
                      onTap: () => _releaseBed(info),
                    ),
                  
                  _actionBtn(
                    icon: Icons.edit_outlined,
                    color: Colors.white,
                    tooltip: 'Editar',
                    onTap: () => _showBedForm(existing: info),
                  ),
                 
                  if (!isOccupied)
                    _actionBtn(
                      icon: Icons.delete_outline,
                      color: AppColors.error,
                      tooltip: 'Eliminar',
                      onTap: () => _confirmDelete(info),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 16, color: color.withValues(alpha: 0.45)),
        ),
      ),
    );
  }

  IconData _mobilityIcon(String s) {
    switch (s) {
      case 'normal':      return Icons.directions_walk;
      case 'wheelchair':  return Icons.accessible;
      case 'bedridden':   return Icons.hotel;
      default:            return Icons.directions_walk;
    }
  }

  String _mobilityLabel(String s) {
    const map = {
      'normal':     'Normal',
      'reduced':    'Reducida',
      'wheelchair': 'Silla ruedas',
      'bedridden':  'Postrado',
    };
    return map[s] ?? s;
  }
}



