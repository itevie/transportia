import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/widgets/util/drop_down.dart';

Widget modelBusContextMenu(
  BuildContext context, {
  required ApiModelBus modelBus,
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
            Text("Delete ${modelBus.productCode}?"),
            Text("Are you sure you want to delete this model bus?"),
          );

          if (!confirm) return;

          await ApiModelBus.delete(modelBus.id);
          if (reload != null) reload();
        },
      if (isTool)
        'Edit': () {
          context.go("/model-bus/${modelBus.id}/edit");
        },
      'Add to ownerships': () async {
        final confirm = await showConfirmPrompt(
          context,
          Text("Confirm"),
          Text(
            "Are you sure you want to add ${modelBus.manufacturer} ${modelBus.productCode} ${modelBus.vehicleTypeObj?.name ?? modelBus.vehicleType} to your owned model buses?\nYou can add your certificate later if you have one.",
          ),
        );
      },
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
