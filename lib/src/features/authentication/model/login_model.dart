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
  final String? lastName;
  final String? email;
  final dynamic secondaryEmail;
  final String? gender;
  final String? phone;
  final dynamic secondaryPhone;
  final Address? address;
  final dynamic postcode;
  final dynamic birthday;
  final dynamic emailVerifiedAt;
  final Meta? meta;
  final String? token;
  final Cookie? cookie;

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
    this.token,
    this.cookie,
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
    token: json["token"],
    cookie: json["cookie"] == null ? null : Cookie.fromJson(json["cookie"]),
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
    "token": token,
    "cookie": cookie?.toJson(),
  };
}

class Address {
  final String? streetName;
  final String? streetNumber;
  final String? suburb;
  final dynamic state;
  final String? postcode;
  final String? country;

  Address({
    this.streetName,
    this.streetNumber,
    this.suburb,
    this.state,
    this.postcode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    streetName: json["street_name"],
    streetNumber: json["street_number"],
    suburb: json["suburb"],
    state: json["state"],
    postcode: json["postcode"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "street_name": streetName,
    "street_number": streetNumber,
    "suburb": suburb,
    "state": state,
    "postcode": postcode,
    "country": country,
  };
}

class Cookie {
  final String? authToken;

  Cookie({
    this.authToken,
  });

  factory Cookie.fromJson(Map<String, dynamic> json) => Cookie(
    authToken: json["auth_token"],
  );

  Map<String, dynamic> toJson() => {
    "auth_token": authToken,
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
