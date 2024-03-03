// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  LoginModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final String? username;
  final String? firstName;
  final dynamic lastName;
  final dynamic email;
  final dynamic secondaryEmail;
  final String? gender;
  final String? phone;
  final dynamic secondaryPhone;
  final Address? address;
  final dynamic postcode;
  final dynamic birthday;
  final dynamic emailVerifiedAt;
  final Meta? meta;
  final String? url;
  final String? authToken;
  late int? companyId;
  late String? linkdCompanyName;

  Data({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.secondaryEmail,
    this.gender,
    this.phone,
    this.secondaryPhone,
    this.address,
    this.postcode,
    this.birthday,
    this.emailVerifiedAt,
    this.meta,
    this.url,
    this.authToken,
    this.companyId,
    this.linkdCompanyName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    secondaryEmail: json["secondary_email"],
    gender: json["gender"],
    phone: json["phone"],
    secondaryPhone: json["secondary_phone"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    postcode: json["postcode"],
    birthday: json["birthday"],
    emailVerifiedAt: json["email_verified_at"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    url: json["url"],
    authToken: json["auth_token"],
    companyId: json["company_id"],
    linkdCompanyName: json["linkd_company_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "secondary_email": secondaryEmail,
    "gender": gender,
    "phone": phone,
    "secondary_phone": secondaryPhone,
    "address": address?.toJson(),
    "postcode": postcode,
    "birthday": birthday,
    "email_verified_at": emailVerifiedAt,
    "meta": meta?.toJson(),
    "url": url,
    "auth_token": authToken,
    "company_id": companyId,
    "linkd_company_name": linkdCompanyName,
  };
}

class Address {
  final String? state;
  final String? suburb;
  final String? postcode;
  final String? streetAddress;
  final String? streetNumber;
  final String? unitType;
  final String? country;
  final String? customAddress;

  Address({
    this.state,
    this.suburb,
    this.postcode,
    this.streetAddress,
    this.streetNumber,
    this.unitType,
    this.country,
    this.customAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    state: json["state"],
    suburb: json["suburb"],
    postcode: json["postcode"],
    streetAddress: json["street_address"],
    streetNumber: json["street_number"],
    unitType: json["unit_type"],
    country: json["country"],
    customAddress: json["custom_address"],
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
  };
}

class Meta {
  final String? licenseNumber;
  final String? profileImage;

  Meta({
    this.licenseNumber,
    this.profileImage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    licenseNumber: json["license_number"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "license_number": licenseNumber,
    "profile_image": profileImage,
  };
}
