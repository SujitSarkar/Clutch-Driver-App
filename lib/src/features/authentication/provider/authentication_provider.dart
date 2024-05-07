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
import '../model/success_message_model.dart';
import '../model/country_code_model.dart';
import '../model/login_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  static final AuthenticationProvider instance =
      Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);

  bool loading = false;
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey();
  final GlobalKey<FormState> phoneFormKey = GlobalKey();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  List<CountryCode> countryCodeList = [];
  CountryCode? selectedCountryCode;

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
    phoneController.clear();
    otpController.clear();
  }

  Future<void> initialize() async {
    await getCountryCodeList();
  }

  void changeCountryCode(CountryCode value) {
    selectedCountryCode = value;
    notifyListeners();
  }

  Future<void> getCountryCodeList() async {
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance
          .get('${ApiEndpoint.baseUrl}${ApiEndpoint.countryCodeList}');
    }, onSuccess: (response) async {
      CountryCodeModel countryCodeModel =
          countryCodeModelFromJson(response.body);
      countryCodeList = countryCodeModel.data ?? [];
      selectedCountryCode =
          countryCodeList.isNotEmpty ? countryCodeList.first : null;
      countryCodeModel = CountryCodeModel();
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> signInButtonOnTap() async {
    if (loading == true) {
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
          '${ApiEndpoint.baseUrl}${ApiEndpoint.login}',
          body: requestBody);
    }, onSuccess: (response) async {
      LoginModel loginModel = loginModelFromJson(response.body);
      if (loginModel.data != null) {
        await setData(
                LocalStorageKey.loginResponseKey, loginModelToJson(loginModel))
            .then((value) async {
          ApiService.instance.addAccessTokenAndCookie(
              token: loginModel.data?.authToken,
              cookie: loginModel.data?.authToken);
          final BuildContext context =
              AppNavigatorKey.key.currentState!.context;
          final HomeProvider homeProvider = Provider.of(context, listen: false);
          final DrawerMenuProvider drawerMenuProvider =
              Provider.of(context, listen: false);
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

  Future<void> getOtpButtonOnTap() async {
    if (loading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if (selectedCountryCode == null) {
      showToast("Country code required");
      return;
    }
    if (!phoneFormKey.currentState!.validate()) {
      return;
    }
    loading = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "phone": phoneController.text.trim(),
      "phone_code": selectedCountryCode?.countryCode,
    };
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.sendOtp}',
          body: requestBody);
    }, onSuccess: (response) async {
      SuccessMessageModel successMessageModel =
          successMessageModelFromJson(response.body);
      showToast(successMessageModel.message ?? "Something went wrong");
      successMessageModel = SuccessMessageModel();
      pushTo(AppRouter.resetPassword);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }

  Future<void> changePasswordButtonOnTap() async {
    if (loading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showToast('Password did not matched');
      return;
    }
    loading = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "phone": phoneController.text.trim(),
      "phone_code": selectedCountryCode?.countryCode,
      'otp_code': otpController.text.trim(),
      'password': passwordController.text,
      'password_confirmation': confirmPasswordController.text,
    };
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.resetPassword}',
          body: requestBody);
    }, onSuccess: (response) async {
      SuccessMessageModel successMessageModel =
          successMessageModelFromJson(response.body);
      showToast(successMessageModel.message ?? "Something went wrong");
      successMessageModel = SuccessMessageModel();
      clearLocalData();
      popUntilOf(AppRouter.signIn);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    loading = false;
    notifyListeners();
  }
}
