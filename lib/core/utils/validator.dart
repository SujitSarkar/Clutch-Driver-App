import 'dart:io';
import 'package:flutter/cupertino.dart';

bool validateEmail(String emailAddress) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(emailAddress);

bool validatePassword(String password) => password.length >= 8;

bool isVideoUrl(String url) {
  final RegExp videoExtensions =
      RegExp(r'\.(mp4|avi|mov|wmv)$', caseSensitive: false);
  return videoExtensions.hasMatch(url);
}

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
