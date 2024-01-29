import 'dart:io';
import 'package:clutch_driver_app/core/utils/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {

  static final AppPermissionHandler appPermissionHandler = AppPermissionHandler();
  static final ImagePicker imagePicker = ImagePicker();

  Future<File?> getImageFromCamera() async {
    File? file;
    final bool permission = await appPermissionHandler.cameraPermission();
    if (permission) {
      if (Platform.isAndroid) {
        final XFile? image = await imagePicker.pickImage(
            source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
        if (image != null) {
          file = File(image.path);
        }
      }
    }
    return file;
  }

  Future<File?> getFileFromStorage() async {
    File? file;
    final bool permission = await appPermissionHandler.galleryPermission();
    if (permission) {
      if (Platform.isAndroid) {
        FilePickerResult? filePickerResult = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: [
          'pdf',
          'docx',
          'doc',
          'png',
          'jpg',
          'jpeg'
        ]);
        if (filePickerResult != null) {
          file = File(filePickerResult.files.single.path ?? '');
        }
      }
    }
    return file;
  }
}
