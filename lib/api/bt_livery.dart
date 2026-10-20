import 'package:transportia/api/api.dart';

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

  static Future<List<ApiBtLivery>> search(String query) async {
    final data = await Api().get(
      "/liveries?query=${Uri.encodeQueryComponent(query)}",
    );

    return (data as List).map((json) => ApiBtLivery.fromJson(json)).toList();
  }
}
