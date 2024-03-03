import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../src/features/home/model/load_weight_model.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../src/features/profile/provider/profile_provider.dart';
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
import '../model/truck_model.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance =
  Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);

  bool functionLoading = false;
  bool companyListLoading = false;
  bool pendingLoadLoading = false;
  bool upcomingLoadLoading = false;
  bool completeLoadLoading = false;
  bool loadDetailsLoading = false;
  LoginModel? loginModel;
  // int selectedCompanyIndex = 0;

  ///Debounce timer
  Timer? debounceTimer;

  ///Filter
  DateTime? filterStartDate = DateTime.now();
  DateTime? filterEndDate = DateTime.now();

  ///Truck
  List<TruckDataModel> allTruckList = [];
  TruckDataModel? selectedAllTruck;

  ///Load
  final GlobalKey<FormState> loadDetailsFormKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();
  List<LoadDataModel> pendingLoadList = [];
  List<LoadDataModel> upcomingLoadList = [];
  List<LoadDataModel> completedLoadList = [];
  LoadDataModel? selectedPendingLoadModel;
  LoadWeightModel? loadWeightModel;

  Future<void> initialize() async {
    pendingLoadLoading=true;
    notifyListeners();
    await getLocalData();
    ProfileProvider.instance.getUserInfo();
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

  ///Change All Truck
  Future<void> changeAllTruck({required TruckDataModel value, required String fromPage}) async {
    selectedAllTruck = value;
    debugPrint('FromPage: $fromPage');

    if (fromPage == AppRouter.pendingLoad) {
       getPendingLoadList();
    } else if (fromPage == AppRouter.upcomingLoad) {
       getUpcomingLoadList();
    } else if (fromPage == AppRouter.completeLoad) {
       getCompletedLoadList();
    }
    notifyListeners();
  }

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
    pushTo(AppRouter.preStartChecklist,
        arguments: const PreStartChecklistScreen(fromPage: AppRouter.pendingLoad));
  }

  void clearFilter() {
    searchController.clear();
    filterStartDate = DateTime.now();
    filterEndDate = DateTime.now();
    DrawerMenuProvider.instance.notifyListeners();
  }

  ///API Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  // 2=Upcoming load
  // 3=Pending load (progress)
  // 4=Completed load

  Future<void> loadSearchOnChange({required String loadType})async{
    debouncing(waitForMs: 2000,fn: (){
      notifyListeners();
      debugPrint('Load Type: $loadType');
      if (loadType == StaticList.loadTypeList.first) {
        getPendingLoadList();
      } else if (loadType == StaticList.loadTypeList[1]) {
        getUpcomingLoadList();
      } else if (loadType == StaticList.loadTypeList.last) {
        getCompletedLoadList();
      }
    });
  }

  Future<void> clearSearchOnTap({required String loadType})async{
    searchController.clear();
    notifyListeners();
    debugPrint('Load Type: $loadType');
    if (loadType == StaticList.loadTypeList.first) {
      getPendingLoadList();
    } else if (loadType == StaticList.loadTypeList[1]) {
      getUpcomingLoadList();
    } else if (loadType == StaticList.loadTypeList.last) {
      getCompletedLoadList();
    }
  }

  Future<void> getPendingLoadList() async {
    pendingLoadLoading=true;
    notifyListeners();
    pendingLoadList = [];
    final driverId = loginModel?.data?.id;
    final assetId = selectedAllTruck?.id;
    final companyId = loginModel?.data?.companyId??'';
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());
    final String loadRef = searchController.text.trim();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.pendingLoadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate&status=3&asset_id=$assetId&load_ref=$loadRef');
    }, onSuccess: (response) async {
      LoadModel loadModel = loadModelFromJson(response.body);
      pendingLoadList = loadModel.data??[];
      notifyListeners();
      loadModel = LoadModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    pendingLoadLoading=false;
    notifyListeners();
  }

  Future<void> getUpcomingLoadList() async {
    upcomingLoadList = [];
    upcomingLoadLoading=true;
    notifyListeners();
    final driverId = loginModel?.data?.id;
    final assetId = selectedAllTruck?.id;
    final companyId = loginModel?.data?.companyId??'';
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());
    final String loadRef = searchController.text.trim();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate&status=2&asset_id=$assetId&load_ref=$loadRef');
    }, onSuccess: (response) async {
      LoadModel loadModel = loadModelFromJson(response.body);
      upcomingLoadList = loadModel.data??[];
      notifyListeners();
      getPendingLoadList();
      loadModel = LoadModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    upcomingLoadLoading=false;
    notifyListeners();
  }

  Future<void> getCompletedLoadList() async {
    completedLoadList = [];
    completeLoadLoading=true;
    notifyListeners();
    final driverId = loginModel?.data?.id;
    final assetId = selectedAllTruck?.id;
    final companyId = loginModel?.data?.companyId??'';
    final String startDate = DateFormat('yyyy-MM-dd').format(filterStartDate??DateTime.now());
    final String endDate = DateFormat('yyyy-MM-dd').format(filterEndDate??DateTime.now());
    final String loadRef = searchController.text.trim();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadList}?company_id=$companyId&driver_id=$driverId&start_date=$startDate&end_date=$endDate&status=4&asset_id=$assetId&load_ref=$loadRef');
    }, onSuccess: (response) async {
      LoadModel loadModel = loadModelFromJson(response.body);
      completedLoadList = loadModel.data??[];
      notifyListeners();
      getPendingLoadList();
      loadModel = LoadModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    completeLoadLoading=false;
    notifyListeners();
  }

  Future<void> loadDecline({required int loadId}) async {
    final requestBody = {
      'user_id': loadId,
      'load_id': loginModel?.data?.id};

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadDecline}',body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast(jsonData['message']);
      getPendingLoadList();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> getLoadWeight() async {
    loadDetailsLoading = true;
    notifyListeners();
    final loadId = selectedPendingLoadModel?.id;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getLoadWeight}?load_id=$loadId');
    }, onSuccess: (response) async {
      loadWeightModel = loadWeightModelFromJson(response.body);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loadDetailsLoading = false;
    notifyListeners();
  }

  Future<void> saveOrCompleteLoadWeight({required Map<String, dynamic> body}) async {
    if(functionLoading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    debugPrint('RequestBody: $body');
    //save=3, complete=4
    functionLoading = true;
    notifyListeners();
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.loadWeightCreateEdit}',body: body);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast(jsonData['message']);
      if(body['status']==4){
        await getPendingLoadList();
        popUntilOf(AppRouter.pendingLoad);
      }
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> saveLoadWeightAttachment(
      {required String loadWeightType,
        required List<File> files}) async {
    if(functionLoading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if(files.isEmpty){
      showToast('Attach $loadWeightType file');
      return;
    }
    functionLoading=true;
    notifyListeners();
    final loadId = selectedPendingLoadModel?.id;
    String fileFieldName = '';

    if(loadWeightType==StaticList.loadWeightType.first){
      fileFieldName = 'pickup_attachments';
    }else{
      fileFieldName = 'delivery_attachments';
    }
    await Future.forEach(files, (File element)async{
      await ApiService.instance.apiCall(execute: () async {
        return await ApiService.instance.multipartRequest(
          url: '${ApiEndpoint.baseUrl}${ApiEndpoint.loadWeightAttachment}',
          requestBody: {'load_id': loadId},
          file: element,
          fileFieldName: fileFieldName,
        );
      }, onSuccess: (response) async {
        var jsonData = jsonDecode(response.body);
        showToast(jsonData['message']);
        await getLoadWeight();
        jsonData = null;
      }, onError: (error) {
        debugPrint('Error: ${error.message}');
        showToast('Error: ${error.message}');
      });
    });

    functionLoading=false;
    notifyListeners();
  }

  void debouncing({required Function() fn, int waitForMs = 1000}) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }
}
