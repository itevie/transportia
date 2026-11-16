import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/route_search.dart';
import 'package:transportia/prompts/tram.dart';
import 'package:transportia/prompts/tram_operator.dart';
import 'package:transportia/prompts/tram_type.dart';
import 'package:transportia/prompts/user_search.dart';
import 'package:transportia/prompts/vehicle_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/inputs/search_field_bool.dart';

Widget matchedVehicleInputField(
  BuildContext context,
  bool? current,
  Function(bool?) callback,
) {
  return InputBoolField(
    label: 'Vehicle matched?',
    value: current,
    tristate: true,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget boolInputField(
  BuildContext context,
  String label,
  bool? current,
  Function(bool?) callback,
) {
  return InputBoolField(
    label: label,
    value: current,
    tristate: true,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget tramInputField(
  BuildContext context,
  ApiTram? current,
  Function(ApiTram?) callback,
) {
  return InputSelectionField<ApiTram>(
    label: "Operator",
    value: current,
    onSearch: showTramSearchPrompt,
    displayValue: (value) => value.displayName,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget tramTypeInputField(
  BuildContext context,
  ApiTramType? current,
  Function(ApiTramType?) callback,
) {
  return InputSelectionField<ApiTramType>(
    label: "Vehicle Type",
    value: current,
    onSearch: showTramTypeSearchPrompt,
    displayValue: (value) => value.name,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget tramOperatorInputField(
  BuildContext context,
  ApiTramOperator? current,
  Function(ApiTramOperator?) callback,
) {
  return InputSelectionField<ApiTramOperator>(
    label: "Operator",
    value: current,
    onSearch: showTramOperatorSearchPrompt,
    displayValue: (value) => value.name,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget vehicleInputField(
  BuildContext context,
  ApiBtVehicle? current,
  Function(ApiBtVehicle?) callback,
) {
  return InputSelectionField<ApiBtVehicle>(
    label: "Vehicle",
    value: current,
    onSearch: showvehicleSearchPrompt,
    displayValue: (value) => value.displayName,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget vehicleTypeInputField(
  BuildContext context,
  ApiBtVehicleType? current,
  Function(ApiBtVehicleType?) callback,
) {
  return InputSelectionField<ApiBtVehicleType>(
    label: "Vehicle Type",
    value: current,
    onSearch: showVehicleTypeSearchPrompt,
    displayValue: (value) => value.name,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget liveryInputField(
  BuildContext context,
  ApiBtLivery? current,
  Function(ApiBtLivery?) callback,
) {
  return InputSelectionField<ApiBtLivery>(
    label: "Livery",
    value: current,
    onSearch: showLiverySearchPrompt,
    displayValue: (value) => value.name,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget operatorInputField(
  BuildContext context,
  ApiTxOperator? current,
  Function(ApiTxOperator?) callback,
) {
  return InputSelectionField<ApiTxOperator>(
    label: "Operator",
    value: current,
    onSearch: showOperatorSearchPrompt,
    displayValue: (value) => value.displayName,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget routeInputField(
  BuildContext context,
  ApiTxLine? current,
  Function(ApiTxLine?) callback,
) {
  return InputSelectionField<ApiTxLine>(
    label: "Route",
    value: current,
    onSearch: showLinePrompt,
    displayValue: (value) => value.displayName,
    onChanged: (value) {
      callback(value);
    },
  );
}

Widget authorInputField(
  BuildContext context,
  ApiUser? current,
  Function(ApiUser?) callback,
) {
  return InputSelectionField<ApiUser>(
    label: "Author",
    value: current,
    onSearch: showUserSearchPrompt,
    displayValue: (value) => value.username,
    onChanged: (value) {
      callback(value);
    },
  );
}
