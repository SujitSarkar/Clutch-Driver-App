import 'dart:convert';

LoadWeightModel loadWeightModelFromJson(String str) => LoadWeightModel.fromJson(json.decode(str));

class LoadWeightModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  LoadWeightModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoadWeightModel.fromJson(Map<String, dynamic> json) => LoadWeightModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final Pickup? pickup;
  final Delivery? deli;
  final Note? note;

  Data({
    this.pickup,
    this.deli,
    this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pickup: json["pickup"] == null ? null : Pickup.fromJson(json["pickup"]),
    deli: json["deli"] == null ? null : Delivery.fromJson(json["deli"]),
    note: json["note"] == null ? null : Note.fromJson(json["note"]),
  );
}

class Delivery {
  final String? loadId;
  final dynamic deliveryTime;
  final dynamic deliveryDate;
  final dynamic deliveryTareWeight;
  final dynamic deliveryGrossWeight;
  final dynamic deliveryNetWeight;
  final List<String>? pickupAttachments;
  final String? url;

  Delivery({
    this.loadId,
    this.deliveryTime,
    this.deliveryDate,
    this.deliveryTareWeight,
    this.deliveryGrossWeight,
    this.deliveryNetWeight,
    this.pickupAttachments,
    this.url,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    loadId: json["load_id"],
    deliveryTime: json["delivery_time"],
    deliveryDate: json["delivery_date"],
    deliveryTareWeight: json["delivery_tare_weight"],
    deliveryGrossWeight: json["delivery_gross_weight"],
    deliveryNetWeight: json["delivery_net_weight"],
    pickupAttachments: json["pickup_attachments"] == null ? [] : List<String>.from(json["pickup_attachments"]!.map((x) => x)),
    url: json["url"],
  );
}

class Note {
  final String? noteByDriver;

  Note({
    this.noteByDriver
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    noteByDriver: json["note_by_driver"],
  );
}

class Pickup {
  final int? loadId;
  final String? pickupTime;
  final DateTime? pickupDate;
  final String? pickupTareWeight;
  final String? pickupGrossRate;
  final String? pickupNetWeight;
  final List<String>? pickupAttachments;
  final String? url;

  Pickup({
    this.loadId,
    this.pickupTime,
    this.pickupDate,
    this.pickupTareWeight,
    this.pickupGrossRate,
    this.pickupNetWeight,
    this.pickupAttachments,
    this.url,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    loadId: json["load_id"],
    pickupTime: json["pickup_time"],
    pickupDate: json["pickup_date"] == null ? null : DateTime.parse(json["pickup_date"]),
    pickupTareWeight: json["pickup_tare_weight"],
    pickupGrossRate: json["pickup_gross_rate"],
    pickupNetWeight: json["pickup_net_weight"],
    pickupAttachments: json["pickup_attachments"] == null ? [] : List<String>.from(json["pickup_attachments"]!.map((x) => x)),
    url: json["url"],
  );
}
