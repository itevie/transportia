import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/cm/tram.dart';
import 'package:transportia/widgets/util/seach_results_table.dart';

class TramListRow extends StatelessWidget {
  final List<ApiTram> vehicles;
  final VoidCallback? reload;

  const TramListRow({super.key, required this.vehicles, this.reload});

  @override
  Widget build(BuildContext context) {
    return SearchResultsTable<ApiTram>(
      columns: [
        (
          'Fleet',
          75,
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
        ('Garage', 150, null),

        ('Vehicle Type', null, null),
        // ('Livery', null, null),
        // ('Badges', 70, null),
        ('Actions', 60, null),
      ],
      builder: (ApiTram vehicle) {
        return (
          {
            'Fleet': Text(vehicle.fleet),
            'Operator': Text(vehicle.operator?.name ?? ""),
            'Garage': Text(vehicle.garage ?? ""),
            'Vehicle Type': Text(vehicle.tramType?.name ?? ""),
            // 'Livery': vehicle.livery != null
            //     ? Row(
            //         children: [
            //           LiveryView(livery: vehicle.livery!),
            //           const SizedBox(width: 4),
            //           Expanded(
            //             child: Text(
            //               vehicle.livery!.name,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 1,
            //             ),
            //           ),
            //         ],
            //       )
            //     : const SizedBox.shrink(),
            // 'Badges': Wrap(children: [...vehicleIcons(vehicle)]),
            'Actions': Row(
              children: [
                tramContextMenu(
                  context,
                  tram: vehicle,
                  reload: reload,
                  isTool: true,
                ),
              ],
            ),
          },
          vehicle.withdrawn ? Colors.red.withValues(alpha: 0.25) : null,
        );
      },
      items: vehicles,
    );
  }
}
