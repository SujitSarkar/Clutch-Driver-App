import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/permission_handler.dart';
import '../../authentication/model/login_response_model.dart';

class ProfileProvider extends ChangeNotifier{
  bool initialLoading = false;
  bool functionLoading = false;
  LoginResponseModel? loginResponseModel;

  final TextEditingController name = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController organization = TextEditingController();
  final TextEditingController license = TextEditingController();
  final TextEditingController vic = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController reservoir = TextEditingController();

  File? selectedAttachmentFile;
  static final ImagePicker imagePicker = ImagePicker();
  static final AppPermissionHandler appPermissionHandler=AppPermissionHandler();

  Future<void> initialize() async {
    initialLoading = true;
    notifyListeners();
    await getLocalData();
    initialLoading = false;
    notifyListeners();
  }

  Future<void> getLocalData() async {
    final loginResponseFromLocal =
    await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      notifyListeners();
    }
  }

  ///Get image from camera
  Future<void> getImageFromCamera() async {
    selectedAttachmentFile = null;
    final bool permission = await appPermissionHandler.cameraPermission();
    if (permission) {
      if (Platform.isAndroid) {
        final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 720,maxWidth: 1280);
        if (image != null) {
          selectedAttachmentFile = File(image.path);
          notifyListeners();
        }
      }
    }
  }
}