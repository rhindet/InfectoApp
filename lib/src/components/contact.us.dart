import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  // Colores de marca
  static const Color primary = Color(0xFF1E6BB8);
  static const Color primarySoft = Color(0xFFE9F2FB);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Material(
        elevation: 8,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              color: primarySoft,
              child: Row(
                children: [
                  const Icon(Icons.support_agent, color: primary),
                  const SizedBox(width: 10),
                  Text(
                    'Contáctanos',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  const Spacer(),
                  _Pill(text: 'Lun–Dom · 8:00–18:00'),
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
                    trailing: _QuickAction(
                      label: 'Llamar',
                      icon: Icons.phone,
                      onTap: () => _call('8110061414'),
                    ),
                  ),
                  const Divider(height: 20),
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
                  ),
                  const Divider(height: 20),
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
                  ),
                  const Divider(height: 20),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

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
              color: ContactCard.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.call_outlined, color: ContactCard.primary),
          ).withIcon(icon), // extensión definida abajo
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: text.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: text.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.2,
                    )),
              ],
            ),
          ),
          if (trailing != null) trailing!,
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
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: ContactCard.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: ContactCard.primarySoft,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
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
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ContactCard.primarySoft,
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

/// ---- Pequeña extensión para reutilizar el contenedor de icono ----
extension _IconBox on Widget {
  Widget withIcon(IconData icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        this,
        Icon(icon, color: ContactCard.primary),
      ],
    );
  }
}


class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ContactCard.primary.withOpacity(0.1),
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