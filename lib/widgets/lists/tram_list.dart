import 'package:flutter/material.dart';
import 'package:transportia/api/tram.dart';

import 'package:transportia/widgets/object/tram_card.dart';

class TramList extends StatelessWidget {
  final List<ApiTram> vehicles;
  final VoidCallback? reload;

  const TramList({super.key, required this.vehicles, this.reload});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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

        return TramCard(vehicle: vehicle, reload: reload);
      },
    );
  }
}
