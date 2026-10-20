import 'package:transportia/api/api.dart';

class ApiTxOperator {
  final String id;

  final String? nationalCode;

  final String? code;

  final String shortName;

  final String? licenceNumber;

  final int? commentThread;

  String get displayName =>
      "$shortName${nationalCode != null ? " ($nationalCode)" : ""}";

  ApiTxOperator({
    required this.id,
    required this.nationalCode,
    required this.code,
    required this.shortName,
    required this.licenceNumber,
    required this.commentThread,
  });

  factory ApiTxOperator.fromJson(Map<String, dynamic> json) {
    return ApiTxOperator(
      id: json["id"],
      nationalCode: json["national_code"],
      code: json["code"],
      shortName: json["short_name"],
      licenceNumber: json["licence_number"],
      commentThread: json["comment_thread"],
    );
  }

  static Future<List<ApiTxOperator>> search(String query) async {
    final data = await Api().get(
      "/operators?query=${Uri.encodeQueryComponent(query)}",
    );

    return (data as List).map((json) => ApiTxOperator.fromJson(json)).toList();
  }
}
