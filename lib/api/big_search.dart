import 'package:transportia/api/api.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/api/user.dart';

class ApiBigSearch {
  final List<ApiUser> users;
  final List<ApiTxOperator> operators;
  final List<ApiTxLine> routes;
  final List<ApiBtVehicleType> vehicleTypes;
  final List<ApiBtLivery> liveries;

  const ApiBigSearch({
    required this.users,
    required this.operators,
    required this.routes,
    required this.vehicleTypes,
    required this.liveries,
  });

  factory ApiBigSearch.fromJson(Map<String, dynamic> json) {
    return ApiBigSearch(
      users: (json["users"] as List).map((x) => ApiUser.fromJson(x)).toList(),
      operators: (json["operators"] as List)
          .map((x) => ApiTxOperator.fromJson(x))
          .toList(),
      routes: (json["routes"] as List)
          .map((x) => ApiTxLine.fromJson(x))
          .toList(),
      vehicleTypes: (json["vehicle_types"] as List)
          .map((x) => ApiBtVehicleType.fromJson(x))
          .toList(),
      liveries: (json["liveries"] as List)
          .map((x) => ApiBtLivery.fromJson(x))
          .toList(),
    );
  }

  static Future<ApiBigSearch> search(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final response = await Api().get("/everything-search?query=$encodedQuery");

    return ApiBigSearch.fromJson(response);
  }
}
