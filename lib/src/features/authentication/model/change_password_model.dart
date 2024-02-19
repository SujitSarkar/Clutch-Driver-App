import 'dart:convert';
ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

class ChangePasswordModel {
  final String? message;
  final int? statusCode;
  final List<dynamic>? data;

  ChangePasswordModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
  );
}
