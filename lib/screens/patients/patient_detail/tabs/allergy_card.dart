import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/data/models/allergy_model.dart';

class AllergyCard extends StatelessWidget {
  final Allergy allergy;
  final void Function(Allergy) onEdit;
  final void Function(Allergy) onDelete;
  final Color severityColor;

  const AllergyCard({super.key, 
    required this.allergy,
    required this.onEdit,
    required this.onDelete,
    required this.severityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withValues(alpha: 0.25)),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: severityColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.warning_amber_outlined,
              size: 18, color: severityColor.withValues(alpha: 0.80)),
        ),
        title: Text(allergy.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(allergy.severityLabel,
                    style: TextStyle(
                        fontSize: 10,
                        color: severityColor.withValues(alpha: 0.90))),
              ),
            ]),
            if (allergy.reaction != null && allergy.reaction!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text('Reacción: ${allergy.reaction}',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.45))),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => onEdit(allergy),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.edit_outlined,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.35)),
              ),
            ),
            InkWell(
              onTap: () => onDelete(allergy),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.delete_outline,
                    size: 15,
                    color: AppColors.error.withValues(alpha: 0.40)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
