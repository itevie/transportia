import 'package:flutter/material.dart';

import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/user.dart';

import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class PhotoSearchPage extends StatelessWidget {
  final String? query;

  final ApiBtLivery? livery;
  final ApiBtVehicleType? vehicleType;
  final ApiBtVehicle? vehicle;
  final ApiUser? author;
  final ApiTxLine? route;

  const PhotoSearchPage({
    super.key,
    this.query,
    this.livery,
    this.vehicleType,
    this.vehicle,
    this.author,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiPhoto>(
      searchHint: "Search",
      filters: [
        SearchFilter.livery,
        SearchFilter.vehicleType,
        SearchFilter.vehicle,
        SearchFilter.route,
        SearchFilter.author,
        SearchFilter.vehicleMatched,
      ],
      initFilters: (filters) {
        filters.query = query;
        filters.livery = livery;
        filters.vehicleType = vehicleType;
        filters.vehicle = vehicle;
        filters.author = author;
        filters.route = route;
      },
      query: (filters) async {
        final photos = await ApiBusPhotoDetails.fetchAll(
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
          bdLiveryId: filters.livery?.id,
          bdVehicleTypeId: filters.vehicleType?.id,
          authorId: filters.author?.id,
          bdVehicleId: filters.vehicle?.id,
          bdHasMatchedVehicle: filters.vehicleMatched,
          bdRoute: filters.route?.txId.toString(),
          offset: filters.offset,
        );

        return photos
            .skip(photos.length > 50 ? photos.length - 50 : 0)
            .toList();
      },
      results: (results) => Expanded(
        child: SingleChildScrollView(child: PhotoList(photos: results)),
      ),
    );
  }
}
