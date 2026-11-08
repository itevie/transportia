import 'package:flutter/material.dart';

class PopupPageContainer extends StatelessWidget {
  final Widget child;
  const PopupPageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: child);
  }
}
