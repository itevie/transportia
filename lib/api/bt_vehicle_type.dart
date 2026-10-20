import 'package:transportia/api/api.dart';

class ApiBtVehicleType {
  final int id;

  final String name;

  final String style;

  final String fuel;

  final bool doubleDecker;

  final bool coach;

  final bool electric;

  ApiBtVehicleType({
    required this.id,
    required this.name,
    required this.style,
    required this.fuel,
    required this.doubleDecker,
    required this.coach,
    required this.electric,
  });

  factory ApiBtVehicleType.fromJson(Map<String, dynamic> json) {
    return ApiBtVehicleType(
      id: json["id"],
      name: json["name"],
      style: json["style"],
      fuel: json["fuel"],
      doubleDecker: json["double_decker"],
      coach: json["coach"],
      electric: json["electric"],
    );
  }

  static Future<List<ApiBtVehicleType>> search(String query) async {
    final data = await Api().get(
      "/vehicle-types?query=${Uri.encodeQueryComponent(query)}",
    );

    return (data as List)
        .map((json) => ApiBtVehicleType.fromJson(json))
        .toList();
  }
}
