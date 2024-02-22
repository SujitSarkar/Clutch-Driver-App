import 'dart:convert';

FatigueManagementBreakModel fatigueManagementBreakModelFromJson(String str) => FatigueManagementBreakModel.fromJson(json.decode(str));

class FatigueManagementBreakModel {
  final String? message;
  final int? statusCode;
  final FatigueManagementBreakData? data;

  FatigueManagementBreakModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory FatigueManagementBreakModel.fromJson(Map<String, dynamic> json) => FatigueManagementBreakModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : FatigueManagementBreakData.fromJson(json["data"]),
  );
}

class FatigueManagementBreakData {
  final List<BreakModel>? breakes;
  final int? totaltime;

  FatigueManagementBreakData({
    this.breakes,
    this.totaltime,
  });

  factory FatigueManagementBreakData.fromJson(Map<String, dynamic> json) => FatigueManagementBreakData(
    breakes: json["breakes"] == null ? [] : List<BreakModel>.from(json["breakes"]!.map((x) => BreakModel.fromJson(x))),
    totaltime: json["totaltime"],
  );
}

class BreakModel {
  final int? totalTime;
  final String? randomCode;
  final String? breakStartTime;
  final String? breakEndTime;
  final String? breakDetails;
  final int? assetId;
  final int? id;

  BreakModel({
    this.totalTime,
    this.randomCode,
    this.breakStartTime,
    this.breakEndTime,
    this.breakDetails,
    this.assetId,
    this.id,
  });

  factory BreakModel.fromJson(Map<String, dynamic> json) => BreakModel(
    totalTime: json["total_time"],
    randomCode: json["random_code"],
    breakStartTime: json["break_start_time"],
    breakEndTime: json["break_end_time"],
    breakDetails: json["break_details"],
    assetId: json["asset_id"],
    id: json["id"],
  );
}
