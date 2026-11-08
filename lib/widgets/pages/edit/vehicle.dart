import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/edit_object.dart';
import 'package:transportia/widgets/inputs/search_field_bool.dart';
import 'package:transportia/widgets/object/vehicle_card.dart';

class VehicleEditPage extends StatefulWidget {
  final ApiBtVehicle vehicle;

  const VehicleEditPage({super.key, required this.vehicle});

  @override
  State<VehicleEditPage> createState() => _VehicleEditPageState();
}

class _VehicleEditPageState extends State<VehicleEditPage> {
  late ApiBtVehicle vehicle;
  bool trainingVehicle = false;
  bool demonstrator = false;
  bool openTop = false;

  @override
  void initState() {
    super.initState();

    vehicle = widget.vehicle;
    trainingVehicle = widget.vehicle.trainingVehicle;
    demonstrator = widget.vehicle.demonstrator;
    openTop = widget.vehicle.openTop;
  }

  void reload() async {
    final vehicle = await ApiBtVehicle.get(this.vehicle.id);

    // TODO: Add proper error message
    if (vehicle == null) return;

    setState(() {
      this.vehicle = vehicle;
    });
  }

  ApiBtVehicle make() {
    return widget.vehicle.copyWith(
      trainingVehicle: trainingVehicle,
      demonstrator: demonstrator,
      openTop: openTop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditObjectPage(
      onSave: () async {
        await vehicle.updateVehicle(
          trainingVehicle: trainingVehicle,
          demonstrator: demonstrator,
          openTop: openTop,
        );
        reload();
      },
      title: "Edit vehicle ${widget.vehicle.reg} (${widget.vehicle.fleet})",
      options: [
        InputBoolField(
          label: "Training Vehicle?",
          value: trainingVehicle,
          onChanged: (v) {
            setState(() {
              trainingVehicle = v ?? false;
            });
          },
        ),
        InputBoolField(
          label: "Demonstrator?",
          value: demonstrator,
          onChanged: (v) {
            setState(() {
              demonstrator = v ?? false;
            });
          },
        ),
        InputBoolField(
          label: "Open Top?",
          value: openTop,
          onChanged: (v) {
            setState(() {
              openTop = v ?? false;
            });
          },
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 200,
          child: SubText(
            "All other details are from bustimes.org and cannot be changed",
          ),
        ),
      ],
      child: VehicleCard(vehicle: make(), dummy: true),
    );
  }
}
