import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';

import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/widgets/vehicle_card.dart';

class VehicleList extends StatelessWidget {
  final List<ApiBtVehicle> vehicles;

  const VehicleList({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 4,
          ),
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];

            return VehicleCard(vehicle: vehicle);
          },
        ),

        SubText("Data from bustimes.org/api"),
      ],
    );
  }
}
