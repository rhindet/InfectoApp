import 'package:flutter/material.dart';
import 'InicioView.dart';

class BottomTabNavegator extends StatelessWidget {
  const BottomTabNavegator({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text('Calculadora')),
            InicioView(),
            Center(child: Text('Guía')),
            Center(child: Text('Vacunación')),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          color: const Color(0xFF084C8A),
          child: const TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 0.0),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 2,
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.amber,
                  width: 5.0,
                ),
              ),
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.calculate_outlined, size: 16),
                child: Text(
                  'Calculadora',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                icon: Icon(Icons.home, size: 16),
                child: Text(
                  'Inicio',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                icon: Icon(Icons.inventory_sharp, size: 16),
                child: Text(
                  'Guía',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                icon: Icon(Icons.vaccines, size: 16),
                child: Text(
                  'Vacunas',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}