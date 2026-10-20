import 'package:transportia/api/api.dart';

class ApiTxLine {
  final String txId;

  final String name;

  final String? operatorCode;

  final String? operatorNationalCode;

  final String lineId;

  final String serviceCode;

  final String? outboundDescription;

  final String? inboundDescription;

  String get displayName =>
      "$name ${outboundDescription ?? inboundDescription}";

  ApiTxLine({
    required this.txId,
    required this.name,
    required this.operatorCode,
    required this.operatorNationalCode,
    required this.lineId,
    required this.serviceCode,
    required this.outboundDescription,
    required this.inboundDescription,
  });

  factory ApiTxLine.fromJson(Map<String, dynamic> json) {
    return ApiTxLine(
      txId: json["tx_id"],
      name: json["name"],
      operatorCode: json["operator_code"],
      operatorNationalCode: json["operator_national_code"],
      lineId: json["line_id"],
      serviceCode: json["service_code"],
      outboundDescription: json["outbound_description"],
      inboundDescription: json["inbound_description"],
    );
  }

  static Future<List<ApiTxLine>> fetchAll({
    String? search,
    String? txId,
    String? name,
    String? operatorCode,
    String? operatorNationalCode,
    String? lineId,
    String? serviceCode,
    String? outboundDescription,
    String? inboundDescription,
    int? pageLength = 50,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("tx_id", txId),
      ("name", name),
      ("operator_code", operatorCode),
      ("operator_national_code", operatorNationalCode),
      ("line_id", lineId),
      ("service_code", serviceCode),
      ("outbound_description", outboundDescription),
      ("inbound_description", inboundDescription),
      ("page_length", pageLength.toString()),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2!)}";
    }

    final data = await Api().get("/lines$query");

    return (data as List).map((json) => ApiTxLine.fromJson(json)).toList();
  }
}
