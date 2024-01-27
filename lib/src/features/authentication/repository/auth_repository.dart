import 'package:flutter/Material.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';
import '../model/reset_password_model.dart';

class AuthRepository {
  Future<LoginResponseModel?> signIn(
      {required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signIn}', LoginResponseModel.fromJson,
          body: requestBody);
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = response as LoginResponseModel;
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<ResetPasswordResponseModel?> resetPassword(
      {required Map<String, dynamic> requestBody}) async {
    ResetPasswordResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.forgetPassword}', ResetPasswordResponseModel.fromJson,
          body: requestBody);
    }, onSuccess: (response) async {
      result = response as ResetPasswordResponseModel;
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }
}
