import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    this.imageAsset = "assets/about_us.jpeg",
  });

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Paleta reactiva
    final Color headline = isDark ? Colors.white : const Color(0xFF0F3057);
    final Color body     = isDark ? Colors.white70 : const Color(0xFF374151);

    // Card contenedor
    final Color cardBg   = isDark ? const Color(0xFF161A20) : Colors.white;
    final Color cardShadow =
    isDark ? Colors.black45 : Colors.black.withOpacity(0.08);
    final Color cardBorder =
    isDark ? Colors.white10 : Colors.transparent;

    // Chips/valores
    final Color chipBg   = isDark ? const Color(0x1A8AB4FF) : const Color(0xFFE9F2FB);
    final Color chipFg   = isDark ? const Color(0xFFB8D4FF) : const Color(0xFF1E6BB8);
    final Color chipStroke = isDark ? const Color(0x338AB4FF) : const Color(0xFFCAE3FA);

    final t = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, c) {
                final bool isMobile = c.maxWidth < 720;

                final content = isMobile
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Quienes somos",
                      style: t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: headline,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _ImageCard(imageAsset: imageAsset),
                    const SizedBox(height: 18),
                    _TextBlock(
                      headline: headline,
                      body: body,
                      chipBg: chipBg,
                      chipFg: chipFg,
                      chipStroke: chipStroke,
                    ),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _TextBlock(
                        headline: headline,
                        body: body,
                        chipBg: chipBg,
                        chipFg: chipFg,
                        chipStroke: chipStroke,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _ImageCard(imageAsset: imageAsset),
                    ),
                  ],
                );

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadow,
                        blurRadius: isMobile ? 12 : 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: isMobile ? 16 : 24,
                    ),
                    child: content,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({
    required this.headline,
    required this.body,
    required this.chipBg,
    required this.chipFg,
    required this.chipStroke,
  });

  final Color headline;
  final Color body;
  final Color chipBg;
  final Color chipFg;
  final Color chipStroke;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final valores = const [
      "Ética",
      "Espíritu de Servicio",
      "Honestidad",
      "Responsabilidad",
      "Respeto a la vida",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        Text(
          "El Servicio de Infectología forma parte del Departamento de Medicina Interna del "
              "Hospital Universitario “Dr. José Eleuterio González” de la Universidad Autónoma "
              "de Nuevo León, en Monterrey, México.",
          style: t.bodyMedium?.copyWith(
            color: body,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 28),

        Text(
          "Valores",
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: headline,
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: valores.map((valor) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: chipStroke),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: chipFg, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      valor,
                      style: TextStyle(
                        color: chipFg,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({this.imageAsset = "assets/edificio.png"});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,     // ⬅️ define alto en función del ancho
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageAsset, fit: BoxFit.cover),
            if (isDark) Container(color: Colors.black.withOpacity(0.06)),
          ],
        ),
      ),
    );
  }
}

// (Opcional) chip suelto si lo necesitas en algún lugar
class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.label, this.bg, this.fg, this.stroke});
  final String label;
  final Color? bg;
  final Color? fg;
  final Color? stroke;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color chipBg   = bg ?? (isDark ? const Color(0x1A8AB4FF) : const Color(0xFFE9F2FB));
    final Color chipFg   = fg ?? (isDark ? const Color(0xFFB8D4FF) : const Color(0xFF1E6BB8));
    final Color chipLine = stroke ?? (isDark ? const Color(0x338AB4FF) : const Color(0xFFCAE3FA));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipLine),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipFg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}