import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../home/model/truck_model.dart';
import '../../home/provider/home_provider.dart';

class DrawerMenuProvider extends ChangeNotifier {
  static final DrawerMenuProvider instance =
  Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);

  bool initialLoading = false;
  bool functionLoading = false;
  List<TruckDataModel> truckList = [];
  TruckDataModel? selectedTruck;

  ///Additional Fees
  List<bool> additionalFeeCheckedList = List.generate(
      AppString.additionalFeeCheckBoxList.length, (index) => false);

  ///Pre-Start
  List<bool> preStartFeeCheckedList =
      List.generate(AppString.preStartCheckboxList.length, (index) => false);

  ///Fatigue Management
  List<String> fatigueManagementCheckboxList = [
    'Regular Breaks Taken',
    'Communicated with Scheduler',
    'Driving hours did not exceed Limit'
  ];
  List<bool> fatigueManagementCheckedList = List.generate(3, (index) => false);

  Future<void> initialize()async{
    await getTruckList();
  }

  ///Additional Fees
  void changeAdditionalFeeCheckedList(int index, bool? value) {
    additionalFeeCheckedList[index] = value!;
    notifyListeners();
  }

  ///Pre-Start
  void changePreStartCheckedList(int index, bool? value) {
    preStartFeeCheckedList[index] = value!;
    notifyListeners();
  }

  ///Fatigue Management
  void changeFatigueManagementCheckedList(int index, bool? value) {
    fatigueManagementCheckedList[index] = value!;
    notifyListeners();
  }

  void changeTruck(TruckDataModel value) {
    selectedTruck = value;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }

  Future<void> getTruckList() async {
    final HomeProvider homeProvider =
    Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);
    final companyId = homeProvider.loginModel?.userInfo?.user?.companies?.first.id;
    final driverId = homeProvider.loginModel?.userInfo?.user?.info?.id;

    initialLoading = false;
    notifyListeners();
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.get(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.assetList}?company_id=$companyId&driver_id=$driverId',fromJson: TruckModel.fromJson);
    }, onSuccess: (response) async {
      final TruckModel truckModel = response as TruckModel;
      truckList = truckModel.data??[];
      selectedTruck = truckList.first;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    initialLoading = false;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }
  void addBreakButtonOnTap() {}
}
