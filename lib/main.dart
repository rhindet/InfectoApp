import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:infecto_migrado/src/components/terminos.y.condiciones.dart';
import 'package:infecto_migrado/src/core/controllers/TermsService.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:infecto_migrado/src/components/CounterCubit.dart';
import 'package:infecto_migrado/src/components/BottomTabNavegator.dart';
import 'package:infecto_migrado/src/components/ChangePageBloc.dart';
import 'package:infecto_migrado/src/components/article_filter_cubit.dart';
import 'package:infecto_migrado/src/components/article_search_cubit.dart';
import 'package:infecto_migrado/src/utils/themecubit.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Future.delayed(const Duration(milliseconds: 3000), () {
    FlutterNativeSplash.remove();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterCubit>(create: (_) => CounterCubit()),
        BlocProvider<ChangePageBloc>(create: (_) => ChangePageBloc()),
        BlocProvider<ArticleSearchCubit>(create: (_) => ArticleSearchCubit()),
        BlocProvider<ArticleFilterCubit>(create: (_) => ArticleFilterCubit()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Terapía antimicrobiana HU',
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70, brightness: Brightness.light),
              scaffoldBackgroundColor: const Color(0xFFF7F9FC),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF4F7FA),
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              useMaterial3: true,
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF084C8A), brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF12151B),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0A0B0F),
                foregroundColor: Colors.white,
                elevation: 1,
              ),
              useMaterial3: true,
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: BouncingScrollWrapper(child: child!),
              breakpoints: const [
                Breakpoint(start: 0, end: 360, name: MOBILE),
                Breakpoint(start: 360, end: 480, name: 'MOBILE_L'),
                Breakpoint(start: 480, end: 768, name: TABLET),
                Breakpoint(start: 768, end: 1024, name: DESKTOP),
                Breakpoint(start: 1024, end: double.infinity, name: 'XL'),
              ],
            ),
            //Puerta de acceso: muestra T&C si no se han aceptado
            home: const _LaunchGate(),
          );
        },
      ),
    );
  }
}

/// Decide si mostrar T&C o la app
class _LaunchGate extends StatelessWidget {
  const _LaunchGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: TermsService.isAccepted(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final accepted = snap.data!;
        if (accepted) {
          return const MyHomePage();
        }

        // Bloquea “back” para no saltar sin aceptar (opcional)
        return WillPopScope(
          onWillPop: () async => false,
          child: TermsAndConditionsView(
            //  personaliza si hace falta:
            contactEmail: 'laura.nuzzolos@uanl.edu.mx',
            lastUpdated: '03/10/2025',
            onAccept: () async {
              await TermsService.accept();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                );
              }
            },
          ),
        );
      },
    );
  }
}

/// Tu Home original (no lo toqué)
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
                      onPressed: () {
                        showSideModal(context);
                      },
                    ),
                    BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return Image.asset(
                          isDark
                              ? 'assets/infecto_logo_blanco.png'
                              : 'assets/infecto_logo_sin_fondo.png',
                          width: 120,
                          height: 40,
                        );
                      },
                    ),
                    BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return IconButton(
                          iconSize: 30,
                          onPressed: () => context.read<ThemeCubit>().toggle(),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, anim) {
                              return RotationTransition(
                                turns: Tween<double>(begin: 0.75, end: 1.0).animate(anim),
                                child: FadeTransition(opacity: anim, child: child),
                              );
                            },
                            child: isDark
                                ? const Icon(Icons.wb_sunny, key: ValueKey('sun'), color: Colors.amber)
                                : const Icon(Icons.dark_mode, key: ValueKey('moon'), color: Colors.black87),
                          ),
                          tooltip: isDark ? 'Tema claro' : 'Tema oscuro',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
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

// … (tu _MenuPanel, _MenuHeader, etc. permanecen iguales)



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
                      // Footer también azul

                    ],
                  ),
                ),
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
                          'v1.0.0',
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
    return const Divider(
      height: 1,
      thickness: 0.8,
      color: Colors.white24,
    );
  }
}