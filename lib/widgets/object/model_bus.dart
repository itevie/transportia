import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/cm/model_bus.dart';
import 'package:transportia/util/text.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class ModelBusCard extends StatefulWidget {
  final ApiModelBus model;
  final bool dummy;

  const ModelBusCard({super.key, required this.model, this.dummy = false});

  @override
  State<ModelBusCard> createState() => _ModelBusCardState();
}

class _ModelBusCardState extends State<ModelBusCard> {
  Widget _linkedText({
    required String text,
    String? id,
    required String route,
  }) {
    bool clickable =
        !(widget.dummy || id == null || id.isEmpty || id == "null");
    return InkWell(
      onTap: !clickable
          ? null
          : () {
              context.push(route.replaceAll(':id', id.toString()));
            },
      child: Text(
        text,
        style: TextStyle(
          color: clickable ? Theme.of(context).colorScheme.primary : null,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _detail(IconData label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(label, color: Colors.grey, size: 16),
          const SizedBox(width: 4),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    final vehicleDetails = <Widget>[];

    var operator = oneOf([model.operatorObj?.displayName, model.operator]);
    if (operator != null) {
      vehicleDetails.add(
        _detail(
          Icons.business,
          _linkedText(
            text: operator,
            id: model.operatorLink,
            route: '/operator/:id',
          ),
        ),
      );
    }

    var livery = oneOf([model.liveryObj?.name, model.livery]);
    if (livery != null) {
      vehicleDetails.add(
        _detail(
          Icons.palette,
          _linkedText(
            text: livery,
            id: model.liveryLink.toString(),
            route: '/livery/:id',
          ),
        ),
      );
    }

    var fleet = oneOf([model.vehicleObj?.fleet, model.fleetNumber]);
    var reg = oneOf([model.vehicleObj?.reg, model.registration]);
    if (reg != null || fleet != null) {
      vehicleDetails.add(
        _detail(
          Icons.numbers,
          _linkedText(
            text: [?reg, ?fleet].join(' - '),
            id: model.vehicleLink.toString(),
            route: '/vehicle/:id',
          ),
        ),
      );
    }

    var vehicleType = oneOf([model.vehicleTypeObj?.name, model.vehicleType]);
    if (vehicleType != null) {
      vehicleDetails.add(
        _detail(
          Icons.directions_bus,
          _linkedText(
            text: vehicleType,
            id: model.vehicleTypeLink.toString(),
            route: '/vehicle-type/:id',
          ),
        ),
      );
    }

    var routeNumber = oneOf([model.routeObj?.name, model.routeNumber]);
    var destination = oneOf([
      model.destination,
      model.routeObj?.outboundDescription,
    ]);
    if (routeNumber != null || destination != null) {
      vehicleDetails.add(
        _detail(
          Icons.route,
          _linkedText(
            text: [
              if (model.routeNumber != null) model.routeNumber!,
              if (model.destination != null) model.destination!,
            ].join(' - '),
            id: model.routeLink,
            route: '/route/:id',
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.dummy
            ? null
            : () {
                context.go('/model-bus/${model.id}');
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: double.infinity,
              height: 150,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus, size: 40),
                        SizedBox(height: 4),
                        Text('No Photo'),
                      ],
                    ),
                  ),

                  if (!widget.dummy)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: modelBusContextMenu(
                        context,
                        modelBus: widget.model,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.manufacturer,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    [model.productCode, '1:${model.scale}'].join(' • '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 4),

                  // Vehicle details
                  _section('Vehicle', vehicleDetails),

                  // Certificate
                  if (model.hasCertificate)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Certificate (max ${model.certificateMax})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  // Release information
                  if (model.released != null) ...[
                    const SizedBox(height: 8),
                    SubText('Released: ${model.released}'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
