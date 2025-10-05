import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import '../components/article_search_cubit.dart';
import '../core/Repositories/AppDeps.dart';
import '../core/models/ArticleModel.dart';
import '../utils/highlight.dart';

/// --------- Estado de navegación (0..5 niveles) ----------
class GuiaState {
  final bool isArticleMode;
  final int level; // 0..5  (5 = detalle de artículo)
  final String? key0; final String? title0;
  final String? key1; final String? title1;
  final String? key2; final String? title2;
  final String? key3; final String? title3;

  // Nivel 5 (detalle de artículo)
  final String? articleId;
  final String? articleTitle;

  final bool showArticleDetail;

  const GuiaState({
    this.level = 0,
    this.key0, this.title0,
    this.key1, this.title1,
    this.key2, this.title2,
    this.key3, this.title3,
    this.articleId,
    this.articleTitle,
    this.showArticleDetail = false,
    this.isArticleMode = false,
  });

  GuiaState copyWith({
    int? level,
    String? key0, String? title0,
    String? key1, String? title1,
    String? key2, String? title2,
    String? key3, String? title3,
    String? articleId,
    String? articleTitle,
    bool? showArticleDetail,
    bool? isArticleMode,
  }) => GuiaState(
    level: level ?? this.level,
    key0: key0 ?? this.key0, title0: title0 ?? this.title0,
    key1: key1 ?? this.key1, title1: title1 ?? this.title1,
    key2: key2 ?? this.key2, title2: title2 ?? this.title2,
    key3: key3 ?? this.key3, title3: title3 ?? this.title3,
    articleId: articleId ?? this.articleId,
    articleTitle: articleTitle ?? this.articleTitle,
    showArticleDetail: showArticleDetail ?? this.showArticleDetail,
    isArticleMode: isArticleMode ?? this.isArticleMode,
  );

  GuiaState toLevel0() => const GuiaState(level: 0);

  GuiaState toLevel1({required String key0, required String title0}) =>
      GuiaState(level: 1, key0: key0, title0: title0);

  GuiaState toLevel2({
    required String key0, required String title0,
    required String key1, required String title1,
  }) => GuiaState(
    level: 2,
    key0: key0, title0: title0,
    key1: key1, title1: title1,
  );

  GuiaState toLevel3({
    required String key0, required String title0,
    required String key1, required String title1,
    required String key2, required String title2,
  }) => GuiaState(
    level: 3,
    key0: key0, title0: title0,
    key1: key1, title1: title1,
    key2: key2, title2: title2,
  );

  GuiaState toLevel4({
    required String key0, required String title0,
    required String key1, required String title1,
    required String key2, required String title2,
    required String key3, required String title3,
  }) => GuiaState(
    level: 4,
    key0: key0, title0: title0,
    key1: key1, title1: title1,
    key2: key2, title2: title2,
    key3: key3, title3: title3,
  );

  /// Nuevo: Nivel 5 (detalle de artículo)
  GuiaState toLevel5({
    required String key0, required String title0,
    required String key1, required String title1,
    required String key2, required String title2,
    required String key3, required String title3,
    required String articleId,
    required String articleTitle,
  }) => GuiaState(
    level: 5,
    key0: key0, title0: title0,
    key1: key1, title1: title1,
    key2: key2, title2: title2,
    key3: key3, title3: title3,
    articleId: articleId,
    articleTitle: articleTitle,
  );

  GuiaState showArticle({required String articleId, required String articleTitle}) =>
      GuiaState(
        level: level,
        key0: key0, title0: title0,
        key1: key1, title1: title1,
        key2: key2, title2: title2,
        key3: key3, title3: title3,
        articleId: articleId,
        articleTitle: articleTitle,
        showArticleDetail: true,
      );

  GuiaState hideArticle() => GuiaState(
    level: level,
    key0: key0, title0: title0,
    key1: key1, title1: title1,
    key2: key2, title2: title2,
    key3: key3, title3: title3,
    articleId: null,
    articleTitle: null,
    showArticleDetail: false,
  );
}

