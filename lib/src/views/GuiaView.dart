import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../components/article_search_cubit.dart';
import '../components/image_viewer_dialog.dart';
import '../core/Repositories/AppDeps.dart';
import '../core/models/ArticleModel.dart';
import '../utils/highlight.dart';
import 'package:url_launcher/url_launcher.dart';
/// --------- Estado de navegación (0..5 niveles) ----------
class GuiaState {
  final bool isArticleMode;
  final int level; // 0..5  (5 = detalle de artículo)

  final String? key0;
  final String? title0;
  final String? key1;
  final String? title1;
  final String? key2;
  final String? title2;
  final String? key3;
  final String? title3;

  // Detalle de artículo
  final String? articleId;
  final String? articleTitle;
  final bool showArticleDetail;

  const GuiaState({
    this.level = 0,
    this.key0,
    this.title0,
    this.key1,
    this.title1,
    this.key2,
    this.title2,
    this.key3,
    this.title3,
    this.articleId,
    this.articleTitle,
    this.showArticleDetail = false,
    this.isArticleMode = false,
  });

  GuiaState copyWith({
    int? level,
    String? key0,
    String? title0,
    String? key1,
    String? title1,
    String? key2,
    String? title2,
    String? key3,
    String? title3,
    String? articleId,
    String? articleTitle,
    bool? showArticleDetail,
    bool? isArticleMode,
  }) =>
      GuiaState(
        level: level ?? this.level,
        key0: key0 ?? this.key0,
        title0: title0 ?? this.title0,
        key1: key1 ?? this.key1,
        title1: title1 ?? this.title1,
        key2: key2 ?? this.key2,
        title2: title2 ?? this.title2,
        key3: key3 ?? this.key3,
        title3: title3 ?? this.title3,
        articleId: articleId ?? this.articleId,
        articleTitle: articleTitle ?? this.articleTitle,
        showArticleDetail: showArticleDetail ?? this.showArticleDetail,
        isArticleMode: isArticleMode ?? this.isArticleMode,
      );

  GuiaState toLevel0() => const GuiaState(level: 0);

  GuiaState toLevel1({required String key0, required String title0}) =>
      GuiaState(level: 1, key0: key0, title0: title0);

  GuiaState toLevel2({
    required String key0,
    required String title0,
    required String key1,
    required String title1,
  }) =>
      GuiaState(
        level: 2,
        key0: key0,
        title0: title0,
        key1: key1,
        title1: title1,
      );

  GuiaState toLevel3({
    required String key0,
    required String title0,
    required String key1,
    required String title1,
    required String key2,
    required String title2,
  }) =>
      GuiaState(
        level: 3,
        key0: key0,
        title0: title0,
        key1: key1,
        title1: title1,
        key2: key2,
        title2: title2,
      );

  GuiaState toLevel4({
    required String key0,
    required String title0,
    required String key1,
    required String title1,
    required String key2,
    required String title2,
    required String key3,
    required String title3,
  }) =>
      GuiaState(
        level: 4,
        key0: key0,
        title0: title0,
        key1: key1,
        title1: title1,
        key2: key2,
        title2: title2,
        key3: key3,
        title3: title3,
      );

  GuiaState toLevel5({
    required String key0,
    required String title0,
    required String key1,
    required String title1,
    required String key2,
    required String title2,
    required String key3,
    required String title3,
    required String articleId,
    required String articleTitle,
  }) =>
      GuiaState(
        level: 5,
        key0: key0,
        title0: title0,
        key1: key1,
        title1: title1,
        key2: key2,
        title2: title2,
        key3: key3,
        title3: title3,
        articleId: articleId,
        articleTitle: articleTitle,
        showArticleDetail: true,
      );

  GuiaState showArticle({required String articleId, required String articleTitle}) =>
      GuiaState(
        level: level,
        key0: key0,
        title0: title0,
        key1: key1,
        title1: title1,
        key2: key2,
        title2: title2,
        key3: key3,
        title3: title3,
        articleId: articleId,
        articleTitle: articleTitle,
        showArticleDetail: true,
        isArticleMode: true,
      );

