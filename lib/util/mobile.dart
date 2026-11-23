import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 600;
}
