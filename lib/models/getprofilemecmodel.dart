// To parse this JSON data, do
//
//     final getprofilemec = getprofilemecFromJson(jsonString);

import 'dart:convert';

List<Getprofilemec> getprofilemecFromJson(String str) =>
    List<Getprofilemec>.from(
        json.decode(str).map((x) => Getprofilemec.fromJson(x)));

String getprofilemecToJson(List<Getprofilemec> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getprofilemec {
  Getprofilemec({
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
    this.idData,
    this.idGenJob,
    this.idStaff,
    this.idProduct,
    this.latData,
    this.lngData,
    this.waring,
    this.timeStart,
    this.timeEnd,
    this.machineCode,
    this.statusData,
    this.createdDate,
    this.id,
    this.idBranch,
    this.fullnameStaff,
    this.phoneStaff,
    this.statusStaff,
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
  String? idData;
  String? idGenJob;
  String? idStaff;
  String? idProduct;
  String? latData;
  String? lngData;
  String? waring;
  String? timeStart;
  String? timeEnd;
  String? machineCode;
  String? statusData;
  DateTime? createdDate;
  String? id;
  String? idBranch;
  String? fullnameStaff;
  String? phoneStaff;
  String? statusStaff;

  factory Getprofilemec.fromJson(Map<String, dynamic> json) => Getprofilemec(
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
        idData: json["id_data"] == null ? null : json["id_data"],
        idGenJob: json["id_gen_job"] == null ? null : json["id_gen_job"],
        idStaff: json["id_staff"] == null ? null : json["id_staff"],
        idProduct: json["id_product"] == null ? null : json["id_product"],
        latData: json["lat_data"] == null ? null : json["lat_data"],
        lngData: json["lng_data"] == null ? null : json["lng_data"],
        waring: json["waring"] == null ? null : json["waring"],
        timeStart: json["time_start"] == null ? null : json["time_start"],
        timeEnd: json["time_end"] == null ? null : json["time_end"],
        machineCode: json["machine_code"] == null ? null : json["machine_code"],
        statusData: json["status_data"] == null ? null : json["status_data"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        id: json["id"] == null ? null : json["id"],
        idBranch: json["id_branch"] == null ? null : json["id_branch"],
        fullnameStaff:
            json["fullname_staff"] == null ? null : json["fullname_staff"],
        phoneStaff: json["phone_staff"] == null ? null : json["phone_staff"],
        statusStaff: json["status_staff"] == null ? null : json["status_staff"],
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
        "id_data": idData == null ? null : idData,
        "id_gen_job": idGenJob == null ? null : idGenJob,
        "id_staff": idStaff == null ? null : idStaff,
        "id_product": idProduct == null ? null : idProduct,
        "lat_data": latData == null ? null : latData,
        "lng_data": lngData == null ? null : lngData,
        "waring": waring == null ? null : waring,
        "time_start": timeStart == null ? null : timeStart,
        "time_end": timeEnd == null ? null : timeEnd,
        "machine_code": machineCode == null ? null : machineCode,
        "status_data": statusData == null ? null : statusData,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "id": id == null ? null : id,
        "id_branch": idBranch == null ? null : idBranch,
        "fullname_staff": fullnameStaff == null ? null : fullnameStaff,
        "phone_staff": phoneStaff == null ? null : phoneStaff,
        "status_staff": statusStaff == null ? null : statusStaff,
      };
}
