import 'package:flutter/material.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/widgets/prompts/generic_search.dart';

Future<PhotoType?> showPhotoTypePrompt({required BuildContext context}) async {
  final value = await showSearchPrompt<PhotoType>(
    title: "Search Photo Types",
    context: context,
    search: (q) async {
      var results = PhotoType.values;
      return results
          .where((x) => x.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    },
    showSearch: false,
    widgetBuilder: (m) => Text(m.humanValue),
  );

  return value;
}
