import 'package:clutch_driver_app/core/router/app_router.dart';
import 'package:clutch_driver_app/core/router/page_route.dart';
import 'package:flutter/Material.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';
import '../model/reset_password_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool loading = false;
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey();

  final TextEditingController email = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    passwordController.clear();
    email.clear();
  }

  Future<void> signInButtonOnTap() async {
    ApiService.instance.clearAccessToken();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email.text.trim(),
      "password": passwordController.text,
    };

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signIn}', fromJson: LoginResponseModel.fromJson,
          body: requestBody);
    }, onSuccess: (response) async {
      final LoginResponseModel model = response as LoginResponseModel;
      await setData(LocalStorageKey.loginResponseKey, loginResponseModelToJson(model)).then((value){
        ApiService.instance.addAccessToken(model.token);
        clearAllData();
        pushAndRemoveUntil(targetRoute: AppRouter.pendingLoad);
      });
    }, onError: (error) {
      showToast("$error");
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

    Map<String, dynamic> requestBody = {
      "email": '',
      'phone': phoneController.text.trim()
    };
    loading = false;
    notifyListeners();
  }
}
