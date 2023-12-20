import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  void showSnackBar(String? message, {bool isError = false}) =>
      ScaffoldMessenger.of(this)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message ?? ''),
          ),
        );
}
