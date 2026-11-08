import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/prompts/route_checklist_selector.dart';
import 'package:transportia/widgets/util/drop_down.dart';

Widget serviceContextMenu(
  BuildContext context, {
  required ApiTxLine service,
  Widget? child,
}) {
  return TDropDownMenu(
    options: {
      'Search Photos': () {
        context.go("/photos?route=${service.txId}");
      },
      'Add To Checklist': () async {
        final checklist = await showRouteChecklistSelectorPrompt(
          context: context,
        );
        await checklist?.addLine(service.txId);
        // TODO: Add feedback
      },
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
