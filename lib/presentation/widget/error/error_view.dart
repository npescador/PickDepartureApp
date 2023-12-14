import 'package:flutter/material.dart';

class ErrorView {
  static show(BuildContext context, String message, Function onRetry) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(Icons.error_outline),
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: const Text("Retry"),
                onPressed: () {
                  onRetry.call();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        });
  }
}
