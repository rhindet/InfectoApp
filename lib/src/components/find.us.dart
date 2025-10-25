import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FindUsPage extends StatelessWidget {
  const FindUsPage({super.key});

  final String imageAsset = "assets/edificio.png";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Paleta reactiva a tema
    final Color primary     = const Color(0xFF1C3D8C);
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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

              final left = _ImageCard(imageAsset: imageAsset);
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

class _HospitalImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTall = MediaQuery.of(context).size.width >= 900;
    final double h = isTall ? 420 : 260;

    return ClipPath(
      clipper: _CurvedBottomClipper(),
      child: Container(
        height: h,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.grey.shade200,
          image: const DecorationImage(
            image: AssetImage('assets/find_us.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleStyle = TextStyle(
      color: primary,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.15,
    );

    final bodyColor = isDark ? Colors.white70 : Colors.blue.shade900;

    Future<void> _abrirUrl(String url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
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
          // (Opcional) título dentro del panel:
          // Row(
          //   children: [
          //     Icon(Icons.location_city, color: primary),
          //     const SizedBox(width: 8),
          //     Text('Ubicación', style: titleStyle),
          //   ],
          // ),
          // const SizedBox(height: 12),

          Text(
            'Segundo Piso de la Torre de Alta Especialidad y\n'
                'Medicina Avanzada (AEMA)\n'
                'Hospital Universitario "Dr. José Eleuterio González"\n'
                'Av. Francisco I. Madero Pte. S/N y Av. Gonzalitos\n'
                'Colonia Mitras Centro, C.P. 64460\n'
                'Monterrey, N.L., México.',
            style: TextStyle(color: bodyColor, fontSize: 16, height: 1.35),
          ),

          const SizedBox(height: 18),
        InkWell(
          onTap: () => _abrirUrl(
            "https://www.google.com/maps/place/Servicio+de+Infectolog%C3%ADa+del+Hospital+Universitario+(UANL)/@25.690449,-100.349064,16z/data=!4m6!3m5!1s0x86629562a7bad809:0x82cddaccea741859!8m2!3d25.690449!4d-100.3490644!16s%2Fg%2F11pz3559ps?hl=en&entry=ttu",
          ),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.red.withOpacity(0.2),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  "Ver en Google Maps",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.open_in_new,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
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
                // overlay sutil (ligerísimo) en oscuro para contraste
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