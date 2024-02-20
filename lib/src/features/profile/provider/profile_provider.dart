import 'package:flutter/Material.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../authentication/model/login_model.dart';

class ProfileProvider extends ChangeNotifier{
  bool initialLoading = false;
  bool functionLoading = false;
  LoginModel? loginResponseModel;

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
      loginResponseModel = loginModelFromJson(loginResponseFromLocal);
      notifyListeners();
    }
  }
}