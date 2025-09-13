import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'InicioView.dart';
import 'ContactoView.dart';
import 'ChangePageBloc.dart';
import '../views/GuiaView.dart';
import 'BaseAlignment.dart';
import 'SearchBarCustomed.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'article_filter_cubit.dart';
import 'article_search_cubit.dart';

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
    pageController = PageController();
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
          // ✅ permite navegar a cualquier página válida (0.._totalPages-1)
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
                    onTapped: () {},
                    // si quieres evitar filtrar en vivo, puedes quitar onChanged
                    onChanged: (text) {
                      context.read<ArticleFilterCubit>().updateQuery(text);
                      context.read<ArticleSearchCubit>().setQuery(text); // solo guarda el query
                    },
                    onSubmitted: (text) {
                      context.read<ArticleSearchCubit>().search(text);  // aquí sí busca
                    },
                    onClear: () {
                      // limpiar estados al tocar la X
                      context.read<ArticleFilterCubit>().updateQuery(''); // limpia filtro local
                      context.read<ArticleSearchCubit>().clear();         // 👈 método nuevo (abajo)
                    },
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const Center(child: Text("Calculadora")),
                        const InicioView(),
                        Center(child: BaseAlignment(child: GuiaView())),
                        const Center(
                          child: BaseAlignment(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Esquema Nacional de Vacunación',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Image(
                                  image: AssetImage('assets/vacunacion.jpg'),
                                  width: 500,
                                  height: 500,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Center(child: Text("Contacto")),
                        // Center(child: ContactoView()),
                        const Center(child: Text("Cómo llegar")),
                        const Center(child: Text("Términos y condiciones")),
                        const Center(child: Text("Acerca de")),
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
                        onTap: (i) => context.read<ChangePageBloc>().add(CambiarPagina(i)),
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
          icon: buildTabIcon(currentIndex == 0, Icons.calculate_outlined),
          label: 'Calculadora',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 1, Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 2, Icons.inventory_sharp),
          label: 'Guía',
        ),
        BottomNavigationBarItem(
          icon: buildTabIcon(currentIndex == 3, Icons.vaccines),
          label: 'Vacunas',
        ),
      ],
    );
  }
}