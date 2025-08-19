import 'package:flutter/material.dart';

class SearchBarCustomed extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapped;                // <-- tipo correcto
  final ValueChanged<String>? onSubmitted;
  final String hint;

  const SearchBarCustomed({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint = 'Buscar',
    this.onTapped
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          // Sombra muy suave como en iOS
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTapped,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          border: InputBorder.none,
          // padding para centrar bien el contenido
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        ),
      ),
    );
  }
}