import 'dart:convert';

StateModel stateModelFromJson(String str) =>
    StateModel.fromJson(json.decode(str));

class StateModel {
  final String? message;
  final int? statusCode;
  final List<String>? data;

  StateModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );
}
