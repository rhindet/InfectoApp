// lib/src/components/article_search_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/Repositories/AppDeps.dart';

class ArticleSearchState {
  final String query;
  final bool loading;
  final String? error;
  final List<SearchRow> results;

  const ArticleSearchState({
    this.query = '',
    this.loading = false,
    this.error,
    this.results = const [],
  });

  ArticleSearchState copyWith({
    String? query,
    bool? loading,
    String? error,
    List<SearchRow>? results,
  }) {
    return ArticleSearchState(
      query: query ?? this.query,
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

  void setQuery(String q) => emit(state.copyWith(query: q, error: null));

  Future<void> search([String? q]) async {
    final text = (q ?? state.query).trim();
    if (text.isEmpty) {
      emit(state.copyWith(loading: false, error: null, results: const []));
      return;
    }

    emit(state.copyWith(loading: true, error: null));
    try {
      // Usa el que tengas implementado, pero SIEMPRE con 'text'
      // final arts = await AppDeps.I.articleRepository.getAllArticle(text);
      print("aaaaaaasasaasasasasa");
      final arts = await AppDeps.I.articleRepository.getAllArticlesByWord(text); // 👈 CORREGIDO

      final rows = arts.map<SearchRow>((a) {
        final title = (a.tema?.isNotEmpty ?? false)
            ? a.tema!
            : (a.tema?.isNotEmpty ?? false)
            ? a.tema!
            : 'Sin título';
        return SearchRow(a.id ?? '', title);
      }).toList();

      emit(state.copyWith(loading: false, results: rows, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), results: const []));
    }
  }
  void clear() {
    // deja todo limpio para que GuiaView NO entre al modo "resultados"
    emit(state.copyWith(
      query: '',
      loading: false,
      error: null,
      results: const [],
    ));
  }

}