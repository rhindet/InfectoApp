import 'package:flutter/material.dart';

class FindUsPage extends StatelessWidget {
  const FindUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF1C3D8C); // azul corporativo
    const Color lightPanel = Color(0xFFF2F5FA); // panel gris-azulado claro
    const double panelRadius = 28;
    final titleStyle = TextStyle(
      color: primary,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.15,
    );
    return Container(
      color: Colors.transparent, // color de fondo “detrás” del scaffold
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32), // 🔹 redondeado global
        child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: primary,
          title:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, color: primary, size: 28),
              const SizedBox(width: 10),
              Text('¡Encuéntranos!', style: titleStyle),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900; // cambia a 900/800 a tu gusto

            final left = _HospitalImage();
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
                  // Foto izquierda
                  Expanded(
                    flex: 5,
                    child: left,
                  ),
                  const SizedBox(width: 24),
                  // Panel derecha
                  Expanded(
                    flex: 6,
                    child: right,
                  ),
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
    ));
  }
}

class _HospitalImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Altura controlada para que se vea “hero”
    final isTall = MediaQuery.of(context).size.width >= 900;
    final double h = isTall ? 420 : 260;

    return ClipPath(
      clipper: _CurvedBottomClipper(),
      child: Container(
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
          color: Colors.grey.shade200,
          image: const DecorationImage(
            image: AssetImage('assets/find_us.png'), // <-- tu imagen
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

/// Panel de información con “sensación” hexagonal (bordes muy redondeados)
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
    final titleStyle = TextStyle(
      color: primary,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.15,
    );

    final bodyStyle = TextStyle(
      color: Colors.blue.shade900,
      fontSize: 16,
      height: 1.35,
    );

    return Container(
      decoration: ShapeDecoration(
        color: lightPanel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(panelRadius),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con ícono de ubicación
          // Dirección
          Text(
            'Segundo Piso de la Torre de Alta Especialidad y\n'
                'Medicina Avanzada (AEMA)\n'
                'Hospital Universitario "Dr. José Eleuterio González"\n'
                'Av. Francisco I. Madero Pte. S/N y Av. Gonzalitos\n'
                'Colonia Mitras Centro, C.P. 64460\n'
                'Monterrey, N.L., México.',
            style: bodyStyle,
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),

          const SizedBox(height: 18),

          // Horario
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_time, color: primary, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: bodyStyle,
                    children: const [
                      TextSpan(
                        text: 'Horario:\n',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'Lunes a domingo de 8:00 a.m. a 6:00 p.m.',
                      ),
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

/// Clipper para simular el borde inferior curvo de la foto
class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Curva suave que sube hacia la derecha
    final Path path = Path();
    path.lineTo(0, size.height * 0.85);

    // Curva de Bezier hacia la derecha
    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.70,
      size.width * 0.60, size.height * 0.88,
    );
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 1.02,
      size.width, size.height * 0.90,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_CurvedBottomClipper oldClipper) => false;
}