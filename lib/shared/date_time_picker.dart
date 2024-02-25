import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';

Future<TimeOfDay?> pickTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  debugPrint('Picked Time: $picked');
  return picked;
}

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final formatter = DateFormat('HH:mm:ss');
  return formatter.format(dateTime);
}

Future<DateTime?> pickDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  return pickedDate;
}
