// To parse this JSON data, do
//
//     final jobmechanic = jobmechanicFromJson(jsonString);

import 'dart:convert';

List<Jobmechanic> jobmechanicFromJson(String str) => List<Jobmechanic>.from(
    json.decode(str).map((x) => Jobmechanic.fromJson(x)));

String jobmechanicToJson(List<Jobmechanic> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jobmechanic {
  Jobmechanic({
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
    this.id,
    this.idBranch,
    this.fullnameStaff,
    this.phoneStaff,
    this.statusStaff,
    this.statusShow,
    this.datePd,
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
  dynamic updateDate;
  String? id;
  String? idBranch;
  String? fullnameStaff;
  String? phoneStaff;
  String? statusStaff;
  String? statusShow;
  DateTime? datePd;

  factory Jobmechanic.fromJson(Map<String, dynamic> json) => Jobmechanic(
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
        updateDate: json["update_date"],
        id: json["id"] == null ? null : json["id"],
        idBranch: json["id_branch"] == null ? null : json["id_branch"],
        fullnameStaff:
            json["fullname_staff"] == null ? null : json["fullname_staff"],
        phoneStaff: json["phone_staff"] == null ? null : json["phone_staff"],
        statusStaff: json["status_staff"] == null ? null : json["status_staff"],
        statusShow: json["status_show"] == null ? null : json["status_show"],
        datePd:
            json["date_pd"] == null ? null : DateTime.parse(json["date_pd"]),
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
        "update_date": updateDate,
        "id": id == null ? null : id,
        "id_branch": idBranch == null ? null : idBranch,
        "fullname_staff": fullnameStaff == null ? null : fullnameStaff,
        "phone_staff": phoneStaff == null ? null : phoneStaff,
        "status_staff": statusStaff == null ? null : statusStaff,
        "status_show": statusShow == null ? null : statusShow,
        "date_pd": datePd == null
            ? null
            : "${datePd!.year.toString().padLeft(4, '0')}-${datePd!.month.toString().padLeft(2, '0')}-${datePd!.day.toString().padLeft(2, '0')}",
      };
}
