// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:app_geriatrico/data/models/patient_contact_model.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/tabs/contact_card.dart';

class ContactTab extends StatelessWidget {
  final List<PatientContact> contacts;
  final VoidCallback onAdd;
  final void Function(PatientContact) onEdit;
  final void Function(PatientContact) onSetPrimary;
  final void Function(PatientContact) onDelete;

  const ContactTab({
    super.key,
    required this.contacts,
    required this.onAdd,
    required this.onEdit,
    required this.onSetPrimary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        contacts.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.family_restroom_outlined,
                        color: Colors.white.withValues(alpha: 0.12), size: 48),
                    const SizedBox(height: 12),
                    Text('Sin familiares registrados',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 13)),
                    const SizedBox(height: 6),
                    Text('Tocá + para agregar un familiar a cargo',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.20),
                            fontSize: 11)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: contacts.length,
                itemBuilder: (context, i) => ContactCard(
                  contact: contacts[i],
                  onEdit: onEdit,
                  onSetPrimary: onSetPrimary,
                  onDelete: onDelete,
                ),
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'fab_contact',
            backgroundColor: const Color(0xFF4A1240),
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: onAdd,
            child: const Icon(Icons.person_add_outlined, size: 22),
          ),
        ),
      ],
    );
  }
}


