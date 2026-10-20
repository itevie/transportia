import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double averageRating;
  final int? userRating;

  final VoidCallback removeRating;
  final void Function(int) setRating;

  const StarRating({
    super.key,
    required this.averageRating,
    required this.userRating,
    required this.removeRating,
    required this.setRating,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  void setRating(int rating) {
    if (rating == widget.userRating) {
      widget.removeRating();
    } else {
      widget.setRating(rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: Duration(milliseconds: 500),
      message:
          "Rating: ${widget.averageRating}${widget.userRating != null ? "\nYour Rating: ${widget.userRating}" : ""}",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          final rating = index + 1;
          final selected = (widget.userRating ?? 0) >= rating;

          return IconButton(
            onPressed: () => setRating(rating),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: SizedBox(
              width: 32,
              height: 38,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(
                      0,
                      selected ? -3 : 0,
                      0,
                    ),
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: Stack(
                        children: [
                          const Icon(Icons.star, color: Colors.grey, size: 26),

                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: (widget.averageRating - (rating - 1))
                                  .clamp(0.0, 1.0),
                              child: const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: selected ? 1 : 0,
                    child: const Icon(
                      Icons.circle,
                      size: 5,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