  GuiaState hideArticle() => GuiaState(
    level: level,
    key0: key0,
    title0: title0,
    key1: key1,
    title1: title1,
    key2: key2,
    title2: title2,
    key3: key3,
    title3: title3,
    articleId: null,
    articleTitle: null,
    showArticleDetail: false,
    isArticleMode: false,
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
      emit(state.toLevel1(key0: key0, title0: title0).copyWith(isArticleMode: false));

  void openLevel2({required String key1, required String title1}) => emit(
    state
        .toLevel2(
      key0: state.key0!,
      title0: state.title0!,
      key1: key1,
      title1: title1,
    )
        .copyWith(isArticleMode: false),
  );

  void openLevel3({required String key2, required String title2}) => emit(
    state
        .toLevel3(
      key0: state.key0!,
      title0: state.title0!,
      key1: state.key1!,
      title1: state.title1!,
      key2: key2,
      title2: title2,
    )
        .copyWith(isArticleMode: false),
  );

  void openLevel4({required String key3, required String title3}) => emit(
    state
        .toLevel4(
      key0: state.key0!,
      title0: state.title0!,
      key1: state.key1!,
      title1: state.title1!,
      key2: state.key2!,
      title2: state.title2!,
      key3: key3,
      title3: title3,
    )
        .copyWith(isArticleMode: false),
  );

  /// Abrir detalle de artículo (nivel 5)
  void openArticle({required String articleId, required String articleTitle}) => emit(
    state.toLevel5(
      key0: state.key0!,
      title0: state.title0!,
      key1: state.key1!,
      title1: state.title1!,
      key2: state.key2!,
      title2: state.title2!,
      key3: state.key3!,
      title3: state.title3!,
      articleId: articleId,
      articleTitle: articleTitle,
    ),
  );

  void showArticle({required String articleId, required String articleTitle}) =>
      emit(state.showArticle(articleId: articleId, articleTitle: articleTitle));

  void hideArticle() => emit(state.hideArticle());

  void back() {
    if (state.showArticleDetail) {
      emit(state.hideArticle());
      return;
    }

    if (state.level == 4) {
      emit(
        state
            .toLevel3(
          key0: state.key0!,
          title0: state.title0!,
          key1: state.key1!,
          title1: state.title1!,
          key2: state.key2!,
          title2: state.title2!,
        )
            .copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 3) {
      emit(
        state
            .toLevel2(
          key0: state.key0!,
          title0: state.title0!,
          key1: state.key1!,
          title1: state.title1!,
        )
            .copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 2) {
      emit(
        state.toLevel1(key0: state.key0!, title0: state.title0!).copyWith(isArticleMode: false),
      );
      return;
    }

    if (state.level == 1) {
      if (exitToParentWhenBackFromLevel1 && onExit != null) {
        onExit!();
        return;
      }
      emit(state.toLevel0().copyWith(isArticleMode: false));
      return;
    }
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

class GuiaView extends StatefulWidget {
  final String? initialKey0;
  final String? initialTitle0;
  final bool exitToParentWhenBackFromLevel1;
  final VoidCallback? onExit;

  const GuiaView({
    super.key,
    this.initialKey0,
    this.initialTitle0,
    this.exitToParentWhenBackFromLevel1 = false,
    this.onExit,
  });

  @override
  State<GuiaView> createState() => _GuiaViewState();
}

class _GuiaViewState extends State<GuiaView> {
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
        return GuiaRow(
          id: e.id ?? '',
          label: label,
          icon: _iconForLabel(label),
          isArticle: false,
        );
      }).toList();
    }

    if (s.level == 1) {
      final l1 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key0!, s.level);
      if (l1.isNotEmpty) {
        final icon = _iconForLabel(s.title0, fallback: Icons.folder);
        return l1
            .map((e) => GuiaRow(
          id: e.id ?? '',
          label: e.nombre ?? 'Sin nombre',
          icon: icon,
          isArticle: false,
        ))
            .toList();
      }

      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key0!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      return articulos
          .map((e) => GuiaRow(
        id: e.id ?? '',
        label: e.tema ?? 'Sin nombre',
        icon: iconArticulos,
        isArticle: true,
      ))
          .toList();
    }

    if (s.level == 2) {
      final l2 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key1!, s.level);
      if (l2.isNotEmpty) {
        final icon = _iconForLabel(s.title0, fallback: Icons.folder_open);
        return l2
            .map((e) => GuiaRow(
          id: e.id ?? '',
          label: e.nombre ?? 'Sin nombre',
          icon: icon,
          isArticle: false,
        ))
            .toList();
      }

      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key1!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      return articulos
          .map((e) => GuiaRow(
        id: e.id ?? '',
        label: e.tema ?? 'Sin nombre',
        icon: iconArticulos,
        isArticle: true,
      ))
          .toList();
    }

