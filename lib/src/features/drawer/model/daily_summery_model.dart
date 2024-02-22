import 'dart:convert';

DailySummaryModel dailySummaryModelFromJson(String str) => DailySummaryModel.fromJson(json.decode(str));

class DailySummaryModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  DailySummaryModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory DailySummaryModel.fromJson(Map<String, dynamic> json) => DailySummaryModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final int? totalLoads;
  final int? totalqty;
  final int? totalkms;

  Data({
    this.totalLoads,
    this.totalqty,
    this.totalkms,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalLoads: json["totalLoads"],
    totalqty: json["totalqty"],
    totalkms: json["totalkms"],
  );
}
