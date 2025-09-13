// lib/src/components/article_filter_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

/// Estado del filtro local de artículos (no llama backend).
class ArticleFilterState {
  /// Texto de búsqueda actual.
  final String query;

  /// Fuente completa (lo que tu UI cargó para el nivel actual).
  final List<FilterRow> all;

  /// Resultado filtrado según [query] y [matchAll].
  final List<FilterRow> filtered;

  /// true = AND (todas las palabras), false = OR (cualquier palabra).
  final bool matchAll;

  const ArticleFilterState({
    this.query = '',
    this.all = const [],
    this.filtered = const [],
    this.matchAll = false,
  });

  ArticleFilterState copyWith({
    String? query,
    List<FilterRow>? all,
    List<FilterRow>? filtered,
    bool? matchAll,
  }) {
    return ArticleFilterState(
      query: query ?? this.query,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      matchAll: matchAll ?? this.matchAll,
    );
  }
}

/// Fila simple para filtrar (id + label).
class FilterRow {
  final String id;
  final String label;
  const FilterRow(this.id, this.label);
}

/// Cubit de filtro en memoria (case/accent-insensitive).
class ArticleFilterCubit extends Cubit<ArticleFilterState> {
  ArticleFilterCubit() : super(const ArticleFilterState());

  // Normaliza: minúsculas y sin acentos/ñ.
  String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[áàäâ]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöô]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll('ñ', 'n');

  /// Alimenta la fuente completa (lista visible del nivel actual).
  /// Aplica el filtro vigente (query + matchAll) sobre [rows].
  void setAll(List<FilterRow> rows) {
    final filtered = _apply(state.query, rows, state.matchAll);
    emit(state.copyWith(all: rows, filtered: filtered));
  }

  /// Actualiza el texto de búsqueda (no toca backend).
  void updateQuery(String q) {
    final filtered = _apply(q, state.all, state.matchAll);
    emit(state.copyWith(query: q, filtered: filtered));
  }

  /// Cambia el modo: AND (todas) vs OR (cualquiera).
  void setMatchAll(bool v) {
    final filtered = _apply(state.query, state.all, v);
    emit(state.copyWith(matchAll: v, filtered: filtered));
  }

  /// Aplica el filtro por palabras separadas por espacio.
  /// - OR: coincide si cualquier token aparece en id o label.
  /// - AND: coincide si todos los tokens aparecen.
  List<FilterRow> _apply(String q, List<FilterRow> src, bool matchAll) {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return src;

    final tokens = trimmed
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map(_norm)
        .toList();

    if (tokens.isEmpty) return src;

    return src.where((row) {
      final haystack = '${_norm(row.id)} ${_norm(row.label)}';
      return matchAll
          ? tokens.every(haystack.contains)
          : tokens.any(haystack.contains);
    }).toList(growable: false);
  }

  /// Restaura el estado inicial.
  void clear() => emit(const ArticleFilterState());
}