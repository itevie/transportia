import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int currentRating = 0;

  void setRating(int rating) {
    setState(() {
      currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => setRating(currentRating == 1 ? 0 : 1),
          icon: Icon(Icons.star),
          color: currentRating > 0 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => setRating(2),
          icon: Icon(Icons.star),
          color: currentRating > 1 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => setRating(3),
          icon: Icon(Icons.star),
          color: currentRating > 2 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => setRating(4),
          icon: Icon(Icons.star),
          color: currentRating > 3 ? Colors.yellow : null,
        ),
        IconButton(
          onPressed: () => setRating(5),
          icon: Icon(Icons.star),
          color: currentRating > 4 ? Colors.yellow : null,
        ),
      ],
    );
  }
}
