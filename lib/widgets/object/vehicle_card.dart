import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/cm/vehicle.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/util/vehicle_icons.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

import '../livery/livery.dart';

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
              color: Colors.green,
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
                      child: vehicleContextMenu(
                        context,
                        vehicle: widget.vehicle,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
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
                    Text(
                      widget.vehicle.vehicleType!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (widget.vehicle.operator != null)
                    InkWell(
                      onTap: widget.dummy
                          ? null
                          : () {
                              context.push(
                                "/operators?id=${widget.vehicle.operator!.id}",
                              );
                              // setAppPage(
                              //   OperatorPage(operator: widget.vehicle.operator!),
                              // );
                            },
                      child: SubText(widget.vehicle.operator!.shortName),
                    ),
                  if (widget.vehicle.livery != null)
                    SubText(widget.vehicle.livery!.name),
                  if (widget.vehicle.vehicleType != null)
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.vehicle.livery != null) ...[
                            Tooltip(
                              message: widget.vehicle.livery!.name,
                              child: LiveryView(
                                livery: widget.vehicle.livery!,
                                size: 32,
                                key: Key(widget.vehicle.id.toString()),
                              ),
                            ),
                            Spacer(),
                          ],
                          ...vehicleIcons(widget.vehicle),
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
