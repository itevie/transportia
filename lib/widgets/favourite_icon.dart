import 'package:flutter/material.dart';
import 'package:transportia/api/favourites.dart';

class FavouriteButton extends StatelessWidget {
  final FavouriteType type;
  final String id;
  final bool? isFavourited;
  final bool compact;
  final Future<void> Function() onChanged;

  const FavouriteButton({
    super.key,
    required this.type,
    required this.id,
    required this.isFavourited,
    required this.onChanged,
    this.compact = false,
  });

  Future<void> _toggleFavourite() async {
    if (isFavourited == null) return;

    if (isFavourited!) {
      await ApiFavourite.delete(type, id);
    } else {
      await ApiFavourite.create(type, id);
    }

    await onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isFavourited == null ? null : _toggleFavourite,
      padding: compact ? EdgeInsets.zero : null,
      constraints: compact ? const BoxConstraints() : null,
      visualDensity: compact ? VisualDensity.compact : null,
      icon: Icon(
        Icons.favorite,
        color: isFavourited == true ? Colors.red : null,
      ),
    );
  }
}
