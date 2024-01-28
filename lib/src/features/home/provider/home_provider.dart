import 'dart:io';
import 'package:clutch_driver_app/shared/api/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/permission_handler.dart';
import '../../authentication/model/login_response_model.dart';
import '../repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  bool companyListLoading = false;
  bool functionLoading = false;
  LoginResponseModel? loginResponseModel;
  int selectedCompanyIndex = 0;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();
  int selectedTimeSlot = 1;

  ///Load
  final TextEditingController pickupTareWeight = TextEditingController();
  final TextEditingController pickupGrossWeight = TextEditingController();
  final TextEditingController deliveryTareWeight = TextEditingController();
  final TextEditingController deliveryGrossWeight = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController calculatedNett = TextEditingController();

  ///Load Attachment
  File? selectedAttachmentFile;
  List<File> attachmentFileList = [];
  static final ImagePicker imagePicker = ImagePicker();
  static final AppPermissionHandler appPermissionHandler=AppPermissionHandler();

  Future<void> initialize() async {
    await getLocalData();
  }

  Future<void> getLocalData() async {
    final loginResponseFromLocal =
    await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessToken(loginResponseModel!.data!.accessToken);
      notifyListeners();
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  void changeCompanyRadioValue(int value){
    selectedCompanyIndex = value;
    notifyListeners();
  }

  ///Load Filter
  void dateRangeOnSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange && args.value.startDate != null) {
      filterStartDate = args.value.startDate ?? DateTime.now();
      filterEndDate = args.value.endDate ?? filterStartDate;
      notifyListeners();
    }
  }

  void changeFilterTimeSlot(int value){
    selectedTimeSlot = value;
    notifyListeners();
  }

  void forwardDateBySlot(){
    filterStartDate = filterStartDate!.add(Duration(days: selectedTimeSlot));
    filterEndDate = filterStartDate;
    notifyListeners();
  }
  void backwardDateBySlot(){
    filterStartDate = filterStartDate!.subtract(Duration(days: selectedTimeSlot));
    filterEndDate = filterStartDate;
    notifyListeners();
  }

  Future<void> dateFilterButtonOnTap() async {
    functionLoading=true;
    notifyListeners();

    functionLoading=false;
    notifyListeners();
  }


  ///Attachment
  Future<void> getImageFromCamera() async {
    selectedAttachmentFile = null;
    final bool permission = await appPermissionHandler.cameraPermission();
    if (permission) {
      if (Platform.isAndroid) {
        final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 720,maxWidth: 1280);
        if (image != null) {
          selectedAttachmentFile = File(image.path);
          attachmentFileList.add(selectedAttachmentFile!);
          notifyListeners();
        }
      }
    }
  }

  Future<void> getFileFromStorage() async {
    selectedAttachmentFile = null;
    final bool permission = await appPermissionHandler.galleryPermission();
    if (permission) {
      if (Platform.isAndroid) {
        FilePickerResult? file = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx', 'doc', 'png', 'jpg', 'jpeg']);
        if (file != null) {
          selectedAttachmentFile = File(file.files.single.path ?? '');
          attachmentFileList.add(selectedAttachmentFile!);
          notifyListeners();
        }
      }
    }
  }

  void clearAttachedFile(){
    attachmentFileList = [];
    selectedAttachmentFile = null;
    notifyListeners();
  }

  void removeFileFromAttachmentFileList(int index){
    if(selectedAttachmentFile!.uri.pathSegments.last == attachmentFileList[index].uri.pathSegments.last){
      selectedAttachmentFile = null;
    }
    attachmentFileList.removeAt(index);
    notifyListeners();
  }

}
