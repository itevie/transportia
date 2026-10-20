import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiBtVehicle?> showvehicleSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiBtVehicle>(
    title: "Search Vehicles",
    context: context,
    search: (q) async {
      var results = await ApiBtVehicle.search(search: q);
      return results;
    },
    widgetBuilder: (v) =>
        Text("${v.reg}: ${v.fleet} (${v.operator?.nationalCode})"),
  );

  return value;
}
