// lib/src/utils/highlight.dart
/// Resalta cada término de [query] en [html] envolviéndolo con <mark>.
/// No modifica el interior de etiquetas HTML (solo texto plano).
String highlightHtml(String html, String query) {
  final terms = query
      .trim()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (terms.isEmpty) return html;

  // Partimos por tags para no alterar nombres/atributos.
  final parts = html.split(RegExp(r'(<[^>]+>)')); // mantiene los tags en el array
  for (int i = 0; i < parts.length; i++) {
    final seg = parts[i];
    final isTag = seg.startsWith('<') && seg.endsWith('>');
    if (isTag) continue;

    var replaced = seg;
    for (final t in terms) {
      final re = RegExp('(${RegExp.escape(t)})', caseSensitive: false);
      replaced = replaced.replaceAllMapped(re, (m) => '<mark>${m.group(1)}</mark>');
    }
    parts[i] = replaced;
  }
  return parts.join();
}