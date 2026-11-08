import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/cm/model_bus.dart';
import 'package:transportia/widgets/util/seach_results_table.dart';

class ModelBusListRows extends StatelessWidget {
  final List<ApiModelBus> vehicles;

  const ModelBusListRows({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return SearchResultsTable<ApiModelBus>(
      columns: [
        (
          'Name',
          130,

          (v) {
            context.go('/model-bus/${v.id}');
          },
        ),
        ('Fleet', null, null),
        (
          'Operator',
          100,
          (v) {
            context.go('/operator/${v.operatorLink}');
          },
        ),
        ('Vehicle Type', 150, null),
        ('Livery', null, null),
        ('Route', null, null),
        ('Certificate', null, null),
        ('Released', 100, null),
        ('Actions', 60, null),
      ],
      builder: (ApiModelBus model) {
        return (
          {
            'Name': Text(
              "1:${model.scale} ${model.manufacturer} ${model.productCode}",
            ),
            'Scale': Text('1:${model.scale}'),
            'Fleet': Text(" ${model.registration} - ${model.fleetNumber}"),
            'Operator': Text(
              model.operatorObj?.displayName ?? model.operator ?? '',
            ),
            'Vehicle Type': Text(
              model.vehicleObj?.name ?? model.vehicleType ?? '',
            ),
            'Livery': Text(model.liveryObj?.name ?? model.livery ?? ''),
            'Route': Text(
              [
                if (model.routeNumber != null) model.routeNumber!,
                if (model.destination != null) model.destination!,
              ].join(' - '),
            ),
            'Certificate': Text(
              model.hasCertificate ? 'Yes (max ${model.certificateMax})' : 'No',
            ),
            'Released': Text(model.released?.toString() ?? ''),
            'Actions': Row(
              children: [
                modelBusContextMenu(context, modelBus: model, isTool: true),
              ],
            ),
          },
          null,
        );
      },
      items: vehicles,
    );
  }
}
