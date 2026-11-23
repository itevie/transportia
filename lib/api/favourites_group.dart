import 'package:transportia/api/api.dart';
import 'package:transportia/api/favourites.dart';

class ApiFavouriteGroup {
  final int id;
  final FavouriteType favouriteType;
  final int ownerId;
  final String name;
  final String createdAt;

  ApiFavouriteGroup({
    required this.id,
    required this.favouriteType,
    required this.ownerId,
    required this.name,
    required this.createdAt,
  });

  factory ApiFavouriteGroup.fromJson(Map<String, dynamic> json) {
    print(json["favourite_type"]);
    return ApiFavouriteGroup(
      id: json["id"],
      favouriteType: FavouriteType.values.firstWhere(
        (type) => type.apiValue == json["favourite_type"],
      ),
      ownerId: json["owner_id"],
      name: json["name"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "favourite_type": favouriteType.value,
      "owner_id": ownerId,
      "name": name,
      "created_at": createdAt,
    };
  }

  static Future<ApiFavouriteGroup?> get(int userId, int id) async {
    final data = await Api().get("/users/$userId/favourites/groups/$id");

    if (data == null) {
      return null;
    }

    return ApiFavouriteGroup.fromJson(data);
  }

  static Future<List<ApiFavouriteGroup>> getAll(int userId) async {
    final data = await Api().get("/users/$userId/favourites/groups");

    return (data as List).map((x) => ApiFavouriteGroup.fromJson(x)).toList();
  }

  static Future<List<ApiFavouriteGroup>> search(
    int userId, {
    FavouriteType? favouriteType,
    String? search,
    int pageLength = 50,
    int offset = 0,
  }) async {
    final query = <String, String>{
      if (favouriteType != null)
        "favourite_type": favouriteType.value.toString(),
      if (search != null && search.isNotEmpty) "search": search,
      "page_length": pageLength.toString(),
      "offset": offset.toString(),
    };

    final queryString = Uri(queryParameters: query).query;
    final data = await Api().get(
      "/users/$userId/favourites/groups?$queryString",
    );

    return (data as List)
        .map((json) => ApiFavouriteGroup.fromJson(json))
        .toList();
  }

  static Future<void> create(
    int userId,
    FavouriteType favouriteType,
    String name,
  ) async {
    await Api().post("/users/$userId/favourites/groups", {
      "favourite_type": favouriteType.value,
      "name": name,
    });
  }

  static Future<void> update(
    int userId, {
    required int id,
    required FavouriteType favouriteType,
    required String name,
  }) async {
    await Api().patch("/users/$userId/favourites/groups/$id", {
      "favourite_type": favouriteType.value,
      "name": name,
    });
  }

  static Future<void> delete(int userId, int id) async {
    await Api().delete("/users/$userId/favourites/groups/$id");
  }
}
