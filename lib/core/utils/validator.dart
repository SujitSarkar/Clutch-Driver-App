import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

bool validateEmail(String emailAddress) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(emailAddress);

bool validatePassword(String password) => password.length >= 8;

bool isImageFile(File file) {
  String fileName = file.uri.pathSegments.last;
  String extension = fileName.split('.').last.toLowerCase();
  List<String> imageExtensions = ['jpg', 'jpeg', 'png'];
  return imageExtensions.contains(extension);
}

double parseTextFieldDataToDouble(TextEditingController textEditingController) {
  return double.parse(
      textEditingController.text.isNotEmpty ? textEditingController.text : '0');
}

double roundDouble(double value, [int places = 2]) {
  final factor = pow(10, places);
  return (value * factor).round() / factor;
}
