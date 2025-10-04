import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    this.imageAsset = "assets/about_us.jpeg",
  });

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    const Color headline = Color(0xFF0F3057);
    const Color body     = Color(0xFF374151);
    const Color chipBg   = Color(0xFFE9F2FB);
    const Color chipFg   = Color(0xFF1E6BB8);
    final t = Theme.of(context).textTheme;

    // Para que no ocupe todo el ancho en pantallas grandes
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
                    // Título
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
                    _TextBlock(headline: headline, body: body, chipBg: chipBg, chipFg: chipFg),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Texto
                    Expanded(
                      flex: 2,
                      child: _TextBlock(
                        headline: headline,
                        body: body,
                        chipBg: chipBg,
                        chipFg: chipFg,
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Imagen
                    const Expanded(
                      flex: 1,
                      child: _ImageCard(),
                    ),
                  ],
                );
      
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
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
  });

  final Color headline;
  final Color body;
  final Color chipBg;
  final Color chipFg;

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
        // Párrafo
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

        // Subtítulo
        Text(
          "Valores",
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: headline,
          ),
        ),
        const SizedBox(height: 12),

        // Lista de valores estilizada
        Column(
          children: valores.map((valor) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F2FB), // mismo azul suave de las burbujas
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCAE3FA)),
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
                  const Icon(Icons.star, color: Color(0xFF1E6BB8), size: 20), // ícono cool
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      valor,
                      style: const TextStyle(
                        color: Color(0xFF1E6BB8),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // 🔹 bordes redondeados
      child: Image.asset(
        imageAsset,
        fit: BoxFit.cover,     // 🔹 ocupa todo el espacio recortando si es necesario
        width: double.infinity,
        height: 220,           // 🔹 alto fijo, puedes ajustar según tu diseño
      ),
    );
  }
}
class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCAE3FA)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1E6BB8),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}