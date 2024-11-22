import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showError({required String message}) {
  toastification.show(
    alignment: Alignment.center,
    title: const Text('Error'),
    description: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
    style: ToastificationStyle.flatColored,
    primaryColor: Colors.red,
  );
}
