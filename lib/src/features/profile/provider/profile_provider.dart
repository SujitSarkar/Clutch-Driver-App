import 'dart:convert';
import 'dart:io';
import 'package:flutter/Material.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../src/features/profile/model/country_model.dart';
import '../../../../src/features/profile/model/state_model.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool initialLoading = false;
  bool functionLoading = false;
  LoginModel? loginResponseModel;

  List<String> countryList = [];
  List<String> stateList = [];
  String? selectedState;
  String? selectedCountry;

  Future<void> initialize() async {
    initialLoading = true;
    notifyListeners();
    if (stateList.isEmpty) {
      await getStateList();
    }
    if (countryList.isEmpty) {
      await getCountryList();
    }
    initialLoading = false;
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
      final StateModel stateModel = stateModelFromJson(response.body);
      stateList = stateModel.data ?? [];
      selectedState = stateList.isNotEmpty ? stateList.first : null;
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
      final CountryModel countryModel = countryModelFromJson(response.body);
      countryList = countryModel.data ?? [];
      selectedCountry = countryList.isNotEmpty ? countryList.first : null;
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
  }

  Future<void> updateProfile(
      {required Map<String, dynamic> requestBody,
      required File? file,
      required String fileFieldName}) async {
    if(functionLoading == true){
      showToast(AppString.anotherProcessRunning);
      return;
    }
    functionLoading=true;
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
      var jsonData = jsonDecode(response.body);
      showToast(jsonData['message']);
    }, onError: (error) {
      debugPrint('Error: ${error.message}');
      showToast('Error: ${error.message}');
    });
    functionLoading=false;
    notifyListeners();
  }
}