    if (s.level == 3) {
      final l3 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key2!, s.level);
      if (l3.isNotEmpty) {
        const icon = Icons.description;
        return l3
            .map((e) => GuiaRow(
          id: e.id ?? '',
          label: e.nombre ?? 'Sin nombre',
          icon: icon,
          isArticle: false,
        ))
            .toList();
      }

      final articulos = await AppDeps.I.articleRepository.getAllArticlesById(s.key2!);
      final iconArticulos = _iconForLabel(s.title0, fallback: Icons.folder);
      return articulos
          .map((e) => GuiaRow(
        id: e.id ?? '',
        label: e.tema ?? 'Sin nombre',
        icon: iconArticulos,
        isArticle: true,
      ))
          .toList();
    }

    if (s.level == 4) {
      // ✅ FIX REAL: aquí era s.key2!, debe ser s.key3!
      final l4 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key3!, s.level);
      if (l4.isNotEmpty) {
        const icon = Icons.description;
        return l4
            .map((e) => GuiaRow(
          id: e.id ?? '',
          label: e.nombre ?? 'Sin nombre',
          icon: icon,
          isArticle: false,
        ))
            .toList();
      }

      final articles = await AppDeps.I.articleRepository.getAllArticlesById(s.key3!);
      const icon = Icons.article;
      return articles.map((a) {
        final label = a.tema?.isNotEmpty == true ? a.tema! : 'Sin tema';
        return GuiaRow(id: a.id ?? '', label: label, icon: icon, isArticle: true);
      }).toList();
    }

    return const <GuiaRow>[];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = GuiaSectionCubit(
          exitToParentWhenBackFromLevel1: widget.exitToParentWhenBackFromLevel1,
          onExit: widget.onExit,
        );
        if (widget.initialKey0 != null && widget.initialTitle0 != null) {
          cubit.openLevel1(key0: widget.initialKey0!, title0: widget.initialTitle0!);
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
                              Icon(Icons.menu_book, color: isDark ? Colors.white : Colors.black),
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
                            final slide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(anim);
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
                                  prev.loading != curr.loading ||
                                  prev.error != curr.error ||
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
                                        Text(
                                          search.error!,
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
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
                                        context.read<GuiaSectionCubit>().showArticle(
                                          articleId: r.id,
                                          articleTitle: r.label,
                                        );
                                      },
                                    );
                                  },
                                );
                              }

                              // 🔁 Sin query → navegación jerárquica
                              return FutureBuilder<List<GuiaRow>>(
                                key: ValueKey(
                                  'level-${s.level}-${s.key0}-${s.key1}-${s.key2}-${s.key3}-${s.articleId ?? ''}',
                                ),
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
                                          Text(
                                            '${snap.error}',
                                            style: const TextStyle(color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
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
                                              cubit.showArticle(articleId: r.id, articleTitle: r.label);
                                              return;
                                            }

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

/// ---------- Detalle de artículo ----------
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

        const query = ''; // no resaltar en detalle para no alterar HTML

        return ListView(
          key: PageStorageKey('article-$articleId'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            if (a.contenidos.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...a.contenidos.cast<String>().expand((c) => _buildHtmlSegments(c, context, query)).toList(),
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

/// ---------- Helpers UI ----------
String _normalize(String s) => s
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[áàäâ]'), 'a')
    .replaceAll(RegExp(r'[éèëê]'), 'e')
    .replaceAll(RegExp(r'[íìïî]'), 'i')
    .replaceAll(RegExp(r'[óòöô]'), 'o')
    .replaceAll(RegExp(r'[úùüû]'), 'u')
    .replaceAll('ñ', 'n');

Future<void> _openUrl(BuildContext context, String? url) async {
  if (url == null || url.trim().isEmpty) return;

  final raw = url.trim();
  Uri? uri = Uri.tryParse(raw);

  if (uri == null || (!uri.hasScheme && !raw.startsWith('mailto:') && !raw.startsWith('tel:'))) {
    uri = Uri.tryParse('https://$raw');
  }

  if (uri == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('URL inválida')),
    );
    return;
  }

  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al abrir el enlace')),
      );
    }
  }
}

