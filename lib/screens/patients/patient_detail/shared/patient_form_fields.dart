import 'package:flutter/material.dart';
import 'package:app_geriatrico/core/app_colors.dart';
import 'package:app_geriatrico/screens/patients/patient_detail/shared/patient_labels.dart';


class PatientFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool required;
  final bool isDate;
  final bool isLast;
  final TextInputType? keyboardType;
  final int maxLines;
  final VoidCallback? onPickDate;

  const PatientFieldRow({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
    this.required = false,
    this.isDate = false,
    this.isLast = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: isEditing ? _editField() : _readField(),
    );
  }

  Widget _editField() {
    return TextFormField(
      controller: controller,
      keyboardType: isDate ? TextInputType.datetime : keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      readOnly: isDate,
      onTap: isDate ? onPickDate : null,
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
        suffixIcon: isDate
            ? Icon(Icons.calendar_today_outlined,
                size: 15, color: Colors.white.withValues(alpha: 0.30))
            : null,
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white.withValues(alpha: 0.18))),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54)),
        errorBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.error.withValues(alpha: 0.65))),
        errorStyle: TextStyle(
            color: AppColors.error.withValues(alpha: 0.80), fontSize: 11),
      ),
    );
  }

  Widget _readField() {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.38))),
        ),
        Expanded(
          child: Text(
            controller.text.isEmpty ? '—' : controller.text,
            style: TextStyle(
                fontSize: 13,
                color: controller.text.isEmpty
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.80)),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}


class PatientDropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool isEditing;
  final bool isLast;

  const PatientDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.isEditing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16, vertical: isEditing ? 4 : 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: isEditing ? _editDropdown() : _readDropdown(),
    );
  }

  Widget _editDropdown() {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      dropdownColor: const Color(0xFF2A0825),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white.withValues(alpha: 0.18))),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54)),
      ),
      items: options
          .map((o) => DropdownMenuItem(
                value: o.isEmpty ? null : o,
                child: Text(
                  o.isEmpty ? '—' : PatientLabels.of(o),
                  style: TextStyle(
                      color: Colors.white
                          .withValues(alpha: o.isEmpty ? 0.35 : 0.85),
                      fontSize: 13),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _readDropdown() {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.38))),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : PatientLabels.of(value),
            style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.80)),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}


class SheetFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType? keyboard;
  final String? hint;
  final int maxLines;

  const SheetFieldRow({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.keyboard,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        validator: required
            ? (v) =>
                (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.40), fontSize: 12),
          hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.20), fontSize: 12),
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.18))),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54)),
          errorBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.error.withValues(alpha: 0.65))),
          errorStyle: TextStyle(
              color: AppColors.error.withValues(alpha: 0.80), fontSize: 11),
        ),
      ),
    );
  }
}
