import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infecto_migrado/src/components/table_vacunacion.dart';
import 'package:infecto_migrado/src/components/terminos.y.condiciones.dart';
import 'CalculadoraView.dart';
import 'InicioView.dart';
import 'ContactoView.dart';
import 'ChangePageBloc.dart';
import '../views/GuiaView.dart';
import 'BaseAlignment.dart';
import 'SearchBarCustomed.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'about.us.dart';
import 'article_filter_cubit.dart';
import 'article_search_cubit.dart';
import 'contact.us.dart';
import 'find.us.dart';

class BottomTabNavegator extends StatefulWidget {
  const BottomTabNavegator({super.key});

  @override
  State<BottomTabNavegator> createState() => _BottomTabNavegatorState();
}

class _BottomTabNavegatorState extends State<BottomTabNavegator> {
  late final PageController pageController;
  int _bottomNavIndex = 0;
  final TextEditingController _searchCtl = TextEditingController();

  // Mantén sincronizado este número con la cantidad de children del PageView
  static const int _totalPages = 9;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<ChangePageBloc, int>(
        listener: (context, state) {
          // permite navegar a cualquier página válida (0.._totalPages-1)
          if (state >= 0 && state < _totalPages) {
            pageController.jumpToPage(state);
          }
        },
        child: BlocBuilder<ChangePageBloc, int>(
          builder: (context, state) {
            final int currentIndexForBottomNav =
            (state >= 0 && state <= 3) ? state : _bottomNavIndex;

            if (state >= 0 && state <= 3) {
              _bottomNavIndex = state;
            }

            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Column(
                children: [
                  const SizedBox(height: 5),
                  SearchBarCustomed(
                    controller: _searchCtl,
                    onChanged: (text) {
                      context.read<ArticleSearchCubit>().setQuery(text);
                    },
                    onSubmitted: (text) {
                      final q = text.trim();
                      if (q.isEmpty) return;

                      // 1) Cerrar teclado (opcional pero recomendable)
                      FocusScope.of(context).unfocus();

                      // 2) Ir a la pestaña "Guía"
                      context.read<ChangePageBloc>().add(CambiarPagina(0));

                      // 3) Ejecutar la búsqueda una vez montada la vista
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final search = context.read<ArticleSearchCubit>();
                        search.setQuery(q);
                        search.search(q);
                      });
                    },
                    onClear: () {
                      context.read<ArticleSearchCubit>().clear();
                    },
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Center(child: BaseAlignment(child: GuiaView())),
                        BaseAlignment(child: InicioView()),
                        BaseAlignment(child: CalculadoraView()),
                        Center(child: BaseAlignment(child: TableVacunacion())),
                        BaseAlignment(child: ContactCard()),
                        // Center(child: ContactoView()),
                        BaseAlignment(child: FindUsPage()),
                        BaseAlignment(child: TermsAndConditionsView()),
                        BaseAlignment(child: AboutSection()),
                        const Center(child: Text("<Farmacos>")),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: AnimatedSwitcher(
                duration: const Duration(milliseconds: 900),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                    return AnimatedSwitcher(
                      duration: isKeyboardVisible
                          ? Duration.zero
                          : const Duration(milliseconds: 600),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                        return currentChild ?? const SizedBox.shrink();
                      },
                      child: isKeyboardVisible
                          ? const SizedBox.shrink(key: ValueKey('hidden'))
                          : _BottomBar(
                        key: const ValueKey('shown'),
                        currentIndex: currentIndexForBottomNav,
                        onTap: (i) {
                          // Cerrar teclado
                          FocusScope.of(context).unfocus();

                          // Limpiar el campo de búsqueda
                          _searchCtl.clear();

                          //  Notificar al cubit que también limpie la búsqueda
                          context.read<ArticleSearchCubit>().clear();

                          //. Cambiar de página
                          context.read<ChangePageBloc>().add(CambiarPagina(i));
                        },
                        buildTabIcon: _buildTabIcon,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabIcon(bool isSelected, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 4,
          width: isSelected ? 24 : 0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        Icon(icon, size: 18),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Widget Function(bool, IconData) buildTabIcon;

  const _BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.buildTabIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      backgroundColor: const Color(0xFF084C8A),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: const Color(0xffABB8C7),
      selectedItemColor: Colors.amber,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 0, Icons.inventory_sharp),
          label: 'Guía',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 1, Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 2, Icons.calculate_outlined),
          label: 'Calculadora',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 3, Icons.vaccines),
          label: 'Vacunas',
        ),
      ],
    );
  }
}