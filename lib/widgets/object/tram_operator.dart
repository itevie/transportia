import 'package:flutter/material.dart';
import 'package:transportia/api/tram_operator.dart';

class TramOperatorView extends StatelessWidget {
  final ApiTramOperator operator;

  const TramOperatorView({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(operator.name)));
  }
}
