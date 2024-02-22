import 'package:flutter/Material.dart';

Future<TimeOfDay?> pickTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  debugPrint('Picked Time: $picked');
  return picked;
}