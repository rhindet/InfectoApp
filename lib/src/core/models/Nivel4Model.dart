class Nivel4Model {
  final String id; // _id de Mongo
  final String nombre;
  final DateTime? fechaCreacion;
  final DateTime? fechaModificacion;

  const Nivel4Model({
    required this.id,
    required this.nombre,
    this.fechaCreacion,
    this.fechaModificacion,
  });

  factory Nivel4Model.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) {
      if (v == null || v.toString().isEmpty) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return null;
    }

    return Nivel4Model(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      fechaCreacion: _parseDate(json['fecha_creacion']),
      fechaModificacion: _parseDate(json['fecha_modificacion']),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final map = <String, dynamic>{
      'nombre': nombre,
      'fecha_creacion': fechaCreacion?.toIso8601String() ?? '',
      'fecha_modificacion': fechaModificacion?.toIso8601String() ?? '',
    };
    if (includeId) {
      map['_id'] = id;
    }
    return map;
  }

  static List<Nivel4Model> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => Nivel4Model.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return const [];
  }

  static List<Map<String, dynamic>> listToJson(List<Nivel4Model> items, {bool includeId = true}) {
    return items.map((e) => e.toJson(includeId: includeId)).toList();
  }

  @override
  String toString() => 'Nivel(id: $id, nombre: $nombre)';
}