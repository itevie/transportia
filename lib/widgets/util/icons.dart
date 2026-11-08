import 'package:flutter/material.dart';

Widget electricVehicleIcon() =>
    const Tooltip(message: "Electric", child: Icon(Icons.electric_bolt));

Widget coachVehicleIcon() =>
    const Tooltip(message: "Coach", child: Icon(Icons.directions_bus));

Widget doubleDeckerVehicleIcon() =>
    const Tooltip(message: "Double-decker", child: Icon(Icons.layers));

Widget trainingVehicleIcon() =>
    const Tooltip(message: "Training Vehicle", child: Icon(Icons.school));

Widget openTopVehicleIcon() =>
    const Tooltip(message: "Open Top", child: Icon(Icons.wb_sunny_outlined));

Widget demonstratorVehicleIcon() =>
    const Tooltip(message: "Demonstrator", child: Icon(Icons.science));
