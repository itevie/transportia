import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/util/object_labels.dart';
import 'package:transportia/util/vehicle_icons.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

class VehicleCard extends StatefulWidget {
  final ApiBtVehicle vehicle;
  final bool dummy;

  const VehicleCard({super.key, required this.vehicle, this.dummy = false});

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.dummy
            ? null
            : () {
                context.go("/vehicle/${widget.vehicle.id}");
                // setAppPage(VehiclePage(vehicle: widget.vehicle));
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: cardBgColor(context),
              width: double.infinity,
              height: 150,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.vehicle.photo == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image),
                              Text("No Photo"),
                            ],
                          )
                        : Image.network(
                            widget.vehicle.photo!.withSize(150),
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (!widget.dummy)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: createCm(context, [
                        CmContext.hasPhoto,
                      ], widget.vehicle),
                      //  vehicleContextMenu(
                      //   context,
                      //   vehicle: widget.vehicle,
                      //   child: IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.more_vert),
                      //     style: IconButton.styleFrom(
                      //       backgroundColor: Colors.black54,
                      //       foregroundColor: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ),
                ],
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
                    VehicleTypeLabel(vt: widget.vehicle.vehicleType!),
                  widget.vehicle.operator != null
                      ? OperatorLabel(
                          operator: widget.vehicle.operator!,
                          dummy: widget.dummy,
                        )
                      : SubText(widget.vehicle.operatorId),

                  if (widget.vehicle.livery != null)
                    LiveryLabel(
                      livery: widget.vehicle.livery!,
                      dummy: widget.dummy,
                    ),
                  if (widget.vehicle.vehicleType != null)
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Spacer(), ...vehicleIcons(widget.vehicle)],
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
