import 'package:transportia/api/api.dart';

class ApiFavourite {
  final int id;
  final int userId;
  final String targetId;
  final FavouriteType targetType;
  final String createdAt;
  final dynamic object;

  ApiFavourite({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.createdAt,
    required this.object,
  });

  factory ApiFavourite.fromJson(Map<String, dynamic> json) {
    return ApiFavourite(
      id: json["id"],
      userId: json["user_id"],
      targetId: json["target_id"],
      targetType: FavouriteType.fromJson(json["target_type"]),
      createdAt: json["created_at"],
      object: json["object"],
    );
  }

  static Future<List<ApiFavourite>> getByType(
    FavouriteType type, {
    bool fillOut = false,
  }) async {
    final data = await Api().get(
      "/favourites?target_type=${type.apiValue}&fill_out=$fillOut",
    );

    return (data as List).map((json) => ApiFavourite.fromJson(json)).toList();
  }

  static Future<ApiFavourite?> get(
    FavouriteType type,
    int targetId, {
    bool fillOut = false,
  }) async {
    final data = await Api().get(
      "/favourites"
      "?target_type=${type.apiValue}"
      "&target_id=$targetId"
      "&fill_out=$fillOut",
    );

    if (data == null) {
      return null;
    }

    return ApiFavourite.fromJson(data);
  }

  static Future<void> create(FavouriteType type, String targetId) async {
    await Api().post(
      "/favourites"
      "?target_type=${type.apiValue}"
      "&target_id=$targetId",
      {},
    );
  }

  static Future<void> delete(FavouriteType type, String targetId) async {
    await Api().delete(
      "/favourites"
      "?target_type=${type.apiValue}"
      "&target_id=$targetId",
    );
  }
}

enum FavouriteType {
  photo(0, "Photo"),
  operator_(1, "Operator"),
  vehicle(2, "Vehicle"),
  vehicleType(3, "VehicleType"),
  livery(4, "Livery"),
  service(5, "Service"),
  comment(6, "Comment");

  final int value;
  final String apiValue;

  const FavouriteType(this.value, this.apiValue);

  // static FavouriteType fromJson(int value) {
  //   return FavouriteType.values.firstWhere((type) => type.value == value);
  // }
  static FavouriteType fromJson(String value) {
    return FavouriteType.values.firstWhere((type) => type.apiValue == value);
  }
}
