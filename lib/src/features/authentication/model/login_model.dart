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
    data: json["data"] == null? null : Data.fromJson(json["data"]),
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
  final String? authToken;
  final Organizations? organizations;
  final List<Company>? companies;

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
    this.authToken,
    this.organizations,
    this.companies,
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
    authToken: json["auth_token"],
    organizations: json["organizations"] == null ? null : Organizations.fromJson(json["organizations"]),
    companies: json["companies"] == null ? [] : List<Company>.from(json["companies"]!.map((x) => Company.fromJson(x))),
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
    "auth_token": authToken,
    "organizations": organizations?.toJson(),
    "companies": companies == null ? [] : List<dynamic>.from(companies!.map((x) => x.toJson())),
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

class Company {
  final int? roleId;
  final int? userId;
  final String? roleName;
  final String? roleCode;
  final dynamic designationName;
  final dynamic designationCode;
  final int? id;
  final String? orgName;
  final String? orgKey;
  final String? orgAbn;
  final String? orgEmail;
  final String? orgPhone;
  final int? isActive;
  final int? orgOwnerId;
  final int? actionPerformedBy;
  final String? companyName;
  final String? companyKey;
  final String? companyAbn;
  final String? companyEmail;
  final String? companyPhone;
  final String? companyAddress;
  final int? organizationId;
  final dynamic xeroAuthToken;
  final String? companyManagement;
  final int? companyId;

  Company({
    this.roleId,
    this.userId,
    this.roleName,
    this.roleCode,
    this.designationName,
    this.designationCode,
    this.id,
    this.orgName,
    this.orgKey,
    this.orgAbn,
    this.orgEmail,
    this.orgPhone,
    this.isActive,
    this.orgOwnerId,
    this.actionPerformedBy,
    this.companyName,
    this.companyKey,
    this.companyAbn,
    this.companyEmail,
    this.companyPhone,
    this.companyAddress,
    this.organizationId,
    this.xeroAuthToken,
    this.companyManagement,
    this.companyId,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    roleId: json["role_id"],
    userId: json["user_id"],
    roleName: json["role_name"],
    roleCode: json["role_code"],
    designationName: json["designation_name"],
    designationCode: json["designation_code"],
    id: json["id"],
    orgName: json["org_name"],
    orgKey: json["org_key"],
    orgAbn: json["org_abn"],
    orgEmail: json["org_email"],
    orgPhone: json["org_phone"],
    isActive: json["is_active"],
    orgOwnerId: json["org_owner_id"],
    actionPerformedBy: json["action_performed_by"],
    companyName: json["company_name"],
    companyKey: json["company_key"],
    companyAbn: json["company_abn"],
    companyEmail: json["company_email"],
    companyPhone: json["company_phone"],
    companyAddress: json["company_address"],
    organizationId: json["organization_id"],
    xeroAuthToken: json["xero_auth_token"],
    companyManagement: json["company_management"],
    companyId: json["company_id"],
  );

  Map<String, dynamic> toJson() => {
    "role_id": roleId,
    "user_id": userId,
    "role_name": roleName,
    "role_code": roleCode,
    "designation_name": designationName,
    "designation_code": designationCode,
    "id": id,
    "org_name": orgName,
    "org_key": orgKey,
    "org_abn": orgAbn,
    "org_email": orgEmail,
    "org_phone": orgPhone,
    "is_active": isActive,
    "org_owner_id": orgOwnerId,
    "action_performed_by": actionPerformedBy,
    "company_name": companyName,
    "company_key": companyKey,
    "company_abn": companyAbn,
    "company_email": companyEmail,
    "company_phone": companyPhone,
    "company_address": companyAddress,
    "organization_id": organizationId,
    "xero_auth_token": xeroAuthToken,
    "company_management": companyManagement,
    "company_id": companyId,
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

class Organizations {
  final int? id;
  final String? orgName;
  final String? orgKey;
  final String? orgAbn;
  final String? orgEmail;
  final String? orgPhone;
  final int? isActive;
  final int? orgOwnerId;
  final int? actionPerformedBy;

  Organizations({
    this.id,
    this.orgName,
    this.orgKey,
    this.orgAbn,
    this.orgEmail,
    this.orgPhone,
    this.isActive,
    this.orgOwnerId,
    this.actionPerformedBy,
  });

  factory Organizations.fromJson(Map<String, dynamic> json) => Organizations(
    id: json["id"],
    orgName: json["org_name"],
    orgKey: json["org_key"],
    orgAbn: json["org_abn"],
    orgEmail: json["org_email"],
    orgPhone: json["org_phone"],
    isActive: json["is_active"],
    orgOwnerId: json["org_owner_id"],
    actionPerformedBy: json["action_performed_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "org_name": orgName,
    "org_key": orgKey,
    "org_abn": orgAbn,
    "org_email": orgEmail,
    "org_phone": orgPhone,
    "is_active": isActive,
    "org_owner_id": orgOwnerId,
    "action_performed_by": actionPerformedBy,
  };
}
