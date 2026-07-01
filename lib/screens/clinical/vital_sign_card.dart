import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/date_utils.dart';
import 'package:app_geriatrico/data/models/vital_sign_model.dart';

class VitalSignCard extends StatelessWidget {
  final VitalSign sign;
  const VitalSignCard({super.key, required this.sign});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                const Icon(Icons.monitor_heart_outlined, size: 15, color: Color(0xFFB55B5B)),
                const SizedBox(width: 8),
                Text('Signos Vitales',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                if (sign.recordedAt != null)
                  Text(AppDateUtils.formatDateTime(sign.recordedAt),
                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    if (sign.bloodPressure != null)
                      _Metric('PA', sign.bloodPressure!, 'mmHg', Icons.favorite_outline_rounded),
                    if (sign.heartRate != null)
                      _Metric('FC', '${sign.heartRate}', 'lpm', Icons.monitor_heart_outlined),
                    if (sign.temperature != null)
                      _Metric('Temp', '${sign.temperature}', '°C', Icons.thermostat_rounded),
                    if (sign.oxygenSaturation != null)
                      _Metric('SatO₂', '${sign.oxygenSaturation}', '%', Icons.air_rounded),
                  ],
                ),
                if (sign.bloodGlucose != null || sign.weight != null || sign.respiratoryRate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (sign.bloodGlucose != null)
                        _Metric('Glucemia', '${sign.bloodGlucose}', 'mg/dL', Icons.water_drop_outlined),
                      if (sign.weight != null)
                        _Metric('Peso', '${sign.weight}', 'kg', Icons.scale_outlined),
                      if (sign.respiratoryRate != null)
                        _Metric('FR', '${sign.respiratoryRate}', 'rpm', Icons.air_outlined),
                    ],
                  ),
                ],
                if (sign.notes != null && sign.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(sign.notes!,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.50), fontSize: 12)),
                  ),
                ],
                if (sign.registeredBy != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 12, color: Colors.white.withValues(alpha: 0.30)),
                        const SizedBox(width: 4),
                        Text('${sign.registeredBy!.name} ${sign.registeredBy!.lastName ?? ''}',
                            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.38))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _Metric(this.label, this.value, this.unit, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.35)),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.40),
                    letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            Text(unit, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.30))),
          ],
        ),
      ),
    );
  }
}

