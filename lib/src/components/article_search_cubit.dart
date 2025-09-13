// lib/src/components/article_search_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/Repositories/AppDeps.dart';

class ArticleSearchState {
  final String query;        // lo que el usuario VA ESCRIBIENDO
  final String committed;    // lo que el usuario BUSCÓ (enter/buscar)
  final bool loading;
  final String? error;
  final List<SearchRow> results;

  const ArticleSearchState({
    this.query = '',
    this.committed = '',
    this.loading = false,
    this.error,
    this.results = const [],
  });

  ArticleSearchState copyWith({
    String? query,
    String? committed,
    bool? loading,
    String? error,
    List<SearchRow>? results,
  }) {
    return ArticleSearchState(
      query: query ?? this.query,
      committed: committed ?? this.committed,
      loading: loading ?? this.loading,
      error: error,
      results: results ?? this.results,
    );
  }
}

class SearchRow {
  final String id;
  final String label;
  const SearchRow(this.id, this.label);
}

class ArticleSearchCubit extends Cubit<ArticleSearchState> {
  ArticleSearchCubit() : super(const ArticleSearchState());

  /// Solo guarda lo que se escribe, NO dispara búsqueda
  void setQuery(String q) => emit(state.copyWith(query: q, error: null));

  /// Dispara búsqueda con lo que haya en query (o con [q] si se pasa)
  Future<void> search([String? q]) async {
    final text = (q ?? state.query).trim();
    if (text.isEmpty) {
      // No entres a modo resultados si no hay término confirmado
      emit(state.copyWith(
        committed: '',
        loading: false,
        error: null,
        results: const [],
      ));
      return;
    }

    // marca el término confirmado y muestra loading
    emit(state.copyWith(
      committed: text,
      loading: true,
      error: null,
      results: const [],
    ));

    try {
      // Busca SIEMPRE con 'text' (confirmado)
      final arts = await AppDeps.I.articleRepository.getAllArticlesByWord(text);

      final rows = arts.map<SearchRow>((a) {
        final title = (a.tema?.isNotEmpty ?? false)
            ? a.tema!
            : 'Sin título';
        return SearchRow(a.id ?? '', title);
      }).toList();

      emit(state.copyWith(loading: false, results: rows, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), results: const []));
    }
  }

  /// Limpia TODO (incluye lo confirmado) → vuelve a vista jerárquica
  void clear() {
    emit(state.copyWith(
      query: '',
      committed: '',
      loading: false,
      error: null,
      results: const [],
    ));
  }
}