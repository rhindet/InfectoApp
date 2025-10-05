import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculadoraView extends StatefulWidget {
  @override
  State<CalculadoraView> createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  final _formKey = GlobalKey<FormState>();
  final _ageCtrl = TextEditingController();
  final _scrCtrl = TextEditingController();
  final _ageFocus = FocusNode();
  final _scrFocus = FocusNode();

  String _sex = 'M';
  double? _egfrResult;

  @override
  void initState() {
    super.initState();
    // Cierra teclado cuando ambos campos pierden foco
    _ageFocus.addListener(_handleBlurDismiss);
    _scrFocus.addListener(_handleBlurDismiss);
  }

  void _handleBlurDismiss() {
    if (!_ageFocus.hasFocus && !_scrFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _scrCtrl.dispose();
    _ageFocus.dispose();
    _scrFocus.dispose();
    super.dispose();
  }

  String _normalizeNumber(String v) => v.replaceAll(',', '.').trim();

  void _calculate() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final age = int.parse(_ageCtrl.text.trim());
    final scr = double.parse(_normalizeNumber(_scrCtrl.text));

    final isFemale = (_sex == 'F');
    final k = isFemale ? 0.7 : 0.9;
    final alpha = isFemale ? -0.241 : -0.302;

    final scrOverK = scr / k;
    final minPart = math.pow(math.min(scrOverK, 1.0), alpha) as double;
    final maxPart = math.pow(math.max(scrOverK, 1.0), -1.200) as double;
    final agePart = math.pow(0.9938, age) as double;
    final femaleFactor = isFemale ? 1.012 : 1.0;

    final egfr = 142 * minPart * maxPart * agePart * femaleFactor;

    setState(() => _egfrResult = egfr);
  }

  String _ckdStage(double egfr) {
    if (egfr >= 90) return 'G1 (Normal/Alta)';
    if (egfr >= 60) return 'G2 (Ligeramente reducida)';
    if (egfr >= 45) return 'G3a (Leve-moderada)';
    if (egfr >= 30) return 'G3b (Moderada-severa)';
    if (egfr >= 15) return 'G4 (Severa)';
    return 'G5 (Falla renal)';
  }

  Color _ckdColor(double egfr) {
    if (egfr >= 90) return const Color(0xFF2E7D32);
    if (egfr >= 60) return const Color(0xFF558B2F);
    if (egfr >= 45) return const Color(0xFFF9A825);
    if (egfr >= 30) return const Color(0xFFEF6C00);
    if (egfr >= 15) return const Color(0xFFD32F2F);
    return const Color(0xFFB71C1C);
  }

  InputDecoration _decor(BuildContext context, String label, {String? hint}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? const Color(0xFF1D2229) : Colors.white;
    final baseBorder = isDark ? const Color(0x22FFFFFF) : const Color(0xFFE0E0E0);
    final focusBorder = isDark ? Colors.lightBlueAccent : const Color(0xFF4A90E2);
    final labelColor = isDark ? Colors.white70 : Colors.black87;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      hintText: hint,
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: baseBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: baseBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focusBorder, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDark ? const Color(0xFF0F1115) : const Color(0xFFF4F6F8);

    // En claro: SIN fondo/borde/sombra (transparente). En oscuro: panel oscuro para contraste.
    final cardBg     = isDark ? const Color(0xFF161A20) : Colors.white;          // antes: Colors.transparent
    final cardBorder = isDark ? Colors.white10 : const Color(0xFFE6E8EC);        // antes: Colors.transparent
    final List<BoxShadow> cardShadows = isDark
        ? [const BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4))]
        : [const BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))]; // antes: const []

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Cierra teclado al tocar fuera o al arrastrar
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Título dentro del contenido (opcional). Borra este bloque si no quieres título.
                Text(
                  'TFG (CKD-EPI 2021)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),

                // 🧱 Contenedor del formulario: transparente en claro
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cardBorder, width: isDark ? 1 : 0),
                    boxShadow: cardShadows,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _ageCtrl,
                          focusNode: _ageFocus,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: _decor(context, 'Edad (años)', hint: 'Ej: 60'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Ingresa la edad';
                            final n = int.tryParse(v.trim());
                            if (n == null || n <= 0 || n > 120) return 'Edad inválida';
                            return null;
                          },
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_scrFocus),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _scrCtrl,
                          focusNode: _scrFocus,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          decoration: _decor(context, 'Creatinina sérica (mg/dL)', hint: 'Ej: 1.0'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Ingresa la creatinina';
                            final d = double.tryParse(_normalizeNumber(v));
                            if (d == null || d <= 0 || d > 20) return 'Valor inválido';
                            return null;
                          },
                          onFieldSubmitted: (_) => _calculate(),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _sex,
                          decoration: _decor(context, 'Sexo'),
                          dropdownColor: isDark ? const Color(0xFF1D2229) : Colors.white,
                          items: const [
                            DropdownMenuItem(value: 'M', child: Text('Masculino')),
                            DropdownMenuItem(value: 'F', child: Text('Femenino')),
                          ],
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          onChanged: (v) => setState(() => _sex = v ?? 'M'),
                          iconEnabledColor: isDark ? Colors.white70 : Colors.black54,
                        ),
                        const SizedBox(height: 24),
                        _GradientButton(onPressed: _calculate),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (_egfrResult != null)
                  _ResultCard(
                    egfr: _egfrResult!,
                    stage: _ckdStage(_egfrResult!),
                    color: _ckdColor(_egfrResult!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    this.borderRadius = 16,
    super.key,
  });

  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return Material(
      color: Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF3E7CCC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text(
                'Calcular eGFR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.egfr,
    required this.stage,
    required this.color,
  });

  final double egfr;
  final String stage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Transparente en claro; panel oscuro en modo oscuro
    final bg = isDark ? const Color(0xFF161A20) : Colors.transparent;
    final border = isDark ? Colors.white10 : Colors.transparent;
    final List<BoxShadow> shadows =
    isDark ? [const BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4))] : const [];

    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: isDark ? 1 : 0),
        boxShadow: shadows,
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${egfr.toStringAsFixed(1)} mL/min/1.73 m²',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Categoría: $stage',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}