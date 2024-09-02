import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
