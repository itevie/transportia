import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/widgets/util/drop_down.dart';

Widget tramTypeContextMenu(
  BuildContext context, {
  required ApiTramType tramType,
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
            Text("Delete ${tramType.name}?"),
            Text("All trams using this type will no longer have a type."),
          );

          if (!confirm) return;

          await ApiTramType.delete(tramType.id);
          if (reload != null) reload();
        },
      if (isTool) 'Edit': () {},
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
