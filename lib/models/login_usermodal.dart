// To parse this JSON data, do
//
//     final loginusermodel = loginusermodelFromJson(jsonString);

import 'dart:convert';

List<Loginusermodel> loginusermodelFromJson(String str) =>
    List<Loginusermodel>.from(
        json.decode(str).map((x) => Loginusermodel.fromJson(x)));

String loginusermodelToJson(List<Loginusermodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Loginusermodel {
  Loginusermodel({
    this.id,
    this.idcard,
    this.username,
    this.password,
    this.fullname,
    this.addressUser,
    this.provincesU,
    this.amphuresU,
    this.districtsU,
    this.phoneUser,
    this.profileUser,
    this.lat,
    this.lng,
    this.status,
    this.statusMember,
    this.imageIdcard,
    this.errorMessage,
    this.token,
    this.createdDate,
    this.updateDate,
    this.code,
    this.nameTh,
    this.nameEn,
    this.geographyId,
    this.provinceId,
    this.zipCode,
    this.amphureId,
    this.idProvinces,
    this.nameProvinces,
    this.idAmphures,
    this.nameAmphures,
    this.idDistricts,
    this.nameDistricts,
  });

  String? id;
  String? idcard;
  String? username;
  String? password;
  String? fullname;
  String? addressUser;
  String? provincesU;
  String? amphuresU;
  String? districtsU;
  String? phoneUser;
  String? profileUser;
  dynamic lat;
  dynamic lng;
  String? status;
  String? statusMember;
  String? imageIdcard;
  String? errorMessage;
  String? token;
  DateTime? createdDate;
  dynamic updateDate;
  String? code;
  String? nameTh;
  String? nameEn;
  String? geographyId;
  String? provinceId;
  String? zipCode;
  String? amphureId;
  String? idProvinces;
  String? nameProvinces;
  String? idAmphures;
  String? nameAmphures;
  String? idDistricts;
  String? nameDistricts;

  factory Loginusermodel.fromJson(Map<String, dynamic> json) => Loginusermodel(
        id: json["id"] == null ? null : json["id"],
        idcard: json["idcard"] == null ? null : json["idcard"],
        username: json["user_name"] == null ? null : json["user_name"],
        password: json["pass_word"] == null ? null : json["pass_word"],
        fullname: json["fullname"] == null ? null : json["fullname"],
        addressUser: json["address_user"] == null ? null : json["address_user"],
        provincesU: json["provinces_u"] == null ? null : json["provinces_u"],
        amphuresU: json["amphures_u"] == null ? null : json["amphures_u"],
        districtsU: json["districts_u"] == null ? null : json["districts_u"],
        phoneUser: json["phone_user"] == null ? null : json["phone_user"],
        profileUser: json["profile_user"] == null ? null : json["profile_user"],
        lat: json["lat"],
        lng: json["lng"],
        status: json["status"] == null ? null : json["status"],
        statusMember:
            json["status_member"] == null ? null : json["status_member"],
        imageIdcard: json["image_idcard"] == null ? null : json["image_idcard"],
        errorMessage:
            json["error_message"] == null ? null : json["error_message"],
        token: json["Token"] == null ? null : json["Token"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"],
        code: json["code"] == null ? null : json["code"],
        nameTh: json["name_th"] == null ? null : json["name_th"],
        nameEn: json["name_en"] == null ? null : json["name_en"],
        geographyId: json["geography_id"] == null ? null : json["geography_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        zipCode: json["zip_code"] == null ? null : json["zip_code"],
        amphureId: json["amphure_id"] == null ? null : json["amphure_id"],
        idProvinces: json["id_provinces"] == null ? null : json["id_provinces"],
        nameProvinces:
            json["name_provinces"] == null ? null : json["name_provinces"],
        idAmphures: json["id_amphures"] == null ? null : json["id_amphures"],
        nameAmphures:
            json["name_amphures"] == null ? null : json["name_amphures"],
        idDistricts: json["id_districts"] == null ? null : json["id_districts"],
        nameDistricts:
            json["name_districts"] == null ? null : json["name_districts"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "idcard": idcard == null ? null : idcard,
        "user_name": username == null ? null : username,
        "pass_word": password == null ? null : password,
        "fullname": fullname == null ? null : fullname,
        "address_user": addressUser == null ? null : addressUser,
        "provinces_u": provincesU == null ? null : provincesU,
        "amphures_u": amphuresU == null ? null : amphuresU,
        "districts_u": districtsU == null ? null : districtsU,
        "phone_user": phoneUser == null ? null : phoneUser,
        "profile_user": profileUser == null ? null : profileUser,
        "lat": lat,
        "lng": lng,
        "status": status == null ? null : status,
        "status_member": statusMember == null ? null : statusMember,
        "image_idcard": imageIdcard == null ? null : imageIdcard,
        "error_message": errorMessage == null ? null : errorMessage,
        "Token": token == null ? null : token,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date": updateDate,
        "code": code == null ? null : code,
        "name_th": nameTh == null ? null : nameTh,
        "name_en": nameEn == null ? null : nameEn,
        "geography_id": geographyId == null ? null : geographyId,
        "province_id": provinceId == null ? null : provinceId,
        "zip_code": zipCode == null ? null : zipCode,
        "amphure_id": amphureId == null ? null : amphureId,
        "id_provinces": idProvinces == null ? null : idProvinces,
        "name_provinces": nameProvinces == null ? null : nameProvinces,
        "id_amphures": idAmphures == null ? null : idAmphures,
        "name_amphures": nameAmphures == null ? null : nameAmphures,
        "id_districts": idDistricts == null ? null : idDistricts,
        "name_districts": nameDistricts == null ? null : nameDistricts,
      };
}
