import 'package:clutch_driver_app/shared/api/api_service.dart';
import 'package:flutter/Material.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../authentication/model/login_response_model.dart';
import '../repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  bool initialLoading = false;
  bool loading = false;
  LoginResponseModel? loginResponseModel;

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
      ApiService.instance.addAccessToken(loginResponseModel!.data!.accessToken);
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

}
