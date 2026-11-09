import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/main.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/model_bus_manufacturer.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/route_search.dart';
import 'package:transportia/prompts/vehicle_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/inputs/search_field_bool.dart';
import 'package:transportia/widgets/inputs/search_field_int.dart';
import 'package:transportia/widgets/inputs/search_field_or_manual.dart';
import 'package:transportia/widgets/inputs/search_field_text.dart';
import 'package:transportia/widgets/object/model_bus.dart';
import 'package:transportia/widgets/util/edit_object.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class ModelBusEditPage extends StatefulWidget {
  final ApiModelBus? modelBus;

  const ModelBusEditPage({super.key, this.modelBus});

  @override
  State<ModelBusEditPage> createState() => _ModelBusEditPageState();
}

class _ModelBusEditPageState extends State<ModelBusEditPage> {
  ApiModelBus? modelBus;

  late TextEditingController productCode;
  late TextEditingController scale;
  String? manufacturer;

  late TextEditingController fleet;
  late TextEditingController reg;
  ApiBtVehicle? vehicle;

  late TextEditingController routeNumber;
  late TextEditingController routeDestination;
  ApiTxLine? line;

  ApiBtVehicleType? vehicleType;
  late TextEditingController vehicleTypeStr;

  late TextEditingController liveryStr;
  ApiBtLivery? livery;

  late TextEditingController operatorStr;
  ApiTxOperator? operator;

  bool hasCertificate = false;
  int? maxCertificate;

  @override
  void initState() {
    super.initState();

    modelBus = widget.modelBus;

    productCode = TextEditingController(text: modelBus?.productCode ?? "");
    scale = TextEditingController(text: modelBus?.scale.toString() ?? "76");

    manufacturer = modelBus?.manufacturer;

    fleet = TextEditingController(text: modelBus?.fleetNumber ?? "");
    reg = TextEditingController(text: modelBus?.registration ?? "");
    vehicle = modelBus?.vehicleObj;

    routeNumber = TextEditingController(text: modelBus?.routeNumber ?? "");
    routeDestination = TextEditingController(text: modelBus?.destination ?? "");
    line = modelBus?.routeObj;

    vehicleType = modelBus?.vehicleTypeObj;
    vehicleTypeStr = TextEditingController(text: modelBus?.vehicleType ?? "");

    liveryStr = TextEditingController(text: modelBus?.livery ?? "");
    livery = modelBus?.liveryObj;

    operatorStr = TextEditingController(text: modelBus?.operator ?? "");
    operator = modelBus?.operatorObj;

    hasCertificate = modelBus?.hasCertificate ?? false;
    maxCertificate = modelBus?.certificateMax;
  }

  ApiModelBus make() {
    return (modelBus ??
            ApiModelBus(
              id: 0,
              manufacturer: "",
              createdAt: "",
              updatedAt: "",
              productCode: '',
              scale: 76,
            ))
        .copyWith(
          manufacturer: manufacturer ?? "",
          productCode: productCode.text,
          scale: int.tryParse(scale.text),
          operator: operatorStr.text,
          operatorLink: operator?.id,
          livery: liveryStr.text,
          liveryLink: livery?.id,
          fleetNumber: fleet.text,
          registration: reg.text,
          vehicleLink: vehicle?.id,
          routeNumber: routeNumber.text,
          destination: routeDestination.text,
          routeLink: line?.txId,
          vehicleType: vehicleType?.name ?? vehicleTypeStr.text,
          vehicleTypeLink: vehicleType?.id,
          hasCertificate: hasCertificate,
          certificateMax: maxCertificate,
        );
  }

  String? s(String? v) {
    return v == null
        ? null
        : v.isEmpty
        ? null
        : v;
  }

