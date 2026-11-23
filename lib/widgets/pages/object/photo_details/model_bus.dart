import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/model_bus_ownership.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/prompts/model_bus.dart';
import 'package:transportia/widgets/prompts/model_bus_ownerships.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/util/detail_chip.dart';

import '../../../livery/livery.dart';

class ModelBusPhotoDetailsBit extends StatefulWidget {
  final ApiPhoto photo;
  final bool isEditing;
  final VoidCallback cancelEdit;

  const ModelBusPhotoDetailsBit({
    super.key,
    required this.photo,
    required this.isEditing,
    required this.cancelEdit,
  });

  @override
  State<ModelBusPhotoDetailsBit> createState() =>
      ModelBusPhotoDetailsBitState();
}

class ModelBusPhotoDetailsBitState extends State<ModelBusPhotoDetailsBit> {
  late ApiPhoto photo;

  bool overwriteMatched = false;

  ApiModelBus? modelBus;
  ApiModelBusOwnership? ownership;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;

    modelBus = photo.modelBus!.matchedModel;
    ownership = photo.modelBus!.ownershipDetails;
  }

  void save() async {
    await photo.modelBus!.updateDetails(
      overrideMatch: overwriteMatched,
      matchedModelId: modelBus?.id,
      ownership: ownership?.id,
    );

    final loaded = await ApiPhoto.fetch(photo.id);

    setState(() {
      photo = loaded;
    });

    widget.cancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    final details = photo.modelBus!;
    final vehicleObj = details.matchedModel?.vehicleObj;

    if (widget.isEditing) {
      return Column(
        children: [
          // TextField(
          //   controller: fleet,
          //   decoration: InputDecoration(hintText: "Fleet #"),
          // ),
          // const SizedBox(height: 4),
          // InputSelectionField(
          //   label: "Livery",
          //   value: livery,
          //   onSearch: ShowTram,
          //   displayValue: (v) => v.name,
          //   onChanged: (v) {
          //     setState(() {
          //       livery = v;
          //     });
          //   },
          // ),
          // const SizedBox(height: 4),
          InputSelectionField(
            label: "Model Bus",
            value: modelBus,
            onSearch: showModelBusSearchPrompt,
            displayValue: (v) => v.displayName,
            onChanged: (v) {
              setState(() {
                modelBus = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Ownership",
            value: ownership,
            onSearch: showModelBusOwnershipSearchPrompt,
            displayValue: (v) => v.displayName,
            onChanged: (v) {
              setState(() {
                ownership = v;
              });
            },
          ),
          // InputSelectionField(
          //   label: "Operator",
          //   value: operator,
          //   onSearch: showTramOperatorSearchPrompt,
          //   displayValue: (v) => v.name,
          //   onChanged: (v) {
          //     setState(() {
          //       operator = v;
          //     });
          //   },
          // ),
          // const SizedBox(height: 4),
          // InputSelectionField(
          //   label: "Vehicle",
          //   value: vehicle,
          //   onSearch: showTramSearchPrompt,
          //   displayValue: (v) => v.displayName,
          //   onChanged: (v) {
          //     setState(() {
          //       vehicle = v;
          //     });
          //   },
          // ),
          // const SizedBox(height: 4),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: overwriteMatched,
          //       onChanged: (v) {
          //         if (v == null) return;
          //         setState(() {
          //           overwriteMatched = v;
          //         });
          //       },
          //     ),
          //     Text("Overwrite Vehicle"),
          //     Spacer(),
          //     Tooltip(
          //       message:
          //           "If selected, your own details will take precedence over the matched vehicle.\nE.g. if this is selected and you have a matched vehicle, the fleet you type here will be used instead.\nUse this if a vehicle has changed after you uploaded your photo.",
          //       child: const Icon(Icons.help),
          //     ),
          //   ],
          // ),
        ],
      );
    }

    return Column(
      children: [
        if (details.matchedModel != null)
          DetailChip(
            contents: Text(details.matchedModel!.displayName),
            icon: Icons.badge,
            onClick: () {},
          ),

        if (details.ownership != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(details.ownershipDetails?.displayName ?? ""),
            icon: Icons.assignment_ind,
            onClick: () {},
          ),
        ],

        if (vehicleObj?.fleet != null) ...[
          createCm(
            context,
            [CmContext.extSearch],
            vehicleObj,
            child: DetailChip(
              contents: Text(vehicleObj!.fleet),
              icon: Icons.numbers,
              onClick: () {},
            ),
          ),
        ],

        if (vehicleObj?.reg != null) ...[
          const SizedBox(height: 4),
          createCm(
            context,
            [CmContext.extSearch],
            vehicleObj,
            child: DetailChip(
              contents: Text(vehicleObj!.reg),
              icon: Icons.badge,
              onClick: () {},
            ),
          ),
        ],

        if (vehicleObj?.livery != null) ...[
          const SizedBox(height: 4),
          createCm(
            context,
            [CmContext.extSearch],
            vehicleObj?.livery,
            child: isLinux()
                ? DetailChip(
                    contents: Text(vehicleObj?.livery?.id.toString() ?? ""),
                    icon: Icons.palette,
                    onClick: () {},
                  )
                : DetailChipNoIcon(
                    icon: LiveryView(livery: vehicleObj!.livery!),
                    contents: Text(vehicleObj.livery!.name),
                  ),
          ),
        ],

        if (vehicleObj?.vehicleType != null) ...[
          const SizedBox(height: 4),
          createCm(
            context,
            [CmContext.extSearch],
            vehicleObj?.vehicleType,
            child: DetailChip(
              contents: Text(vehicleObj!.vehicleType!.name),
              icon: Icons.bus_alert,
              onClick: () {},
            ),
          ),
        ],

        if (vehicleObj?.operator != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(vehicleObj!.operator!.displayName),
            icon: Icons.business,
            onClick: () => context.go("/operator/${vehicleObj.operator!.id}"),
          ),
        ],
      ],
    );
  }
}
