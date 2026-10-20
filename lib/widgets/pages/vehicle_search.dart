import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';
import 'package:transportia/widgets/search_field.dart';
import 'package:transportia/widgets/search_field_bool.dart';
import 'package:transportia/widgets/search_page.dart';

class VehicleSearchPage extends StatefulWidget {
  final ApiBtLivery? livery;
  final ApiTxOperator? operator;
  final ApiBtVehicleType? vehicleType;
  final String? query;

  const VehicleSearchPage({
    super.key,
    this.livery,
    this.operator,
    this.vehicleType,
    this.query,
  });

  @override
  State<VehicleSearchPage> createState() => _VehicleSearchPageState();
}

class _VehicleSearchPageState extends State<VehicleSearchPage> {
  List<ApiBtVehicle> vehicles = [];

  ApiBtLivery? livery;
  ApiBtVehicleType? vehicleType;
  ApiTxOperator? operator;
  bool? withdrawn;
  bool? electric;
  bool? doubleDecker;
  bool? coach;
  bool? hasImage;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    livery = widget.livery;
    operator = widget.operator;
    vehicleType = widget.vehicleType;

    load();
  }

  void load({String? query}) async {
    setState(() {
      loading = true;
    });

    var listings = await ApiBtVehicle.search(
      liveryId: livery?.id,
      vehicleTypeId: vehicleType?.id,
      withdrawn: withdrawn,
      search: query == null || query.isEmpty ? null : query,
      operatorId: operator?.nationalCode,
      electric: electric,
      coach: coach,
      doubleDecker: doubleDecker,
      hasImage: hasImage,
    );

    setState(() {
      vehicles = listings;
      loading = false;
    });
  }

  void addPostLoad() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchPage(
      searchHint: "Search by fleet or reg...",
      prefilledQuery: widget.query,
      onSearch: (v) => load(query: v),
      loading: loading,
      filters: [
        SearchSelectionField<ApiBtLivery>(
          label: "Livery",
          value: livery,
          onSearch: showLiverySearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              livery = value;
            });

            addPostLoad();
          },
        ),

        SearchSelectionField<ApiBtVehicleType>(
          label: "Vehicle Type",
          value: vehicleType,
          onSearch: showVehicleTypeSearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              vehicleType = value;
            });

            addPostLoad();
          },
        ),

        SearchSelectionField<ApiTxOperator>(
          label: "Operator",
          value: operator,
          onSearch: showOperatorSearchPrompt,
          displayValue: (value) => value.displayName,
          onChanged: (value) {
            setState(() {
              operator = value;
            });

            addPostLoad();
          },
        ),

        SearchCheckboxSelector(
          label: "Electric?",
          value: electric,
          tristate: true,
          onChanged: (v) {
            setState(() {
              electric = v;
            });

            addPostLoad();
          },
        ),

        SearchCheckboxSelector(
          label: "Double Decker?",
          value: doubleDecker,
          tristate: true,
          onChanged: (v) {
            setState(() {
              doubleDecker = v;
            });

            addPostLoad();
          },
        ),

        SearchCheckboxSelector(
          label: "Coach?",
          value: coach,
          tristate: true,
          onChanged: (v) {
            setState(() {
              coach = v;
            });

            addPostLoad();
          },
        ),

        SearchCheckboxSelector(
          label: "Withdrawn?",
          value: withdrawn,
          tristate: true,
          onChanged: (v) {
            setState(() {
              withdrawn = v;
            });

            addPostLoad();
          },
        ),

        SearchCheckboxSelector(
          label: "Has Image?",
          value: hasImage,
          tristate: true,
          onChanged: (v) {
            setState(() {
              hasImage = v;
            });

            addPostLoad();
          },
        ),
      ],
      onClear: () {
        setState(() {
          withdrawn = null;
          operator = null;
          vehicleType = null;
          livery = null;
          electric = null;
          doubleDecker = null;
          coach = null;
        });

        addPostLoad();
      },
      results: Expanded(
        child: SingleChildScrollView(child: VehicleList(vehicles: vehicles)),
      ),
    );
  }
}
