// To parse this JSON data, do
//
//     final historyUser = historyUserFromJson(jsonString);

import 'dart:convert';

List<HistoryUser> historyUserFromJson(String str) => List<HistoryUser>.from(
    json.decode(str).map((x) => HistoryUser.fromJson(x)));

String historyUserToJson(List<HistoryUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryUser {
  HistoryUser({
    this.idJob,
    this.idCardUser,
    this.idMechanic,
    this.idProductJoblog,
    this.addressGoProduct,
    this.dateGo,
    this.status,
    this.statusM,
    this.carateDate,
    this.updateDate,
    this.id,
    this.imgNamePath,
    this.createdDate,
    this.fullnameMechanic,
    this.idCardMechanic,
    this.addressMechanic,
    this.phoneMechanic,
    this.date,
  });

  String? idJob;
  String? idCardUser;
  String? idMechanic;
  String? idProductJoblog;
  String? addressGoProduct;
  DateTime? dateGo;
  String? status;
  String? statusM;
  DateTime? carateDate;
  dynamic updateDate;
  String? id;
  String? imgNamePath;
  DateTime? createdDate;
  String? fullnameMechanic;
  String? idCardMechanic;
  String? addressMechanic;
  String? phoneMechanic;
  String? date;

  factory HistoryUser.fromJson(Map<String, dynamic> json) => HistoryUser(
        idJob: json["id_job"] == null ? null : json["id_job"],
        idCardUser: json["id_card_user"] == null ? null : json["id_card_user"],
        idMechanic: json["id_mechanic"] == null ? null : json["id_mechanic"],
        idProductJoblog: json["id_product_joblog"] == null
            ? null
            : json["id_product_joblog"],
        addressGoProduct: json["address_go_product"] == null
            ? null
            : json["address_go_product"],
        dateGo:
            json["date_go"] == null ? null : DateTime.parse(json["date_go"]),
        status: json["status"] == null ? null : json["status"],
        statusM: json["status_m"] == null ? null : json["status_m"],
        carateDate: json["carate_date"] == null
            ? null
            : DateTime.parse(json["carate_date"]),
        updateDate: json["update_date"],
        id: json["id"] == null ? null : json["id"],
        imgNamePath:
            json["img_name_path"] == null ? null : json["img_name_path"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        fullnameMechanic: json["fullname_mechanic"] == null
            ? null
            : json["fullname_mechanic"],
        idCardMechanic:
            json["id_card_mechanic"] == null ? null : json["id_card_mechanic"],
        addressMechanic:
            json["address_mechanic"] == null ? null : json["address_mechanic"],
        phoneMechanic:
            json["phone_mechanic"] == null ? null : json["phone_mechanic"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id_job": idJob == null ? null : idJob,
        "id_card_user": idCardUser == null ? null : idCardUser,
        "id_mechanic": idMechanic == null ? null : idMechanic,
        "id_product_joblog": idProductJoblog == null ? null : idProductJoblog,
        "address_go_product":
            addressGoProduct == null ? null : addressGoProduct,
        "date_go": dateGo == null
            ? null
            : "${dateGo!.year.toString().padLeft(4, '0')}-${dateGo!.month.toString().padLeft(2, '0')}-${dateGo!.day.toString().padLeft(2, '0')}",
        "status": status == null ? null : status,
        "status_m": statusM == null ? null : statusM,
        "carate_date":
            carateDate == null ? null : carateDate!.toIso8601String(),
        "update_date": updateDate,
        "id": id == null ? null : id,
        "img_name_path": imgNamePath == null ? null : imgNamePath,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "fullname_mechanic": fullnameMechanic == null ? null : fullnameMechanic,
        "id_card_mechanic": idCardMechanic == null ? null : idCardMechanic,
        "address_mechanic": addressMechanic == null ? null : addressMechanic,
        "phone_mechanic": phoneMechanic == null ? null : phoneMechanic,
        "date": date == null ? null : date,
      };
}
