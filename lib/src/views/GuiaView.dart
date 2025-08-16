import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/Repositories/AppDeps.dart';
import '../core/models/Nivel0Model.dart';
import '../core/models/Nivel1Model.dart';
import '../core/models/Nivel2Model.dart';
import '../core/models/Nivel3Model.dart';
import '../core/models/Nivel4Model.dart';
import '../core/models/ArticleModel.dart';

/// --------- Estado de navegación (0..5 niveles) ----------
class GuiaState {
  final int level;        // 0..5  (5 = detalle de artículo)
  final String? key0;     final String? title0;
  final String? key1;     final String? title1;
  final String? key2;     final String? title2;
  final String? key3;     final String? title3;

  // Nivel 5 (detalle de artículo)
  final String? articleId;
  final String? articleTitle;

  const GuiaState({
    this.level = 0,
    this.key0, this.title0,
    this.key1, this.title1,
    this.key2, this.title2,
    this.key3, this.title3,
    this.articleId,
    this.articleTitle,
  });

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
}

/// Cubit para manejar navegación
class GuiaSectionCubit extends Cubit<GuiaState> {
  GuiaSectionCubit() : super(const GuiaState());

  void openLevel1({required String key0, required String title0}) =>
      emit(state.toLevel1(key0: key0, title0: title0));

  void openLevel2({required String key1, required String title1}) =>
      emit(state.toLevel2(
        key0: state.key0!, title0: state.title0!,
        key1: key1,       title1: title1,
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
        key3: key3,        title3: title3,
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

  void back() {
    if (state.level == 5) {
      // Volver del detalle de artículo a la lista de artículos (nivel 4)
      emit(state.toLevel4(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
        key2: state.key2!, title2: state.title2!,
        key3: state.key3!, title3: state.title3!,
      ));
    } else if (state.level == 4) {
      emit(state.toLevel3(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
        key2: state.key2!, title2: state.title2!,
      ));
    } else if (state.level == 3) {
      emit(state.toLevel2(
        key0: state.key0!, title0: state.title0!,
        key1: state.key1!, title1: state.title1!,
      ));
    } else if (state.level == 2) {
      emit(state.toLevel1(key0: state.key0!, title0: state.title0!));
    } else if (state.level == 1) {
      emit(state.toLevel0());
    }
  }
}

/// Fila plana para UI (para los niveles listados)
class GuiaRow {
  final String id;
  final String label;
  final IconData icon;
  const GuiaRow({required this.id, required this.label, required this.icon});
}

class GuiaView extends StatelessWidget {
  GuiaView({super.key});

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
        return GuiaRow(id: e.id ?? '', label: label, icon: _iconForLabel(label));
      }).toList();
    } else if (s.level == 1) {
      final l1 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key0!,s.level);
      final icon = _iconForLabel(s.title0, fallback: Icons.folder);
      return l1.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon)).toList();
    } else if (s.level == 2) {
      //final l2 = await AppDeps.I.articleRepository.getAllNivel2();
      final l2 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key1!,s.level);
      final icon = _iconForLabel(s.title0, fallback: Icons.folder_open);
      return l2.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon)).toList();
    } else if (s.level == 3) {
      final l3 = await AppDeps.I.articleRepository.fetchAllNivelesScraping(s.key2!,s.level);
      const icon = Icons.description;
      return l3.map((e) => GuiaRow(id: e.id ?? '', label: e.nombre ?? 'Sin nombre', icon: icon)).toList();
    } else if (s.level == 4) {
      // Lista de artículos
      final articles = await AppDeps.I.articleRepository.getAllArticles();
      const icon = Icons.article;
      return articles.map((a) {
        final label = a.tema?.isNotEmpty == true ? a.tema! : 'Sin tema';
        return GuiaRow(id: a.id ?? '', label: label, icon: icon);
      }).toList();
    } else {
      // level == 5 (detalle) no usa lista
      return const <GuiaRow>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuiaSectionCubit(),
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
                  builder: (context, s) {
                    if (s.level == 0) {
                      return const Row(
                        children: [
                          Icon(Icons.menu_book, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Guía', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      );
                    }
                    final title = (s.level == 5)
                        ? (s.articleTitle ?? 'Artículo')
                        : (s.title3 ?? s.title2 ?? s.title1 ?? s.title0) ?? 'Detalle';
                    return Row(
                      children: [
                        InkWell(
                          onTap: () => context.read<GuiaSectionCubit>().back(),
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.arrow_back, size: 24),
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
                      child: s.level == 5
                          ? _ArticleDetail(articleId: s.articleId!)
                          : FutureBuilder<List<GuiaRow>>(
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
                                  Text('${snap.error}',
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center),
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
                                    if (s.level == 0) {
                                      cubit.openLevel1(
                                        key0: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title0: r.label,
                                      );
                                    } else if (s.level == 1) {
                                      cubit.openLevel2(
                                        key1: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title1: r.label,
                                      );
                                    } else if (s.level == 2) {
                                      cubit.openLevel3(
                                        key2: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title2: r.label,
                                      );
                                    } else if (s.level == 3) {
                                      cubit.openLevel4(
                                        key3: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title3: r.label,
                                      );
                                    } else if (s.level == 4) {
                                      // Ir al detalle del artículo
                                      cubit.openArticle(
                                        articleId: r.id,
                                        articleTitle: r.label,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
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

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            // Tema
            Text(
              a.tema ?? 'Sin tema',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Subtemas
            if ((a.subtemas).isNotEmpty) ...[
              const Text('Subtemas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: -8,
                children: a.subtemas.map((s) => Chip(label: Text(s))).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Contenidos
            if ((a.contenidos).isNotEmpty) ...[
              const Text('Contenido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...a.contenidos.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('• $c', style: const TextStyle(fontSize: 15)),
              )),
            ],

            const SizedBox(height: 20),
            // Metadatos opcionales
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
  final child = Container(
    width: double.infinity,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white),
      ],
    ),
  );

  return onTap == null
      ? child
      : InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap, child: child);
}