/// Cubit para manejar navegación
class GuiaSectionCubit extends Cubit<GuiaState> {
  GuiaSectionCubit({
    this.exitToParentWhenBackFromLevel1 = false,
    this.onExit,
  }) : super(const GuiaState());

  final bool exitToParentWhenBackFromLevel1;
  final VoidCallback? onExit;

  void openLevel1({required String key0, required String title0}) =>
      emit(state.toLevel1(key0: key0, title0: title0));

  void openLevel2({required String key1, required String title1}) =>
      emit(state.toLevel2(
        key0: state.key0!, title0: state.title0!,
        key1: key1, title1: title1,
      ));

  void openLevel3({required String key2, required String title2}) =>
      emit(state.toLevel3(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
        key2: key2,        title2: title2,
      ));

  void openLevel4({required String key3, required String title3}) =>
      emit(state.toLevel4(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
        key2: state.key2!, title2: state.title2!,
        key3: key3,        title3: title3, // ✅ FIX: pasar el argumento, no state.title3!
      ));

  /// Nuevo: abrir detalle de artículo (nivel 5)
  void openArticle({required String articleId, required String articleTitle}) =>
      emit(state.toLevel5(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
        key2: state.key2!, title2: state.title2!,
        key3: state.key3!, title3: state.title3!,
        articleId: articleId,
        articleTitle: articleTitle,
      ));

  void showArticle({required String articleId, required String articleTitle}) =>
      emit(state.showArticle(articleId: articleId, articleTitle: articleTitle));

  void hideArticle() => emit(state.hideArticle());

