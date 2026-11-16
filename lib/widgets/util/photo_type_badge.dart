import 'package:flutter/material.dart';
import 'package:transportia/api/photo.dart';

class PhotoTypeBadge extends StatefulWidget {
  final PhotoType photoType;
  final VoidCallback? onTap;

  const PhotoTypeBadge({super.key, required this.photoType, this.onTap});

  @override
  State<PhotoTypeBadge> createState() => _PhotoTypeBadgeState();
}

class _PhotoTypeBadgeState extends State<PhotoTypeBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: 'Change photo type',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: FilledButton.icon(
          onPressed: widget.onTap ?? () {},
          icon: Icon(_isHovered ? Icons.edit : widget.photoType.icon, size: 16),
          label: Text(widget.photoType.humanValue),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: const StadiumBorder(),
            visualDensity: VisualDensity.compact,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
