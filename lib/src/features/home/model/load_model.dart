import 'dart:convert';

LoadModel loadModelFromJson(String str) => LoadModel.fromJson(json.decode(str));

class LoadModel {
  final String? message;
  final int? statusCode;
  final List<LoadDataModel>? data;

  LoadModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoadModel.fromJson(Map<String, dynamic> json) => LoadModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<LoadDataModel>.from(json["data"]!.map((x) => LoadDataModel.fromJson(x))),
  );
}

class LoadDataModel {
  final int? id;
  final int? assetId;
  final bool? requiredPrecheck;
  final int? status;
  final String? statusName;
  final int? companyId;
  final String? loadRef;
  final String? qty;
  final String? contractNo;
  final String? commodity;
  final Destination? pickup;
  final Destination? destination;

  LoadDataModel({
    this.id,
    this.assetId,
    this.requiredPrecheck,
    this.status,
    this.statusName,
    this.companyId,
    this.loadRef,
    this.qty,
    this.contractNo,
    this.commodity,
    this.pickup,
    this.destination,
  });

  factory LoadDataModel.fromJson(Map<String, dynamic> json) => LoadDataModel(
    id: json["id"],
    assetId: json["asset_id"],
    requiredPrecheck: json["required_precheck"],
    status: json["status"],
    statusName: json["status_name"],
    companyId: json["company_id"],
    loadRef: json["load_Ref"],
    qty: json["qty"],
    contractNo: json["contract_no"],
    commodity: json["commodity"],
    pickup: json["pickup"] == null ? null : Destination.fromJson(json["pickup"]),
    destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
  );
}

class Destination {
  final String? state;
  final dynamic suburb;
  final dynamic postcode;
  final dynamic streetAddress;
  final dynamic streetNumber;
  final dynamic unitType;
  final String? country;
  final String? customAddress;

  Destination({
    this.state,
    this.suburb,
    this.postcode,
    this.streetAddress,
    this.streetNumber,
    this.unitType,
    this.country,
    this.customAddress,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    state: json["state"],
    suburb: json["suburb"],
    postcode: json["postcode"],
    streetAddress: json["street_address"],
    streetNumber: json["street_number"],
    unitType: json["unit_type"],
    country: json["country"],
    customAddress: json["custom_address"],
  );
}
