import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/router/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../src/features/home/provider/home_provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../src/features/profile/model/country_model.dart';
import '../../../../src/features/profile/model/state_model.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_model.dart';

class ProfileProvider extends ChangeNotifier {
  static final ProfileProvider instance =
      Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);

  bool initialLoading = true;
  bool functionLoading = false;
  bool stateCountryLoading = false;
  bool unlinkLoading = false;
  LoginModel? loginResponseModel;

  LoginModel? loginModel;
  List<String> countryList = [];
  List<String> stateList = [];
  String? selectedState;
  String? selectedCountry;

  Future<void> initialize() async {
    await getUserInfo();
    initialLoading = false;
    notifyListeners();

    ///Get country state list
    stateCountryLoading = true;
    notifyListeners();
    if (stateList.isEmpty) {
      await getStateList();
    }
    if (countryList.isEmpty) {
      await getCountryList();
    }
    stateCountryLoading = false;
    notifyListeners();
  }

  void changeState(String value) {
    selectedState = value;
    notifyListeners();
  }

  void changeCountry(String value) {
    selectedCountry = value;
    notifyListeners();
  }

  Future<void> getStateList() async {
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance
          .get('${ApiEndpoint.baseUrl}${ApiEndpoint.stateList}');
    }, onSuccess: (response) async {
      StateModel stateModel = stateModelFromJson(response.body);
      stateList = stateModel.data ?? [];
      stateModel = StateModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> getCountryList() async {
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance
          .get('${ApiEndpoint.baseUrl}${ApiEndpoint.countryList}');
    }, onSuccess: (response) async {
      CountryModel countryModel = countryModelFromJson(response.body);
      countryList = countryModel.data ?? [];
      selectedCountry = countryList.isNotEmpty ? countryList.first : null;
      countryModel = CountryModel();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> getUserInfo() async {
    final userId = HomeProvider.instance.loginModel?.data?.id;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance
          .get('${ApiEndpoint.baseUrl}${ApiEndpoint.getUserInfo}?id=$userId');
    }, onSuccess: (response) async {
      loginModel = loginModelFromJson(response.body);
      selectedState = loginModel?.data?.address?.state;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> unlinkDriver() async {
    unlinkLoading = true;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
    final requestBody = {
      'id': HomeProvider.instance.loginModel?.data?.id,
      'company_id': HomeProvider.instance.loginModel?.data?.companyId ?? ''
    };

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.unlinkDriver}',
          body: requestBody);
    }, onSuccess: (response) async {
      HomeProvider.instance.loginModel?.data?.linkdCompanyName = null;
      HomeProvider.instance.loginModel?.data?.companyId = null;
      await setData(LocalStorageKey.loginResponseKey,
              loginModelToJson(HomeProvider.instance.loginModel!))
          .then((value) async {
        await HomeProvider.instance.getLocalData();
        ApiService.instance.addAccessTokenAndCookie(
            token: loginModel?.data?.authToken,
            cookie: loginModel?.data?.authToken);
      });
      var jsonData = jsonDecode(response.body);
      showToast(jsonData['message']);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    unlinkLoading = false;
    notifyListeners();
    HomeProvider.instance.notifyListeners();
  }

  Future<void> updateProfile(
      {required Map<String, dynamic> requestBody,
      required File? file,
      required String fileFieldName}) async {
    if (functionLoading == true) {
      showToast(AppString.anotherProcessRunning);
      return;
    }
    functionLoading = true;
    notifyListeners();
    await ApiService.instance.apiCall(execute: () async {
      if (file != null) {
        return await ApiService.instance.multipartRequest(
          url: '${ApiEndpoint.baseUrl}${ApiEndpoint.updateProfile}',
          requestBody: requestBody,
          file: file,
          fileFieldName: fileFieldName,
        );
      } else {
        return await ApiService.instance.post(
            '${ApiEndpoint.baseUrl}${ApiEndpoint.updateProfile}',
            body: requestBody);
      }
    }, onSuccess: (response) async {
      await getUserInfo();
      var jsonData = jsonDecode(response.body);
      showToast(jsonData['message']);
      jsonData = null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading = false;
    notifyListeners();
  }
}
