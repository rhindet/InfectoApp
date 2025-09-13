import 'package:flutter/material.dart';

class SearchBarCustomed extends StatelessWidget {
  final VoidCallback? onTapped;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController controller; // 👈 requerido para leer el texto al tocar el botón

  const SearchBarCustomed({
    super.key,
    required this.controller,
    this.onTapped,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        onTap: onTapped,
        onChanged: onChanged,
        onSubmitted: onSubmitted, // Enter del teclado
        decoration: InputDecoration(
          hintText: 'Buscar artículos (ej: paracetamol)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            tooltip: 'Buscar',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (onSubmitted != null) {
                onSubmitted!(controller.text); // click del botón = disparar búsqueda
              }
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}