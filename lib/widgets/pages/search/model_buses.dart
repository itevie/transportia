import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/model_bus_ownership.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/prompts/livery_search.dart';
import 'package:transportia/widgets/prompts/model_bus_manufacturer.dart';
import 'package:transportia/widgets/prompts/operator_search.dart';
import 'package:transportia/widgets/prompts/vehicle_type_search.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/inputs/search_field_text.dart';
import 'package:transportia/widgets/lists/model_bus_list.dart';
import 'package:transportia/widgets/lists/model_bus_rows.dart';
import 'package:transportia/widgets/util/search_page.dart';

class ModelBusSearchPage extends StatefulWidget {
  final bool isOwnerships;
  const ModelBusSearchPage({super.key, required this.isOwnerships});

  @override
  State<ModelBusSearchPage> createState() => _ModelBusSearchPageState();
}

class _ModelBusSearchPageState extends State<ModelBusSearchPage> {
  List<ApiModelBus> models = [];
  List<ApiModelBusOwnership> modelOwnerships = [];

  String? query;

  int currentOffset = 0;
  ApiTxOperator? operator;
  ApiBtVehicleType? vehicleType;
  ApiBtLivery? livery;
  String? manufacturer;
  late TextEditingController scale;

  @override
  void initState() {
    super.initState();

    scale = TextEditingController();

    load();
  }

  void load() async {
    if (widget.isOwnerships) {
      loadModelOwnerships();
    } else {
      loadModels();
    }
  }

  void loadModels() async {
    final loadedModels = await ApiModelBus.search(
      search: query,
      operatorLink: operator?.code,
      vehicleTypeLink: vehicleType?.id,
      liveryLink: livery?.id,
      manufacturer: manufacturer,
    );

    setState(() {
      models = loadedModels;
    });
  }

  void loadModelOwnerships() async {
    final loadedModels = await ApiModelBusOwnership.search(search: query);

    setState(() {
      modelOwnerships = loadedModels;
    });
  }

  void addPostLoad() async {}

  @override
  Widget build(BuildContext context) {
    // TODO: Listen to reloads for deletion / edit
    return SearchPage(
      searchHint: "Search model buses..",
      onSearch: (v) {
        setState(() {
          query = v;
        });

        addPostLoad();
      },
      filters: [
        InputSelectionField<String>(
          label: "Manufacturer",
          value: manufacturer,
          onSearch: showModelBusManufacturerPrompt,
          displayValue: (value) => value,
          onChanged: (value) {
            setState(() {
              manufacturer = value;
              currentOffset = 0;
            });

            addPostLoad();
          },
        ),

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

        Row(
          children: [
            Text("1 : "),
            Expanded(
              child: InputTextField(
                label: "Scale",
                controller: scale,
                onChanged: (value) => {setState(() {})},
              ),
            ),
          ],
        ),
      ],
      onClear: () {},
      createCallback: () {
        context.go("/model-buses/create");
      },
      results: () => Expanded(
        child: SingleChildScrollView(
          child: ModelBusList(
            modelBuses: widget.isOwnerships
                ? modelOwnerships.map((x) => x.modelBus!).toList()
                : models,
            ownerships: modelOwnerships,
          ),
        ),
      ),
      resultsTable: () => Expanded(child: ModelBusListRows(vehicles: models)),
    );
  }
}
