import 'package:flutter/material.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/cm/cm_base.dart';

class TramTypeView extends StatelessWidget {
  final ApiTramType tramType;
  final bool isTool;
  final VoidCallback? reload;

  const TramTypeView({
    super.key,
    required this.tramType,
    this.isTool = false,
    this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tramType.name),
        trailing: createCm(context, [], tramType, reload: reload),
      ),
    );
  }
}
