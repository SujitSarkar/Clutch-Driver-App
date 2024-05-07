import 'dart:convert';
//LoadDataModel

LoadModel loadModelFromJson(String str) => LoadModel.fromJson(json.decode(str));

String loadModelToJson(LoadModel data) => json.encode(data.toJson());

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
        data: json["data"] == null
            ? []
            : List<LoadDataModel>.from(
                json["data"]!.map((x) => LoadDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
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
  final dynamic noteForDriver;
  final dynamic noteByDriver;
  final bool? editable;
  final DateTime? loadStartDate;
  final dynamic releaseNo;
  final dynamic deliveryNo;
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
    this.noteForDriver,
    this.noteByDriver,
    this.editable,
    this.loadStartDate,
    this.releaseNo,
    this.deliveryNo,
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
        noteForDriver: json["note_for_driver"],
        noteByDriver: json["note_by_driver"],
        editable: json["editable"],
        loadStartDate: json["load_start_date"] == null
            ? null
            : DateTime.parse(json["load_start_date"]),
        releaseNo: json["release_no"],
        deliveryNo: json["delivery_no"],
        pickup: json["pickup"] == null
            ? null
            : Destination.fromJson(json["pickup"]),
        destination: json["destination"] == null
            ? null
            : Destination.fromJson(json["destination"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "asset_id": assetId,
        "required_precheck": requiredPrecheck,
        "status": status,
        "status_name": statusName,
        "company_id": companyId,
        "load_Ref": loadRef,
        "qty": qty,
        "contract_no": contractNo,
        "commodity": commodity,
        "note_for_driver": noteForDriver,
        "note_by_driver": noteByDriver,
        "editable": editable,
        "load_start_date":
            "${loadStartDate!.year.toString().padLeft(4, '0')}-${loadStartDate!.month.toString().padLeft(2, '0')}-${loadStartDate!.day.toString().padLeft(2, '0')}",
        "release_no": releaseNo,
        "delivery_no": deliveryNo,
        "pickup": pickup?.toJson(),
        "destination": destination?.toJson(),
      };
}

class Destination {
  final String? state;
  final String? suburb;
  final String? postcode;
  final String? streetAddress;
  final String? streetNumber;
  final String? unitType;
  final String? country;
  final String? customAddress;
  final String? lat;
  final String? lon;

  Destination({
    this.state,
    this.suburb,
    this.postcode,
    this.streetAddress,
    this.streetNumber,
    this.unitType,
    this.country,
    this.customAddress,
    this.lat,
    this.lon,
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
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "suburb": suburb,
        "postcode": postcode,
        "street_address": streetAddress,
        "street_number": streetNumber,
        "unit_type": unitType,
        "country": country,
        "custom_address": customAddress,
        "lat": lat,
        "lon": lon,
      };
}
