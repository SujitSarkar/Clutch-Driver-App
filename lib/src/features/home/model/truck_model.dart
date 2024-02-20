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

  TruckDataModel({
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

  factory TruckDataModel.fromJson(Map<String, dynamic> json) => TruckDataModel(
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
}
