import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiHttpException implements Exception {
  final int statusCode;
  final String statusMessage;
  final String message;

  ApiHttpException({
    required this.statusCode,
    required this.statusMessage,
    required this.message,
  });

  @override
  String toString() => '$statusCode - $statusMessage: $message';
}

class TransportiaErrorWidget extends StatelessWidget {
  final Object? error;

  const TransportiaErrorWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;

    late final String title;
    late final String message;

    if (error is ApiHttpException) {
      final e = error as ApiHttpException;

      title = '${e.statusCode} - ${e.statusMessage}';
      message = e.message;
    } else if (error is SocketException || error is http.ClientException) {
      title = 'Connection error';
      message = error.toString();
    } else if (error is TimeoutException) {
      title = 'Request timed out';
      message = 'The server took too long to respond.';
    } else if (error is FormatException) {
      title = 'Invalid response';
      message = error.toString();
    } else if (error is HandshakeException) {
      title = 'Secure connection error';
      message = error.toString();
    } else {
      title = 'Something went wrong';
      message = error?.toString() ?? 'An unknown error occurred.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 40, color: color),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
