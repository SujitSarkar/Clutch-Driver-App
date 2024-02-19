import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'api_exception.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  factory ApiService() {
    return instance;
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': '*/*',
    'Cookie': 'auth_token=347%7CjmYNu0wbM99zWQObuvOTgs5tegddq1CGcvXSnni3558dc798; laravel_session=E4QlFwGjaV2pWCz2NeO3NOpSOD0XKMxPtSFnw2PH'
  };

  void addAccessToken(String? token) {
    headers.addEntries({'Authorization': '$token'}.entries);
  }

  void clearAccessToken() {
    headers.remove('Authorization');
  }

  Future<void> apiCall(
      {required Function execute,
      required Function(dynamic) onSuccess,
      Function(dynamic)? onError}) async {
    try {
      // hide keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var response = await execute();
      return onSuccess(response);
    } on SocketException{
      if (onError == null) return;
      onError(ApiException(message: 'No internet connection'));
      return;
    } catch (error) {
      if (onError == null) return;
      onError(error);
      return;
    }
  }

  ///get api request
  Future<T> get<T>(String url, {required T Function(Map<String, dynamic> json) fromJson}) async {
    final http.Response response = await http.get(Uri.parse(url), headers: headers);
    return _processResponse(response, fromJson);
  }

  ///post api request
  Future<T> post<T>(String url, {required T Function(Map<String, dynamic> json) fromJson, Map<String, dynamic>? body}) async {
    final http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response, fromJson);
  }

  ///patch api request
  Future<T> patch<T>(String url, {required T Function(Map<String, dynamic> json) fromJson, Map<String, dynamic>? body}) async {
    final http.Response response = await http.patch(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response, fromJson);
  }

  ///delete api request
  Future<T> delete<T>(String url,{required T Function(Map<String, dynamic> json) fromJson}) async {
    final http.Response response =
        await http.delete(Uri.parse(url), headers: headers);
    return _processResponse(response, fromJson);
  }

  ///check if the response is valid (everything went fine) / else throw error
  T _processResponse<T>(var response, T Function(Map<String, dynamic> json) fromJson) {
    debugPrint('url:- ${response.request?.url}');
    debugPrint('AccessToken:- ${headers['Authorization']}');
    debugPrint('statusCode:- ${response.statusCode}');
    debugPrint('response:- ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try{
        final dynamic jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return fromJson(jsonData);
        } else {
          throw ApiException(message: 'Data parsing error');
        }
      }on FormatException{
        throw ApiException(message: 'Data formation error');
      } catch(error){
        throw ApiException(message: '$error');
      }
    } else {
      var jsonData = jsonDecode(response.body);
      throw ApiException(message: jsonData['message']);
    }
  }
}
