
abstract class PatientLabels {
  static const _map = {
    'female':     'Femenino',
    'male':       'Masculino',
    'other':      'Otro',
    'normal':     'Normal',
    'reduced':    'Reducida',
    'wheelchair': 'Silla de ruedas',
    'bedridden':  'Postrado',
    'low':        'Dependencia baja',
    'medium':     'Dependencia media',
    'high':       'Dependencia alta',
    'active':     'Activo',
    'inactive':   'Inactivo',
    'deceased':   'Fallecido',
  };

  static String of(String key) => _map[key] ?? key;
}
