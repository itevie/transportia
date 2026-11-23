import 'package:transportia/api/api.dart';
import 'package:transportia/constants.dart';

class ApiBtLivery {
  final int id;

  final String name;

  final String leftCss;

  final String rightCss;

  final bool whiteText;

  final String textColour;

  final String strokeColour;

  ApiBtLivery({
    required this.id,
    required this.name,
    required this.leftCss,
    required this.rightCss,
    required this.whiteText,
    required this.textColour,
    required this.strokeColour,
  });

  factory ApiBtLivery.fromJson(Map<String, dynamic> json) {
    return ApiBtLivery(
      id: json["id"],
      name: json["name"],
      leftCss: json["left_css"],
      rightCss: json["right_css"],
      whiteText: json["white_text"],
      textColour: json["text_colour"],
      strokeColour: json["stroke_colour"],
    );
  }

  static Future<List<ApiBtLivery>> search({
    String? search,
    String? operatorId,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("operator_id", operatorId),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
    }

    final data = await Api().get("/liveries$query");

    return (data as List).map((json) => ApiBtLivery.fromJson(json)).toList();
  }

  static Future<ApiBtLivery?> get(int id) async {
    final data = await Api().get("/liveries/$id");

    if (data == null) {
      return null;
    }

    return ApiBtLivery.fromJson(data);
  }
}
