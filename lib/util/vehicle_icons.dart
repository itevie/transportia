import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/widgets/util/icons.dart';

List<Widget> vehicleIcons(ApiBtVehicle vehicle) => [
  if (vehicle.vehicleType!.electric) electricVehicleIcon(),
  if (vehicle.vehicleType!.coach) coachVehicleIcon(),
  if (vehicle.vehicleType!.doubleDecker) doubleDeckerVehicleIcon(),
  if (vehicle.trainingVehicle) trainingVehicleIcon(),
  if (vehicle.demonstrator) demonstratorVehicleIcon(),
  if (vehicle.openTop) openTopVehicleIcon(),
];
