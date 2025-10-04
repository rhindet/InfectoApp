import 'package:flutter/material.dart';
import 'CardBase.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  _InicioViewState createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Aquí decides qué diseño mostrar
            //_buildQuickLinks(),                // 3 en fila (claro)
            _buildQuickLinksAlt(),             // 3 en fila (azul alternativo)
            //_buildQuickLinksRect(),            // Rectangulares outlined (2 columnas)
           // _buildQuickLinksRectFilled(),      // Rectangulares filled azul (2 columnas)
           // _buildQuickLinksExtended(),        // Rectangulares extendidos con descripción
             SizedBox(height: 10),
            _buildTitulo(),
             SizedBox(height: 10),
            _buildCardBase(),
          ],
        ),
      ),
    );
  }

  // ---------- Funciones para cada sección ----------
  Widget _buildTitulo() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 5, top: 8),
      child: const Text(
        "Información Importante",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCardBase() {
    // Ejemplo de artículos (puedes traer estos datos de tu backend)
    final articles = <PopularArticle>[
      const PopularArticle(
        imageAsset: 'assets/imgane_vih2.png',
        tag: 'Artículo',
        title: 'Guía de manejo antirretroviral de las personas con VIH ',
        author: 'Centro Nacional para la Prevención y el Control del VIH/Sida y Hepatitis (Censida)',
        date: '2025',
        url: 'https://www.gob.mx/cms/uploads/attachment/file/1006720/Guia_de_manejo_antirretroviral_de_las_personas_con_VIH_2025.pdf'
      ),
      const PopularArticle(
        imageAsset: 'assets/card_2.png',
        tag: 'Articulo',
        title: '2024 Clinical Practice Guideline Update by the Infectious Diseases Society of America on ComplicatedIntra-abdominal Infections: Risk Assessment, DiagnosticImaging, and Microbiological Evaluation in Adults,Children, and Pregnant People',
        author: 'Oxford Academic',
        date: '2024',
        url: 'https://www.idsociety.org/practice-guideline/intra-abdominal-infections/'
      ),
      const PopularArticle(
        imageAsset: 'assets/card_3.png',
        tag: 'Articulo',
        title: 'Guide to Utilization of the Microbiology Laboratory for Diagnosis of Infectious Diseases: 2024 Update by theInfectious Diseases Society of America (IDSA) and theAmerican Society for Microbiology (ASM)',
        author: 'Oxford Academic',
        date: '2024',
        url: 'https://www.idsociety.org/practice-guideline/laboratory-diagnosis-of-infectious-diseases/'
      ),
    ];

    return CardBase(articles: articles);
  }

  // ====== Cuadrados claros (3 por fila) ======
  Widget _buildQuickLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text("Accesos rápidos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _QuickLinkTile(label: "Fármacos", imageAsset: "assets/medicamento.png", onTap: _noop),
              _QuickLinkTile(label: "Patógenos", imageAsset:"assets/pateogeno.png", onTap: _noop),
              _QuickLinkTile(label: "Vacunas",  imageAsset:"assets/jeringuilla.png", onTap: _noop),
              _QuickLinkTile(label: "Sindromes",  imageAsset:"assets/sindrome-de-down.png", onTap: _noop),
              _QuickLinkTile(label: "Prevencion y control de infecciones",  imageAsset:"assets/escudo-con-simbolo-de-hospital.png", onTap: _noop),
              //_QuickLinkTile(label: "Guías", icon: Icons.menu_book_outlined, onTap: _noop),
            ],
          ),
        ),
      ],
    );
  }

  // ====== Cuadrados azules (3 por fila) ======
  Widget _buildQuickLinksAlt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text("Accesos rápidos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _QuickLinkTileAlt(label: "Fármacos", imageAsset: "assets/medicamento.png", onTap: _noop),
              _QuickLinkTileAlt(label: "Patógenos", imageAsset:"assets/patogeno.png", onTap: _noop),
              _QuickLinkTileAlt(label: "Vacunas",  imageAsset:"assets/jeringuilla.png", onTap: _noop),
              _QuickLinkTileAlt(label: "Sindromes",  imageAsset:"assets/sindrome-de-down.png", onTap: _noop),
              _QuickLinkTileAlt(label: "Prevencion y control de infecciones",  imageAsset:"assets/escudo-con-simbolo-de-hospital.png", onTap: _noop),
             // _QuickLinkTileAlt(label: "Farmacología", icon: Icons.science_outlined, onTap: _noop),
            ],
          ),
        ),
      ],
    );
  }

  // ====== Rectangulares OUTLINED (2 por fila) ======
  Widget _buildQuickLinksRect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "Accesos rápidos (rectangular — outlined)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _QuickLinkRect(label: "Triage Rápido", icon: Icons.local_hospital_outlined, onTap: _noop),
              _QuickLinkRect(label: "Guías Clínicas", icon: Icons.menu_book_outlined, onTap: _noop),
              _QuickLinkRect(label: "Farmacología", icon: Icons.science_outlined, onTap: _noop),
              _QuickLinkRect(label: "Laboratorio", icon: Icons.biotech_outlined, onTap: _noop),
            ],
          ),
        ),
      ],
    );
  }

  // ====== Rectangulares FILLED (2 por fila) ======
  Widget _buildQuickLinksRectFilled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "Accesos rápidos (rectangular — filled)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _QuickLinkRectFilled(label: "Protocolos", icon: Icons.rule_folder_outlined, onTap: _noop),
              _QuickLinkRectFilled(label: "Imágenes", icon: Icons.image_search_outlined, onTap: _noop),
              _QuickLinkRectFilled(label: "Vacunación", icon: Icons.vaccines_outlined, onTap: _noop),
              _QuickLinkRectFilled(label: "Telemedicina", icon: Icons.videocam_outlined, onTap: _noop),
            ],
          ),
        ),
      ],
    );
  }

  // ====== Rectangulares EXTENDIDOS (con descripción) ======
  Widget _buildQuickLinksExtended() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "Accesos rápidos (extended — con descripción)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 10),
        _QuickLinkRectExtended(
          label: "Consulta Médica",
          description: "Accede a consultas generales y especialistas en línea.",
          icon: Icons.safety_check,
          onTap: _noop,
        ),
        SizedBox(height: 10),
        _QuickLinkRectExtended(
          label: "Resultados de Laboratorio",
          description: "Descarga y consulta tus resultados de análisis clínicos.",
          icon: Icons.analytics_outlined,
          onTap: _noop,
        ),
        SizedBox(height: 10),
        _QuickLinkRectFilledExtended(
          label: "Historial Clínico",
          description: "Revisa tu expediente médico y notas anteriores.",
          icon: Icons.folder_shared_outlined,
          onTap: _noop,
        ),
        SizedBox(height: 10),
        _QuickLinkRectFilledExtended(
          label: "Videoconsulta",
          description: "Conéctate con un médico desde la comodidad de tu casa.",
          icon: Icons.video_call_outlined,
          onTap: _noop,
        ),
      ],
    );
  }
}

