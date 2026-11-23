import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/widgets/livery/livery.dart';
import 'package:transportia/widgets/util/sub_text.dart';

Widget _baseObjectLabel(
  BuildContext context,
  Widget label,
  String? destination, {
  bool dummy = false,
  Widget? icon,
}) {
  return InkWell(
    onTap: dummy || destination == null
        ? null
        : () {
            context.go(destination);
          },
    child: icon == null
        ? label
        : Row(children: [icon, const SizedBox(width: 4), label]),
  );
}

class OperatorLabel extends StatelessWidget {
  final ApiTxOperator operator;
  final String? leadingText;
  final bool? dummy;
  const OperatorLabel({
    required this.operator,
    this.dummy,
    super.key,
    this.leadingText,
  });

  @override
  Widget build(BuildContext context) {
    return _baseObjectLabel(
      context,
      SubText("${leadingText ?? ""}${operator.displayName}"),
      "/operator/${operator.id}",
      dummy: dummy ?? false,
    );
  }
}

class TramOperatorLabel extends StatelessWidget {
  final ApiTramOperator operator;
  final String? leadingText;
  final bool? dummy;
  const TramOperatorLabel({
    required this.operator,
    this.dummy,
    super.key,
    this.leadingText,
  });

  @override
  Widget build(BuildContext context) {
    return _baseObjectLabel(
      context,
      SubText("${leadingText ?? ""}${operator.name}"),
      "/tram-operator/${operator.id}",
      dummy: dummy ?? false,
    );
  }
}

class LiveryLabel extends StatelessWidget {
  final ApiBtLivery livery;
  final bool? dummy;
  const LiveryLabel({required this.livery, this.dummy, super.key});

  @override
  Widget build(BuildContext context) {
    return _baseObjectLabel(
      context,
      SubText(livery.name),
      "/livery/${livery.id}",
      icon: isLinux() ? null : LiveryView(livery: livery, size: 24),
      dummy: dummy ?? false,
    );
  }
}

class VehicleTypeLabel extends StatelessWidget {
  final ApiBtVehicleType vt;
  final bool? dummy;
  final Widget? child;
  const VehicleTypeLabel({required this.vt, this.dummy, super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return _baseObjectLabel(
      context,
      child ?? Text(vt.name, style: TextStyle(fontWeight: FontWeight.bold)),
      "/vehicle-type/${vt.id}",
      dummy: dummy ?? false,
    );
  }
}
