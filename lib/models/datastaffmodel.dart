// To parse this JSON data, do
//
//     final dataStaffScore = dataStaffScoreFromJson(jsonString);

import 'dart:convert';

List<DataStaffScore> dataStaffScoreFromJson(String str) =>
    List<DataStaffScore>.from(
        json.decode(str).map((x) => DataStaffScore.fromJson(x)));

String dataStaffScoreToJson(List<DataStaffScore> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataStaffScore {
  DataStaffScore({
    this.idJob,
    this.idJobHead,
    this.idCardUser,
    this.idMechanic,
    this.idSale,
    this.idCredit,
    this.addressDeliver,
    this.dateTimeInstall,
    this.productTypeContract,
    this.latJob,
    this.lngJob,
    this.statusJob,
    this.cratedDate,
    this.updateDate,
    this.id,
    this.idStaff,
    this.idBranch,
    this.fullnameStaff,
    this.phoneStaff,
    this.statusStaff,
    this.createdDate,
    this.statusShow,
  });

  String? idJob;
  String? idJobHead;
  String? idCardUser;
  dynamic idMechanic;
  String? idSale;
  String? idCredit;
  String? addressDeliver;
  dynamic dateTimeInstall;
  String? productTypeContract;
  String? latJob;
  String? lngJob;
  String? statusJob;
  DateTime? cratedDate;
  dynamic updateDate;
  String? id;
  String? idStaff;
  String? idBranch;
  String? fullnameStaff;
  dynamic phoneStaff;
  String? statusStaff;
  DateTime? createdDate;
  String? statusShow;

  factory DataStaffScore.fromJson(Map<String, dynamic> json) => DataStaffScore(
        idJob: json["id_job"] == null ? null : json["id_job"],
        idJobHead: json["id_job_head"] == null ? null : json["id_job_head"],
        idCardUser: json["id_card_user"] == null ? null : json["id_card_user"],
        idMechanic: json["id_mechanic"],
        idSale: json["id_sale"] == null ? null : json["id_sale"],
        idCredit: json["id_credit"] == null ? null : json["id_credit"],
        addressDeliver:
            json["address_deliver"] == null ? null : json["address_deliver"],
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
        updateDate: json["update_date"],
        id: json["id"] == null ? null : json["id"],
        idStaff: json["id_staff"] == null ? null : json["id_staff"],
        idBranch: json["id_branch"] == null ? null : json["id_branch"],
        fullnameStaff:
            json["fullname_staff"] == null ? null : json["fullname_staff"],
        phoneStaff: json["phone_staff"],
        statusStaff: json["status_staff"] == null ? null : json["status_staff"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        statusShow: json["status_show"] == null ? null : json["status_show"],
      );

  Map<String, dynamic> toJson() => {
        "id_job": idJob == null ? null : idJob,
        "id_job_head": idJobHead == null ? null : idJobHead,
        "id_card_user": idCardUser == null ? null : idCardUser,
        "id_mechanic": idMechanic,
        "id_sale": idSale == null ? null : idSale,
        "id_credit": idCredit == null ? null : idCredit,
        "address_deliver": addressDeliver == null ? null : addressDeliver,
        "date_time_install": dateTimeInstall,
        "product_type_contract":
            productTypeContract == null ? null : productTypeContract,
        "lat_job": latJob == null ? null : latJob,
        "lng_job": lngJob == null ? null : lngJob,
        "status_job": statusJob == null ? null : statusJob,
        "crated_date":
            cratedDate == null ? null : cratedDate!.toIso8601String(),
        "update_date": updateDate,
        "id": id == null ? null : id,
        "id_staff": idStaff == null ? null : idStaff,
        "id_branch": idBranch == null ? null : idBranch,
        "fullname_staff": fullnameStaff == null ? null : fullnameStaff,
        "phone_staff": phoneStaff,
        "status_staff": statusStaff == null ? null : statusStaff,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "status_show": statusShow == null ? null : statusShow,
      };
}
