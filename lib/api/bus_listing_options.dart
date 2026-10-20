import 'package:transportia/api/api.dart';

class ApiBusListingQueryOptions {
  final List<String> scale;
  final List<String> originCode;
  final List<String> manufacturer;
  final List<String> manufacturerCode;
  final List<String> condition;

  ApiBusListingQueryOptions({
    required this.scale,
    required this.originCode,
    required this.manufacturer,
    required this.manufacturerCode,
    required this.condition,
  });

  factory ApiBusListingQueryOptions.fromJson(Map<String, dynamic> json) {
    return ApiBusListingQueryOptions(
      scale: List<String>.from(json["scale"] ?? []),
      originCode: List<String>.from(json["origin_code"] ?? []),
      manufacturer: List<String>.from(json["manufacturer"] ?? []),
      manufacturerCode: List<String>.from(json["manufacturer_code"] ?? []),
      condition: List<String>.from(json["condition"] ?? []),
    );
  }

  static Future<ApiBusListingQueryOptions> fetch() async {
    final data = await Api().get("/listings/options");

    return ApiBusListingQueryOptions.fromJson(data as Map<String, dynamic>);
  }
}
