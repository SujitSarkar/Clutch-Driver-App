import 'package:clutch_driver_app/shared/api/api_service.dart';
import 'package:flutter/Material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../authentication/model/login_response_model.dart';

class HomeProvider extends ChangeNotifier {
  bool functionLoading = false;
  bool companyListLoading = false;
  bool pendingLoadLoading = false;
  bool upcomingLoadLoading = false;
  bool completeLoadLoading = false;
  LoginResponseModel? loginResponseModel;
  int selectedCompanyIndex = 0;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();
  int selectedTimeSlot = 1;

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

  void changeFilterTimeSlot(int value) {
    selectedTimeSlot = value;
    notifyListeners();
  }

  void forwardDateBySlot() {
    if(filterStartDate!.add(Duration(days: selectedTimeSlot)).isBefore(DateTime.now())){
      filterStartDate = filterStartDate!.add(Duration(days: selectedTimeSlot));
      filterEndDate = filterStartDate;
      notifyListeners();
    }
  }

  void backwardDateBySlot() {
    filterStartDate =
        filterStartDate!.subtract(Duration(days: selectedTimeSlot));
    filterEndDate = filterStartDate;
    notifyListeners();
  }

  Future<void> dateFilterButtonOnTap() async {
    functionLoading = true;
    notifyListeners();

    functionLoading = false;
    notifyListeners();
  }

  void clearFilter() {
    filterStartDate = DateTime.now();
    filterEndDate = DateTime.now();
    selectedTimeSlot = 1;
  }
}
