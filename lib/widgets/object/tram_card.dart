import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/cm/tram.dart';
import 'package:transportia/cm/vehicle.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/util/vehicle_icons.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

class TramCard extends StatefulWidget {
  final ApiTram vehicle;
  final bool dummy;
  final VoidCallback? reload;

  const TramCard({
    super.key,
    required this.vehicle,
    this.dummy = false,
    this.reload,
  });

  @override
  State<TramCard> createState() => _TramCardState();
}

class _TramCardState extends State<TramCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.dummy
            ? null
            : () {
                context.go("/tram/${widget.vehicle.id}");
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
                    child:
                        //  null == null
                        //     ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image),
                            Text("No Photo"),
                          ],
                        ),
                    // : Image.network(
                    //     widget.vehicle.!.withSize(150),
                    //     fit: BoxFit.cover,
                    //   ),
                  ),
                  if (!widget.dummy)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: tramContextMenu(
                        context,
                        tram: widget.vehicle,
                        reload: widget.reload,
                        isTool: true,
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
                          "${widget.vehicle.fleet}",
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
                  if (widget.vehicle.tramType != null)
                    Text(
                      widget.vehicle.tramType!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  Row(
                    children: [
                      if (widget.vehicle.operator != null)
                        InkWell(
                          onTap: widget.dummy
                              ? null
                              : () {
                                  context.push(
                                    "/operators?id=${widget.vehicle.operator!.id}",
                                  );
                                },
                          child: SubText(widget.vehicle.operator!.name),
                        ),

                      if (widget.vehicle.garage != null) ...[
                        const SizedBox(width: 4),
                        SubText("- ${widget.vehicle.garage!}"),
                      ],
                    ],
                  ),

                  if (widget.vehicle.livery != null)
                    SubText(widget.vehicle.livery!.name),
                  // if (widget.vehicle.vehicleType != null)
                  //   Align(
                  //     alignment: Alignment.center,
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         if (widget.vehicle.livery != null) ...[
                  //           Tooltip(
                  //             message: widget.vehicle.livery!.name,
                  //             child: LiveryView(
                  //               livery: widget.vehicle.livery!,
                  //               size: 32,
                  //               key: Key(widget.vehicle.id.toString()),
                  //             ),
                  //           ),
                  //           Spacer(),
                  //         ],
                  //         ...vehicleIcons(widget.vehicle),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
