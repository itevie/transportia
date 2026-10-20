import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiBtVehicleType?> showVehicleTypeSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiBtVehicleType>(
    title: "Search Vehicle Types",
    context: context,
    search: (q) async {
      var results = await ApiBtVehicleType.search(q);
      return results;
    },
    widgetBuilder: (vt) => Text(vt.name),
  );

  return value;
}
