// find_us_page.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FindUsPage extends StatelessWidget {
  const FindUsPage({super.key});

  static const String _imageAsset = "assets/edificio.png";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Paleta reactiva a tema
    const Color primary     = Color(0xFF1C3D8C);
    final Color bgScaffold  = isDark ? const Color(0xFF12151B) : Colors.white;
    final Color appBarBg    = isDark ? const Color(0xFF12151B) : Colors.white;
    final Color appBarFg    = isDark ? Colors.white : primary;
    final Color lightPanel  = isDark ? const Color(0xFF161A20) : const Color(0xFFF2F5FA);
    const double panelRadius = 28;

    final titleStyle = TextStyle(
      color: appBarFg,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.15,
    );

    return Container(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Scaffold(
          backgroundColor: bgScaffold,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarBg,
            foregroundColor: appBarFg,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, color: appBarFg, size: 28),
                const SizedBox(width: 10),
                Text('¡Encuéntranos!', style: titleStyle),
              ],
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              final left = _ImageCard(imageAsset: _imageAsset);
              final right = _InfoPanel(
                primary: primary,
                lightPanel: lightPanel,
                panelRadius: panelRadius,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: left),
                    const SizedBox(width: 24),
                    Expanded(flex: 6, child: right),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    left,
                    const SizedBox(height: 16),
                    right,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.primary,
    required this.lightPanel,
    required this.panelRadius,
  });

  final Color primary;
  final Color lightPanel;
  final double panelRadius;

  static const _addressLines = [
    'Segundo Piso de la Torre de Alta Especialidad y',
    'Medicina Avanzada (AEMA)',
    'Hospital Universitario "Dr. José Eleuterio González"',
    'Av. Francisco I. Madero Pte. S/N y Av. Gonzalitos',
    'Colonia Mitras Centro, C.P. 64460',
    'Monterrey, N.L., México.',
  ];

  // Coordenadas / etiqueta
  static const _lat = 25.690449;
  static const _lng = -100.3490644;
  static const _label = 'Infectología HU UANL';

  // iOS (Apple Maps: esquema y enlace universal)
  Uri get _appleMapsScheme =>
      Uri.parse('maps://?q=${Uri.encodeComponent(_label)}&ll=$_lat,$_lng');
  Uri get _appleMapsUniversal =>
      Uri.parse('https://maps.apple.com/?ll=$_lat,$_lng&q=${Uri.encodeComponent(_label)}');

  // iOS (terceros)
  Uri get _googleMapsIOS =>
      Uri.parse('comgooglemaps://?q=${Uri.encodeComponent(_label)}&center=$_lat,$_lng&zoom=16');
  Uri get _wazeIOS =>
      Uri.parse('waze://?ll=$_lat,$_lng&navigate=yes');

  // Android
  Uri get _googleNavAndroid =>
      Uri.parse('google.navigation:q=$_lat,$_lng(${Uri.encodeComponent(_label)})&mode=d');
  Uri get _googleGeoAndroid =>
      Uri.parse('geo:$_lat,$_lng?q=$_lat,$_lng(${Uri.encodeComponent(_label)})');
  Uri get _wazeAndroid =>
      Uri.parse('waze://?ll=$_lat,$_lng&navigate=yes');

  // Fallback web
  Uri get _webFallback =>
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$_lat,$_lng');

  Future<void> _openChooser(BuildContext context) async {
    // Web: no hay nativo
    if (kIsWeb) {
      await launchUrl(_webFallback, mode: LaunchMode.platformDefault);
      return;
    }

    // Construir opciones
    final List<_MapApp> options = [];

    if (Platform.isIOS) {
      // **Siempre** ofrece Apple Maps primero (sin depender de canLaunchUrl)
      options.add(_MapApp(
        'Apple Maps',
        Icons.map_outlined,
            () async {
          // Intento nativo; si falla, universal (que igualmente abre la app)
          if (await canLaunchUrl(_appleMapsScheme)) {
            await launchUrl(_appleMapsScheme, mode: LaunchMode.externalApplication);
          } else {
            await launchUrl(_appleMapsUniversal, mode: LaunchMode.externalApplication);
          }
        },
      ));

      if (await canLaunchUrl(_googleMapsIOS)) {
        options.add(_MapApp('Google Maps', Icons.map, () async {
          await launchUrl(_googleMapsIOS, mode: LaunchMode.externalApplication);
        }));
      }
      if (await canLaunchUrl(_wazeIOS)) {
        options.add(_MapApp('Waze', Icons.directions_car, () async {
          await launchUrl(_wazeIOS, mode: LaunchMode.externalApplication);
        }));
      }
    } else if (Platform.isAndroid) {
      if (await canLaunchUrl(_googleNavAndroid)) {
        options.add(_MapApp('Google Maps (Navegar)', Icons.directions, () async {
          await launchUrl(_googleNavAndroid, mode: LaunchMode.externalApplication);
        }));
      }
      if (await canLaunchUrl(_googleGeoAndroid)) {
        options.add(_MapApp('Google Maps (Mapa)', Icons.map, () async {
          await launchUrl(_googleGeoAndroid, mode: LaunchMode.externalApplication);
        }));
      }
      if (await canLaunchUrl(_wazeAndroid)) {
        options.add(_MapApp('Waze', Icons.directions_car, () async {
          await launchUrl(_wazeAndroid, mode: LaunchMode.externalApplication);
        }));
      }
    }

    if (options.isEmpty) {
      options.add(_MapApp('Abrir en el navegador', Icons.public, () async {
        await launchUrl(_webFallback, mode: LaunchMode.platformDefault);
      }));
    }

    // Modal de opciones
    final selected = await showModalBottomSheet<_MapApp>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Abrir con', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            for (final opt in options)
              ListTile(
                leading: Icon(opt.icon),
                title: Text(opt.title),
                onTap: () => Navigator.of(ctx).pop(opt),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (selected != null) {
      await selected.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor = isDark ? Colors.white70 : Colors.blue.shade900;

    return Container(
      decoration: ShapeDecoration(
        color: lightPanel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(panelRadius)),
        shadows: [
          BoxShadow(
            color: isDark ? Colors.black38 : const Color(0x14000000),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_addressLines.join('\n'), style: TextStyle(color: bodyColor, fontSize: 16, height: 1.35)),

          const SizedBox(height: 18),

          // Botón: SIEMPRE abre chooser
          Semantics(
            button: true,
            label: 'Elegir aplicación de mapas',
            child: Tooltip(
              message: 'Elegir app (Apple / Google / Waze)',
              child: InkWell(
                onTap: () => _openChooser(context),
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.blue.withOpacity(0.15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.more_horiz, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Elegir app de Mapas",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Divider(height: 1, color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_time, color: primary, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: bodyColor, fontSize: 16, height: 1.35),
                    children: const [
                      TextSpan(text: 'Horario:\n', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: 'Lunes a domingo de 8:00 a.m. a 6:00 p.m.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapApp {
  final String title;
  final IconData icon;
  final Future<void> Function() onTap;
  _MapApp(this.title, this.icon, this.onTap);
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({this.imageAsset = "assets/edificio.png"});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 720;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 160 : 220),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(imageAsset, fit: BoxFit.cover),
                if (isDark)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.05)],
                        ),
                      ),
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

// Curva por si luego quieres usarla en un header con imagen
class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.70, size.width * 0.60, size.height * 0.88);
    path.quadraticBezierTo(size.width * 0.85, size.height * 1.02, size.width, size.height * 0.90);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_CurvedBottomClipper oldClipper) => false;
}