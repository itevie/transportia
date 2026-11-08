import 'package:transportia/api/api.dart';

class ApiTramOperator {
  final int id;
  final String name;
  final String? location;
  final String? website;

  ApiTramOperator({
    required this.id,
    required this.name,
    this.location,
    this.website,
  });

  factory ApiTramOperator.fromJson(Map<String, dynamic> json) {
    return ApiTramOperator(
      id: json["id"],
      name: json["name"],
      location: json["location"],
      website: json["website"],
    );
  }

  ApiTramOperator copyWith({
    int? id,
    String? name,
    String? location,
    String? website,
  }) {
    return ApiTramOperator(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      website: website ?? this.website,
    );
  }

  static Future<List<ApiTramOperator>> search(String search) async {
    final data = await Api().get(
      "/tram-operators?query=${Uri.encodeQueryComponent(search)}",
    );

    return (data as List)
        .map((json) => ApiTramOperator.fromJson(json))
        .toList();
  }

  static Future<ApiTramOperator?> get(int id) async {
    final data = await Api().get("/tram-operators/$id");

    if (data == null) {
      return null;
    }

    return ApiTramOperator.fromJson(data);
  }

  static Future<int> create({
    required String name,
    String? location,
    String? website,
  }) async {
    final data = await Api().post("/tram-operators", {
      "id": 0,
      "name": name,
      "location": ?location,
      "website": ?website,
    });

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create tram operator response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/tram-operators/$id");
  }

  Future<void> updateOperator({
    String? name,
    String? location,
    String? website,
  }) async {
    await Api().patch("/tram-operators/$id", {
      "name": ?name,
      "location": ?location,
      "website": ?website,
    });
  }
}
