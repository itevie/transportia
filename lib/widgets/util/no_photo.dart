import 'package:flutter/material.dart';

Widget noPhoto({IconData? icon = Icons.directions_bus}) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(icon ?? Icons.directions_bus, size: 40),
    SizedBox(height: 4),
    Text('No Photo'),
  ],
);
