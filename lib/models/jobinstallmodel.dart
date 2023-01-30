// To parse this JSON data, do
//
//     final jobinstall = jobinstallFromJson(jsonString);

import 'dart:convert';

List<Jobinstall> jobinstallFromJson(String str) =>
    List<Jobinstall>.from(json.decode(str).map((x) => Jobinstall.fromJson(x)));

String jobinstallToJson(List<Jobinstall> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jobinstall {
  Jobinstall({
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
    this.checkMachineCode,
    this.statusData,
    this.createdDate,
    this.updateDate,
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
    this.date,
    this.timeInstall,
  });

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
  String? checkMachineCode;
  String? statusData;
  DateTime? createdDate;
  DateTime? updateDate;
  String? idJob;
  String? idJobHead;
  String? idCardUser;
  dynamic idMechanic;
  String? idSale;
  dynamic idCredit;
  String? addressDeliver;
  dynamic dateTimeInstall;
  String? productTypeContract;
  String? latJob;
  String? lngJob;
  String? statusJob;
  DateTime? cratedDate;
  String? date;
  String? timeInstall;

  factory Jobinstall.fromJson(Map<String, dynamic> json) => Jobinstall(
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
        checkMachineCode: json["check_machine_code"] == null
            ? null
            : json["check_machine_code"],
        statusData: json["status_data"] == null ? null : json["status_data"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"] == null
            ? null
            : DateTime.parse(json["update_date"]),
        idJob: json["id_job"] == null ? null : json["id_job"],
        idJobHead: json["id_job_head"] == null ? null : json["id_job_head"],
        idCardUser: json["id_card_user"] == null ? null : json["id_card_user"],
        idMechanic: json["id_mechanic"],
        idSale: json["id_sale"] == null ? null : json["id_sale"],
        idCredit: json["id_credit"],
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
        date: json["date"] == null ? null : json["date"],
        timeInstall: json["time_install"] == null ? null : json["time_install"],
      );

  Map<String, dynamic> toJson() => {
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
        "check_machine_code":
            checkMachineCode == null ? null : checkMachineCode,
        "status_data": statusData == null ? null : statusData,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date":
            updateDate == null ? null : updateDate!.toIso8601String(),
        "id_job": idJob == null ? null : idJob,
        "id_job_head": idJobHead == null ? null : idJobHead,
        "id_card_user": idCardUser == null ? null : idCardUser,
        "id_mechanic": idMechanic,
        "id_sale": idSale == null ? null : idSale,
        "id_credit": idCredit,
        "address_deliver": addressDeliver == null ? null : addressDeliver,
        "date_time_install": dateTimeInstall,
        "product_type_contract":
            productTypeContract == null ? null : productTypeContract,
        "lat_job": latJob == null ? null : latJob,
        "lng_job": lngJob == null ? null : lngJob,
        "status_job": statusJob == null ? null : statusJob,
        "crated_date":
            cratedDate == null ? null : cratedDate!.toIso8601String(),
        "date": date == null ? null : date,
        "time_install": timeInstall == null ? null : timeInstall,
      };
}
