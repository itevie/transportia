import 'package:dawn_ui_flutter/prompts/confirm.dart';
import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/checklist.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/prompts/big_button_selector.dart';
import 'package:transportia/widgets/prompts/operator_search.dart';
import 'package:transportia/widgets/prompts/route_search.dart';
import 'package:transportia/widgets/prompts/service_presets.dart';
import 'package:transportia/widgets/prompts/vehicle_search.dart';
import 'package:transportia/widgets/util/toasts.dart';

Future<void> checklistAddFully(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
}) async {
  if (checklist.checklistType == ChecklistType.service) {
    await showBigButtonPrompt(context, "What to add?", [
      BigButtonOption(
        icon: Icons.business,
        label: "Operator",
        onPressed: () async {
          await checklistAddServiceOperator(context, checklist, reload: reload);
        },
      ),
      BigButtonOption(
        icon: Icons.route,
        label: "Service",
        onPressed: () async {
          await checklistAddService(context, checklist, reload: reload);
        },
      ),
      BigButtonOption(
        icon: Icons.bookmark,
        label: "Operator Preset",
        onPressed: () async {
          await checklistAddServicePreset(context, checklist, reload: reload);
        },
      ),
    ]);
  } else if (checklist.checklistType == ChecklistType.vehicle) {
    await showBigButtonPrompt(context, "What to add?", [
      BigButtonOption(
        icon: Icons.business,
        label: "Operator",
        onPressed: () async {
          await checklistAddVehicleOperator(context, checklist, reload: reload);
        },
      ),
      BigButtonOption(
        icon: Icons.route,
        label: "Vehicle",
        onPressed: () async {
          await checklistAddVehicle(context, checklist, reload: reload);
        },
      ),
      BigButtonOption(
        icon: Icons.bookmark,
        label: "Operator Preset",
        onPressed: () async {
          await checklistAddVehiclePreset(context, checklist, reload: reload);
        },
      ),
    ]);
  }
}

Future<void> checklistAddServiceOperator(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
  ApiTxOperator? foperator,
}) async {
  final operator =
      foperator ??
      await showOperatorSearchPrompt(
        // ignore: use_build_context_synchronously
        context: context,
      );

  if (operator == null) return;

  final lines = await ApiTxLine.fetchAll(
    operatorNationalCode: operator.nationalCode,
    pageLength: 1000,
  );

  final confirmed = await showConfirmPrompt(
    // ignore: use_build_context_synchronously
    context,
    const Text("Add Lines?"),
    Text(
      "Are you sure you want to add "
      "${lines.length} lines from "
      "${operator.shortName} (${operator.nationalCode}) "
      "to the ${checklist.title} checklist?",
    ),
  );

  if (!confirmed) return;

  await checklist.addOperator(operator.nationalCode!);

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added ${lines.length} services!",
  );

  reload?.call();
}

Future<void> checklistAddVehicleOperator(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
  ApiTxOperator? foperator,
}) async {
  final operator =
      foperator ??
      await showOperatorSearchPrompt(
        // ignore: use_build_context_synchronously
        context: context,
      );

  if (operator == null) return;

  final vehicles = await ApiBtVehicle.search(
    operatorId: operator.nationalCode,
    pageLength: 1000,
  );

  final confirmed = await showConfirmPrompt(
    // ignore: use_build_context_synchronously
    context,
    const Text("Add Vehicles?"),
    Text(
      "Are you sure you want to add "
      "${vehicles.length} vehicles from "
      "${operator.shortName} (${operator.nationalCode}) "
      "to the ${checklist.title} checklist?",
    ),
  );

  if (!confirmed) return;

  await checklist.addOperator(operator.nationalCode!);

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added ${vehicles.length} services!",
  );

  reload?.call();
}

Future<void> checklistAddService(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
}) async {
  final service = await showLinePrompt(context: context);

  if (service == null) return;

  await checklist.addObj(service.txId);

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added ${service.name} to preset!",
  );

  reload?.call();
}

Future<void> checklistAddVehicle(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
}) async {
  final vehicle = await showvehicleSearchPrompt(context: context);

  if (vehicle == null) return;

  await checklist.addObj(vehicle.id.toString());

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added ${vehicle.displayName} to preset!",
  );

  reload?.call();
}

Future<void> checklistAddServicePreset(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
}) async {
  final preset = await showServicePresetPrompt(context: context);
  if (preset == null) return;

  final count = await ApiChecklist.countBulkOperator(
    preset.value,
    ChecklistType.service,
  );

  final confirmed = await showConfirmPrompt(
    // ignore: use_build_context_synchronously
    context,
    const Text("Add Lines?"),
    Text(
      "Are you sure you want to add $count lines from ${preset.value.length} operators to the ${checklist.title} checlist?",
    ),
  );

  if (!confirmed) return;

  await checklist.addBulkOperator(preset.value);

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added the ${preset.key} preset!",
  );

  reload?.call();
}

Future<void> checklistAddVehiclePreset(
  BuildContext context,
  ApiChecklist checklist, {
  VoidCallback? reload,
}) async {
  final preset = await showServicePresetPrompt(context: context);
  if (preset == null) return;

  final count = await ApiChecklist.countBulkOperator(
    preset.value,
    ChecklistType.vehicle,
  );

  final confirmed = await showConfirmPrompt(
    // ignore: use_build_context_synchronously
    context,
    const Text("Add Lines?"),
    Text(
      "Are you sure you want to add $count vehicles from ${preset.value.length} operators to the ${checklist.title} checlist?",
    ),
  );

  if (!confirmed) return;

  await checklist.addBulkOperator(preset.value);

  showSuccessToast(
    // ignore: use_build_context_synchronously
    context,
    "Added the ${preset.key} preset!",
  );

  reload?.call();
}
