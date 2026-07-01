class AppDateUtils {
  AppDateUtils._();

  static String format(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return '—';
    try {
      final d = DateTime.parse(dateStr).toLocal();
      return '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }


  static String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return '—';
    try {
      final d = DateTime.parse(dateStr).toLocal();
      return '${_pad(d.day)}/${_pad(d.month)}/${d.year} ${_pad(d.hour)}:${_pad(d.minute)}';
    } catch (_) {
      return dateStr;
    }
  }


  static String? toIso(String display) {
    if (display.trim().isEmpty) return null;
    try {
      final parts = display.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${_pad(int.parse(parts[1]))}-${_pad(int.parse(parts[0]))}';
      }
    } catch (_) {}
    return null;
  }

  static DateTime parseOrNow(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateStr).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  static String fromDateTime(DateTime d) {
    return '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
