class ApiPhotoRatingResponse {
  final int? rating;
  final double averageRating;

  ApiPhotoRatingResponse({required this.rating, required this.averageRating});

  factory ApiPhotoRatingResponse.fromJson(Map<String, dynamic> json) {
    return ApiPhotoRatingResponse(
      rating: json["rating"],
      averageRating: (json["average_rating"] as num).toDouble(),
    );
  }
}
