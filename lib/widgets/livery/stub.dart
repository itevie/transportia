import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';

class LiveryView extends StatelessWidget {
  final ApiBtLivery livery;
  final double size;

  const LiveryView({super.key, required this.livery, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
