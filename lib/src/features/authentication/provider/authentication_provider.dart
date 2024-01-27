import 'package:flutter/Material.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';
import '../model/reset_password_model.dart';
import '../repository/auth_repository.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool loading = false;
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey();

  final TextEditingController username = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    passwordController.clear();
    username.clear();
  }

  Future<void> signInButtonOnTap() async {
    ApiService.instance.clearAccessToken();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "username": username.text.trim(),
      "password": passwordController.text.trim(),
    };

    await _authRepository.signIn(requestBody: requestBody).then(
        (LoginResponseModel? response) async {
      if (response != null) {
        await setData(LocalStorageKey.loginResponseKey,
            loginResponseModelToJson(response)).then((value) async {
          ApiService.instance.addAccessToken(response.data?.accessToken);
          clearAllData();

        }, onError: (error) {
          showToast(error.toString());
        });
      }
    }, onError: (error) {
      showToast(error.toString());
    });
    loading = false;
    notifyListeners();
  }

  Future<void> resetPasswordButtonOnTap() async {
    ApiService.instance.clearAccessToken();
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": ''};

    await _authRepository.resetPassword(requestBody: requestBody).then(
            (ResetPasswordResponseModel? response) async {
          if (response != null && response.status==true) {

          }
        }, onError: (error) {
      showToast(error.toString());
    });
    loading = false;
    notifyListeners();
  }
}