// ===== util =====
void _noop() {}

/// ---------- Cuadrado claro ----------
class _QuickLinkTile extends StatelessWidget {
  final String label;
  final String imageAsset; // 👈 ruta de tu imagen en assets (por ejemplo: 'assets/icons/vacuna.png')
  final VoidCallback onTap;

  const _QuickLinkTile({
    required this.label,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color surface = Colors.white;
    const Color border = Color(0xFFE6E8EC);
    const Color textColor = Color(0xFF1F2A37);
    const Color chipBg = Color(0xFFE8F2FB);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Imagen en lugar del ícono
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: chipBg,
                shape: BoxShape.circle,
                border: Border.all(color: border),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                imageAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            // 🔹 Texto
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// ---------- Cuadrado azul (gradiente) ----------
class _QuickLinkTileAlt extends StatelessWidget {
  final String label;
  final String imageAsset;
  final VoidCallback onTap;

  const _QuickLinkTileAlt({
    required this.label,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primary     = Color(0xFF4A90E2);
    const Color primaryDark = Color(0xFF407EBD);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [primary, primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), // da un poco de respiro lateral
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono en círculo
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  imageAsset,
                  width: 22, height: 22,
                  fit: BoxFit.contain,
                  color: Colors.white, // quítalo si quieres conservar colores del PNG
                ),
              ),

              const SizedBox(height: 8),

              // Texto auto–ajustable (sin cambiar tamaño del card)
              SizedBox(
                width: double.infinity,
                child: AutoSizeText(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 9,            // hasta dónde puede reducir
                  stepGranularity: 0.5,       // pasos finos de reducción
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// ---------- Rectangular OUTLINED ----------
class _QuickLinkRect extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickLinkRect({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color border = Color(0xFFE6E8EC);
    const Color primary = Color(0xFF146EB4);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(icon, color: primary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: Colors.black38),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// ---------- Rectangular FILLED ----------
class _QuickLinkRectFilled extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickLinkRectFilled({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFE8F2FB);
    const Color primary = Color(0xFF146EB4);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(icon, color: primary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right, color: Colors.black26),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// ---------- Rectangular EXTENDIDO (outlined) ----------
class _QuickLinkRectExtended extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickLinkRectExtended({
    required this.label, required this.description, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color border = Color(0xFFE6E8EC);
    const Color primary = Color(0xFF146EB4);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- Rectangular EXTENDIDO (filled) ----------
class _QuickLinkRectFilledExtended extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickLinkRectFilledExtended({
    required this.label, required this.description, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFE8F2FB);
    const Color primary = Color(0xFF146EB4);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}