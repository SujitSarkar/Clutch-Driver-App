import 'dart:convert';

PreStartDataModel preStartDataModelFromJson(String str) =>
    PreStartDataModel.fromJson(json.decode(str));

class PreStartDataModel {
  final String? message;
  final int? statusCode;
  final PreStartData? data;

  PreStartDataModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory PreStartDataModel.fromJson(Map<String, dynamic> json) =>
      PreStartDataModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : PreStartData.fromJson(json["data"]),
      );
}

class PreStartData {
  final String? randomCode;
  final String? logsDate;
  final String? companyId;
  final String? organizationId;
  final String? assetId;
  final String? driverId;
  final String? logStartTime;
  final String? startOdoReading;
  final String? preStartNotes;
  final List<CheckBoxDataModel>? preStartChecks;
  final String? logEndTime;
  final String? endOdoReading;
  final String? logNotes;
  final List<CheckBoxDataModel>? additionalFees;
  final String? fatigueNotes;
  final List<CheckBoxDataModel>? fatigueChecks;

  PreStartData({
    this.randomCode,
    this.logsDate,
    this.companyId,
    this.organizationId,
    this.assetId,
    this.driverId,
    this.logStartTime,
    this.startOdoReading,
    this.preStartNotes,
    this.preStartChecks,
    this.logEndTime,
    this.endOdoReading,
    this.logNotes,
    this.additionalFees,
    this.fatigueNotes,
    this.fatigueChecks,
  });

  factory PreStartData.fromJson(Map<String, dynamic> json) => PreStartData(
        randomCode: json["random_code"],
        logsDate: json["logs_date"] != null
            ? '${json["logs_date"]}'
            : json["logs_date"],
        companyId: json["company_id"] != null
            ? '${json["company_id"]}'
            : json["company_id"],
        organizationId: json["organization_id"] != null
            ? '${json["organization_id"]}'
            : json["organization_id"],
        assetId:
            json["asset_id"] != null ? '${json["asset_id"]}' : json["asset_id"],
        driverId: json["driver_id"] != null
            ? '${json["driver_id"]}'
            : json["driver_id"],
        logStartTime: json["log_start_time"] != null
            ? '${json["log_start_time"]}'
            : json["log_start_time"],
        startOdoReading: json["start_odo_reading"] != null
            ? '${json["start_odo_reading"]}'
            : json["start_odo_reading"],
        preStartNotes: json["pre_start_notes"] != null
            ? '${json["pre_start_notes"]}'
            : json["pre_start_notes"],
        preStartChecks: json["pre_start_checks"] == null
            ? []
            : List<CheckBoxDataModel>.from(json["pre_start_checks"]!
                .map((x) => CheckBoxDataModel.fromJson(x))),
        logEndTime: json["log_end_time"] != null
            ? '${json["log_end_time"]}'
            : json["log_end_time"],
        endOdoReading: json["end_odo_reading"] != null
            ? '${json["end_odo_reading"]}'
            : json["end_odo_reading"],
        logNotes: json["log_notes"] != null
            ? '${json["log_notes"]}'
            : json["log_notes"],
        additionalFees: json["additional_fees"] == null
            ? []
            : List<CheckBoxDataModel>.from(json["additional_fees"]!
                .map((x) => CheckBoxDataModel.fromJson(x))),
        fatigueNotes: json["fatigue_notes"] != null
            ? '${json["fatigue_notes"]}'
            : json["fatigue_notes"],
        fatigueChecks: json["fatigue_checks"] == null
            ? []
            : List<CheckBoxDataModel>.from(json["fatigue_checks"]!
                .map((x) => CheckBoxDataModel.fromJson(x))),
      );
}

class CheckBoxDataModel {
  final int? id;
  final String? name;
  final bool? value;

  CheckBoxDataModel({
    this.id,
    this.name,
    this.value,
  });

  factory CheckBoxDataModel.fromJson(Map<String, dynamic> json) =>
      CheckBoxDataModel(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );
}
