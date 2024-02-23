import 'dart:async';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/constants/static_list.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_model.dart';
import '../../drawer/provider/drawer_menu_provider.dart';
import '../../drawer/screen/prestart_checklist_screen.dart';
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
  // int selectedCompanyIndex = 0;

  ///Debounce timer
  Timer? debounceTimer;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();

  ///Load
  List<LoadDataModel> pendingLoadList = [];
  List<LoadDataModel> upcomingLoadList = [];
  List<LoadDataModel> completedLoadList = [];
  LoadDataModel? selectedPendingLoadModel;

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
          token: loginModel?.data?.authToken,
          cookie: loginModel?.data?.authToken);
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  // void changeCompanyRadioValue(int value) {
  //   selectedCompanyIndex = value;
  //   notifyListeners();
  // }

  ///Load Filter
  void dateRangeOnSelectionChanged(DateRangePickerSelectionChangedArgs args) async{
    if (args.value is PickerDateRange && args.value.startDate != null) {
      filterStartDate = args.value.startDate ?? DateTime.now();
      filterEndDate = args.value.endDate ?? filterStartDate;
    }
  }

  Future<void> dateFilterButtonOnTap({required String loadType}) async {
    functionLoading = true;
    notifyListeners();

    if(loadType == StaticList.loadTypeList.first){
      ///pending load
      await getPendingLoadList();
    }else if(loadType == StaticList.loadTypeList[1]){
      ///Upcoming load
      await getUpcomingLoadList();
    }else if(loadType == StaticList.loadTypeList.last){
      ///Completed load
      await getCompletedLoadList();
    }
    functionLoading = false;
    notifyListeners();
    popScreen();
  }

  void pendingLoadStartButtonOnTap({required LoadDataModel model}){
    selectedPendingLoadModel = model;
    notifyListeners();
    pushTo(AppRouter.preStartChecklist,
        arguments: const PreStartChecklistScreen(fromPage: AppRouter.pendingLoad));
  }

  void clearFilter() {
    filterStartDate = DateTime.now();
    filterEndDate = DateTime.now();
    // DrawerMenuProvider.instance.selectedTruck = null;
    DrawerMenuProvider.instance.notifyListeners();
  }

  ///API Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> getPendingLoadList() async {
    pendingLoadList = [];
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?driver_id=$driverId&start_date=2023-02-23&end_date=$endDate?status=2');
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
    if(upcomingLoadLoading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    upcomingLoadList = [];
    upcomingLoadLoading=true;
    notifyListeners();
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?driver_id=$driverId&start_date=2023-02-23&end_date=$endDate?status=3');
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
    if(completeLoadLoading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    completedLoadList = [];
    completeLoadLoading=true;
    notifyListeners();
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?driver_id=$driverId&start_date=2023-02-23&end_date=$endDate?status=4');
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
