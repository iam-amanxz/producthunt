import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message,
    {bool isSuccess = true}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
}
