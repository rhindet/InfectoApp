import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para cargar assets
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class TableVacunacion extends StatefulWidget {
  const TableVacunacion({super.key});

  @override
  State<TableVacunacion> createState() => _TableVacunacionState();
}

class _TableVacunacionState extends State<TableVacunacion> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  final GlobalKey _botoneraKey = GlobalKey(); // clave para posicionar el snackbar
  int _currentIndex = 0;

  // 🎨 Paleta base (modo claro)
  static const Color kPrimary      = Color(0xFF146EB4);
  static const Color kPrimaryLight = Color(0xFF4A90E2);
  static const Color kPrimaryDark  = Color(0xFF407EBD);
  static const Color kSoftBg       = Color(0xFFF5F7FB);
  static const Color kIndicatorOff = Color(0xFFC9D3EA);

  final List<String> _images = const [
    'assets/tabla_vacunacion_2.png',
    'assets/tabla_vacunacion_1.jpg',
    'assets/tabla_vacunacion_3.png',
    'assets/tabla_vacunacion_4.png',
  ];

  /// SnackBar animado que aparece encima de la botonera
  Future<void> _mostrarSnackBar(
      String mensaje, {
        bool esError = false,
        Duration duration = const Duration(seconds: 3),
      }) async {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // Ubicamos la fila de botones
    final renderBox = _botoneraKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;

    // Altura estimada del snackbar
    const double snackHeight = 60;
    // Coordenada Y: un poco arriba del top de la botonera
    final double? topY = (offset != null) ? (offset.dy - snackHeight - 10) : null;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
    );
    final slide = Tween<Offset>(begin: const Offset(0, .25), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic),
    );
    final fade = CurvedAnimation(parent: controller, curve: Curves.easeOut, reverseCurve: Curves.easeIn);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        final media = MediaQuery.of(context);
        // Si no logramos medir la botonera, colocamos al fondo con un margen fijo
        final double? top = topY ?? (media.size.height - snackHeight - media.padding.bottom - 76);
        final double left = 16;
        final double right = 16;
        final double width = size?.width ?? media.size.width - left - right;

        return Positioned(
          left: left,
          right: right,
          top: top,
          child: SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: _SnackContent(
                mensaje: mensaje,
                esError: esError,
                width: width,
                gradient: esError
                    ? null
                    : const LinearGradient(
                  colors: [kPrimary, kPrimaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    await controller.forward();
    await Future.delayed(duration);
    await controller.reverse();
    entry.remove();
    controller.dispose();
  }

  void _ampliarImagen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.8,
              maxScale: 5.0,
              child: Image.asset(_images[_currentIndex], fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _descargarImagen() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      _mostrarSnackBar("Permiso de almacenamiento denegado", esError: true);
      return;
    }

    try {
      final ByteData bytes = await rootBundle.load(_images[_currentIndex]);
      final Uint8List uint8List = bytes.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        uint8List,
        quality: 100,
        name: "vacunacion_${_currentIndex + 1}",
      );

      if (result['isSuccess'] == true) {
        _mostrarSnackBar("Imagen guardada en galería ");
      } else {
        throw Exception("Error al guardar");
      }
    } catch (e) {
      _mostrarSnackBar("Error al descargar: $e", esError: true);
    }
  }

  void _abrirEnChrome() async {
    final url = Uri.parse("https://www.gob.mx/cms/uploads/attachment/file/977163/Lineamientos_Generales_2025_.pdf");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _mostrarSnackBar("No se pudo abrir el enlace", esError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores dependientes de tema
    final bgSoft = isDark ? const Color(0xFF0F1115) : kSoftBg;
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : Colors.black,
    );

    final indicatorActive = isDark ? Colors.lightBlueAccent : kPrimaryLight;
    final indicatorIdle   = isDark ? Colors.white24 : kIndicatorOff;

    // Botones circulares - colores dependientes de tema
    final buttonBg     = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final buttonBorder = isDark ? Colors.white24 : kPrimaryLight.withOpacity(0.25);
    final iconColor    = isDark ? Colors.lightBlueAccent : kPrimary;
    final splashColor  = (isDark ? Colors.lightBlueAccent : kPrimary).withOpacity(0.12);

    return Column(
      children: [
        Text(
          'Esquema Nacional de Vacunación',
          textAlign: TextAlign.center,
          style: titleStyle,
        ),

        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final path = _images[index].replaceAll('"', '').trim();
              return Container(
                alignment: Alignment.center,
                color: bgSoft,
                child: Image.asset(
                  path,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (i) {
            final selected = i == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: selected ? 18 : 6,
              decoration: BoxDecoration(
                color: selected ? indicatorActive : indicatorIdle,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // 🔑 Botonera con key para posicionar el snackbar
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            key: _botoneraKey,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _IconButtonCircle(
                icon: CupertinoIcons.fullscreen,
                onTap: _ampliarImagen,
                materialColor: buttonBg,
                iconColor: iconColor,
                splashColor: splashColor,
                borderColor: buttonBorder,
              ),
              _IconButtonCircle(
                icon: CupertinoIcons.arrow_down_circle,
                onTap: _descargarImagen,
                materialColor: buttonBg,
                iconColor: iconColor,
                splashColor: splashColor,
                borderColor: buttonBorder,
              ),
              _IconButtonCircle(
                icon: CupertinoIcons.globe,
                onTap: _abrirEnChrome,
                materialColor: buttonBg,
                iconColor: iconColor,
                splashColor: splashColor,
                borderColor: buttonBorder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SnackContent extends StatelessWidget {
  const _SnackContent({
    required this.mensaje,
    required this.esError,
    required this.width,
    this.gradient,
  });

  final String mensaje;
  final bool esError;
  final double width;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: gradient,
            color: esError ? Colors.red.shade700 : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Icon(
                esError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.amberAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.w700,
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

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  // ahora todos los colores son parametrizables (y ya los enviamos desde arriba)
  final Color materialColor;
  final Color iconColor;
  final Color splashColor;
  final Color borderColor;

  const _IconButtonCircle({
    required this.icon,
    required this.onTap,
    this.materialColor = Colors.white,
    this.iconColor = const Color(0xFF146EB4),
    this.splashColor = const Color(0x20146EB4),
    this.borderColor = const Color(0x40146EB4),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: materialColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: splashColor,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 26, color: iconColor),
        ),
      ),
    );
  }
}