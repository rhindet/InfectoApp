import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PopularArticle {
  final String imageAsset;
  final String tag;
  final String title;
  final String author;
  final String date;
  final String url;

  const PopularArticle({
    required this.imageAsset,
    required this.tag,
    required this.title,
    required this.author,
    required this.date,
    required this.url,
  });
}

class CardBase extends StatefulWidget {
  const CardBase({
    super.key,
    required this.articles,
    this.height = 280,           // alto del carrusel
    this.viewportFraction = 0.9, // “peek” lateral
  });

  final List<PopularArticle> articles;
  final double height;
  final double viewportFraction;

  @override
  State<CardBase> createState() => _CardBaseState();
}

class _CardBaseState extends State<CardBase> {
  PageController? _pageController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void didUpdateWidget(covariant CardBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _pageController?.dispose();
      _pageController = PageController(viewportFraction: widget.viewportFraction);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();
    if (_pageController == null) return const SizedBox.shrink();

    return SizedBox(
      height: widget.height + 20,
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.articles.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final a = widget.articles[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _ArticleCard(article: a),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _DotsIndicator(count: widget.articles.length, index: _index),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  const _ArticleCard({required this.article});
  final PopularArticle article;

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool isFav = false;

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg      = isDark ? const Color(0xFF1B1C1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : const Color(0xFFEAEAEA);
    final shadowColor = isDark ? Colors.black.withOpacity(0.65) : Colors.black.withOpacity(0.14);
    final titleColor  = isDark ? Colors.white : Colors.black87;
    final metaColor   = isDark ? Colors.grey.shade400 : Colors.grey;
    final linkColor   = isDark ? Colors.lightBlueAccent : Colors.blueAccent;
    final chipBg      = isDark ? Colors.white.withOpacity(0.10) : Colors.lightBlueAccent.withOpacity(.25);
    final chipText    = isDark ? Colors.lightBlue.shade200 : Colors.blue;

    return Card(
      elevation: 8,
      color: cardBg,
      surfaceTintColor: Colors.transparent,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              widget.article.imageAsset,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          // Contenido
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Tag + corazón animado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(16),
                        border: isDark ? Border.all(color: Colors.white12) : null,
                      ),
                      child: Text(
                        widget.article.tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: chipText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // ❤️ Corazón con animación
                    GestureDetector(
                      onTap: () {
                        setState(() => isFav = !isFav);
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: isFav
                            ? Icon(
                          Icons.favorite,
                          key: const ValueKey('filled'),
                          color: Colors.redAccent,
                          size: 26,
                        )
                            : Icon(
                          Icons.favorite_border,
                          key: const ValueKey('border'),
                          color: isDark ? Colors.red.shade200 : Colors.red,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Título
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Autor
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Por ${widget.article.author}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: linkColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Fecha + “ver más”
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.article.date, style: TextStyle(color: metaColor)),
                    InkWell(
                      onTap: () => _abrirUrl(widget.article.url),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              "ver más",
                              style: TextStyle(
                                color: linkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: linkColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active = isDark ? Colors.white : Colors.blue;
    final idle   = isDark ? Colors.white.withOpacity(.25) : Colors.blue.withOpacity(.25);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 14 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? active : idle,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}