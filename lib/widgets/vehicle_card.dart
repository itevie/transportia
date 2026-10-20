import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/widgets/pages/operator_page.dart';
import 'package:transportia/widgets/pages/vehicle_page.dart';
import 'package:transportia/widgets/withdrawn.dart';

class VehicleCard extends StatefulWidget {
  final ApiBtVehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push("/vehicles");
          setAppPage(VehiclePage(vehicle: widget.vehicle));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.green,
              width: double.infinity,
              height: 150,
              child: widget.vehicle.photo == null
                  ? SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image),
                          Text("No Photo"),
                        ],
                      ),
                    )
                  : Image.network(
                      widget.vehicle.photo!.withSize(150),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.vehicle.fleet} ${widget.vehicle.reg}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.vehicle.withdrawn) ...[
                        const SizedBox(width: 8),
                        const Withdrawn(),
                      ],
                    ],
                  ),
                  if (widget.vehicle.vehicleType != null)
                    Text(
                      widget.vehicle.vehicleType!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (widget.vehicle.operator != null)
                    InkWell(
                      onTap: () {
                        setAppPage(
                          OperatorPage(operator: widget.vehicle.operator!),
                        );
                      },
                      child: SubText(widget.vehicle.operator!.shortName),
                    ),
                  if (widget.vehicle.livery != null)
                    SubText(widget.vehicle.livery!.name),
                  if (widget.vehicle.vehicleType != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.vehicle.vehicleType!.electric)
                            const Tooltip(
                              message: "Electric",
                              child: Icon(Icons.electric_bolt),
                            ),

                          if (widget.vehicle.vehicleType!.coach)
                            const Tooltip(
                              message: "Coach",
                              child: Icon(Icons.directions_bus),
                            ),

                          if (widget.vehicle.vehicleType!.doubleDecker)
                            const Tooltip(
                              message: "Double-decker",
                              child: Icon(Icons.layers),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
