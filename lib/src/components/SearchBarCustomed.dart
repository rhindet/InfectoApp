import 'package:flutter/material.dart';

class SearchBarCustomed extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapped;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear; // se llama cuando el texto pasa de no-vacío -> vacío
  final String hint;

  const SearchBarCustomed({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapped,
    this.onClear,
    this.hint = 'Buscar',
  });

  @override
  State<SearchBarCustomed> createState() => _SearchBarCustomedState();
}

class _SearchBarCustomedState extends State<SearchBarCustomed> {
  late final TextEditingController _ctl;
  late final bool _ownsController;

  String _lastText = ''; // guarda el último valor para detectar cambios reales

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ctl = widget.controller ?? TextEditingController();
    _lastText = _ctl.text;

    // Listener que solo reconstruye cuando cambia el texto
    _ctl.addListener(() {
      final current = _ctl.text;
      if (current == _lastText) return; // nada cambió → no reconstruyas

      final wasEmpty = _lastText.trim().isEmpty;
      final isEmpty = current.trim().isEmpty;

      // reconstruye (visibilidad de la X, hint, etc.)
      setState(() {});

      // dispara onClear SOLO cuando va de no-vacío → vacío
      if (!wasEmpty && isEmpty) {
        widget.onClear?.call();
      }

      _lastText = current;
    });
  }

  @override
  void dispose() {
    if (_ownsController) _ctl.dispose();
    super.dispose();
  }

  void _handleClear() {
    if (_ctl.text.isEmpty) return; // evita eventos redundantes
    _ctl.clear(); // esto disparará el listener y llamará onClear() si toca
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = _ctl.text.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _ctl,
        onTap: widget.onTapped,
        onChanged: widget.onChanged, // ya no llamamos onClear aquí; lo decide el listener
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),

          // X solo visible cuando hay texto
          suffixIcon: hasText
              ? IconButton(
            tooltip: 'Borrar',
            icon: const Icon(Icons.clear),
            onPressed: _handleClear,
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        ),
      ),
    );
  }
}