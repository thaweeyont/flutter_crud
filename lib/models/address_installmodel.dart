// To parse this JSON data, do
//
//     final addressInstall = addressInstallFromJson(jsonString);

import 'dart:convert';

List<AddressInstall> addressInstallFromJson(String str) =>
    List<AddressInstall>.from(
        json.decode(str).map((x) => AddressInstall.fromJson(x)));

String addressInstallToJson(List<AddressInstall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressInstall {
  AddressInstall({
    this.idJob,
    this.idJobHead,
    this.idCardUser,
    this.idMechanic,
    this.idSale,
    this.idCredit,
    this.addressDeliver,
    this.provinces,
    this.amphures,
    this.districts,
    this.dateTimeInstall,
    this.productTypeContract,
    this.latJob,
    this.lngJob,
    this.statusJob,
    this.cratedDate,
    this.updateDate,
    this.id,
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

  String? idJob;
  String? idJobHead;
  String? idCardUser;
  dynamic idMechanic;
  String? idSale;
  String? idCredit;
  String? addressDeliver;
  String? provinces;
  String? amphures;
  String? districts;
  dynamic dateTimeInstall;
  String? productTypeContract;
  String? latJob;
  String? lngJob;
  String? statusJob;
  DateTime? cratedDate;
  DateTime? updateDate;
  String? id;
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

  factory AddressInstall.fromJson(Map<String, dynamic> json) => AddressInstall(
        idJob: json["id_job"] == null ? null : json["id_job"],
        idJobHead: json["id_job_head"] == null ? null : json["id_job_head"],
        idCardUser: json["id_card_user"] == null ? null : json["id_card_user"],
        idMechanic: json["id_mechanic"],
        idSale: json["id_sale"] == null ? null : json["id_sale"],
        idCredit: json["id_credit"] == null ? null : json["id_credit"],
        addressDeliver:
            json["address_deliver"] == null ? null : json["address_deliver"],
        provinces: json["provinces"] == null ? null : json["provinces"],
        amphures: json["amphures"] == null ? null : json["amphures"],
        districts: json["districts"] == null ? null : json["districts"],
        dateTimeInstall: json["date_time_install"],
        productTypeContract: json["product_type_contract"] == null
            ? null
            : json["product_type_contract"],
        latJob: json["lat_job"] == null ? null : json["lat_job"],
        lngJob: json["lng_job"] == null ? null : json["lng_job"],
        statusJob: json["status_job"] == null ? null : json["status_job"],
        cratedDate: json["crated_date"] == null
            ? null
            : DateTime.parse(json["crated_date"]),
        updateDate: json["update_date"] == null
            ? null
            : DateTime.parse(json["update_date"]),
        id: json["id"] == null ? null : json["id"],
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
        "id_job": idJob == null ? null : idJob,
        "id_job_head": idJobHead == null ? null : idJobHead,
        "id_card_user": idCardUser == null ? null : idCardUser,
        "id_mechanic": idMechanic,
        "id_sale": idSale == null ? null : idSale,
        "id_credit": idCredit == null ? null : idCredit,
        "address_deliver": addressDeliver == null ? null : addressDeliver,
        "provinces": provinces == null ? null : provinces,
        "amphures": amphures == null ? null : amphures,
        "districts": districts == null ? null : districts,
        "date_time_install": dateTimeInstall,
        "product_type_contract":
            productTypeContract == null ? null : productTypeContract,
        "lat_job": latJob == null ? null : latJob,
        "lng_job": lngJob == null ? null : lngJob,
        "status_job": statusJob == null ? null : statusJob,
        "crated_date":
            cratedDate == null ? null : cratedDate!.toIso8601String(),
        "update_date":
            updateDate == null ? null : updateDate!.toIso8601String(),
        "id": id == null ? null : id,
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
