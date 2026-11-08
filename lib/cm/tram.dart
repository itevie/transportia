import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/widgets/util/drop_down.dart';

Widget tramContextMenu(
  BuildContext context, {
  required ApiTram tram,
  Widget? child,
  bool isTool = false,
  VoidCallback? reload,
}) {
  return TDropDownMenu(
    options: {
      if (isTool)
        'Delete': () async {
          final confirm = await showConfirmPrompt(
            context,
            Text("Delete ${tram.fleet}?"),
            Text("Are you sure you want to delete this tram?"),
          );

          if (!confirm) return;

          await ApiTram.delete(tram.id);
          if (reload != null) reload();
        },
      if (isTool)
        'Edit': () {
          context.go("/trams/${tram.id}/edit");
        },
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
