import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/cm/vehicle.dart';
import 'package:transportia/util/vehicle_icons.dart';
import 'package:transportia/widgets/util/seach_results_table.dart';

import '../livery/livery.dart';

class VehicleListRows extends StatelessWidget {
  final List<ApiBtVehicle> vehicles;

  const VehicleListRows({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return SearchResultsTable<ApiBtVehicle>(
      columns: [
        (
          'Fleet',
          75,
          (v) {
            context.go("/vehicle/${v.id}");
          },
        ),
        (
          'Registration',
          100,
          (v) {
            context.go("/vehicle/${v.id}");
          },
        ),
        (
          'Operator',
          150,
          (v) {
            context.go("/operator/${v.operator?.id}");
          },
        ),
        ('Vehicle Type', null, null),
        ('Livery', null, null),
        ('Badges', 70, null),
        ('Actions', 60, null),
      ],
      builder: (ApiBtVehicle vehicle) {
        return (
          {
            'Fleet': Text(vehicle.fleet),
            'Registration': Text(vehicle.reg),
            'Operator': Text(vehicle.operator?.displayName ?? ""),
            'Vehicle Type': Text(vehicle.vehicleType?.name ?? ""),
            'Livery': vehicle.livery != null
                ? Row(
                    children: [
                      LiveryView(livery: vehicle.livery!),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          vehicle.livery!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            'Badges': Wrap(children: [...vehicleIcons(vehicle)]),
            'Actions': Row(
              children: [vehicleContextMenu(context, vehicle: vehicle)],
            ),
          },
          vehicle.withdrawn ? Colors.red.withValues(alpha: 0.25) : null,
        );
      },
      items: vehicles,
    );
  }
}
