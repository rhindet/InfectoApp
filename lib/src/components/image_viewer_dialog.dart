import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullscreenImageViewer {
  static Future<void> open(
      BuildContext context, {
        required String src,
        String? heroTag,
        String? alt,
      }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withOpacity(0.92),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (ctx, anim1, anim2) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        final img = _buildImage(src, fit: BoxFit.contain);

        return SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 5,
                    child: heroTag != null ? Hero(tag: heroTag, child: img) : img,
                  ),
                ),
              ),

              // Top-right X
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black26,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 1,
                            ),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Alt opcional abajo
             // if ((alt ?? '').trim().isNotEmpty)
                //Positioned(
                 // left: 18,
                  //right: 18,
                  //bottom: 18,
                  //child: Text(
                    //alt!.trim(),
                    //textAlign: TextAlign.center,
                    //style: const TextStyle(color: Colors.white70, fontSize: 12),
                    //maxLines: 2,
                    //overflow: TextOverflow.ellipsis,
                  //),
                //),
            ],
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
        return FadeTransition(opacity: fade, child: child);
      },
    );
  }

  // ---------- helpers base64 ----------
  static bool _isDataImage(String src) {
    final s = src.trim().toLowerCase();
    return s.startsWith('data:image/');
  }

  static Uint8List? _tryDecodeDataImage(String src) {
    // formato típico: data:image/png;base64,AAAA...
    final comma = src.indexOf(',');
    if (comma < 0) return null;
    final meta = src.substring(0, comma).toLowerCase();
    if (!meta.contains('base64')) return null;

    final b64 = src.substring(comma + 1).trim();
    if (b64.isEmpty) return null;

    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  static Widget _buildImage(String src, {BoxFit fit = BoxFit.contain}) {
    final trimmed = src.trim();

    if (_isDataImage(trimmed)) {
      final bytes = _tryDecodeDataImage(trimmed);
      if (bytes == null) {
        return const _BrokenImage();
      }
      return Image.memory(
        bytes,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const _BrokenImage(),
      );
    }

    return Image.network(
      trimmed,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final v = progress.expectedTotalBytes == null
            ? null
            : progress.cumulativeBytesLoaded / (progress.expectedTotalBytes!);
        return SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(value: v),
        );
      },
      errorBuilder: (_, __, ___) => const _BrokenImage(),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Icon(Icons.broken_image, size: 42, color: Colors.white70),
    );
  }
}