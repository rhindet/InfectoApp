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

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final PopularArticle article;

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Fecha + CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(article.date, style: const TextStyle(color: Colors.grey)),
                    InkWell(
                      onTap: () => _abrirUrl(article.url),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          children: const [
                            Text(
                              "ver más",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.blueAccent,
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