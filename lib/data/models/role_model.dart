class Role {
  final int id;
  final String name;
  final String displayName;

  const Role({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: _parseInt(json['id']),
        name: json['name'] as String,
        displayName: (json['display_name'] as String?) ?? json['name'] as String,
      );

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.parse(v.toString());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
      };

  @override
  bool operator ==(Object other) => other is Role && other.id == id;

  @override
  int get hashCode => id.hashCode;
}