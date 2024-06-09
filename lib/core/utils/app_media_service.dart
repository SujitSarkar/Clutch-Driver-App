import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'permission_handler.dart';

class AppMediaService {
  Future<File?> getImageFromCamera() async {
    File? file;
    final bool permission = await AppPermissionHandler().cameraPermission();
    if (!permission) {
      return null;
    }
    try {
      final XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 70);
      if (image != null) {
        file = File(image.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
    return file;
  }

  Future<File?> getImageFromGallery(
      {int? imageQuality, double? maxHeight}) async {
    File? file;
    final bool permission = await AppPermissionHandler().galleryPermission();
    if (!permission) {
      return null;
    }
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality ?? 70,
        maxHeight: maxHeight ?? 500.0,
      );
      if (image != null) {
        file = File(image.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
    return file;
  }

  Future<File?> getFileFromStorage() async {
    File? file;
    final bool permission = await AppPermissionHandler().galleryPermission();
    if (!permission) {
      return null;
    }
    try {
      final FilePickerResult? filePickerResult =
          await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'png', 'jpg', 'jpeg'],
      );
      if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
        file = File(filePickerResult.files.single.path ?? '');
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      return null;
    }
    return file;
  }
}