  void back() {
    if (state.showArticleDetail) {
      emit(state.hideArticle().copyWith(isArticleMode: false));
      return;
    }

    if (state.level == 4) {
      emit(
        state
            .toLevel3(
          key0: state.key0!, title0: state.title0!,
          key1: state.key1!, title1: state.title1!,
          key2: state.key2!, title2: state.title2!,
        )
            .copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 3) {
      emit(
        state
            .toLevel2(
          key0: state.key0!, title0: state.title0!,
          key1: state.key1!, title1: state.title1!,
        )
            .copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 2) {
      emit(
        state
            .toLevel1(key0: state.key0!, title0: state.title0!)
            .copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 1) {
      // Si venimos desde InicioView y queremos volver allí, dispara el callback
      if (exitToParentWhenBackFromLevel1 && onExit != null) {
        onExit!();
        return;
      }
      // Comportamiento normal: volver a nivel 0 dentro de la guía
      emit(state.toLevel0().copyWith(isArticleMode: false));
      return;
    }

    // En nivel 0 no hacemos nada aquí (lo maneja el Navigator/WillPopScope)
  }
}

/// Fila plana para UI (para los niveles listados)
class GuiaRow {
  final String id;
  final String label;
  final IconData icon;
  final bool isArticle;

  const GuiaRow({
    required this.id,
    required this.label,
    required this.icon,
    required this.isArticle,
  });
}

class GuiaView extends StatelessWidget {
  final String? initialKey0;
  final String? initialTitle0;
  final bool exitToParentWhenBackFromLevel1;
  final VoidCallback? onExit;

  GuiaView({
    super.key,
    this.initialKey0,
    this.initialTitle0,
    this.exitToParentWhenBackFromLevel1 = false,
    this.onExit,
  });
  bool isArticleMode = false;

  final Map<String, IconData> _iconos = const {
    'farmacos': Icons.medical_services,
    'patogenos': Icons.healing,
    'sindromes': Icons.health_and_safety,
    'prevencion y control de infecciones': Icons.ac_unit,
  };

  IconData _iconForLabel(String? raw, {IconData fallback = Icons.help_outline}) {
    if (raw == null || raw.trim().isEmpty) return fallback;
    return _iconos[_normalize(raw)] ?? fallback;
  }

  Future<List<GuiaRow>> _loadRows(GuiaState s) async {
    if (s.level == 0) {
      final l0 = await AppDeps.I.articleRepository.getAllNivel0();
      return l0.map((e) {
        final label = e.nombre ?? 'Sin nombre';
        return GuiaRow(id: e.id ?? '', label: label, icon: _iconForLabel(label),isArticle: false);
      }).toList();
    }
    else if (s.level == 1) {
      final l1 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key0!, s.level);
      if (l1.isNotEmpty) {
        final icon = _iconForLabel(s.title0, fallback: Icons.folder);
        isArticleMode = false;
        return l1.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon,isArticle: false,)).toList();
      }
      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key0!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      isArticleMode = true;
      return articulos.map((e) => GuiaRow(id: e.id ?? '', label: e.tema ?? 'Sin nombre', icon: iconArticulos,isArticle: true,)).toList();

    }
    else if (s.level == 2) {
      final l2 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key1!, s.level);
      if (l2.isNotEmpty) {
        final icon = _iconForLabel(s.title0, fallback: Icons.folder_open);
        isArticleMode = false;
        return l2.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon,isArticle: false)).toList();
      }
      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key1!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      isArticleMode = true;
      return articulos.map((e) => GuiaRow(id: e.id ?? '', label: e.tema ?? 'Sin nombre', icon: iconArticulos,isArticle: true)).toList();

    }
    else if (s.level == 3) {
      final l3 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key2!, s.level);
      if (l3.isNotEmpty) {
        const icon = Icons.description;
        isArticleMode = false;

        return l3.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon,isArticle: false,)).toList();
      }
      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key2!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      isArticleMode = true;
      return articulos.map((e) => GuiaRow(id: e.id ?? '', label: e.tema ?? 'Sin nombre', icon: iconArticulos,isArticle: true)).toList();

    }
    else if (s.level == 4) {
      final l4 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key2!, s.level);
      if (l4.isNotEmpty) {
        const icon = Icons.description;
        isArticleMode = false;
        return l4.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon,isArticle: false,)).toList();
      }

      final articles = await AppDeps.I.articleRepository.getAllArticlesById(s.key3!);
      isArticleMode = true;
      const icon = Icons.article;
      return articles.map((a) {
        final label = a.tema?.isNotEmpty == true ? a.tema! : 'Sin tema';
        return GuiaRow(id: a.id ?? '', label: label, icon: icon,isArticle: true);
      }).toList();

    }
    else {
      return const <GuiaRow>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = GuiaSectionCubit(
          exitToParentWhenBackFromLevel1: exitToParentWhenBackFromLevel1,
          onExit: onExit,
        );
        if (initialKey0 != null && initialTitle0 != null) {
          cubit.openLevel1(key0: initialKey0!, title0: initialTitle0!);
        }
        return cubit;
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            final s = context.read<GuiaSectionCubit>().state;
            if (s.showArticleDetail || s.level > 0) {
              context.read<GuiaSectionCubit>().back();
              return false;
            }
            return true;
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<GuiaSectionCubit, GuiaState>(
                      buildWhen: (prev, curr) =>
                          prev.level != curr.level ||
                          prev.showArticleDetail != curr.showArticleDetail ||
                          prev.articleId != curr.articleId ||
                          prev.title0 != curr.title0 ||
                          prev.title1 != curr.title1 ||
                          prev.title2 != curr.title2 ||
                          prev.title3 != curr.title3,
                      builder: (context, s) {
                        final isRootNoArticle = (s.level == 0) && !s.showArticleDetail;
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        if (isRootNoArticle) {
                          return Row(
                            children: [
                              Icon(
                                Icons.menu_book,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              const SizedBox(width: 8),
                              const Text('Guía', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          );
                        }
                        final title = s.showArticleDetail
                            ? (s.articleTitle ?? 'Artículo')
                            : (s.title3 ?? s.title2 ?? s.title1 ?? s.title0) ?? 'Detalle';
                        return Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () => context.read<GuiaSectionCubit>().back(),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.arrow_back, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contenido
                  Expanded(
                    child: BlocBuilder<GuiaSectionCubit, GuiaState>(
                      buildWhen: (prev, curr) =>
                          prev.level != curr.level ||
                          prev.showArticleDetail != curr.showArticleDetail ||
                          prev.articleId != curr.articleId ||
                          prev.title0 != curr.title0 ||
                          prev.title1 != curr.title1 ||
                          prev.title2 != curr.title2 ||
                          prev.title3 != curr.title3,
                      builder: (context, s) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, anim) {
                            final slide = Tween<Offset>(
                              begin: const Offset(0.06, 0),
                              end: Offset.zero,
                            ).animate(anim);
                            return FadeTransition(
                              opacity: anim,
                              child: SlideTransition(position: slide, child: child),
                            );
                          },
                          child: s.showArticleDetail
                              ? _ArticleDetail(articleId: s.articleId!)
                              : BlocBuilder<ArticleSearchCubit, ArticleSearchState>(
                            buildWhen: (prev, curr) {
                              final sameResults = prev.results.length == curr.results.length &&
                                  prev.results.asMap().entries.every(
                                        (e) => e.value.id == curr.results[e.key].id && e.value.label == curr.results[e.key].label,
                                  );
                              return prev.committed != curr.committed ||
                                  prev.loading   != curr.loading   ||
                                  prev.error     != curr.error     ||
                                  !sameResults;
                            },
                            builder: (context, search) {
                              final showResults = search.loading || search.committed.trim().isNotEmpty;

                              if (showResults) {
                                if (search.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (search.error != null) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Error al buscar artículos'),
                                        const SizedBox(height: 8),
                                        Text(search.error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          onPressed: () => context.read<ArticleSearchCubit>().search(search.committed),
                                          child: const Text('Reintentar'),
                                        ),
                                      ],
                                    ),
                                  );
                                }



                                final results = search.results!;
                                if (results.isEmpty) {
                                  return const Center(child: Text('Sin resultados'));
                                }
                                // 👉 Lista de resultados de búsqueda
                                return ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: results.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, i) {
                                    final r = results[i];
                                    return _card(
                                      icon: Icons.article,
                                      label: r.label,
                                      color: Colors.blue,
                                      onTap: () {
                                        // Abre el detalle directamente (level puede estar en 0)
                                        context.read<GuiaSectionCubit>().showArticle(
                                          articleId: r.id,
                                          articleTitle: r.label,
                                        );
                                      },
                                    );
                                  },
                                );
                              }

                              // 🔁 Sin query → comportamiento jerárquico original
                              return FutureBuilder<List<GuiaRow>>(
                                key: ValueKey('level-${s.level}-${s.key0}-${s.key1}-${s.key2}-${s.key3}-${s.articleId ?? ''}'),
                                future: _loadRows(s),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snap.hasError) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Ocurrió un error'),
                                          const SizedBox(height: 8),
                                          Text('${snap.error}', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () => (context as Element).markNeedsBuild(),
                                            child: const Text('Reintentar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  final rows = snap.data ?? const <GuiaRow>[];
                                  if (rows.isEmpty) return const Center(child: Text('Sin datos'));

                                  return RefreshIndicator(
                                    onRefresh: () async => (context as Element).markNeedsBuild(),
                                    child: ListView.separated(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      itemCount: rows.length,
                                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                                      itemBuilder: (context, i) {
                                        final r = rows[i];
                                        return _card(
                                          icon: r.icon,
                                          label: r.label,
                                          color: Colors.blue,
                                          onTap: () {
                                            final cubit = context.read<GuiaSectionCubit>();

                                            if (r.isArticle) {
                                              // Abrir detalle de artículo (nivel 5)
                                              cubit.showArticle(articleId: r.id, articleTitle: r.label);
                                              return;
                                            }

                                            // No es artículo → navegar al siguiente nivel según el estado actual
                                            switch (s.level) {
                                              case 0:
                                                cubit.openLevel1(key0: r.id, title0: r.label);
                                                break;
                                              case 1:
                                                cubit.openLevel2(key1: r.id, title1: r.label);
                                                break;
                                              case 2:
                                                cubit.openLevel3(key2: r.id, title2: r.label);
                                                break;
                                              case 3:
                                                cubit.openLevel4(key3: r.id, title3: r.label);
                                                break;
                                              case 4:
                                              // si existiera más nivel, acá
                                                break;
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- Detalle de artículo (Nivel 5) ----------

class _ArticleDetail extends StatelessWidget {
  final String articleId;
  const _ArticleDetail({required this.articleId});

  Future<ArticleModel?> _loadOne() async {
    try {
      return await AppDeps.I.articleRepository.getArticleById(articleId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleModel?>(
      future: _loadOne(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final a = snap.data;
        if (a == null) {
          return const Center(child: Text('No se pudo cargar el artículo'));
        }

        final query = ''; // No resaltado en el detalle para NO alterar el HTML original

        return ListView(
          key: PageStorageKey('article-$articleId'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            if ((a.contenidos).isNotEmpty) ...[
              const SizedBox(height: 8),
              ...a.contenidos
                  .cast<String>()
                  .expand((c) => _buildHtmlSegments(c, context, query))
                  .toList(),
            ],

            const SizedBox(height: 20),

            if (a.fechaCreacion != null || a.fechaModificacion != null)
              Text(
                'Actualizado: ${a.fechaModificacion ?? a.fechaCreacion}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        );
      },
    );
  }
}

/// ---------- Helpers ----------

String _normalize(String s) => s
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[áàäâ]'), 'a')
    .replaceAll(RegExp(r'[éèëê]'), 'e')
    .replaceAll(RegExp(r'[íìïî]'), 'i')
    .replaceAll(RegExp(r'[óòöô]'), 'o')
    .replaceAll(RegExp(r'[úùüû]'), 'u')
    .replaceAll('ñ', 'n');

Widget _card({
  required IconData icon,
  required String label,
  required Color color,
  VoidCallback? onTap,
}) {
  final content = Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white),
      ],
    ),
  );

  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  // Siempre provee un Material para los Ink effects
  return Material(
    color: Colors.transparent,
    shape: shape,
    clipBehavior: Clip.antiAlias, // recorta el splash al radio
    child: InkWell(
      onTap: onTap,
      customBorder: shape,
      child: Ink( // Ink + BoxDecoration = splash correcto
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: content,
      ),
    ),
  );
}




/// Limpia propiedades problemáticas del HTML (opcional)
String sanitizeFontFeatures(String html) {
  html = html.replaceAll(
    RegExp(r'font-feature-settings\s*:\s*[^;>]*;?', caseSensitive: false),
    '',
  );
  html = html.replaceAll(
    RegExp(r'style\s*=\s*"(\s*;?\s*)+"', caseSensitive: false),
    '',
  );
  html = html.replaceAll(
    RegExp(r'font-variant\s*:\s*[^;>]*;?', caseSensitive: false),
    '',
  );
  return html;
}

/// --- utils: partir el html en texto normal y tablas ---
final _tableRx = RegExp(
  r'<table[\s\S]*?</table>',
  caseSensitive: false,
  dotAll: true,
);

List<Widget> _buildHtmlSegments(String html, BuildContext context, String highlightQuery) {
  final widgets = <Widget>[];
  int last = 0;

  for (final m in _tableRx.allMatches(html)) {
    if (m.start > last) {
      final before = html.substring(last, m.start).trim();
      if (before.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SelectionContainer.disabled(
              child: Html(
                data: (highlightQuery.isEmpty)
                    ? sanitizeFontFeatures(before)
                    : highlightHtml(sanitizeFontFeatures(before), highlightQuery),
                extensions: [
                  const TableHtmlExtension(),
                  ...spanDecorExtensions(),
                ],
                style:  {
                  "mark": Style(
                    backgroundColor: const Color(0xFFFFFF00),
                    padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
                  ),
                  "p": Style(margin: Margins.zero),
                  "h1": Style(fontSize: FontSize(26), fontWeight: FontWeight.w700),
                  "h2": Style(fontSize: FontSize(18), fontWeight: FontWeight.w700),
                  "td": Style(whiteSpace: WhiteSpace.pre),
                  ".muted": Style(color: Colors.black54),
                  ".pill": Style(
                    display: Display.inlineBlock,
                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: const Color(0xFFE9F2FB),
                    color: const Color(0xFF1E6BB8),
                    margin: Margins.only(right: 6, bottom: 6),
                    border: const Border(
                      left: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      top: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      right: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      bottom: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                    ),
                    fontWeight: FontWeight.w700,
                    fontSize: FontSize(12),
                  ),
                },
              ),
            ),
          ),
        );
      }
    }

    final tableHtml = html.substring(m.start, m.end);
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SelectionContainer.disabled(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final minW = constraints.maxWidth;
              final table = Html(
                data: (highlightQuery.isEmpty)
                    ? sanitizeFontFeatures(tableHtml)
                    : highlightHtml(sanitizeFontFeatures(tableHtml), highlightQuery),
                extensions: [
                  const TableHtmlExtension(),
                  ...spanDecorExtensions(),
                ],
                style:  {
                  "mark": Style(
                    backgroundColor: const Color(0xFFFFFF00),
                    padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
                  ),
                  "table": Style(width: Width.auto(), margin: Margins.only(bottom: 0)),
                  "th": Style(
                    fontWeight: FontWeight.w700,
                    padding: HtmlPaddings.all(6),
                    backgroundColor: const Color(0xFFEFEFEF),
                    border: const Border(
                      top: BorderSide(width: 1, color: Color(0x33000000)),
                      right: BorderSide(width: 1, color: Color(0x33000000)),
                      bottom: BorderSide(width: 1, color: Color(0x33000000)),
                      left: BorderSide(width: 1, color: Color(0x33000000)),
                    ),
                  ),
                  "td": Style(
                    padding: HtmlPaddings.all(6),
                    border: const Border(
                      top: BorderSide(width: 1, color: Color(0x33000000)),
                      right: BorderSide(width: 1, color: Color(0x33000000)),
                      bottom: BorderSide(width: 1, color: Color(0x33000000)),
                      left: BorderSide(width: 1, color: Color(0x33000000)),
                    ),
                    whiteSpace: WhiteSpace.pre,
                  ),
                  ".muted": Style(color: Colors.black54),
                  ".pill": Style(
                    display: Display.inlineBlock,
                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: const Color(0xFFE9F2FB),
                    color: const Color(0xFF1E6BB8),
                    margin: Margins.only(right: 6, bottom: 6),
                    border: const Border(
                      left: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      top: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      right: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                      bottom: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                    ),
                    fontWeight: FontWeight.w700,
                    fontSize: FontSize(12),
                  ),
                },
              );

              return Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minW),
                    child: table,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    last = m.end;
  }

  if (last < html.length) {
    final after = html.substring(last).trim();
    if (after.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SelectionContainer.disabled(
            child: Html(
              data: (highlightQuery.isEmpty)
                  ? sanitizeFontFeatures(after)
                  : highlightHtml(sanitizeFontFeatures(after), highlightQuery),
              extensions: [
                const TableHtmlExtension(),
                ...spanDecorExtensions(),
              ],
              style:  {
                "mark": Style(
                  backgroundColor: const Color(0xFFFFFF00),
                  padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
                ),
                "p": Style(margin: Margins.only(bottom: 8)),
                "td": Style(whiteSpace: WhiteSpace.pre),
                ".muted": Style(color: Colors.black54),
                ".pill": Style(
                  display: Display.inlineBlock,
                  padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 4),
                  backgroundColor: const Color(0xFFE9F2FB),
                  color: const Color(0xFF1E6BB8),
                  margin: Margins.only(right: 6, bottom: 6),
                  border: const Border(
                    left: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                    top: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                    right: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                    bottom: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                  ),
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize(12),
                ),
              },
            ),
          ),
        ),
      );
    }
  }

  if (widgets.isEmpty) {
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SelectionContainer.disabled(
          child: Html(
            data: (highlightQuery.isEmpty)
                ? sanitizeFontFeatures(html)
                : highlightHtml(sanitizeFontFeatures(html), highlightQuery),
            extensions: [
              const TableHtmlExtension(),
              ...spanDecorExtensions(),
            ],
            style:  {
              "mark": Style(
                backgroundColor: const Color(0xFFFFFF00),
                padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
              ),
              "table": Style(width: Width.auto()),
              "td": Style(whiteSpace: WhiteSpace.pre),
              ".muted": Style(color: Colors.black54),
              ".pill": Style(
                display: Display.inlineBlock,
                padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 4),
                backgroundColor: const Color(0xFFE9F2FB),
                color: const Color(0xFF1E6BB8),
                margin: Margins.only(right: 6, bottom: 6),
                border: const Border(
                  left: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                  top: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                  right: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                  bottom: BorderSide(color: Color(0xFFCAE3FA), width: 1),
                ),
                fontWeight: FontWeight.w700,
                fontSize: FontSize(12),
              ),
            },
          ),
        ),
      ),
    );
  }

  return widgets;
}

/// ===== Extensión para <span data-border> y opcionalmente data-highlight =====
List<HtmlExtension> spanDecorExtensions() => [
  TagExtension(
    tagsToExtend: const {'span'},
    builder: (ext) {
      final el = ext.element;
      if (el == null) return const SizedBox.shrink();

      final hasBorder    = el.attributes.containsKey('data-border');
      final hasHighlight = el.attributes.containsKey('data-highlight');

      if (!hasBorder && !hasHighlight) {
        return Html(
          data: el.outerHtml,
          extensions: const [TableHtmlExtension()],
        );
      }

      final styleStr     = el.attributes['style'] ?? '';
      final borderColor  = _parseCssColor(styleStr) ?? const Color(0xFF000000);
      final borderWidth  = _parseBorderWidth(styleStr) ?? 1.0;
      final bgColor      = hasHighlight ? _parseBackgroundColor(styleStr) : null;

      return UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            border: hasBorder ? Border.all(color: borderColor, width: borderWidth) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Html(
              data: el.innerHtml,
              extensions: const [TableHtmlExtension()],
              style: {
                "p": Style(margin: Margins.zero),
              },
            ),
          ),
        ),
      );
    },
  ),
];

double? _parseBorderWidth(String css) {
  final m = RegExp(r'border-width\s*:\s*([0-9.]+)px', caseSensitive: false).firstMatch(css);
  if (m != null) return double.tryParse(m.group(1)!);

  final m2 = RegExp(r'border\s*:\s*([0-9.]+)px', caseSensitive: false).firstMatch(css);
  if (m2 != null) return double.tryParse(m2.group(1)!);

  return null;
}

Color? _parseCssColor(String css) {
  final rgb = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)', caseSensitive: false).firstMatch(css);
  if (rgb != null) {
    return Color.fromARGB(
      255,
      int.parse(rgb.group(1)!),
      int.parse(rgb.group(2)!),
      int.parse(rgb.group(3)!),
    );
  }
  final hex6 = RegExp(r'#([0-9a-fA-F]{6})').firstMatch(css);
  if (hex6 != null) {
    return Color(int.parse('FF${hex6.group(1)!}', radix: 16));
  }
  final hex3 = RegExp(r'#([0-9a-fA-F]{3})\b').firstMatch(css);
  if (hex3 != null) {
    final h = hex3.group(1)!;
    final rr = h[0] + h[0];
    final gg = h[1] + h[1];
    final bb = h[2] + h[2];
    return Color(int.parse('FF$rr$gg$bb', radix: 16));
  }
  return null;
}

Color? _parseBackgroundColor(String css) {
  final bg = RegExp(r'background(?:-color)?\s*:\s*([^;]+);?', caseSensitive: false).firstMatch(css)?.group(1);
  if (bg == null) return null;
  final v = bg.trim();
  final tmp = _parseCssColor('color:$v;');
  return tmp;
}