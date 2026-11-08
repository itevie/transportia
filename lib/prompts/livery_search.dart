import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/prompts/generic_search.dart';
import 'package:transportia/widgets/pages/home.dart';

import '../widgets/livery/livery.dart';

Future<ApiBtLivery?> showLiverySearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiBtLivery>(
    title: "Search Liveries",
    context: context,
    search: (q) async {
      var results = await ApiBtLivery.search(q);
      return results;
    },
    widgetBuilder: (livery) => Row(
      children: [
        LiveryView(livery: livery),
        const SizedBox(width: 8),
        Text(livery.name),
      ],
    ),
  );

  return value;
}
