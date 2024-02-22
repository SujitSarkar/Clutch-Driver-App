import 'dart:convert';
import '../../../../src/features/drawer/model/fatigue_management_break_model.dart';
import '../../../../src/features/drawer/model/daily_summery_model.dart';
import '../../../../core/router/page_navigator.dart';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../home/model/truck_model.dart';
import '../../home/provider/home_provider.dart';
import '../model/pre_start_data_model.dart';

class DrawerMenuProvider extends ChangeNotifier {
  static final DrawerMenuProvider instance = Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);

  bool initialLoading = false;
  bool functionLoading = false;
  bool fatigueManagementLoading = false;

  List<TruckDataModel> truckList = [];
  TruckDataModel? selectedTruck;
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
  }

  ///Additional Fees
  void changeAdditionalFeeItemCheckboxValue(
    int index,
    bool value,
    CheckBoxDataModel item,
  ) {
    additionalFeeCheckBoxItem[index] = CheckBoxDataModel(id: item.id, name: item.name, value: value);
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

  ///Change Truck
  void changeTruck(TruckDataModel value) {
    selectedTruck = value;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }

  ///Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


  Future<void> getTruckList() async {
    final companyId =
        HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;

    initialLoading = true;
    notifyListeners();
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.assetList}?company_id=$companyId&driver_id=$driverId');
    }, onSuccess: (response) async {
      final TruckModel truckModel = truckModelFromJson(response.body);
      truckList = truckModel.data ?? [];
      selectedTruck = truckList.isNotEmpty ? truckList.first : null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    initialLoading = false;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }

  Future<void> getPreStartChecks({required fromPage}) async {
    initialLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final assetId = selectedTruck?.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final logsDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getPreStartChecklist}?company_id=$companyId&asset_id=$assetId&driver_id=$driverId&logs_date=$logsDate');
    }, onSuccess: (response) async {
      preStartDataModel = preStartDataModelFromJson(response.body);
      preStartCheckBoxItem = preStartDataModel!.data!.preStartChecks!;
      fatigueManagementCheckBoxItem = preStartDataModel!.data!.fatigueChecks!;
      additionalFeeCheckBoxItem = preStartDataModel!.data!.additionalFees!;
      initialLoading = false;
      notifyListeners();
      debugPrint(fromPage);
      if(fromPage==AppRouter.pendingLoad){
        if(preStartDataModel?.message?.toLowerCase() != 'You have to fillup this form first'.toLowerCase()){
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
    initialLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final assetId = selectedTruck?.id;
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
    fatigueManagementLoading = true;
    notifyListeners();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.getFatigueBreaks}?random_code=${preStartDataModel?.data?.randomCode}');
    }, onSuccess: (response) async {
      fatigueManagementBreakModel = fatigueManagementBreakModelFromJson(response.body);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    fatigueManagementLoading = false;
    notifyListeners();
  }

  Future<void> savePreStartCheckList({
    required String startTime,
    required String odoMeterReading,
    required String notes,
    required fromPage
  }) async {
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final orgId = HomeProvider.instance.loginModel?.data?.organizations?.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedTruck?.id;
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
      'pre_start_checks': preStartChecks,
    };
    await ApiService.instance.apiCall(
        execute: () async {
          return await ApiService.instance.post(
              '${ApiEndpoint.baseUrl}${ApiEndpoint.savePreStartChecklist}',
              body: requestBody);
        },
        onSuccess: (response) async {
          final jsonData = jsonDecode(response.body);
          showToast('${jsonData['message']}');
          debugPrint(fromPage);
          if(fromPage==AppRouter.pendingLoad){
            popAndPushTo(AppRouter.loadDetails);
          }
        },
        onError: (error) {
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
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedTruck?.id;
    List<Map<String, dynamic>> additionalFees = [];

    for (CheckBoxDataModel model in additionalFeeCheckBoxItem) {
      additionalFees.add({'id': model.id, 'value': model.value});
    }
    final requestBody = {
      'company_id': companyId,
      'asset_id': assetId,
      'driver_id': driverId,
      'log_notes': notes,
      'end_odo_reading': endingOdoMeterReading,
      'log_end_time': endTime,
      'additional_fees': additionalFees,
    };
    await ApiService.instance.apiCall(
        execute: () async {
          return await ApiService.instance.post(
              '${ApiEndpoint.baseUrl}${ApiEndpoint.saveDailyLogbook}',
              body: requestBody);
        },
        onSuccess: (response) async {
          final jsonData = jsonDecode(response.body);
          showToast('${jsonData['message']}');
        },
        onError: (error) {
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
    functionLoading = true;
    notifyListeners();
    final assetId = selectedTruck?.id;
    final randomCode = preStartDataModel?.data?.randomCode;

    final requestBody = {
      'asset_id': assetId,
      'random_code': randomCode,
      'break_start_time': startTime,
      'break_end_time': endTime,
      'break_details': breakDetails,
    };
    debugPrint('$requestBody');
    await ApiService.instance.apiCall(
        execute: () async {
          return await ApiService.instance.post(
              '${ApiEndpoint.baseUrl}${ApiEndpoint.saveFatigueBreak}',
              body: requestBody);
        },
        onSuccess: (response) async {
          final jsonData = jsonDecode(response.body);
          showToast('${jsonData['message']}');
          getFatigueBreaks();
          popScreen();
        },
        onError: (error) {
          debugPrint('Error: ${error.message}');
          showToast('Error: ${error.message}');
        });
    functionLoading = false;
    notifyListeners();
  }

  Future<void> saveFatigueManagement({
    required String notes
  }) async {
    functionLoading = true;
    notifyListeners();

    final companyId = HomeProvider.instance.loginModel?.data?.companies?.first.id;
    final driverId = HomeProvider.instance.loginModel?.data?.id;
    final assetId = selectedTruck?.id;
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
      'fatigue_checks': fatigueChecks,
      'logs_date': logsDate,
    };
    await ApiService.instance.apiCall(
        execute: () async {
          return await ApiService.instance.post(
              '${ApiEndpoint.baseUrl}${ApiEndpoint.saveFatigueManagement}',
              body: requestBody);
        },
        onSuccess: (response) async {
          final jsonData = jsonDecode(response.body);
          showToast('${jsonData['message']}');
          getPreStartChecks(fromPage: 'Fatigue Management');
        },
        onError: (error) {
          debugPrint('Error: ${error.message}');
          showToast('Error: ${error.message}');
        });
    functionLoading = false;
    notifyListeners();
  }

  void addBreakButtonOnTap() {}
}
