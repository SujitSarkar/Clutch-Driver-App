// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final bool? status;
  final String? message;
  final UserInfo? userInfo;
  final String? token;

  LoginResponseModel({
    this.status,
    this.message,
    this.userInfo,
    this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    message: json["message"],
    userInfo: json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user_info": userInfo?.toJson(),
    "token": token,
  };
}

class UserInfo {
  final String? token;
  final User? user;

  UserInfo({
    this.token,
    this.user,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    token: '${json["token"]}',
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  final Info? info;
  final Roles? roles;
  final Organizations? organizations;
  final List<Company>? companies;
  final List<dynamic>? routeLists;
  final String? homepage;
  final List<dynamic>? routePermissions;

  User({
    this.info,
    this.roles,
    this.organizations,
    this.companies,
    this.routeLists,
    this.homepage,
    this.routePermissions,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
    roles: json["roles"] == null ? null : Roles.fromJson(json["roles"]),
    organizations: json["organizations"] == null ? null : Organizations.fromJson(json["organizations"]),
    companies: json["companies"] == null ? [] : List<Company>.from(json["companies"]!.map((x) => Company.fromJson(x))),
    routeLists: json["route_lists"] == null ? [] : List<dynamic>.from(json["route_lists"]!.map((x) => x)),
    homepage: json["homepage"],
    routePermissions: json["route_permissions"] == null ? [] : List<dynamic>.from(json["route_permissions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "info": info?.toJson(),
    "roles": roles?.toJson(),
    "organizations": organizations?.toJson(),
    "companies": companies == null ? [] : List<dynamic>.from(companies!.map((x) => x.toJson())),
    "route_lists": routeLists == null ? [] : List<dynamic>.from(routeLists!.map((x) => x)),
    "homepage": homepage,
    "route_permissions": routePermissions == null ? [] : List<dynamic>.from(routePermissions!.map((x) => x)),
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
  final String? orgAddress;
  final int? isActive;
  final int? orgOwnerId;
  final int? actionPerformedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
  final String? xeroTenantAccessToken;
  final String? xeroTenantId;
  final String? xeroTenantName;
  final String? xeroTenantType;
  final List<dynamic>? routePermissions;

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
    this.orgAddress,
    this.isActive,
    this.orgOwnerId,
    this.actionPerformedBy,
    this.createdAt,
    this.updatedAt,
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
    this.xeroTenantAccessToken,
    this.xeroTenantId,
    this.xeroTenantName,
    this.xeroTenantType,
    this.routePermissions,
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
    orgAddress: json["org_address"],
    isActive: json["is_active"],
    orgOwnerId: json["org_owner_id"],
    actionPerformedBy: json["action_performed_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    xeroTenantAccessToken: json["xero_tenant_access_token"],
    xeroTenantId: json["xero_tenant_id"],
    xeroTenantName: json["xero_tenant_name"],
    xeroTenantType: json["xero_tenant_type"],
    routePermissions: json["route_permissions"] == null ? [] : List<dynamic>.from(json["route_permissions"]!.map((x) => x)),
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
    "org_address": orgAddress,
    "is_active": isActive,
    "org_owner_id": orgOwnerId,
    "action_performed_by": actionPerformedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
    "xero_tenant_access_token": xeroTenantAccessToken,
    "xero_tenant_id": xeroTenantId,
    "xero_tenant_name": xeroTenantName,
    "xero_tenant_type": xeroTenantType,
    "route_permissions": routePermissions == null ? [] : List<dynamic>.from(routePermissions!.map((x) => x)),
  };
}

class Info {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final dynamic secondaryEmail;
  final String? gender;
  final String? phone;
  final dynamic secondaryPhone;
  final String? address;
  final dynamic postcode;
  final dynamic birthday;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Info({
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
    this.createdAt,
    this.updatedAt,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    secondaryEmail: json["secondary_email"],
    gender: json["gender"],
    phone: json["phone"],
    secondaryPhone: json["secondary_phone"],
    address: json["address"],
    postcode: json["postcode"],
    birthday: json["birthday"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "address": address,
    "postcode": postcode,
    "birthday": birthday,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Organizations {
  final int? id;
  final String? orgName;
  final String? orgKey;
  final String? orgAbn;
  final String? orgEmail;
  final String? orgPhone;
  final String? orgAddress;
  final int? isActive;
  final int? orgOwnerId;
  final int? actionPerformedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Organizations({
    this.id,
    this.orgName,
    this.orgKey,
    this.orgAbn,
    this.orgEmail,
    this.orgPhone,
    this.orgAddress,
    this.isActive,
    this.orgOwnerId,
    this.actionPerformedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Organizations.fromJson(Map<String, dynamic> json) => Organizations(
    id: json["id"],
    orgName: json["org_name"],
    orgKey: json["org_key"],
    orgAbn: json["org_abn"],
    orgEmail: json["org_email"],
    orgPhone: json["org_phone"],
    orgAddress: json["org_address"],
    isActive: json["is_active"],
    orgOwnerId: json["org_owner_id"],
    actionPerformedBy: json["action_performed_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "org_name": orgName,
    "org_key": orgKey,
    "org_abn": orgAbn,
    "org_email": orgEmail,
    "org_phone": orgPhone,
    "org_address": orgAddress,
    "is_active": isActive,
    "org_owner_id": orgOwnerId,
    "action_performed_by": actionPerformedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Roles {
  final int? id;
  final String? name;
  final String? code;
  final String? type;
  final dynamic createdAt;
  final dynamic updatedAt;

  Roles({
    this.id,
    this.name,
    this.code,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
