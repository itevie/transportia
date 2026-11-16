import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/api/user.dart';

class SearchFilters {
  String? query;

  ApiBtLivery? livery;
  ApiTramLivery? tramLivery;

  ApiBtVehicleType? vehicleType;
  ApiTramType? tramType;

  ApiTxOperator? operator;
  ApiTramOperator? tramOperator;

  ApiBtVehicle? vehicle;
  ApiTram? tram;

  ApiTxLine? route;

  ApiUser? author;

  bool? withdrawn;
  bool? electric;
  bool? doubleDecker;
  bool? coach;
  bool? demonstrator;
  bool? openTop;
  bool? trainingVehicle;
  bool? hasImage;
  bool? vehicleMatched;

  int offset = 0;

  SearchFilters({Object? loadFrom}) {
    if (loadFrom == null) return;
  }

  void clear() {
    query = null;
    livery = null;
    tramLivery = null;
    vehicleType = null;
    tramType = null;
    operator = null;
    tramOperator = null;
    tram = null;
    vehicle = null;
    route = null;

    author = null;

    withdrawn = null;
    electric = null;
    doubleDecker = null;
    coach = null;
    demonstrator = null;
    openTop = null;
    trainingVehicle = null;
    hasImage = null;
    vehicleMatched = null;

    offset = 0;
  }
}
