import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infecto_migrado/src/components/CounterCubit.dart';
import 'package:infecto_migrado/src/components/BottomTabNavegator.dart';
import 'package:infecto_migrado/src/components/ChangePageBloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infecto App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
        splashFactory: NoSplash.splashFactory, // esto desactiva animación tipo ripple (Animacion al dar click en elemento de TabBar)
        splashColor: Colors.transparent,  // esto desactiva animación tipo ripple
        highlightColor: Colors.transparent, //esto desactiva animación tipo ripple
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CounterCubit>(
            create: (_) => CounterCubit(),
          ),
          BlocProvider<ChangePageBloc>(
            create: (_) => ChangePageBloc(),
          ),
        ],
        child:  MyHomePage(),
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
        title: Container(
          //color: Colors.green ,
          child: Column(
              children: [
                Row(
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

              ],
        )
        )

      ),
      body: BottomTabNavegator(),
    );
  }

  void showSideModal(BuildContext outerContext) {
    showGeneralDialog(
      context: outerContext,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Builder(
          builder: (innerContext) {
            return Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Material(
                  color: const Color(0xFF084C8A),
                  elevation: 10,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: const Color(0xFF084C8A),
                        title: Image.asset("assets/infecto_logo_blanco.png"),
                        automaticallyImplyLeading: false,
                      ),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40,horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(innerContext).pop();
                                      outerContext.read<ChangePageBloc>().add(CambiarPagina(4)); // ir a Contacto
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,  // evita que el botón se expanda
                                      children: const [
                                        Icon(Icons.phone_android, color: Colors.white),
                                        SizedBox(width: 8), // espacio entre icono y texto
                                        Text(
                                          "Contacto",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                        child:TextButton(
                                          onPressed: () {
                                            Navigator.of(innerContext).pop();
                                            outerContext.read<ChangePageBloc>().add(CambiarPagina(5)); // ir a Contacto
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min, // evita que el botón se expanda
                                            children: const [
                                              Icon(Icons.map, color: Colors.white),
                                              SizedBox(width: 8), // espacio entre icono y texto
                                              Text(
                                                "Como llegar?",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                        child:TextButton(
                                          onPressed: () {
                                            Navigator.of(innerContext).pop();
                                            outerContext.read<ChangePageBloc>().add(CambiarPagina(6)); // ir a Contacto
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min, // evita que el botón se expanda
                                            children: const [
                                              Icon(Icons.edit_note, color: Colors.white,size: 25,),
                                              SizedBox(width: 8), // espacio entre icono y texto
                                              Text(
                                                "Terminos & \n Condiciones",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                        child:TextButton(
                                          onPressed: () {
                                            Navigator.of(innerContext).pop();
                                            outerContext.read<ChangePageBloc>().add(CambiarPagina(7)); // Acerca de
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min, // evita que el botón se expanda
                                            children: const [
                                              Icon(Icons.info_outline, color: Colors.white),
                                              SizedBox(width: 8), // espacio entre icono y texto
                                              Text(
                                                "Acerca de",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) ),
                              ],
                            ),
                          )

                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

}