Widget _card({
  required IconData icon,
  required String label,
  required Color color, // se mantiene por compatibilidad
  VoidCallback? onTap,
}) {
  const gradStart = Color(0xFF276FAB);
  const gradEnd = Color(0xFF3BA3F2);

  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));

  return Material(
    color: Colors.transparent,
    shape: shape,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      customBorder: shape,
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradStart, gradEnd],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    ),
  );
}

/// ---------- HTML helpers (FIX: no romper inline / spans) ----------

String markEmptyParagraphs(String html) {
  if (html.isEmpty) return html;

  final rx = RegExp(
    r'<p(\s[^>]*)?>\s*(?:<br\s*/?>|&nbsp;|\s)*\s*</p>',
    caseSensitive: false,
  );

  return html.replaceAllMapped(rx, (m) {
    final full = m.group(0)!;

    if (RegExp(r'class\s*=\s*"', caseSensitive: false).hasMatch(full)) {
      return full.replaceFirst(
        RegExp(r'class\s*=\s*"', caseSensitive: false),
        'class="p-empty ',
      );
    }

    return full.replaceFirstMapped(
      RegExp(r'<p(\s[^>]*)?>', caseSensitive: false),
          (pm) {
        final attrs = pm.group(1) ?? '';
        return '<p$attrs class="p-empty">';
      },
    );
  });
}

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

final _tableRx = RegExp(
  r'<table[\s\S]*?</table>',
  caseSensitive: false,
  dotAll: true,
);

