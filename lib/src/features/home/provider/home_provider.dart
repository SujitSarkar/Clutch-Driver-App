import 'dart:async';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_model.dart';
import '../model/load_model.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance =
  Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);

  bool functionLoading = false;
  bool companyListLoading = false;
  bool pendingLoadLoading = false;
  bool upcomingLoadLoading = false;
  bool completeLoadLoading = false;
  LoginModel? loginModel;
  int selectedCompanyIndex = 0;

  ///Debounce timer
  Timer? debounceTimer;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();
  String selectedTruck = AppString.truckList.first;

  ///Load
  List<LoadDataModel> pendingLoadList = [];
  List<LoadDataModel> upcomingLoadList = [];
  List<LoadDataModel> completedLoadList = [];

  Future<void> initialize() async {
    pendingLoadLoading=true;
    notifyListeners();
    await getLocalData();
    await getPendingLoadList();
    pendingLoadLoading=false;
    notifyListeners();
  }

  ///UI Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> getLocalData() async {
    final loginResponseFromLocal =
        await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginModel = loginModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessTokenAndCookie(
          token: loginModel?.data?.token,
          cookie: loginModel?.data?.cookie?.authToken);
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  void changeCompanyRadioValue(int value) {
    selectedCompanyIndex = value;
    notifyListeners();
  }

  ///Load Filter
  void dateRangeOnSelectionChanged(DateRangePickerSelectionChangedArgs args) async{
    if (args.value is PickerDateRange && args.value.startDate != null) {
      filterStartDate = args.value.startDate ?? DateTime.now();
      filterEndDate = args.value.endDate ?? filterStartDate;
    }
  }

  void changeTruck(String value) {
    selectedTruck = value;
    notifyListeners();
  }

  Future<void> dateFilterButtonOnTap({required String loadType}) async {
    functionLoading = true;
    notifyListeners();

    if(loadType == AppString.loadTypeList.first){
      ///pending load
      await getPendingLoadList();
    }else if(loadType == AppString.loadTypeList[1]){
      ///Upcoming load
      await getUpcomingLoadList();
    }else if(loadType == AppString.loadTypeList.last){
      ///Completed load
      await getCompletedLoadList();
    }
    functionLoading = false;
    notifyListeners();
    popScreen();
  }

  void clearFilter() {
    filterStartDate = DateTime.now();
    filterEndDate = DateTime.now();
    selectedTruck = AppString.truckList.first;
  }

  ///API Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> getPendingLoadList() async {
    const companyId = 1;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-mm-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-mm-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate');
    }, onSuccess: (response) async {
      final LoadModel loadModel = loadModelFromJson(response.body);
      pendingLoadList = loadModel.data??[];
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> getUpcomingLoadList() async {
    upcomingLoadLoading=true;
    notifyListeners();
    const companyId = 1;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-mm-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-mm-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate');
    }, onSuccess: (response) async {
      final LoadModel loadModel = loadModelFromJson(response.body);
      upcomingLoadList = loadModel.data??[];
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    upcomingLoadLoading=false;
    notifyListeners();
  }

  Future<void> getCompletedLoadList() async {
    completeLoadLoading=true;
    notifyListeners();
    const companyId = 1;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-mm-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-mm-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate');
    }, onSuccess: (response) async {
      final LoadModel loadModel = loadModelFromJson(response.body);
      completedLoadList = loadModel.data??[];
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    completeLoadLoading=false;
    notifyListeners();
  }

  void debouncing({required Function() fn, int waitForMs = 800}) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }
}
