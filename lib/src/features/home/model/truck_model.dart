import 'dart:convert';

TruckModel truckModelFromJson(String str) => TruckModel.fromJson(json.decode(str));

class TruckModel {
  final String? message;
  final int? statusCode;
  final List<TruckDataModel>? data;

  TruckModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) => TruckModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<TruckDataModel>.from(json["data"]!.map((x) => TruckDataModel.fromJson(x))),
  );
}

class TruckDataModel {
  final int? id;
  final String? registrationNo;
  final String? whoOwns;

  TruckDataModel({
    this.id,
    this.registrationNo,
    this.whoOwns,
  });

  factory TruckDataModel.fromJson(Map<String, dynamic> json) => TruckDataModel(
    id: json["id"],
    registrationNo: json["registration_no"],
    whoOwns: json["who_owns"],
  );
}
