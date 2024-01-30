import 'dart:io';
import 'package:clutch_driver_app/core/utils/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  static final AppPermissionHandler appPermissionHandler =
      AppPermissionHandler();
  static final ImagePicker imagePicker = ImagePicker();

  Future<File?> getImageFromCamera() async {
    File? file;
    final bool permission = await appPermissionHandler.cameraPermission();
    if (!permission) {
      return null;
    }
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
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
    final bool permission = await appPermissionHandler.galleryPermission();
    if (!permission) {
      return null;
    }
    try {
      final FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
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
