import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/photo.dart';
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

  String? tramAnnouncementGroup;

  bool? withdrawn;
  bool? electric;
  bool? doubleDecker;
  bool? coach;
  bool? demonstrator;
  bool? openTop;
  bool? trainingVehicle;
  bool? hasImage;
  bool? vehicleMatched;

  String? vehicleUniqueFilter;

  int offset = 0;
  PhotoOrderBy? orderBy;

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

    vehicleUniqueFilter = null;

    tramAnnouncementGroup = null;

    offset = 0;
  }

  String toQueryString() {
    final params = <String, String>{};

    void add(String key, Object? value) {
      if (value != null) {
        params[key] = value.toString();
      }
    }

    add('query', query);

    add('livery_id', livery?.id);
    add('tram_livery_id', tramLivery?.id);

    add('vehicle_type_id', vehicleType?.id);
    add('tram_type_id', tramType?.id);

    add('operator_id', operator?.id);
    add('tram_operator_id', tramOperator?.id);

    add('vehicle_id', vehicle?.id);
    add('tram_id', tram?.id);

    add('route_id', route?.txId);
    add('author_id', author?.id);

    add("tram_announcement_group", tramAnnouncementGroup);

    add('withdrawn', withdrawn);
    add('electric', electric);
    add('double_decker', doubleDecker);
    add('coach', coach);
    add('demonstrator', demonstrator);
    add('open_top', openTop);
    add('training_vehicle', trainingVehicle);
    add('has_image', hasImage);
    add('vehicle_matched', vehicleMatched);

    add('unique', vehicleUniqueFilter);

    add('offset', offset);

    return Uri(queryParameters: params).query;
  }
}
