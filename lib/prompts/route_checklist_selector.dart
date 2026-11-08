import 'package:flutter/material.dart';
import 'package:transportia/api/route_checklist.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiRouteChecklist?> showRouteChecklistSelectorPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiRouteChecklist>(
    title: "Your Checklists",
    context: context,
    search: (_) async {
      var results = await ApiRouteChecklist.fetchAll();
      return results;
    },
    widgetBuilder: (checklist) => Text(checklist.title),
    showSearch: false,
  );

  return value;
}
