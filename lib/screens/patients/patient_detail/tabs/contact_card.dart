import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/patient_contact_model.dart';

class ContactCard extends StatelessWidget {
  final PatientContact contact;
  final void Function(PatientContact) onEdit;
  final void Function(PatientContact) onSetPrimary;
  final void Function(PatientContact) onDelete;

  const ContactCard({super.key, 
    required this.contact,
    required this.onEdit,
    required this.onSetPrimary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = contact;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: c.isPrimary
              ? Colors.amber.withValues(alpha: 0.30)
              : Colors.white.withValues(alpha: 0.09),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryDark.withValues(alpha: 0.70),
                  child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(c.fullName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        if (c.isPrimary) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.star_rounded,
                              size: 13,
                              color: Colors.amber.withValues(alpha: 0.70)),
                        ],
                      ]),
                      if (c.relationship != null)
                        Text(c.relationship!,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.40),
                                fontSize: 11)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      size: 18, color: Colors.white.withValues(alpha: 0.35)),
                  color: const Color(0xFF3A0B32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  onSelected: (action) {
                    if (action == 'edit')    onEdit(c);
                    if (action == 'primary') onSetPrimary(c);
                    if (action == 'delete')  onDelete(c);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.60)),
                        const SizedBox(width: 10),
                        Text('Editar',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 13)),
                      ]),
                    ),
                    if (!c.isPrimary)
                      PopupMenuItem(
                        value: 'primary',
                        child: Row(children: [
                          Icon(Icons.star_border_rounded,
                              size: 15,
                              color: Colors.amber.withValues(alpha: 0.60)),
                          const SizedBox(width: 10),
                          Text('Marcar como responsable',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.80),
                                  fontSize: 13)),
                        ]),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline,
                            size: 15,
                            color: AppColors.error.withValues(alpha: 0.70)),
                        const SizedBox(width: 10),
                        Text('Eliminar',
                            style: TextStyle(
                                color: AppColors.error.withValues(alpha: 0.80),
                                fontSize: 13)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          InfoRow(label: 'Teléfono', value: c.phone),
          if (c.dni != null)     InfoRow(label: 'DNI',       value: c.dni!),
          if (c.email != null)   InfoRow(label: 'Email',     value: c.email!),
          if (c.address != null) InfoRow(label: 'Dirección', value: c.address!, isLast: true),
          if (c.address == null && c.email == null && c.dni == null)
            InfoRow(label: '', value: '', isLast: true),
        ],
      ),
    );
  }
}