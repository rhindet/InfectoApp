import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/controllers/TermsService.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({
    super.key,
    this.onAccept,
    this.contactEmail = 'laura.nuzzolos@uanl.edu.mx',
    this.lastUpdated = '03/10/2025',
  });

  final VoidCallback? onAccept;
  final String contactEmail;
  final String lastUpdated;

  static const String appName = 'Terapía antimicrobiana HU';
  static const String orgName =
      'Hospital Universitario "Dr. José Eleuterio González"';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Paleta adaptativa
    final bg = isDark ? const Color(0xFF0E1217) : const Color(0xFFF7F8FA);
    final card = isDark ? const Color(0xFF161A20) : Colors.white;
    final title = isDark ? Colors.white : const Color(0xFF0F172A);
    final body = isDark ? Colors.white70 : const Color(0xFF334155);
    final divider = isDark ? Colors.white12 : Colors.black12;
    final primary = const Color(0xFF1E6BB8);
    final chipBg = isDark ? const Color(0x1A1E6BB8) : const Color(0xFFE9F2FB);
    final chipFg = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E6BB8);

    return FutureBuilder<bool>(
      future: TermsService.isAccepted(),
      builder: (context, snap) {
        final accepted = snap.data ?? false;

        return Scaffold(
          backgroundColor: bg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140),
            child: _GradientHeader(
              title: 'Términos y Condiciones',
              subtitle: appName,
              lastUpdated: lastUpdated,
              primary: primary,
            ),
          ),

          // —— BOTONERA: cambia según si ya aceptó ——
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: accepted
                      ? ElevatedButton.icon(
                    onPressed: null, // 🔒 deshabilitado
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Aceptado'),
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                      isDark ? const Color(0xFF243042) : const Color(0xFFE8EEF6),
                      disabledForegroundColor:
                      isDark ? Colors.white70 : const Color(0xFF1E6BB8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  )
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    // 👉 Solo funciona si NO está aceptado aún
                    onPressed: onAccept,
                    child: const Text('Aceptar'),
                  ),
                ),
              ],
            ),
          ),

          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverList.list(
                  children: [
                    _InfoChipRow(
                      chipBg: chipBg,
                      chipFg: chipFg,
                      primary: primary,
                      items: const [
                        ('Académica', Icons.school_outlined),
                        ('Educativa', Icons.menu_book_outlined),
                        ('No sustituye diagnóstico', Icons.medical_information_outlined),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Bienvenida
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      title: 'Bienvenido(a)',
                      titleColor: title,
                      bodyColor: body,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(color: body, height: 1.45),
                            children: [
                              const TextSpan(text: 'Bienvenido(a) a '),
                              TextSpan(text: appName, style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
                              const TextSpan(text: ' (en adelante, la “Aplicación”), desarrollada por '),
                              TextSpan(text: '${orgName} (en adelante, la “Organización”)', style: const TextStyle(fontWeight: FontWeight.w700)),
                              const TextSpan(
                                text:
                                '. El uso de esta Aplicación implica la aceptación plena de los presentes Términos y Condiciones. '
                                    'Si no está de acuerdo, por favor absténgase de utilizarla.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // 1. Objeto
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '1',
                      title: 'Objeto de la Aplicación',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Paragraph(
                          'La Aplicación tiene fines estrictamente académicos y educativos, y proporciona información técnica y científica '
                              'dirigida a estudiantes de Medicina y áreas afines a la salud. La información contenida no sustituye en ningún '
                              'caso la opinión, diagnóstico o tratamiento médico profesional.',
                        ),
                      ],
                    ),

                    // 2. Cuentas

                    // 3. Propiedad intelectual
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '2',
                      title: 'Propiedad intelectual',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Bullet(
                          'Todo el contenido propio de la Aplicación (textos, diseño, logotipos, interfaces, programación) es propiedad '
                              'de la Organización y está protegido por la legislación aplicable en México.',
                        ),
                        _Bullet(
                          'La Aplicación puede mostrar materiales de terceros con fines académicos, debidamente referenciados. '
                              'El usuario reconoce que dichos materiales son propiedad de sus titulares.',
                        ),
                        _Bullet(
                          'Queda prohibido copiar, distribuir, modificar o utilizar con fines comerciales cualquier contenido sin autorización '
                              'expresa por escrito de la Organización.',
                        ),
                      ],
                    ),

                    // 4. Uso permitido
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '3',
                      title: 'Uso permitido',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Paragraph(
                          'El usuario se compromete a utilizar la Aplicación de forma responsable y únicamente para los fines académicos para los que fue creada. Se prohíbe:',
                        ),
                        _Bullet('Usar la Aplicación para fines ilícitos o contrarios al orden público.'),
                        _Bullet('Suplantar la identidad de otras personas.'),
                        _Bullet('Alterar o manipular el funcionamiento técnico de la Aplicación.'),
                      ],
                    ),

                    // 5. Limitación de responsabilidad
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '4',
                      title: 'Limitación de responsabilidad',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Bullet('La información es de carácter académico y no constituye asesoría médica profesional.'),
                        _Bullet('La Organización no será responsable por decisiones o acciones tomadas con base en la información.'),
                        _Bullet('No se garantiza disponibilidad ininterrumpida ni ausencia de errores técnicos.'),
                      ],
                    ),

                    // 6. Contenido de terceros
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '5',
                      title: 'Exclusión por contenido de terceros',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Paragraph(
                          'La Aplicación puede incluir citas, imágenes, referencias o enlaces a contenidos generados por terceros. '
                              'La Organización no garantiza la veracidad, exactitud, vigencia o legalidad de dichos materiales. '
                              'El uso de este contenido es bajo responsabilidad del usuario.',
                        ),
                      ],
                    ),

                    // 7. Modificaciones
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '6',
                      title: 'Modificaciones',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Paragraph(
                          'La Organización podrá modificar en cualquier momento estos Términos y Condiciones. '
                              'Las modificaciones entrarán en vigor desde su publicación en la Aplicación.',
                        ),
                      ],
                    ),

                    // 8. Ley aplicable
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '7',
                      title: 'Ley aplicable y jurisdicción',
                      titleColor: title,
                      bodyColor: body,
                      children: const [
                        _Paragraph(
                          'Estos Términos y Condiciones se rigen por las leyes aplicables en los Estados Unidos Mexicanos. '
                              'Para su interpretación y cumplimiento, las partes se someten a los tribunales competentes del Estado de Nuevo León, '
                              'renunciando a cualquier otro fuero.',
                        ),
                      ],
                    ),

                    // 9. Contacto
                    _CardBlock(
                      color: card,
                      dividerColor: divider,
                      badge: '8',
                      title: 'Contacto',
                      titleColor: title,
                      bodyColor: body,
                      children: [
                        _Paragraph(
                          'Para consultas o solicitudes relacionadas con estos Términos y Condiciones, escriba al siguiente correo:',
                          color: body,
                        ),
                        const SizedBox(height: 6),
                        _MailChip(
                          email: contactEmail,
                          bg: chipBg,
                          fg: chipFg,
                          iconColor: primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Última actualización: $lastUpdated',
                        style: TextStyle(color: body, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= UI helpers (sin cambios salvo este archivo) =================

class _GradientHeader extends StatelessWidget {
  const _GradientHeader({
    required this.title,
    required this.subtitle,
    required this.lastUpdated,
    required this.primary,
  });

  final String title;
  final String subtitle;
  final String lastUpdated;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = isDark ? const Color(0xFF0B1220) : const Color(0xFF0E4C8A);
    final mid = isDark ? const Color(0xFF132036) : const Color(0xFF1E6BB8);
    final bottom = isDark ? const Color(0xFF0E1217) : const Color(0xFF3BA3F2);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [top, mid, bottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      'Última actualización: $lastUpdated',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChipRow extends StatelessWidget {
  const _InfoChipRow({
    required this.items,
    required this.chipBg,
    required this.chipFg,
    required this.primary,
  });

  final List<(String, IconData)> items;
  final Color chipBg;
  final Color chipFg;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (e) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: primary.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(e.$2, size: 16, color: primary),
              const SizedBox(width: 8),
              Text(e.$1, style: TextStyle(color: chipFg, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({
    required this.color,
    required this.dividerColor,
    required this.title,
    required this.titleColor,
    required this.bodyColor,
    this.badge,
    required this.children,
  });

  final Color color;
  final Color dividerColor;
  final String title;
  final Color titleColor;
  final Color bodyColor;
  final String? badge;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E6BB8).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Color(0xFF1E6BB8),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (badge != null) const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._intersperse(children, Divider(height: 18, color: dividerColor)),
          ],
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text, {this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF334155)),
        fontSize: 14,
        height: 1.45,
      ),
      textAlign: TextAlign.justify,
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dot = isDark ? Colors.white70 : const Color(0xFF475569);
    final body = isDark ? Colors.white70 : const Color(0xFF334155);

    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 6, color: dot),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: body, height: 1.45, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

class _MailChip extends StatelessWidget {
  const _MailChip({
    required this.email,
    required this.bg,
    required this.fg,
    required this.iconColor,
  });

  final String email;
  final Color bg;
  final Color fg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () async {
        final uri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(uri)) launchUrl(uri);
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: iconColor.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mail_outline, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              email,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

// util
List<Widget> _intersperse(List<Widget> list, Widget separator) {
  final out = <Widget>[];
  for (var i = 0; i < list.length; i++) {
    out.add(list[i]);
    if (i != list.length - 1) out.add(separator);
  }
  return out;
}