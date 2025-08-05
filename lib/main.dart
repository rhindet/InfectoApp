import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infecto_migrado/src/components/CounterCubit.dart';
import 'package:infecto_migrado/src/components/BottomTabNavegator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infecto App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 40,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               IconButton(
                 iconSize: 30,
                 icon: Icon(Icons.menu),
                 onPressed: (){
                   showSideModal(context);
                 },
               ),
                Image.asset(
                  'assets/infecto_logo_sin_fondo.png',
                  width: 120,
                  height: 40,
                ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.dark_mode),
                onPressed: (){
                },
              ),

            ],
          ),

      ),
      body: BottomTabNavegator(),
    );
  }

  void showSideModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          child: Align(
            alignment:Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5, // Ocupa la mitad de la pantalla
              child: Material(
                color: Color(0xFF084C8A),
                elevation: 10,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor:Color(0xFF084C8A),
                      title: Container(
                        child: Image.asset("assets/infecto_logo_blanco.png"),
                      ),
                      automaticallyImplyLeading: false,
                    ),
                    const Expanded(
                      child: Center(
                          child: Column(
                            children: [
                              TextButton(
                                  child: Text(
                                      "Contacto",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onPressed: null
                              ),
                              TextButton(
                                  child: Text(
                                    "Como Llegar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onPressed: null
                              ),
                              TextButton(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Terminos y\nCondiciones",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onPressed: null
                              ),
                              TextButton(
                                  child: Text(
                                    "Acerca de",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onPressed: null
                              )

                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0), // Empieza fuera de la derecha
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }


}
