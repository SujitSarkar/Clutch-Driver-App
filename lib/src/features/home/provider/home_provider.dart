import 'dart:async';
import 'package:clutch_driver_app/core/constants/app_string.dart';
import 'package:clutch_driver_app/shared/api/api_service.dart';
import 'package:clutch_driver_app/src/features/home/model/asset_response_model.dart';
import 'package:flutter/Material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../authentication/model/login_response_model.dart';

class HomeProvider extends ChangeNotifier {
  bool loading = false;
  bool functionLoading = false;
  bool companyListLoading = false;
  bool pendingLoadLoading = false;
  bool upcomingLoadLoading = false;
  bool completeLoadLoading = false;
  LoginResponseModel? loginResponseModel;
  int selectedCompanyIndex = 0;

  ///Debounce timer
  Timer? debounceTimer;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();
  String selectedTruck = AppString.truckList.first;

  List<AssetListData> assetList = [];

  Future<void> initialize() async {
    loading = true;
    notifyListeners();

    await getLocalData();
    await getAssets();

    loading = false;
    notifyListeners();
    notifyListeners();
  }

  Future<void> getLocalData() async {
    final loginResponseFromLocal = await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessToken(loginResponseModel?.token);
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  void changeCompanyRadioValue(int value) {
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

  void changeTruck(String value) {
    selectedTruck = value;
    notifyListeners();
  }

  Future<void> dateFilterButtonOnTap() async {
    functionLoading = true;
    notifyListeners();

    functionLoading = false;
    notifyListeners();
    Navigator.pop(AppNavigatorKey.key.currentState!.context);
  }

  void clearFilter() {
    filterStartDate = DateTime.now();
    filterEndDate = DateTime.now();
    selectedTruck = AppString.truckList.first;
  }

  ///Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> getAssets() async {
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.assetList}?company_id='
              '${loginResponseModel?.userInfo?.user?.companies?.first.companyId}&driver_id='
              '${loginResponseModel?.userInfo?.user?.info?.id}',
          fromJson: AssetResponseModel.fromJson);
    }, onSuccess: (response) async {
      final AssetResponseModel model = response as AssetResponseModel;
      assetList = model.data?? [];
    }, onError: (error) {
      showToast("$error");
      debugPrint("$error");
    });
  }

  void debouncing({required Function() fn, int waitForMs = 800}) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }
}
