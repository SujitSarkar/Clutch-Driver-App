import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'dart:convert';
import '../../shared/api/parser.dart';
import '../../core/utils/app_navigator_key.dart';
import '../../src/features/authentication/provider/authentication_provider.dart';
import 'api_exception.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  factory ApiService() {
    return instance;
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  void addAccessTokenAndCookie(
      {required String? token, required String? cookie}) {
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
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      var response = await execute();
      return onSuccess(response);
    } on SocketException {
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
    final http.Response response =
        await http.get(Uri.parse(url), headers: headers);
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

  ///Multipart api request
  Future<dynamic> multipartRequest(
      {required String url,
      required Map<String, dynamic> requestBody,
      required File file,
      required String fileFieldName}) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    MediaType contentType;

    // Add fields
    requestBody.forEach((key, value) => request.fields[key] = value.toString());

    //Get file MediaType
    try {
      contentType = getMediaTypeFromFile(file);
    } on UnsupportedError {
      throw ApiException(message: 'Unsupported file');
    } catch (error) {
      throw ApiException(message: '$error');
    }

    // Add file
    var stream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      fileFieldName,
      stream,
      length,
      filename: file.path.split('/').last,
      contentType: contentType,
    );
    request.files.add(multipartFile);
    // Add headers
    request.headers.addAll(headers);

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    return _processResponse(http.Response(responseString, response.statusCode));
  }

  ///check if the response is valid (everything went fine) / else throw error
  dynamic _processResponse(var response) async {
    debugPrint('\nurl:- ${response.request?.url}');
    debugPrint('statusCode:- ${response.statusCode}');
    debugPrint('AccessToken:- ${headers['Authorization']}');
    debugPrint('Cookie:- ${headers['Cookie']}');
    debugPrint('response:- ${response.body}\n\n');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var jsonData = jsonDecode(response.body);
      await tokenExpiredAction(jsonData['message'].runtimeType == List
          ? jsonData['message'].first
          : jsonData['message']);
      return response;
    } else if (response.statusCode == 500) {
      throw ApiException(message: 'Internal server error');
    } else {
      try {
        var jsonData = jsonDecode(response.body);
        await tokenExpiredAction(jsonData['message'].runtimeType == List
            ? jsonData['message'].first
            : jsonData['message']);
        throw ApiException(
            message: jsonData['message'].runtimeType == List
                ? jsonData['message'].first
                : jsonData['message']);
      } catch (e) {
        await tokenExpiredAction(e.toString());
        throw ApiException(message: 'Invalid data format');
      }
    }
  }

  Future<void> tokenExpiredAction(String message) async {
    if (message.toLowerCase() == 'Token expired please login'.toLowerCase()) {
      final AuthenticationProvider authenticationProvider =
          Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);
      await authenticationProvider.logout();
    }
  }
}
