import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotImplementedPage extends StatelessWidget {
  const NotImplementedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final route = GoRouterState.of(context).uri.toString();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "This page has not been created yet.\nCheck back soon!",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(route, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
