import 'dart:convert';

SuccessMessageModel successMessageModelFromJson(String str) =>
    SuccessMessageModel.fromJson(json.decode(str));

class SuccessMessageModel {
  final String? message;
  final int? statusCode;
  final List<dynamic>? data;

  SuccessMessageModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory SuccessMessageModel.fromJson(Map<String, dynamic> json) =>
      SuccessMessageModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<dynamic>.from(json["data"]!.map((x) => x)),
      );
}
