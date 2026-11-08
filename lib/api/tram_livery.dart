import 'package:transportia/api/api.dart';

class ApiTramLivery {
  final int id;
  final String name;
  final String? css;
  final String? textColour;

  ApiTramLivery({
    required this.id,
    required this.name,
    this.css,
    this.textColour,
  });

  factory ApiTramLivery.fromJson(Map<String, dynamic> json) {
    return ApiTramLivery(
      id: json["id"],
      name: json["name"],
      css: json["css"],
      textColour: json["text_colour"],
    );
  }

  ApiTramLivery copyWith({
    int? id,
    String? name,
    String? css,
    String? textColour,
  }) {
    return ApiTramLivery(
      id: id ?? this.id,
      name: name ?? this.name,
      css: css ?? this.css,
      textColour: textColour ?? this.textColour,
    );
  }

  static Future<List<ApiTramLivery>> search(String search) async {
    final data = await Api().get(
      "/tram-liveries?query=${Uri.encodeQueryComponent(search)}",
    );

    return (data as List).map((json) => ApiTramLivery.fromJson(json)).toList();
  }

  static Future<ApiTramLivery?> get(int id) async {
    final data = await Api().get("/tram-liveries/$id");

    if (data == null) {
      return null;
    }

    return ApiTramLivery.fromJson(data);
  }

  static Future<int> create({
    required String name,
    String? css,
    String? textColour,
  }) async {
    final data = await Api().post("/tram-liveries", {
      "id": 0,
      "name": name,
      "css": ?css,
      "text_colour": ?textColour,
    });

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create tram livery response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/tram-liveries/$id");
  }

  Future<void> updateLivery({
    String? name,
    String? css,
    String? textColour,
  }) async {
    await Api().patch("/tram-liveries/$id", {
      "name": ?name,
      "css": ?css,
      "text_colour": ?textColour,
    });
  }
}
