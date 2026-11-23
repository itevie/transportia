import 'package:flutter/material.dart';
import 'package:transportia/api/checklist.dart';
import 'package:transportia/widgets/prompts/generic_search.dart';

Future<ApiChecklist?> showRouteChecklistSelectorPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiChecklist>(
    title: "Your Checklists",
    context: context,
    search: (_) async {
      var results = await ApiChecklist.fetchAll();
      return results;
    },
    widgetBuilder: (checklist) => Text(checklist.title),
    showSearch: false,
  );

  return value;
}
