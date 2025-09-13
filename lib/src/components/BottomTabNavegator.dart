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
  final TextEditingController _searchCtl = TextEditingController(); // 👈


  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: BlocListener<ChangePageBloc, int>(
        listener: (context, state) {
          pageController.jumpToPage(state);
        },
        child: BlocBuilder<ChangePageBloc, int>(
          builder: (context, state) {
            int currentIndexForBottomNav = (state >= 0 && state <= 3) ? state : _bottomNavIndex;

            if (state >= 0 && state <= 3) {
              _bottomNavIndex = state;
            }

            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Column(
                children: [
                  const SizedBox(height: 5),
                  SearchBarCustomed(
                    controller: _searchCtl,            // 👈 pasa el controller
                    onTapped: () {},
                    onChanged: (text) {
                      // opcional: filtro local sobre la lista ya cargada
                      context.read<ArticleFilterCubit>().updateQuery(text);

                      // NO llamar backend aquí
                      context.read<ArticleSearchCubit>().setQuery(text); // solo guarda el texto
                    },
                    onSubmitted: (text) {
                      // SOLO aquí llamas al backend (Enter o botón)
                      context.read<ArticleSearchCubit>().search(text);
                    },
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children:  [
                        Center(child: Text("Calculadora")),
                        InicioView(),
                        Center(child: BaseAlignment(child: GuiaView())),
                        Center(child:
                            BaseAlignment(child:Column(
                              children: [
                                Text('Esquema Nacional de Vacunación', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                               SizedBox(height: 10,),
                                Image.asset(
                                  'assets/vacunacion.jpg',
                                  width: 500,
                                  height: 500,
                                ),
                              ],
                            ) )

                        ),
                        Center(child: Text("Contacto")),
                        //Center(child: ContactoView()),
                        Center(child: Text("Cómo llegar")),
                        Center(child: Text("Términos y condiciones")),
                        Center(child: Text("Acerca de")),
                        Center(child: Text("<Farmacos>")),
                      ],
                    ),
                  ),
                ],
              ),
              // 👉 clave: si hay teclado, no hay bottomNavigationBar
              bottomNavigationBar: AnimatedSwitcher(
                duration: const Duration(milliseconds: 900),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                    return AnimatedSwitcher(
                      duration: isKeyboardVisible
                          ? Duration.zero                           // ocultar: sin animación
                          : const Duration(milliseconds: 600),      // mostrar: fade-in
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      // 🔧 Evita AnimatedSize durante layout
                      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                        return currentChild ?? const SizedBox.shrink();
                      },
                      child: isKeyboardVisible
                          ? const SizedBox.shrink(key: ValueKey('hidden'))
                          : _BottomBar(
                        key: const ValueKey('shown'),
                        currentIndex: currentIndexForBottomNav,
                        onTap: (i) =>
                            context.read<ChangePageBloc>().add(CambiarPagina(i)),
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

  //**
 // Ese error lo provoca AnimatedCrossFade porque usa
 // internamente AnimatedSize, que está intentando animar el
 // tamaño justo durante el performLayout cuando aparece/desaparece el teclado.
 // Arreglo mínimo (solo cambia el builder de KeyboardVisibilityBuilder, nada más):
 // quita AnimatedCrossFade y usa AnimatedSwitcher con un layoutBuilder que desactiva
  //la animación de tamaño.

  //

  /// Widget auxiliar para construir íconos con barra amarilla arriba si está seleccionado
  Widget _buildTabIcon(bool isSelected, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration:  Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 4,
          width: isSelected ? 24 : 0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
          ),
        ),
         SizedBox(height: 10),
        Icon(icon, size: 18),
      ],
    );
  }
}

// Extrae la barra a un widget para que Offstage no recalculé todo
class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final Widget Function(bool, IconData) buildTabIcon;
  const _BottomBar({
    super.key, // ← agrega esto
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