  @override
  Widget build(BuildContext context) {
    return EditObjectPage(
      onSave: () async {
        final data = make();

        if (data.manufacturer.isEmpty) {
          return showError("Manufacturer cannot be empty");
        }

        if (data.productCode.isEmpty) {
          return showError("Product code cannot be empty");
        }

        if (modelBus == null) {
          await ApiModelBus.create(
            manufacturer: data.manufacturer,
            productCode: data.productCode,
            scale: data.scale,
            operator: s(data.operator),
            operatorLink: data.operatorLink,
            livery: s(data.livery),
            liveryLink: data.liveryLink,
            fleetNumber: s(data.fleetNumber),
            registration: s(data.registration),
            vehicleLink: data.vehicleLink,
            routeNumber: s(data.routeNumber),
            destination: s(data.destination),
            routeLink: data.routeLink,
            vehicleType: s(data.vehicleType),
            vehicleTypeLink: data.vehicleTypeLink,
            hasCertificate: hasCertificate,
            certificateMax: maxCertificate ?? 0,
          );
        } else {
          await modelBus!.updateModelBus(
            manufacturer: data.manufacturer,
            productCode: data.productCode,
            scale: data.scale,
            operator: s(data.operator),
            operatorLink: data.operatorLink,
            livery: s(data.livery),
            liveryLink: data.liveryLink,
            fleetNumber: s(data.fleetNumber),
            registration: s(data.registration),
            vehicleLink: data.vehicleLink,
            routeNumber: s(data.routeNumber),
            destination: s(data.destination),
            routeLink: data.routeLink,
            vehicleType: s(data.vehicleType),
            vehicleTypeLink: data.vehicleTypeLink,
            certificateMax: maxCertificate ?? 0,
            hasCertificate: hasCertificate,
          );
        }

        if (lastUri != null) context.go(lastUri!);
      },
      title: widget.modelBus == null ? "Create Model Bus" : "Edit Model Bus",
      options: [
        SubText("Model"),

        SizedBox(
          width: 250,
          child: InputSelectionField<String>(
            label: "Manufacturer",
            value: manufacturer,
            onSearch: showModelBusManufacturerPrompt,
            displayValue: (v) => v,
            onChanged: (v) {
              setState(() {
                manufacturer = v;
              });
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Product Code",
            controller: productCode,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: Row(
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
        ),

        SubText("Vehicle"),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Fleet",
            controller: fleet,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Reg",
            controller: reg,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionField<ApiBtVehicle>(
            label: 'Linked Vehicle',
            value: vehicle,
            onSearch: showvehicleSearchPrompt,
            displayValue: (value) => "${value.reg} - ${vehicle?.fleet}",
            onChanged: (value) {
              setState(() {
                vehicle = value;
              });
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionOrManualField<ApiBtVehicleType>(
            label: 'Vehicle Type',
            value: vehicleType,
            manualValue: vehicleTypeStr,
            onSearch: showVehicleTypeSearchPrompt,
            displayValue: (value) => value.name,
            onChanged: (value) {
              setState(() {
                vehicleType = value;
              });
            },
            onManualChanged: (_) {
              setState(() {});
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionOrManualField<ApiBtLivery>(
            label: 'Livery',
            value: livery,
            manualValue: liveryStr,
            onSearch: showLiverySearchPrompt,
            displayValue: (value) => value.name,
            onChanged: (value) {
              setState(() {
                livery = value;
              });
            },
            onManualChanged: (_) {
              setState(() {});
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionOrManualField<ApiTxOperator>(
            label: 'Operator',
            value: operator,
            manualValue: operatorStr,
            onSearch: showOperatorSearchPrompt,
            displayValue: (value) => value.displayName,
            onChanged: (value) {
              setState(() {
                operator = value;
              });
            },
            onManualChanged: (_) {
              setState(() {});
            },
          ),
        ),

        SubText("Display Blind"),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Route #",
            controller: routeNumber,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Destination",
            controller: routeDestination,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionField<ApiTxLine>(
            label: 'Linked Route',
            value: line,
            onSearch: showLinePrompt,
            displayValue: (value) =>
                '${value.name} ${value.outboundDescription}',
            onChanged: (value) {
              setState(() {
                line = value;
              });
            },
          ),
        ),

        SubText("Certificate"),

        InputBoolField(
          label: "Has Certificate?",
          value: hasCertificate,
          onChanged: (v) {
            setState(() {
              hasCertificate = v ?? false;
            });
          },
        ),

        if (hasCertificate)
          SizedBox(
            width: 250,
            child: InputIntField(
              label: "Certificate Max",
              value: maxCertificate,
              min: 0,
              onChanged: (v) {
                setState(() {
                  maxCertificate = v;
                });
              },
            ),
          ),

        SubText("Linked details will take prescedence over manual fields"),

        // SizedBox(
        //   width: 250,
        //   child: InputSelectionField(
        //     label: "Operator",
        //     value: operator,
        //     onSearch: showTramOperatorSearchPrompt,
        //     displayValue: (v) => v.name,
        //     onChanged: (v) {
        //       setState(() {
        //         operator = v;
        //       });
        //     },
        //   ),
        // ),

        // SizedBox(
        //   width: 250,
        //   child: InputTextField(
        //     label: "Garage",
        //     controller: garage,
        //     onChanged: (value) => {setState(() {})},
        //   ),
        // ),

        // SizedBox(
        //   width: 250,
        //   child: InputTextField(
        //     label: "Branding",
        //     controller: branding,
        //     onChanged: (value) => {setState(() {})},
        //   ),
        // ),

        // SizedBox(
        //   width: 250,
        //   child: InputTextField(
        //     label: "Special Name",
        //     controller: name,
        //     onChanged: (value) => {setState(() {})},
        //   ),
        // ),

        // InputBoolField(
        //   label: "Withdrawn?",
        //   value: withdrawn,
        //   onChanged: (v) {
        //     setState(() {
        //       withdrawn = v ?? false;
        //     });
        //   },
        // ),
      ],
      child: ModelBusCard(model: make()), //TramCard(vehicle: make()),
    );
  }
}
