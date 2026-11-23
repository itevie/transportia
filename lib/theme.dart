import 'package:flutter/material.dart';

const double seperatorPadding = 8;
const double panelPadding = 8;

Color cardBgColor(BuildContext context) {
  return Theme.of(context).colorScheme.onPrimary;
}

int responsiveGridColumns(
  BuildContext context, {
  int mobile = 1,
  int tablet = 2,
  int desktop = 3,
  int largeDesktop = 4,
}) {
  final width = MediaQuery.sizeOf(context).width;

  if (width < 750) return mobile;
  if (width < 1000) return tablet;
  if (width < 1400) return desktop;

  return largeDesktop;
}

SliverGridDelegate responsiveGridDelegate(
  BuildContext context, {
  double minCardWidth = 300,
  double spacing = 8,
  double minCardHeight = 300,
}) {
  final width = MediaQuery.sizeOf(context).width;

  final columns = (width / (minCardWidth + spacing)).floor().clamp(1, 10);

  final cardWidth = (width - spacing * (columns + 1)) / columns;

  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,
    mainAxisExtent: cardWidth.clamp(minCardHeight, double.infinity),
  );
}
