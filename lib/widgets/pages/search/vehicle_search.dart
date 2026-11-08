import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/routing.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';
import 'package:transportia/widgets/lists/vehicle_list_rows.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/inputs/search_field_bool.dart';
import 'package:transportia/widgets/util/search_page.dart';

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
  List<ApiBtVehicle> vehicles = [];

  ApiBtLivery? livery;
  ApiBtVehicleType? vehicleType;
  ApiTxOperator? operator;
  bool? withdrawn;
  bool? electric;
  bool? doubleDecker;
  bool? coach;
  bool? trainingVehicle;
  bool? demonstrator;
  bool? openTop;
  bool? hasImage;

  int currentOffset = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    livery = widget.livery;
    operator = widget.operator;
    vehicleType = widget.vehicleType;
    withdrawn = widget.withdrawn;
    electric = widget.electric;
    doubleDecker = widget.doubleDecker;
    coach = widget.coach;
    hasImage = widget.hasImage;
    currentOffset = widget.offset ?? 0;

    load(query: widget.query);
  }

  // TODO: Make it so query is stored in widet
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
      demonstrator: demonstrator,
      openTop: openTop,
      trainingVehicle: trainingVehicle,
      hasImage: hasImage,
      offset: currentOffset,
    );

    replaceQuery(context, {
      'query': query,
      'vehicleType': vehicleType?.id,
      'withdrawn': withdrawn,
      'operator': operator?.id,
      'electric': electric,
      'coach': coach,
      'double_decker': doubleDecker,
      'has_iamge': hasImage,
      'offset': currentOffset,
    });

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
      currentOffset: currentOffset,
      offsetCallback: (offset) {
        setState(() {
          currentOffset = offset;
        });

        addPostLoad();
      },
      filters: [
        InputSelectionField<ApiBtLivery>(
          label: "Livery",
          value: livery,
          onSearch: showLiverySearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              livery = value;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputSelectionField<ApiBtVehicleType>(
          label: "Vehicle Type",
          value: vehicleType,
          onSearch: showVehicleTypeSearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              vehicleType = value;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputSelectionField<ApiTxOperator>(
          label: "Operator",
          value: operator,
          onSearch: showOperatorSearchPrompt,
          displayValue: (value) => value.displayName,
          onChanged: (value) {
            setState(() {
              operator = value;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Electric?",
          value: electric,
          tristate: true,
          onChanged: (v) {
            setState(() {
              electric = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Double Decker?",
          value: doubleDecker,
          tristate: true,
          onChanged: (v) {
            setState(() {
              doubleDecker = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Coach?",
          value: coach,
          tristate: true,
          onChanged: (v) {
            setState(() {
              coach = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Open Top?",
          value: openTop,
          tristate: true,
          onChanged: (v) {
            setState(() {
              openTop = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Demonstrator?",
          value: demonstrator,
          tristate: true,
          onChanged: (v) {
            setState(() {
              demonstrator = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Training Vehicle?",
          value: trainingVehicle,
          tristate: true,
          onChanged: (v) {
            setState(() {
              trainingVehicle = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Withdrawn?",
          value: withdrawn,
          tristate: true,
          onChanged: (v) {
            setState(() {
              withdrawn = v;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

        InputBoolField(
          label: "Has Image?",
          value: hasImage,
          tristate: true,
          onChanged: (v) {
            setState(() {
              hasImage = v;
              currentOffset = 0;
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
      results: () => Expanded(
        child: SingleChildScrollView(child: VehicleList(vehicles: vehicles)),
        // child: VehicleListRows(vehicles: vehicles),
      ),
      resultsTable: () => Expanded(child: VehicleListRows(vehicles: vehicles)),
    );
  }
}
