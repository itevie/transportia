import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/cm/cm_base.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/route_search.dart';
import 'package:transportia/prompts/vehicle_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/util/vehicle_icons.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/livery/livery.dart';
import 'package:transportia/widgets/util/detail_chip.dart';
import 'package:transportia/widgets/util/drop_down.dart';

class BusPhotoDetailsBit extends StatefulWidget {
  final ApiPhoto photo;
  final bool isEditing;
  final VoidCallback cancelEdit;

  const BusPhotoDetailsBit({
    super.key,
    required this.photo,
    this.isEditing = false,
    required this.cancelEdit,
  });

  @override
  State<BusPhotoDetailsBit> createState() => BusPhotoDetailsBitState();
}

class BusPhotoDetailsBitState extends State<BusPhotoDetailsBit> {
  late ApiPhoto photo;

  late TextEditingController reg;
  late TextEditingController fleet;
  ApiBtVehicleType? vt;
  ApiBtLivery? livery;
  ApiBtVehicle? vehicle;
  ApiTxLine? line;
  bool overwriteMatched = false;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;

    reg = TextEditingController();
    fleet = TextEditingController();

    reg.text = photo.bus?.reg ?? "";
    fleet.text = photo.bus?.fleet ?? "";
    vt = photo.bus?.vehicleType;
    livery = photo.bus?.livery;
    overwriteMatched = photo.bus?.overrideMatch ?? false;
    line = photo.bus?.route;
    vehicle = photo.bus?.matchedVehicle;
  }

  void save() async {
    await photo.bus!.updateDetails(
      matchedVehicleId: vehicle?.id,
      overrideMatch: overwriteMatched,
      reg: reg.text.isEmpty ? null : reg.text,
      fleet: fleet.text.isEmpty ? null : fleet.text,
      liveryId: livery?.id,
      vehicleTypeId: vt?.id,
      routeId: line?.txId,
    );

    final loaded = await ApiPhoto.fetch(photo.id);

    setState(() {
      photo = loaded;
    });

    widget.cancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    final details = photo.bus;

    if (widget.isEditing) {
      return Column(
        children: [
          TextField(
            controller: fleet,
            decoration: InputDecoration(hintText: "Fleet #"),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: reg,
            decoration: InputDecoration(hintText: "Reg"),
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Livery",
            value: livery,
            onSearch: showLiverySearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                livery = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Vehicle Type",
            value: vt,
            onSearch: showVehicleTypeSearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                vt = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Vehicle",
            value: vehicle,
            onSearch: showvehicleSearchPrompt,
            displayValue: (v) => v.displayName,
            onChanged: (v) {
              setState(() {
                vehicle = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Line",
            value: line,
            onSearch: showLinePrompt,
            displayValue: (v) => v.displayName,
            onChanged: (v) {
              setState(() {
                line = v;
              });
            },
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Checkbox(
                value: overwriteMatched,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    overwriteMatched = v;
                  });
                },
              ),
              Text("Overwrite Vehicle"),
              Spacer(),
              Tooltip(
                message:
                    "If selected, your own details will take precedence over the matched vehicle.\nE.g. if this is selected and you have a matched vehicle, the reg you type here will be used instead.\nUse this if a vehicle has changed after you uploaded your photo.",
                child: const Icon(Icons.help),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        if (details?.dFleet != null) ...[
          createCm(
            context,
            [CmContext.extSearch],
            details,
            child: DetailChip(
              contents: Text(details!.dFleet!),
              icon: Icons.numbers,
              onClick: () {},
            ),
          ),
        ],

        if (details?.dReg != null) ...[
          const SizedBox(height: 4),
          createCm(
            context,
            [CmContext.extSearch],
            details,
            child: DetailChip(
              contents: Text(details!.dReg!),
              icon: Icons.badge,
              onClick: () {},
            ),
          ),
        ],

        if (details?.dLivery != null) ...[
          const SizedBox(height: 4),

          createCm(
            context,
            [CmContext.extSearch],
            details!.dLivery,
            child: isLinux()
                ? DetailChip(
                    contents: Text(details.dLivery!.name),
                    icon: Icons.palette,
                    onClick: () {},
                  )
                : DetailChipNoIcon(
                    icon: LiveryView(livery: details.dLivery!),
                    contents: Text(details.dLivery!.name),
                  ),
          ),
        ],

        if (details?.dVehicleType != null) ...[
          const SizedBox(height: 4),

          createCm(
            context,
            [CmContext.extSearch],
            details!.dVehicleType,
            child: DetailChip(
              contents: Text(details.dVehicleType!.name),
              icon: Icons.bus_alert,
              onClick: () {},
            ),
          ),
        ],

        if (details?.matchedVehicle?.operator != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(details!.matchedVehicle!.operator!.displayName),
            icon: Icons.business,
            onClick: () =>
                context.go("/operator/${details.matchedVehicle!.operator!.id}"),
          ),
        ],

        if (details?.route != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(
              "${details!.route?.name} ${details.route?.inboundDescription}",
            ),
            icon: Icons.route,
            onClick: () => context.go("/photos?route=${details.route!.txId}"),
          ),
        ],

        // if (details?.matchedVehicle != null) ...[
        //   const SizedBox(width: 4),
        //   ...vehicleIcons(details!.matchedVehicle!),
        // ],
      ],
    );
  }
}
