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
    'Accept': '*/*'};

  void addAccessTokenAndCookie({required String? token,required String? cookie}) {
    headers.addEntries({'Authorization': '$token'}.entries);
    headers.addEntries({'Cookie': 'auth_token=$cookie'}.entries);
  }

  void clearAccessTokenAndCookie() {
    headers.remove('Authorization');
    headers.remove('Cookie');
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
  Future<dynamic> get(String url) async {
    final http.Response response = await http.get(Uri.parse(url), headers: headers);
    return _processResponse(response);
  }

  ///post api request
  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    final http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response);
  }

  ///patch api request
  Future<dynamic> patch(String url, {Map<String, dynamic>? body}) async {
    final http.Response response = await http.patch(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response);
  }

  ///delete api request
  Future<dynamic> delete(String url) async {
    final http.Response response =
        await http.delete(Uri.parse(url), headers: headers);
    return _processResponse(response);
  }

  ///check if the response is valid (everything went fine) / else throw error
  dynamic _processResponse(var response) {
    debugPrint('url:- ${response.request?.url}');
    debugPrint('statusCode:- ${response.statusCode}');
    debugPrint('AccessToken:- ${headers['Authorization']}');
    debugPrint('Cookie:- ${headers['Cookie']}');
    debugPrint('response:- ${response.body}\n');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      var jsonData = jsonDecode(response.body);
      throw ApiException(message: jsonData['message']);
    }
  }
}
