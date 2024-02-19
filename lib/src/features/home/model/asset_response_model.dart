// To parse this JSON data, do
//
//     final assetResponseModel = assetResponseModelFromJson(jsonString);

import 'dart:convert';

AssetResponseModel assetResponseModelFromJson(String str) => AssetResponseModel.fromJson(json.decode(str));

String assetResponseModelToJson(AssetResponseModel data) => json.encode(data.toJson());

class AssetResponseModel {
  final String? message;
  final int? statusCode;
  final List<AssetListData>? data;

  AssetResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) => AssetResponseModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<AssetListData>.from(json["data"]!.map((x) => AssetListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AssetListData {
  final int? id;
  final String? registrationNo;
  final int? globalAssetId;
  final String? fleetCode;
  final dynamic description;
  final dynamic generalLocation;
  final String? whoOwns;
  final String? generalLoadCapacity;
  final dynamic vehicleType;
  final dynamic linkedEquipment;
  final int? companyId;
  final int? organizationId;
  final int? driverId;
  final dynamic xeroInfo;
  final String? trackingCategory;
  final String? trackingOptions;
  final String? tcId;
  final String? toId;
  final String? shareable;
  final int? isActive;
  final int? actionPerformedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssetListData({
    this.id,
    this.registrationNo,
    this.globalAssetId,
    this.fleetCode,
    this.description,
    this.generalLocation,
    this.whoOwns,
    this.generalLoadCapacity,
    this.vehicleType,
    this.linkedEquipment,
    this.companyId,
    this.organizationId,
    this.driverId,
    this.xeroInfo,
    this.trackingCategory,
    this.trackingOptions,
    this.tcId,
    this.toId,
    this.shareable,
    this.isActive,
    this.actionPerformedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetListData.fromJson(Map<String, dynamic> json) => AssetListData(
    id: json["id"],
    registrationNo: json["registration_no"],
    globalAssetId: json["global_asset_id"],
    fleetCode: json["fleet_code"],
    description: json["description"],
    generalLocation: json["general_location"],
    whoOwns: json["who_owns"],
    generalLoadCapacity: json["general_load_capacity"],
    vehicleType: json["vehicle_type"],
    linkedEquipment: json["linked_equipment"],
    companyId: json["company_id"],
    organizationId: json["organization_id"],
    driverId: json["driver_id"],
    xeroInfo: json["xero_info"],
    trackingCategory: json["tracking_category"],
    trackingOptions: json["tracking_options"],
    tcId: json["tc_id"],
    toId: json["to_id"],
    shareable: json["shareable"],
    isActive: json["is_active"],
    actionPerformedBy: json["action_performed_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "registration_no": registrationNo,
    "global_asset_id": globalAssetId,
    "fleet_code": fleetCode,
    "description": description,
    "general_location": generalLocation,
    "who_owns": whoOwns,
    "general_load_capacity": generalLoadCapacity,
    "vehicle_type": vehicleType,
    "linked_equipment": linkedEquipment,
    "company_id": companyId,
    "organization_id": organizationId,
    "driver_id": driverId,
    "xero_info": xeroInfo,
    "tracking_category": trackingCategory,
    "tracking_options": trackingOptions,
    "tc_id": tcId,
    "to_id": toId,
    "shareable": shareable,
    "is_active": isActive,
    "action_performed_by": actionPerformedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
