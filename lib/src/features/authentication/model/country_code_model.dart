import 'dart:convert';

CountryCodeModel countryCodeModelFromJson(String str) =>
    CountryCodeModel.fromJson(json.decode(str));

class CountryCodeModel {
  final String? message;
  final int? statusCode;
  final List<CountryCode>? data;

  CountryCodeModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) =>
      CountryCodeModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<CountryCode>.from(
                json["data"]!.map((x) => CountryCode.fromJson(x))),
      );
}

class CountryCode {
  final String? countryName;
  final String? countryCode;

  CountryCode({
    this.countryName,
    this.countryCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        countryName: json["country_name"],
        countryCode: json["country_code"],
      );
}
