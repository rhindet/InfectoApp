import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'InicioView.dart';
import 'ContactoView.dart';
import 'ChangePageBloc.dart';
import '../views/GuiaView.dart';
import 'BaseAlignment.dart';

class BottomTabNavegator extends StatefulWidget {
  const BottomTabNavegator({super.key});

  @override
  State<BottomTabNavegator> createState() => _BottomTabNavegatorState();
}

class _BottomTabNavegatorState extends State<BottomTabNavegator> {
  late final PageController pageController;
  int _bottomNavIndex = 0;

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
    return BlocListener<ChangePageBloc, int>(
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
            backgroundColor: Colors.white,
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children:  [
                Center(child: Text("Calculadora")),
                InicioView(),
                Center(child:BaseAlignment(child: GuiaView() ) ),
                Center(child: Text("Vacunas")),
                Center(child: ContactoView()),
                Center(child: Text("Cómo llegar")),
                Center(child: Text("Términos y condiciones")),
                Center(child: Text("Acerca de")),
                Center(child: Text("<Farmacos>")),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndexForBottomNav,
              onTap: (index) {
                context.read<ChangePageBloc>().add(CambiarPagina(index));
              },
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              backgroundColor: const Color(0xFF084C8A),
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: const Color(0xffABB8C7),
              selectedItemColor: Colors.amber,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: _buildTabIcon(
                    currentIndexForBottomNav == 0,
                    Icons.calculate_outlined,
                  ),
                  label: 'Calculadora',
                ),
                BottomNavigationBarItem(
                  icon: _buildTabIcon(
                    currentIndexForBottomNav == 1,
                    Icons.home,
                  ),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: _buildTabIcon(
                    currentIndexForBottomNav == 2,
                    Icons.inventory_sharp,
                  ),
                  label: 'Guía',
                ),
                BottomNavigationBarItem(
                  icon: _buildTabIcon(
                    currentIndexForBottomNav == 3,
                    Icons.vaccines,
                  ),
                  label: 'Vacunas',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget auxiliar para construir íconos con barra amarilla arriba si está seleccionado
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
            borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
          ),
        ),
        const SizedBox(height: 10),
        Icon(icon, size: 18),
      ],
    );
  }
}