List<Widget> _buildHtmlSegments(String html, BuildContext context, String highlightQuery) {
  final widgets = <Widget>[];
  int last = 0;

  final isDark = Theme.of(context).brightness == Brightness.dark;
  final tableBg = isDark ? const Color(0xFF121417) : Colors.white;
  final theadBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFEFEFEF);
  final cellText = isDark ? Colors.white : const Color(0xFF222222);
  final borderColor = isDark ? const Color(0x33FFFFFF) : const Color(0x33000000);
  final mutedColor = isDark ? Colors.white70 : Colors.black54;
  final pillBg = isDark ? const Color(0x332196F3) : const Color(0xFFE9F2FB);
  final pillText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E6BB8);

  Map<String, Style> baseStyles() => {
    "body": Style(
      fontSize: FontSize(14),
      lineHeight: const LineHeight(1.35),
      color: cellText,
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
    "mark": Style(
      backgroundColor: const Color(0xFFFFFF00),
      padding: HtmlPaddings.symmetric(horizontal: 2, vertical: 1),
    ),
    "a": Style(
      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0A66C2),
      textDecoration: TextDecoration.underline,
      textDecorationColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0A66C2),
      fontWeight: FontWeight.w700,
    ),
    "p": Style(
      margin: Margins.only(bottom: 8),
      color: cellText,
      lineHeight: const LineHeight(1.35),
    ),
    ".p-empty": Style(
      margin: Margins.only(bottom: 0),
      padding: HtmlPaddings.zero,
      lineHeight: const LineHeight(0),
    ),
    "h1": Style(
      fontSize: FontSize(26),
      fontWeight: FontWeight.w800,
      color: cellText,
      margin: Margins.only(bottom: 10),
    ),

    "ul": Style(
      margin: Margins.only(bottom: 8),
      padding: HtmlPaddings.only(left: 20),
    ),

    "ol": Style(
      margin: Margins.only(bottom: 8),
      padding: HtmlPaddings.only(left: 20),
    ),

    "li": Style(
      margin: Margins.zero,
      color: cellText,
      lineHeight: const LineHeight(1.35),
    ),

    "h2": Style(
      fontSize: FontSize(18),
      fontWeight: FontWeight.w800,
      color: cellText,
      margin: Margins.only(top: 14, bottom: 8),
    ),
    ".muted": Style(color: mutedColor),
    ".pill": Style(
      display: Display.inlineBlock,
      padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: pillBg,
      color: pillText,
      margin: Margins.only(right: 6, bottom: 6),
      border: Border.all(
        color: isDark ? const Color(0x3393C5FD) : const Color(0xFFCAE3FA),
        width: 1,
      ),
      fontWeight: FontWeight.w700,
      fontSize: FontSize(12),
    ),
    "table": Style(
      width: Width.auto(),
      backgroundColor: tableBg,
      margin: Margins.symmetric(vertical: 8),
      border: Border.all(color: borderColor, width: 1),
    ),
    "tr": Style(backgroundColor: tableBg),
    "th": Style(
      color: cellText,
      fontWeight: FontWeight.w700,
      padding: HtmlPaddings.all(6),
      backgroundColor: theadBg,
      border: Border.all(color: borderColor, width: 1),
    ),
    "td": Style(
      color: cellText,
      backgroundColor: tableBg,
      padding: HtmlPaddings.all(6),
      border: Border.all(color: borderColor, width: 1),
      whiteSpace: WhiteSpace.normal,
    ),

    // ✅ Ajusta default img (mini en artículo)
    "img": Style(
      margin: Margins.symmetric(vertical: 8),
      display: Display.block,
    ),


  };

  String linkifyPlainUrls(String html) {
    if (html.isEmpty) return html;

    // Protegemos bloques donde NO queremos reemplazar nada
    final protectedBlocks = <String>[];
    String protectedHtml = html;

    final blockRegex = RegExp(
      r'(<a\b[^>]*>[\s\S]*?<\/a>)|(<img\b[^>]*>)|(<script\b[^>]*>[\s\S]*?<\/script>)|(<style\b[^>]*>[\s\S]*?<\/style>)|(<code\b[^>]*>[\s\S]*?<\/code>)|(<pre\b[^>]*>[\s\S]*?<\/pre>)',
      caseSensitive: false,
      dotAll: true,
    );

    protectedHtml = protectedHtml.replaceAllMapped(blockRegex, (m) {
      final token = '___HTML_BLOCK_${protectedBlocks.length}___';
      protectedBlocks.add(m.group(0)!);
      return token;
    });

    // Detecta URLs planas:
    // - https://...
    // - http://...
    // - www....
    final urlRegex = RegExp(
      r'((?:https?:\/\/|www\.)[^\s<]+)',
      caseSensitive: false,
    );

    protectedHtml = protectedHtml.replaceAllMapped(urlRegex, (m) {
      String url = m.group(0)!;

      // Quitar puntuación final común que no pertenece al link
      String trailing = '';
      while (url.isNotEmpty &&
          RegExp(r'[)\],.;!?]$').hasMatch(url) &&
          !url.endsWith(')')) {
        trailing = url[url.length - 1] + trailing;
        url = url.substring(0, url.length - 1);
      }

      final href = url.toLowerCase().startsWith('http://') ||
          url.toLowerCase().startsWith('https://')
          ? url
          : 'https://$url';

      return '<a href="$href">$url</a>$trailing';
    });

    // Restaurar bloques protegidos
    // Restaurar bloques protegidos
    for (int i = 0; i < protectedBlocks.length; i++) {
      protectedHtml =
          protectedHtml.replaceFirst('___HTML_BLOCK_${i}___', protectedBlocks[i]);
    }

    return protectedHtml;
  }


  String process(String raw) {
    final sanitized = sanitizeFontFeatures(raw);
    final linked = linkifyPlainUrls(sanitized);
    final cleaned = (highlightQuery.isEmpty)
        ? linked
        : highlightHtml(linked, highlightQuery);
    return markEmptyParagraphs(cleaned);
  }
  

  bool _isDataImage(String src) {
    final s = src.trim().toLowerCase();
    return s.startsWith('data:image/');
  }


  Uint8List? _decodeDataImage(String src) {
    // data:image/png;base64,AAAA...
    final s = src.trim();
    final comma = s.indexOf(',');
    if (comma < 0) return null;

    final meta = s.substring(0, comma).toLowerCase();
    if (!meta.contains('base64')) return null;

    final b64 = s.substring(comma + 1).trim();
    if (b64.isEmpty) return null;

    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }




  // ✅ EXTENSION: intercepta <img> y lo hace clickable -> modal full screen
  List<HtmlExtension> htmlExtensions(BuildContext ctx) => [
    const TableHtmlExtension(),

    TagExtension(
      tagsToExtend: {"img"},
      builder: (ExtensionContext ext) {
        final attrs = ext.attributes;
        final src = (attrs["src"] ?? "").trim();
        final alt = (attrs["alt"] ?? "").trim();

        if (src.isEmpty) {
          return const SizedBox.shrink();
        }

        final st = _readImgStyle(attrs);


        // hero tag único (por src) para animación opcional
        final heroTag = "img-${src.hashCode}";

        final Widget imageWidget;

        if (_isDataImage(src)) {
          final bytes = _decodeDataImage(src);

          if (bytes == null) {
            imageWidget = Container(
              height: 160,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, color: isDark ? Colors.white70 : Colors.black38, size: 34),
                  const SizedBox(height: 6),
                  Text(
                    alt.isNotEmpty ? alt : "Imagen inválida (base64)",
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            imageWidget = Image.memory(
              bytes,
              width: st.widthPx,
              height: st.heightPx,
              fit: st.fit,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image, color: isDark ? Colors.white70 : Colors.black38, size: 34),
                    const SizedBox(height: 6),
                    Text(
                      alt.isNotEmpty ? alt : "No se pudo cargar la imagen",
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          imageWidget = Image.network(
            src,
            width: st.widthPx,
            height: st.heightPx,
            fit: st.fit,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                height: 160,
                alignment: Alignment.center,
                child: const SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              height: 160,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, color: isDark ? Colors.white70 : Colors.black38, size: 34),
                  const SizedBox(height: 6),
                  Text(
                    alt.isNotEmpty ? alt : "No se pudo cargar la imagen",
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }


        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: LayoutBuilder(
            builder: (ctx2, constraints) {
              final maxW = constraints.maxWidth;

              // si viene width:25% -> se convierte a px
              final targetW = (st.widthPct != null)
                  ? (maxW * (st.widthPct! / 100.0))
                  : st.widthPx;

              final boxed = SizedBox(
                width: targetW,
                height: st.heightPx, // si es auto -> null
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: imageWidget,
                ),
              );

              return GestureDetector(
                onTap: () => FullscreenImageViewer.open(ctx, src: src, heroTag: heroTag, alt: alt),
                child: Hero(tag: heroTag, child: boxed),
              );
            },
          ),
        );
      },
    ),
  ];

  void addHtmlWidget(String raw, {EdgeInsets pad = const EdgeInsets.only(bottom: 6)}) {
    final processed = process(raw);
    if (processed.trim().isEmpty) return;

    widgets.add(
      Padding(
        padding: pad,
        child: SelectionContainer.disabled(
          child: Html(
            data: processed,
            extensions: htmlExtensions(context),
            style: baseStyles(),
            onLinkTap: (url, attributes, element) {
              _openUrl(context, url);
            },
          ),
        ),
      ),
    );
  }

  for (final m in _tableRx.allMatches(html)) {
    if (m.start > last) {
      final beforeRaw = html.substring(last, m.start);
      addHtmlWidget(beforeRaw);
    }

    final tableHtmlRaw = html.substring(m.start, m.end);
    final tableProcessed = process(tableHtmlRaw);

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SelectionContainer.disabled(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final minW = constraints.maxWidth;

              final table = Html(
                data: tableProcessed,
                extensions: htmlExtensions(context),
                style: baseStyles(),
                onLinkTap: (url, attributes, element) {
                  _openUrl(context, url);
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
    final afterRaw = html.substring(last);
    addHtmlWidget(afterRaw);
  }

  if (widgets.isEmpty) {
    addHtmlWidget(html);
  }

  return widgets;
}

double? _parseCssPx(String v) {
  // "120px" | "120" | "120.5px"
  final n = double.tryParse(v.replaceAll('px', '').trim());
  return n;
}

double? _parseCssPercent(String v) {
  // "25%"
  final t = v.trim();
  if (!t.endsWith('%')) return null;
  return double.tryParse(t.substring(0, t.length - 1).trim());
}

Map<String, String> _parseInlineStyle(String? style) {
  if (style == null || style.trim().isEmpty) return {};
  final out = <String, String>{};
  for (final part in style.split(';')) {
    final p = part.trim();
    if (p.isEmpty) continue;
    final idx = p.indexOf(':');
    if (idx < 0) continue;
    final k = p.substring(0, idx).trim().toLowerCase();
    final v = p.substring(idx + 1).trim();
    out[k] = v;
  }
  return out;
}

class _ImgStyle {
  final double? widthPx;
  final double? widthPct; // 0..100
  final double? heightPx;
  final BoxFit fit;

  const _ImgStyle({
    this.widthPx,
    this.widthPct,
    this.heightPx,
    this.fit = BoxFit.contain,
  });
}

_ImgStyle _readImgStyle(Map<String, String> attrs) {
  // 1) atributos HTML (width/height)
  double? wPx;
  double? hPx;

  final aw = attrs["width"];
  final ah = attrs["height"];
  if (aw != null) wPx = double.tryParse(aw.replaceAll(RegExp(r"[^\d.]"), ""));
  if (ah != null) hPx = double.tryParse(ah.replaceAll(RegExp(r"[^\d.]"), ""));

  // 2) inline style="..."
  final st = _parseInlineStyle(attrs["style"]);
  double? wPct;

  final w = st["width"];
  if (w != null) {
    wPct = _parseCssPercent(w);
    wPx ??= _parseCssPx(w);
  }

  final h = st["height"];
  if (h != null) {
    // height:auto -> null (dejamos que Flutter lo calcule)
    if (h.toLowerCase() != "auto") {
      hPx ??= _parseCssPx(h);
    }
  }

  // object-fit
  BoxFit fit = BoxFit.contain;
  final of = (st["object-fit"] ?? "").toLowerCase().trim();
  if (of == "cover") fit = BoxFit.cover;
  if (of == "fill") fit = BoxFit.fill;
  if (of == "contain") fit = BoxFit.contain;
  if (of == "none") fit = BoxFit.none;
  if (of == "scale-down") fit = BoxFit.scaleDown;

  return _ImgStyle(widthPx: wPx, widthPct: wPct, heightPx: hPx, fit: fit);
}