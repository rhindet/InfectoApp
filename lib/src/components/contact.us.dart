import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  // Colores de marca (base)
  static const Color primary = Color(0xFF1E6BB8);
  static const Color primarySoft = Color(0xFFE9F2FB);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎨 Paleta adaptativa
    final cardBg        = isDark ? const Color(0xFF161A20) : Colors.white;
    final cardShadow    = isDark ? Colors.black45 : Colors.black.withOpacity(0.15);
    final headerBg      = isDark ? const Color(0x1A1E6BB8) : primarySoft; // sutil en dark
    final titleColor    = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor  = isDark ? Colors.white12 : Colors.black12;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16, // espacio extra cuando aparece el teclado
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Material(
        elevation: 8,
        color: cardBg,
        shadowColor: cardShadow,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              color: headerBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.support_agent, color: primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contáctanos',
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const _Pill(text: 'Lun–Dom · 8:00–18:00'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Cuerpo
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                children: [
                  _ContactRow(
                    icon: Icons.call_outlined,
                    title: 'Laboratorio',
                    subtitle: '8389 1111 ext. 2727 · 81 1006 1414',
                    onTap: () => _call('8110061414'),
                    trailing: Column(
                      children: [
                        _QuickAction(
                          label: 'Llamar',
                          icon: Icons.phone,
                          onTap: () => _call('8110061414'),
                        ),
                      ],
                    ),
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  Divider(height: 20, color: dividerColor),
                  _ContactRow(
                    icon: Icons.call_outlined,
                    title: 'Consulta',
                    subtitle: '8389 1111 ext. 3280',
                    onTap: () => _call('83891111'),
                    trailing: _QuickAction(
                      label: 'Llamar',
                      icon: Icons.phone,
                      onTap: () => _call('83891111'),
                    ),
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  Divider(height: 20, color: dividerColor),
                  _ContactRow(
                    icon: Icons.mail_outline,
                    title: 'Laboratorio',
                    subtitle: 'labinfectohu@gmail.com',
                    onTap: () => _email('labinfectohu@gmail.com'),
                    trailing: _QuickAction(
                      label: 'Escribir',
                      icon: Icons.outgoing_mail,
                      onTap: () => _email('labinfectohu@gmail.com'),
                    ),
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  Divider(height: 20, color: dividerColor),
                  _ContactRow(
                    icon: Icons.mark_email_read_outlined,
                    title: 'Resultados',
                    subtitle: 'resultadoslabinfecto@gmail.com',
                    onTap: () => _email('resultadoslabinfecto@gmail.com'),
                    trailing: _QuickAction(
                      label: 'Escribir',
                      icon: Icons.outgoing_mail,
                      onTap: () => _email('resultadoslabinfecto@gmail.com'),
                    ),
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ),
            ),

            // Redes sociales
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
              child: _SocialBar(
                onFacebook: () => _open('https://facebook.com'),
                onInstagram: () => _open('https://instagram.com'),
                onWhatsapp: () => _open('https://wa.me/5218110012345'),
                onX: () => _open('https://twitter.com'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  // Helpers de acciones
  static Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  static Future<void> _email(String to) async {
    final uri = Uri.parse('mailto:$to');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    required this.titleColor,
    required this.subtitleColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconBoxBg = isDark ? const Color(0x1A1E6BB8) : ContactCard.primarySoft;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBoxBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: ContactCard.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: text.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: text.bodyMedium?.copyWith(
                      color: subtitleColor,
                      height: 1.2,
                    )),
              ],
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: trailing,
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0x1A1E6BB8) : ContactCard.primarySoft; // sutil en oscuro
    final fg = ContactCard.primary;

    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: bg,
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SocialBar extends StatelessWidget {
  const _SocialBar({
    required this.onFacebook,
    required this.onInstagram,
    required this.onWhatsapp,
    required this.onX,
  });

  final VoidCallback onFacebook;
  final VoidCallback onInstagram;
  final VoidCallback onWhatsapp;
  final VoidCallback onX;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _SocialChip(icon: FontAwesomeIcons.facebookF, label: 'Facebook', onTap: onFacebook),
        _SocialChip(icon: FontAwesomeIcons.instagram, label: 'Instagram', onTap: onInstagram),
        _SocialChip(icon: FontAwesomeIcons.whatsapp, label: 'WhatsApp', onTap: onWhatsapp),
        _SocialChip(icon: FontAwesomeIcons.xTwitter, label: 'X / Twitter', onTap: onX),
      ],
    );
  }
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0x1A1E6BB8) : ContactCard.primarySoft; // fondo del chip

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: ContactCard.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: ContactCard.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0x1A1E6BB8) : ContactCard.primary.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: ContactCard.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}