import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';
import 'package:transportia/widgets/lists/vehicle_list_rows.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class VehicleSearchPage extends StatefulWidget {
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
  });

  @override
  State<VehicleSearchPage> createState() => _VehicleSearchPageState();
}

class _VehicleSearchPageState extends State<VehicleSearchPage> {
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
      ],
      initFilters: (filters) {
        filters.query = widget.query;
        filters.livery = widget.livery;
        filters.operator = widget.operator;
        filters.vehicleType = widget.vehicleType;
        filters.withdrawn = widget.withdrawn;
        filters.electric = widget.electric;
        filters.doubleDecker = widget.doubleDecker;
        filters.coach = widget.coach;
        filters.hasImage = widget.hasImage;
        filters.offset = widget.offset ?? 0;
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
        );
      },
      results: (results) => Expanded(
        child: SingleChildScrollView(child: VehicleList(vehicles: results)),
      ),
      resultsTable: (results) =>
          Expanded(child: VehicleListRows(vehicles: results)),
    );
  }
}
