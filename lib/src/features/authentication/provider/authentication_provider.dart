import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/page_navigator.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../drawer/provider/drawer_menu_provider.dart';
import '../../home/provider/home_provider.dart';
import '../model/change_password_model.dart';
import '../model/login_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  static final AuthenticationProvider instance =
      Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);

  bool loading = false;
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
  }

  Future<void> signInButtonOnTap() async {
    if( loading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    ApiService.instance.clearAccessTokenAndCookie();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "username": usernameController.text.trim(),
      "password": passwordController.text,
    };

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.login}', body: requestBody);
    }, onSuccess: (response) async {
      LoginModel loginModel = loginModelFromJson(response.body);
      if (loginModel.data != null) {
        await setData(
                LocalStorageKey.loginResponseKey, loginModelToJson(loginModel))
            .then((value) async {
          ApiService.instance.addAccessTokenAndCookie(
              token: loginModel.data?.authToken,
              cookie: loginModel.data?.authToken);
          final BuildContext context = AppNavigatorKey.key.currentState!.context;
          final HomeProvider homeProvider = Provider.of(context, listen: false);
          final DrawerMenuProvider drawerMenuProvider = Provider.of(context, listen: false);
          await homeProvider.initialize();
          await drawerMenuProvider.initialize();
          clearAllData();
          pushAndRemoveUntil(AppRouter.pendingLoad);
        }, onError: (error) {
          showToast(error.toString());
        });
      }
      showToast('${loginModel.message}');
      loginModel = LoginModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await clearLocalData().then((value) {
      ApiService.instance.clearAccessTokenAndCookie();
      pushAndRemoveUntil(AppRouter.signIn);
    });
  }

  Future<void> changePasswordButtonOnTap({required int? userId}) async {
    if(loading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if (!changePasswordFormKey.currentState!.validate()) {
      return;
    }
    if(passwordController.text != confirmPasswordController.text){
      showToast('Password did not matched');
      return;
    }
    loading = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "id": '$userId',
      "password": passwordController.text,
      'confirm_password': confirmPasswordController.text
    };
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.changePassword}', body: requestBody);
    }, onSuccess: (response) async {
      ChangePasswordModel changePasswordModel = changePasswordModelFromJson(response.body);
      showToast('${changePasswordModel.message}');
      clearAllData();
      usernameController.text = HomeProvider.instance.loginModel!.data!.email!;
      await logout();
      changePasswordModel = ChangePasswordModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }
}
