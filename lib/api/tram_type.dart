import 'package:transportia/api/api.dart';

class ApiTramType {
  final int id;
  final String name;

  ApiTramType({required this.id, required this.name});

  factory ApiTramType.fromJson(Map<String, dynamic> json) {
    return ApiTramType(id: json["id"], name: json["name"]);
  }

  ApiTramType copyWith({int? id, String? name}) {
    return ApiTramType(id: id ?? this.id, name: name ?? this.name);
  }

  static Future<List<ApiTramType>> search(String search) async {
    final data = await Api().get(
      "/tram-types?query=${Uri.encodeQueryComponent(search)}",
    );

    return (data as List).map((json) => ApiTramType.fromJson(json)).toList();
  }

  static Future<ApiTramType?> get(int id) async {
    final data = await Api().get("/tram-types/$id");

    if (data == null) {
      return null;
    }

    return ApiTramType.fromJson(data);
  }

  static Future<int> create({required String name}) async {
    final data = await Api().post("/tram-types", {"id": 0, "name": name});

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create tram type response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/tram-types/$id");
  }

  Future<void> updateType({String? name}) async {
    await Api().patch("/tram-types/$id", {"name": ?name});
  }
}
