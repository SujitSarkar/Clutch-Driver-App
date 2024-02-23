import 'dart:convert';

CountryModel countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

class CountryModel {
  final String? message;
  final int? statusCode;
  final List<String>? data;

  CountryModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );
}
