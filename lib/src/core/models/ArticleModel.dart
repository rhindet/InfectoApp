// articulo.dart
class ArticleModel {
  final String? id;  // _id en Mongo (ObjectId en hex)
  final String? tema;
  final List<String> subtemas;
  final List<String> contenidos;
  final DateTime? fechaCreacion;     // fecha_creacion
  final DateTime? fechaModificacion;  // fecha_modificacion
  final bool sinCategoria;            // sin_categoria
  final String? refTablaNivel1;       // ref_tabla_nivel1
  final String? refTablaNivel2;       // ref_tabla_nivel2
  final String? refTablaNivel3;       // ref_tabla_nivel3
  final String? refTablaNivel0;       // ref_tabla_nivel0

  const ArticleModel({
    this.id,
    this.tema,
    this.subtemas = const [],
    this.contenidos = const [],
    this.fechaCreacion,
    this.fechaModificacion,
    this.sinCategoria = false,
    this.refTablaNivel1,
    this.refTablaNivel2,
    this.refTablaNivel3,
    this.refTablaNivel0,
  });

  ArticleModel copyWith({
    String? id,
    String? tema,
    List<String>? subtemas,
    List<String>? contenidos,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
    bool? sinCategoria,
    String? refTablaNivel1,
    String? refTablaNivel2,
    String? refTablaNivel3,
    String? refTablaNivel0,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      tema: tema ?? this.tema,
      subtemas: subtemas ?? this.subtemas,
      contenidos: contenidos ?? this.contenidos,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      sinCategoria: sinCategoria ?? this.sinCategoria,
      refTablaNivel1: refTablaNivel1 ?? this.refTablaNivel1,
      refTablaNivel2: refTablaNivel2 ?? this.refTablaNivel2,
      refTablaNivel3: refTablaNivel3 ?? this.refTablaNivel3,
      refTablaNivel0: refTablaNivel0 ?? this.refTablaNivel0,
    );
  }

  /// JSON → Articulo
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      // Si viene como ISO string o timestamp
      if (v is String) return DateTime.tryParse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return null;
    }

    List<String> _strList(dynamic v) {
      if (v is List) {
        return v.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
      }
      return const [];
    }

    return ArticleModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      tema: (json['tema'] ?? '').toString(),
      subtemas: _strList(json['subtemas']),
      contenidos: _strList(json['contenidos']),
      fechaCreacion: _parseDate(json['fecha_creacion']),
      fechaModificacion: _parseDate(json['fecha_modificacion']),
      sinCategoria: json['sin_categoria'] == true,
      refTablaNivel1: json['ref_tabla_nivel1']?.toString(),
      refTablaNivel2: json['ref_tabla_nivel2']?.toString(),
      refTablaNivel3: json['ref_tabla_nivel3']?.toString(),
      refTablaNivel0: json['ref_tabla_nivel0']?.toString(),
    );
  }

  /// Articulo → JSON (con nombres igual que en tu backend)
  Map<String, dynamic> toJson({bool includeId = true}) {
    final map = <String, dynamic>{
      'tema': tema,
      'subtemas': subtemas,
      'contenidos': contenidos,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_modificacion': fechaModificacion?.toIso8601String(),
      'sin_categoria': sinCategoria,
      'ref_tabla_nivel1': refTablaNivel1,
      'ref_tabla_nivel2': refTablaNivel2,
      'ref_tabla_nivel3': refTablaNivel3,
      'ref_tabla_nivel0': refTablaNivel0,
    };
    if (includeId) {
      map['_id'] = id;
    }
    return map;
  }

  // Helpers para listas
  static List<ArticleModel> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return const [];
  }

  static List<Map<String, dynamic>> listToJson(List<ArticleModel> items, {bool includeId = true}) {
    return items.map((e) => e.toJson(includeId: includeId)).toList();
  }

  @override
  String toString() => 'Articulo(id: $id, tema: $tema)';
}