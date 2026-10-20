import 'package:flutter/material.dart';

class ProgressivePhotoImage extends StatefulWidget {
  final String Function(int width) imageUrl;
  final int thumbnailWidth;
  final BoxFit fit;
  const ProgressivePhotoImage({
    super.key,
    required this.imageUrl,
    this.thumbnailWidth = 400,
    this.fit = BoxFit.contain,
  });
  @override
  State<ProgressivePhotoImage> createState() => _ProgressivePhotoImageState();
}

class _ProgressivePhotoImageState extends State<ProgressivePhotoImage> {
  bool _thumbnailLoaded = false;
  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = widget.imageUrl(widget.thumbnailWidth);
    final fullUrl = widget.imageUrl(0);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          thumbnailUrl,
          fit: widget.fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              _thumbnailLoaded = true;
            } else if (frame != null && !_thumbnailLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _thumbnailLoaded = true;
                  });
                }
              });
            }
            return child;
          },
        ),
        if (_thumbnailLoaded)
          Image.network(
            fullUrl,
            fit: widget.fit,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
