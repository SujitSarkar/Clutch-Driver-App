import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../../core/constants/static_list.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../src/features/drawer/model/fatigue_management_break_model.dart';
import '../../../../src/features/drawer/model/daily_summery_model.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../home/model/truck_model.dart';
import '../../home/provider/home_provider.dart';
import '../model/pre_start_data_model.dart';

class DrawerMenuProvider extends ChangeNotifier {
  static final DrawerMenuProvider instance =
      Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);

  bool initialLoading = false;
  bool functionLoading = false;
  bool fatigueManagementLoading = false;

  List<TruckDataModel> ownTruckList = [];
  TruckDataModel? selectedOwnTruck;
  PreStartDataModel? preStartDataModel;
  DailySummaryModel? dailySummaryModel;
  FatigueManagementBreakModel? fatigueManagementBreakModel;

  ///Additional Fees
  List<CheckBoxDataModel> additionalFeeCheckBoxItem = [];

  ///Pre-Start
  List<CheckBoxDataModel> preStartCheckBoxItem = [];

  ///Fatigue Management
  List<CheckBoxDataModel> fatigueManagementCheckBoxItem = [];

  Future<void> initialize() async {
    await getTruckList();
    await HomeProvider.instance.getPendingLoadList();
  }

  ///Additional Fees
  void changeAdditionalFeeItemCheckboxValue(
    int index,
    bool value,
    CheckBoxDataModel item,
  ) {
    additionalFeeCheckBoxItem[index] =
        CheckBoxDataModel(id: item.id, name: item.name, value: value);
    notifyListeners();
  }

  ///Pre-Start
  void changePreStartItemCheckboxValue(
    int index,
    bool value,
    CheckBoxDataModel item,
  ) {
    preStartCheckBoxItem[index] =
        CheckBoxDataModel(id: item.id, name: item.name, value: value);
    notifyListeners();
  }

  ///Fatigue Management
  void changeFatigueManagementCheckboxItemValue(
    int index,
    bool value,
    CheckBoxDataModel item,
  ) {
    fatigueManagementCheckBoxItem[index] =
        CheckBoxDataModel(id: item.id, name: item.name, value: value);
    notifyListeners();
  }

  ///Change Own Truck
  Future<void> changeOwnTruck(
      {required TruckDataModel value, required String fromPage}) async {
    selectedOwnTruck = value;
    await getPreStartChecks(fromPage: fromPage);
  }

  ///Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> getTruckList() async {
    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    HomeProvider.instance.allTruckList = [
      TruckDataModel(id: 0, registrationNo: 'All', whoOwns: 'all')
    ];
    ownTruckList = [];
    initialLoading = true;
    notifyListeners();
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.assetList}?company_id=$companyId&driver_id=$driverId');
    }, onSuccess: (response) async {
      TruckModel truckModel = truckModelFromJson(response.body);
      HomeProvider.instance.allTruckList.addAll(truckModel.data!);

      for (int i = 0; i < truckModel.data!.length; i++) {
        if (truckModel.data![i].whoOwns == StaticList.assetType.first) {
          ownTruckList.add(truckModel.data![i]);
        }
      }
      HomeProvider.instance.selectedAllTruck =
          HomeProvider.instance.allTruckList.isNotEmpty
              ? HomeProvider.instance.allTruckList.first
              : null;
      selectedOwnTruck = ownTruckList.isNotEmpty ? ownTruckList.first : null;
      truckModel = TruckModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    initialLoading = false;
    HomeProvider.instance.notifyListeners();
    notifyListeners();
  }

  Future<void> getPreStartChecks({required fromPage}) async {
    if (initialLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    initialLoading = true;
    notifyListeners();
    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final assetId = selectedOwnTruck?.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final logsDate = DateFormat('yyyy-MM-dd').format(
        HomeProvider.instance.selectedPendingLoadModel?.loadStartDate ??
            DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getPreStartChecklist}?company_id=$companyId&asset_id=$assetId&driver_id=$driverId&logs_date=$logsDate');
    }, onSuccess: (response) async {
      preStartDataModel = preStartDataModelFromJson(response.body);
      preStartCheckBoxItem = preStartDataModel!.data!.preStartChecks!;
      fatigueManagementCheckBoxItem = preStartDataModel!.data!.fatigueChecks!;
      additionalFeeCheckBoxItem = preStartDataModel!.data!.additionalFees!;

      debugPrint('From Page: $fromPage');
      if (fromPage == AppRouter.pendingLoad ||
          fromPage == AppRouter.completeLoad) {
        if (HomeProvider.instance.selectedPendingLoadModel?.requiredPrecheck ==
            false) {
          popAndPushTo(AppRouter.loadDetails);
        } else if (HomeProvider
                    .instance.selectedPendingLoadModel?.requiredPrecheck ==
                true &&
            preStartDataModel?.statusCode == 200) {
          popAndPushTo(AppRouter.loadDetails);
        }
      }
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    initialLoading = false;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }

  Future<void> getDailySummary() async {
    if (initialLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    initialLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final assetId = selectedOwnTruck?.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final logsDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getDailySummary}?company_id=$companyId&asset_id=$assetId&driver_id=$driverId&logs_date=$logsDate');
    }, onSuccess: (response) async {
      dailySummaryModel = dailySummaryModelFromJson(response.body);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    initialLoading = false;
    notifyListeners();
  }

  Future<void> getFatigueBreaks() async {
    if (fatigueManagementLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    final randomCode = preStartDataModel?.data?.randomCode;
    fatigueManagementLoading = true;
    notifyListeners();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getFatigueBreaks}?random_code=$randomCode');
    }, onSuccess: (response) async {
      fatigueManagementBreakModel =
          fatigueManagementBreakModelFromJson(response.body);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    fatigueManagementLoading = false;
    notifyListeners();
  }

  Future<void> savePreStartCheckList(
      {required String startTime,
      required String odoMeterReading,
      required String notes,
      required fromPage}) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final orgId = HomeProvider.instance.loginModel?.data?.organizationId ?? '';
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedOwnTruck?.id;
    List<Map<String, dynamic>> preStartChecks = [];

    for (CheckBoxDataModel model in preStartCheckBoxItem) {
      preStartChecks.add({'id': model.id, 'value': model.value});
    }
    final requestBody = {
      'company_id': companyId,
      'organization_id': orgId,
      'asset_id': assetId,
      'driver_id': driverId,
      'log_start_time': startTime,
      'start_odo_reading': odoMeterReading,
      'pre_start_notes': notes,
      'pre_start_checks': jsonEncode(preStartChecks),
      "load_start_date": DateFormat('yyyy-MM-dd').format(
          HomeProvider.instance.selectedPendingLoadModel?.loadStartDate ??
              DateTime.now())
    };
    debugPrint('$requestBody\n');
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.savePreStartChecklist}',
          body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast('${jsonData['message']}');
      await HomeProvider.instance.getPendingLoadList();
      debugPrint(fromPage);
      if (fromPage == AppRouter.pendingLoad) {
        popAndPushTo(AppRouter.loadDetails);
      }
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> saveDailyLogBook({
    required String endTime,
    required String endingOdoMeterReading,
    required String notes,
  }) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if (HomeProvider.instance.loginModel?.data?.companyId == null) {
      showToast('Organization not found');
      return;
    }
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedOwnTruck?.id;
    List<Map<String, dynamic>> additionalFees = [];

    for (CheckBoxDataModel model in additionalFeeCheckBoxItem) {
      additionalFees.add({'id': model.id, 'value': model.value});
    }
    final requestBody = {
      'log_end_time': endTime,
      'end_odo_reading': endingOdoMeterReading,
      'log_notes': notes,
      'additional_fees': jsonEncode(additionalFees),
      'driver_id': driverId,
      'asset_id': assetId,
      'company_id': companyId,
      'load_start_date': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.saveDailyLogbook}',
          body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast('${jsonData['message']}');
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> saveFatigueBreak({
    required String startTime,
    required String endTime,
    required String breakDetails,
  }) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    functionLoading = true;
    notifyListeners();
    final assetId = selectedOwnTruck?.id;
    final randomCode = preStartDataModel?.data?.randomCode;

    final requestBody = {
      'asset_id': assetId,
      'random_code': randomCode,
      'break_start_time': startTime,
      'break_end_time': endTime,
      'break_details': breakDetails,
    };
    debugPrint('$requestBody');
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.saveFatigueBreak}',
          body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast('${jsonData['message']}');
      getFatigueBreaks();
      popScreen();
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> saveFatigueManagement({required String notes}) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if (HomeProvider.instance.loginModel?.data?.companyId == null) {
      showToast('Organization not found');
      return;
    }
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companyId ?? '';
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedOwnTruck?.id;
    final logsDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<Map<String, dynamic>> fatigueChecks = [];

    for (CheckBoxDataModel model in fatigueManagementCheckBoxItem) {
      fatigueChecks.add({'id': model.id, 'value': model.value});
    }
    final requestBody = {
      'company_id': companyId,
      'asset_id': assetId,
      'driver_id': driverId,
      'fatigue_notes': notes,
      'fatigue_checks': jsonEncode(fatigueChecks),
      'logs_date': logsDate,
    };
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.saveFatigueManagement}',
          body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast('${jsonData['message']}');
      getPreStartChecks(fromPage: 'Fatigue Management');
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> deleteFatigueBreak({required String id}) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    functionLoading = true;
    notifyListeners();
    final driverId = HomeProvider.instance.loginModel?.data?.id;

    final requestBody = {
      'id': id,
      'driver_id': driverId,
    };
    debugPrint('$requestBody');
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.deleteFatigueBreak}',
          body: requestBody);
    }, onSuccess: (response) async {
      var jsonData = jsonDecode(response.body);
      showToast('${jsonData['message']}');
      getFatigueBreaks();
      popScreen();
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }
}
