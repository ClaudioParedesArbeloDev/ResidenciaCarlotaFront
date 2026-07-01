import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';


class PatientSection extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const PatientSection({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 9),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: Colors.white.withValues(alpha: 0.30),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ...rows,
        ],
      ),
    );
  }
}


class PatientEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onReload;

  const PatientEmptyState({
    super.key,
    required this.message,
    required this.icon,
    this.subtitle,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.10), size: 44),
          const SizedBox(height: 10),
          Text(message,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.30), fontSize: 13)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.18), fontSize: 11)),
          ],
          if (onReload != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onReload,
              icon: Icon(Icons.refresh,
                  size: 14, color: Colors.white.withValues(alpha: 0.35)),
              label: Text('Recargar',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35), fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

class PillBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const PillBadge({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.45)),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(
                fontSize: 10.5, color: Colors.white.withValues(alpha: 0.65))),
      ]),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.04))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.35))),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 13,
                  color: value == '—'
                      ? Colors.white.withValues(alpha: 0.20)
                      : Colors.white.withValues(alpha: 0.75)),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}


void showPatientSnack(
  BuildContext context,
  String msg, {
  bool success = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg, style: const TextStyle(fontSize: 13)),
    backgroundColor: success
        ? Colors.green.withValues(alpha: 0.85)
        : AppColors.error.withValues(alpha: 0.85),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ));
}
