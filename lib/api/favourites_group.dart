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
    return ApiFavouriteGroup(
      id: json["id"],
      favouriteType: FavouriteType.values.firstWhere(
        (type) => type.value == json["favourite_type"],
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

  static Future<ApiFavouriteGroup?> get(int id) async {
    final data = await Api().get("/favourites/groups/$id");

    if (data == null) {
      return null;
    }

    return ApiFavouriteGroup.fromJson(data);
  }

  static Future<List<ApiFavouriteGroup>> getAll() async {
    final data = await Api().get("/favourites/groups");

    return (data as List).map((x) => ApiFavouriteGroup.fromJson(x)).toList();
  }

  static Future<List<ApiFavouriteGroup>> search({
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
    final data = await Api().get("/favourites/groups?$queryString");

    return (data as List)
        .map((json) => ApiFavouriteGroup.fromJson(json))
        .toList();
  }

  static Future<void> create(FavouriteType favouriteType, String name) async {
    await Api().post("/favourites/groups", {
      "favourite_type": favouriteType.value,
      "name": name,
    });
  }

  static Future<void> update({
    required int id,
    required FavouriteType favouriteType,
    required String name,
  }) async {
    await Api().patch("/favourites/groups/$id", {
      "favourite_type": favouriteType.value,
      "name": name,
    });
  }

  static Future<void> delete(int id) async {
    await Api().delete("/favourites/groups/$id");
  }
}
