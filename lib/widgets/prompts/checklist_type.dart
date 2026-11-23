import 'package:flutter/material.dart';
import 'package:transportia/api/checklist.dart';
import 'package:transportia/widgets/prompts/generic_search.dart';

Future<ChecklistType?> showChecklistTypePrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ChecklistType>(
    title: "Search Checklist Types",
    context: context,
    search: (q) async {
      var results = ChecklistType.values;
      return results
          .where((x) => x.apiValue.toLowerCase().contains(q.toLowerCase()))
          .toList();
    },
    showSearch: false,
    widgetBuilder: (m) => Text(m.apiValue),
  );

  return value;
}
