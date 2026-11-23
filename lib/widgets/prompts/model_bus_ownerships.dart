import 'package:flutter/material.dart';
import 'package:transportia/api/model_bus_ownership.dart';
import 'package:transportia/widgets/prompts/generic_search.dart';

Future<ApiModelBusOwnership?> showModelBusOwnershipSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiModelBusOwnership>(
    title: "Search Tram Types",
    context: context,
    search: (q) async {
      var results = await ApiModelBusOwnership.search(search: q);
      return results;
    },
    preSearch: true,
    widgetBuilder: (type) => Text(type.displayNameLong),
  );
  return value;
}
