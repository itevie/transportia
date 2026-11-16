import 'package:flutter/material.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/prompts/tram.dart';
import 'package:transportia/prompts/tram_operator.dart';
import 'package:transportia/prompts/tram_type.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/util/detail_chip.dart';

class TramPhotoDetailsBit extends StatefulWidget {
  final ApiPhoto photo;
  final bool isEditing;
  final VoidCallback cancelEdit;

  const TramPhotoDetailsBit({
    super.key,
    required this.photo,
    required this.isEditing,
    required this.cancelEdit,
  });

  @override
  State<TramPhotoDetailsBit> createState() => TramPhotoDetailsBitState();
}

class TramPhotoDetailsBitState extends State<TramPhotoDetailsBit> {
  late ApiPhoto photo;

  late TextEditingController fleet;

  ApiTramType? vt;
  ApiTramLivery? livery;
  ApiTramOperator? operator;
  ApiTram? vehicle;

  bool overwriteMatched = false;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;

    fleet = TextEditingController();

    fleet.text = photo.tram?.fleet ?? "";
    vt = photo.tram?.vehicleType;
    livery = photo.tram?.livery;
    operator = photo.tram?.operator;
    vehicle = photo.tram?.matchedVehicle;
    overwriteMatched = photo.tram?.overrideMatch ?? false;
  }

  void save() async {
    await photo.tram!.updateDetails(
      fleet: fleet.text.isEmpty ? null : fleet.text,
      vehicleTypeId: vt?.id,
      operatorId: operator?.id,
      overrideMatch: overwriteMatched,
      matchedVehicleId: vehicle?.id,
    );

    final loaded = await ApiPhoto.fetch(photo.id);

    setState(() {
      photo = loaded;
    });

    widget.cancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    final details = photo.tram!;

    if (widget.isEditing) {
      return Column(
        children: [
          TextField(
            controller: fleet,
            decoration: InputDecoration(hintText: "Fleet #"),
          ),
          const SizedBox(height: 4),
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
            label: "Vehicle Type",
            value: vt,
            onSearch: showTramTypeSearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                vt = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Operator",
            value: operator,
            onSearch: showTramOperatorSearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                operator = v;
              });
            },
          ),
          const SizedBox(height: 4),
          InputSelectionField(
            label: "Vehicle",
            value: vehicle,
            onSearch: showTramSearchPrompt,
            displayValue: (v) => v.displayName,
            onChanged: (v) {
              setState(() {
                vehicle = v;
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
                    "If selected, your own details will take precedence over the matched vehicle.\nE.g. if this is selected and you have a matched vehicle, the fleet you type here will be used instead.\nUse this if a vehicle has changed after you uploaded your photo.",
                child: const Icon(Icons.help),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        if (details.dFleet != null)
          DetailChip(
            contents: Text(details.dFleet!),
            icon: Icons.numbers,
            onClick: () {},
          ),

        if (details.dVehicleType != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(details.dVehicleType?.name ?? ""),
            icon: Icons.tram,
            onClick: () {},
          ),
        ],
        if (details.dOperator != null) ...[
          const SizedBox(height: 4),
          DetailChip(
            contents: Text(details.dOperator?.name ?? ""),
            icon: Icons.business,
            onClick: () {},
          ),
        ],
      ],
    );
  }
}
