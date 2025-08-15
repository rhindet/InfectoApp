import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/Repositories/AppDeps.dart';
import '../core/models/Nivel0Model.dart';
import '../core/models/Nivel1Model.dart';
import '../core/models/Nivel2Model.dart';


/// --------- Estado de navegación (0,1,2 niveles) ----------
class GuiaState {
  final int level;        // 0 = nivel0, 1 = nivel1, 2 = nivel2
  final String? key0;     // clave/ID seleccionado en nivel0
  final String? title0;   // título mostrado para nivel0 elegido
  final String? key1;     // clave/ID seleccionado en nivel1
  final String? title1;   // título mostrado para nivel1 elegido

  const GuiaState({
    this.level = 0,
    this.key0,
    this.title0,
    this.key1,
    this.title1,
  });

  GuiaState toLevel0() => const GuiaState(level: 0);
  GuiaState toLevel1({required String key0, required String title0}) =>
      GuiaState(level: 1, key0: key0, title0: title0);
  GuiaState toLevel2({required String key0, required String title0, required String key1, required String title1}) =>
      GuiaState(level: 2, key0: key0, title0: title0, key1: key1, title1: title1);
}

/// Cubit para manejar la ruta actual (nivel + selecciones)
class GuiaSectionCubit extends Cubit<GuiaState> {
  GuiaSectionCubit() : super(const GuiaState());
  void openLevel1({required String key0, required String title0}) =>
      emit(state.toLevel1(key0: key0, title0: title0));
  void openLevel2({required String key1, required String title1}) =>
      emit(state.toLevel2(key0: state.key0!, title0: state.title0!, key1: key1, title1: title1));
  void back() {
    if (state.level == 2) {
      emit(state.toLevel1(key0: state.key0!, title0: state.title0!));
    } else if (state.level == 1) {
      emit(state.toLevel0());
    }
  }
}

/// Fila plana para pintar la lista (independiente del nivel)
class GuiaRow {
  final String id;
  final String label;
  final IconData icon;
  const GuiaRow({required this.id, required this.label, required this.icon});
}

class GuiaView extends StatelessWidget {
  GuiaView({super.key});

  // Mapa nombre → icono (con clave normalizada)
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

  // Carga UNA sola lista según nivel actual
  Future<List<GuiaRow>> _loadRows(GuiaState s) async {
    if (s.level == 0) {
      // NIVEL 0
      final List<Nivel0Model> l0 = await AppDeps.I.articleRepository.getAllNivel0();
      return l0.map((e) {
        final label = e.nombre ?? 'Sin nombre';
        return GuiaRow(
          id: e.id ?? '',
          label: label,
          icon: _iconForLabel(label),
        );
      }).toList();
    } else if (s.level == 1) {
      // NIVEL 1 (por categoría/key0)
      // Ideal: endpoint filtrado
      // final l1 = await AppDeps.I.articleRepository.getNivel1ByNivel0(s.key0!);
      final List<Nivel1Model> l1 = await AppDeps.I.articleRepository.getAllNivel1(); // <-- reemplaza por filtrado real
      final catIcon = _iconForLabel(s.title0, fallback: Icons.folder);
      return l1.map((e) {
        final label = e.nombre ?? 'Sin nombre';
        return GuiaRow(
          id: e.id ?? '',
          label: label,
          icon: catIcon,
        );
      }).toList();
    } else {
      // NIVEL 2 (por key1)
      // Crea en tu repo: getNivel2ByNivel1(s.key1!)
      final List<Nivel2Model> l2 = await AppDeps.I.articleRepository.getAllNivel2(); // <-- reemplaza por filtrado real

      final catIcon = _iconForLabel(s.title0, fallback: Icons.folder_open);
      return l2.map((e) {
        final label = e.nombre ?? 'Sin nombre';
        return GuiaRow(
          id: e.id ?? '',
          label: label,
          icon: catIcon,
        );
      }).toList();
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
              // Encabezado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<GuiaSectionCubit, GuiaState>(
                  builder: (context, s) {
                    if (s.level == 0) {
                      return Row(
                        children: const [
                          Icon(Icons.menu_book, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Guía', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      );
                    }
                    // Nivel 1 o 2: back + título (usa el más específico disponible)
                    final title = s.level == 2 ? (s.title1 ?? s.title0 ?? 'Detalle')
                        : (s.title0 ?? 'Detalle');
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
                        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Contenido (una sola lista)
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
                      child: FutureBuilder<List<GuiaRow>>(
                        key: ValueKey('level-${s.level}-${s.key0}-${s.key1}'),
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
                          if (rows.isEmpty) {
                            return const Center(child: Text('Sin datos'));
                          }

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
                                      // Pasar a Nivel1
                                      cubit.openLevel1(
                                        key0: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title0: r.label,
                                      );
                                    } else if (s.level == 1) {
                                      // Pasar a Nivel2
                                      cubit.openLevel2(
                                        key1: _normalize(r.id.isNotEmpty ? r.id : r.label),
                                        title1: r.label,
                                      );
                                    } else {
                                      // Nivel2 → aquí haces la acción final (abrir detalle, navegar, etc.)
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