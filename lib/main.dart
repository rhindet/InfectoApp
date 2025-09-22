import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infecto_migrado/src/components/CounterCubit.dart';
import 'package:infecto_migrado/src/components/BottomTabNavegator.dart';
import 'package:infecto_migrado/src/components/ChangePageBloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:infecto_migrado/src/components/article_filter_cubit.dart';
import 'package:infecto_migrado/src/components/article_search_cubit.dart';

void main() async{
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
  Future.delayed(const Duration(milliseconds: 3000), () {
    FlutterNativeSplash.remove(); // quita la splash
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infecto App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CounterCubit>(create: (_) => CounterCubit()),
          BlocProvider<ChangePageBloc>(create: (_) => ChangePageBloc()),
          BlocProvider<ArticleSearchCubit>(create: (_) => ArticleSearchCubit()),
          BlocProvider<ArticleFilterCubit>(create: (_) => ArticleFilterCubit()),
        ],
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
          title: Container(
              child: Column(
                children: [
                  Row(
                    spacing: 40,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.menu),
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
                        icon: const Icon(Icons.dark_mode),
                        onPressed: (){
                          // TODO: toggle tema
                        },
                      ),
                    ],
                  ),
                ],
              )
          )
      ),
      body: const BottomTabNavegator(),
    );
  }



  void showSideModal(BuildContext outerContext) {
    showGeneralDialog(
      context: outerContext,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(
            builder: (_, c) {
              final bool isMobile = c.maxWidth < 720;
              final double widthFactor = isMobile ? 0.8 : 0.5;

              return FractionallySizedBox(
                widthFactor: widthFactor,
                child: _MenuPanel(
                  onClose: () => Navigator.of(context).pop(),
                  onTapContacto: () {
                    Navigator.of(context).pop();
                    outerContext.read<ChangePageBloc>().add(CambiarPagina(4));
                  },
                  onTapComoLlegar: () {
                    Navigator.of(context).pop();
                    outerContext.read<ChangePageBloc>().add(CambiarPagina(5));
                  },
                  onTapTerminos: () {
                    Navigator.of(context).pop();
                    outerContext.read<ChangePageBloc>().add(CambiarPagina(6));
                  },
                  onTapAcercaDe: () {
                    Navigator.of(context).pop();
                    outerContext.read<ChangePageBloc>().add(CambiarPagina(7));
                  },
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }




}
class _MenuPanel extends StatelessWidget {
  const _MenuPanel({
    required this.onClose,
    required this.onTapContacto,
    required this.onTapComoLlegar,
    required this.onTapTerminos,
    required this.onTapAcercaDe,
  });

  final VoidCallback onClose;
  final VoidCallback onTapContacto;
  final VoidCallback onTapComoLlegar;
  final VoidCallback onTapTerminos;
  final VoidCallback onTapAcercaDe;

  static const Color c1 = Color(0xFF0A3F7A);
  static const Color c2 = Color(0xFF0E5EA8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c1, c2],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                _MenuHeader(onClose: onClose),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    children: [
                      _MenuTile(
                        leading: Icons.phone_android,
                        color: Colors.white,
                        title: 'Contacto',
                        subtitle: 'Números, correos y redes',
                        onTap: onTapContacto,
                      ),
                      const _Sep(),
                      _MenuTile(
                        leading: Icons.map_outlined,
                        color: Colors.white,
                        title: '¿Cómo llegar?',
                        subtitle: 'Ubicación y rutas sugeridas',
                        onTap: onTapComoLlegar,
                      ),
                      const _Sep(),
                      _MenuTile(
                        leading: Icons.edit_note,
                        color: Colors.white,
                        title: 'Términos & Condiciones',
                        subtitle: 'Uso, privacidad y políticas',
                        onTap: onTapTerminos,
                      ),
                      const _Sep(),
                      _MenuTile(
                        leading: Icons.info_outline,
                        color: Colors.white,
                        title: 'Acerca de',
                        subtitle: 'Quiénes somos y misión',
                        onTap: onTapAcercaDe,
                      ),
                      const Spacer(),
                      // Footer también azul
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Infecto App · v1.0.0',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.copyright, size: 14, color: Colors.white54),
                            const SizedBox(width: 4),
                            const Text('2025',
                                style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 18),
      child: Row(
        children: [
          const Spacer(),

          Image.asset(
              "assets/infecto_logo_blanco.png",
              height: 40,
              fit: BoxFit.contain,
            ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  final IconData leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(leading, color: color, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: Colors.white24,
    );
  }
}