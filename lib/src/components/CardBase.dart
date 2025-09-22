import 'package:flutter/material.dart';

class PopularArticle {
  final String imageAsset;
  final String tag;
  final String title;
  final String author;
  final String date;

  const PopularArticle({
    required this.imageAsset,
    required this.tag,
    required this.title,
    required this.author,
    required this.date,
  });
}

class CardBase extends StatefulWidget {
  const CardBase({
    super.key,
    required this.articles,
    this.height = 250,          // ↑ más alto para evitar overflow
    this.viewportFraction = .9, // “peek” lateral
  });

  final List<PopularArticle> articles;
  final double height;
  final double viewportFraction;

  @override
  State<CardBase> createState() => _CardBaseState();
}

class _CardBaseState extends State<CardBase> {
  PageController? _pageController; // ← null-safe
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void didUpdateWidget(covariant CardBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia el viewportFraction, recrea el controller
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _pageController?.dispose();
      _pageController = PageController(viewportFraction: widget.viewportFraction);
      setState(() {}); // refrescar
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
    if (_pageController == null) return const SizedBox.shrink(); // seguridad en hot-reload

    return SizedBox(
      height: widget.height + 20, // + indicador
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

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final PopularArticle article;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              article.imageAsset,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          // Contenido
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Tag + fav
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.withOpacity(.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        article.tag,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.favorite_border, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 10),
                // Título
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                // Autor
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Por ${article.author}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Fecha + CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(article.date, style: const TextStyle(color: Colors.grey)),
                    Row(
                      children: const [
                        Text("ver artículo", style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                      ],
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
            color: isActive ? Colors.blue : Colors.blue.withOpacity(.25),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}