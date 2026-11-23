import 'package:flutter/material.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/widgets/service_number.dart';
import 'package:transportia/widgets/util/cm_base.dart';

class SmallServiceRow extends StatelessWidget {
  final ApiTxLine route;
  const SmallServiceRow({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ServiceNumber(
            lineName: route.name,
            operator: route.operatorNationalCode,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              route.displayNameNoName,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          createCm(context, [CmContext.objService], route),
        ],
      ),
    );
  }
}
