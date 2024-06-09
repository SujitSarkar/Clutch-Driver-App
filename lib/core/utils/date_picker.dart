import 'package:flutter/material.dart';
import '../router/app_navigator_key.dart';

Future<DateTime?> getDateFromPicker({DateTime? maxDate}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: AppNavigatorKey.key.currentState!.context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: maxDate ?? DateTime.now(),
  );
  return pickedDate;
}
