import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
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
import '../model/login_response_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  static final AuthenticationProvider instance =
  Provider.of(AppNavigatorKey.key.currentState!.context,listen: false);

  bool loading = false;
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    passwordController.clear();
    confirmPasswordController.clear();
    emailController.clear();
    phoneController.clear();
  }

  Future<void> signInButtonOnTap() async {
    ApiService.instance.clearAccessToken();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.login}',fromJson: LoginResponseModel.fromJson,
          body: requestBody);
    }, onSuccess: (response) async {
      final LoginResponseModel loginResponseModel = response;
      if (loginResponseModel.userInfo!=null) {
        await setData(LocalStorageKey.loginResponseKey,
            loginResponseModelToJson(loginResponseModel))
            .then((value) async {
          ApiService.instance.addAccessToken(loginResponseModel.token);
          clearAllData();
          final BuildContext context = AppNavigatorKey.key.currentState!.context;
          final HomeProvider homeProvider = Provider.of(context,listen: false);
          final DrawerMenuProvider drawerMenuProvider = Provider.of(context,listen: false);
          await homeProvider.initialize();
          await drawerMenuProvider.initialize();
          pushAndRemoveUntil(AppRouter.pendingLoad);
        }, onError: (error) {
          showToast(error.toString());
        });
      }
      showToast('${loginResponseModel.message}');
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }

  Future<void>logout()async{
    await clearLocalData().then((value) {
      ApiService.instance.clearAccessToken();
      pushAndRemoveUntil(AppRouter.signIn);
    });
  }

  Future<void> changePasswordButtonOnTap({required int? userId}) async {
    if (!changePasswordFormKey.currentState!.validate()) {
      return;
    }
    Map<String, dynamic> requestBody = {
      "id": '$userId',
      "password": passwordController.text,
      'confirm_password': confirmPasswordController.text
    };
    loading = true;
    notifyListeners();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.changePassword}',fromJson: ChangePasswordModel.fromJson,
          body: requestBody);
    }, onSuccess: (response) async {
      final ChangePasswordModel changePasswordModel = response;
      showToast('${changePasswordModel.message}');
      clearAllData();
      await logout();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }
}
