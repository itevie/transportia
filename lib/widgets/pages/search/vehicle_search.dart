import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';
import 'package:transportia/widgets/lists/vehicle_list_rows.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class VehicleSearchPage extends StatelessWidget {
  final ApiBtLivery? livery;
  final ApiTxOperator? operator;
  final ApiBtVehicleType? vehicleType;
  final String? query;
  final bool? doubleDecker;
  final bool? electric;
  final bool? coach;
  final bool? hasImage;
  final bool? withdrawn;
  final int? offset;

  final bool isNested;

  const VehicleSearchPage({
    super.key,
    this.livery,
    this.operator,
    this.vehicleType,
    this.query,
    this.doubleDecker,
    this.electric,
    this.coach,
    this.hasImage,
    this.withdrawn,
    this.offset,
    this.isNested = false,
  });

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiBtVehicle>(
      searchHint: "Search by fleet or reg...",
      filters: [
        SearchFilter.livery,
        SearchFilter.vehicleType,
        SearchFilter.operator,
        SearchFilter.vehicle,
        SearchFilter.electric,
        SearchFilter.doubleDecker,
        SearchFilter.coach,
        SearchFilter.openTop,
        SearchFilter.demonstrator,
        SearchFilter.trainingVehicle,
        SearchFilter.withdrawn,
        SearchFilter.hasImage,
        SearchFilter.vehicleMatched,
        SearchFilter.vehicleUnique,
      ],
      initFilters: (filters) {
        filters.query = query;
        filters.livery = livery;
        filters.operator = operator;
        filters.vehicleType = vehicleType;
        filters.withdrawn = withdrawn;
        filters.electric = electric;
        filters.doubleDecker = doubleDecker;
        filters.coach = coach;
        filters.hasImage = hasImage;
        filters.offset = offset ?? 0;
      },
      query: (filters) async {
        return await ApiBtVehicle.search(
          liveryId: filters.livery?.id,
          vehicleTypeId: filters.vehicleType?.id,
          withdrawn: filters.withdrawn,
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
          operatorId: filters.operator?.nationalCode,
          electric: filters.electric,
          coach: filters.coach,
          doubleDecker: filters.doubleDecker,
          demonstrator: filters.demonstrator,
          openTop: filters.openTop,
          trainingVehicle: filters.trainingVehicle,
          hasImage: filters.hasImage,
          offset: filters.offset,
          unique: filters.vehicleUniqueFilter,
        );
      },
      isNested: isNested,
      nestedExternalLink: (query) => "/vehicles?$query",
      results: (results) => Expanded(
        child: SingleChildScrollView(child: VehicleList(vehicles: results)),
      ),
      resultsTable: (results) =>
          Expanded(child: VehicleListRows(vehicles: results)),
    );
  }
}
