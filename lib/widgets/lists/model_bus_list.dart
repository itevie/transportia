import 'package:flutter/material.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/widgets/object/model_bus.dart';

import 'package:transportia/widgets/object/tram_card.dart';

class ModelBusList extends StatelessWidget {
  final List<ApiModelBus> modelBuses;
  final VoidCallback? reload;

  const ModelBusList({super.key, required this.modelBuses, this.reload});

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
        childAspectRatio: 3 / 6,
      ),
      itemCount: modelBuses.length,
      itemBuilder: (context, index) {
        final model = modelBuses[index];

        return ModelBusCard(model: model);
      },
    );
  }
}
