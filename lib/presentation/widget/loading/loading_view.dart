import 'package:flutter/material.dart';

class LoadingView {
  static var _isLoading = false;
  static BuildContext? _dialogContext;
  static show(BuildContext context) {
    if (_isLoading) return;

    _isLoading = true;

    showDialog(
        context: context,
        builder: (dialogContext) {
          _dialogContext = dialogContext;
          return const PopScope(
              canPop: false, //El dialogo no puede ocultarse
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ));
        });
  }

  static hide() {
    if (!_isLoading) return;

    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
    }
    _isLoading = false;
  }
}
