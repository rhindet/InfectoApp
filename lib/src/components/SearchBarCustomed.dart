import 'package:flutter/material.dart';

class SearchBarCustomed extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTapped;
  final VoidCallback? onClear;   // 👈 NUEVO
  final String hint;

  const SearchBarCustomed({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapped,
    this.onClear,                // 👈 NUEVO
    this.hint = 'Buscar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField
        (
        controller: controller,
        onChanged: onChanged,      // si no quieres filtrar en vivo, pásalo null
        onSubmitted: onSubmitted,  // dispara la búsqueda aquí
        onTap: onTapped,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          // 👇 Botón de X que NO llama onChanged('') para evitar re-filtrar
          suffixIcon: controller != null
              ? ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller!,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  // 1) limpiar texto
                  controller!.clear();
                  // 2) accionar limpieza de resultados
                  if (onClear != null) onClear!();
                  // 3) opcional: ocultar teclado
                  // FocusScope.of(context).unfocus();
                },
              );
            },
          )
              : null,
        ),
      ),
    );
  }
}