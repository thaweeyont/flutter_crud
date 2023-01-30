// To parse this JSON data, do
//
//     final joindetail = joindetailFromJson(jsonString);

import 'dart:convert';

List<Joindetail> joindetailFromJson(String str) =>
    List<Joindetail>.from(json.decode(str).map((x) => Joindetail.fromJson(x)));

String joindetailToJson(List<Joindetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Joindetail {
  Joindetail({
    this.idJob,
    this.idCardUser,
    this.idMechanic,
    this.productType,
    this.detailProduct,
    this.addressGoProduct,
    this.dateGo,
    this.status,
    this.carateDate,
    this.updateDate,
    this.id,
    this.fullnameMechanic,
    this.idCardMechanic,
    this.addressMechanic,
    this.phoneMechanic,
    this.createdDate,
    this.idJobDetail,
    this.titleDetail,
    this.textDetail,
    this.warringDetail,
    this.statusDetail,
  });

  String? idJob;
  String? idCardUser;
  String? idMechanic;
  String? productType;
  String? detailProduct;
  String? addressGoProduct;
  DateTime? dateGo;
  String? status;
  DateTime? carateDate;
  dynamic updateDate;
  String? id;
  String? fullnameMechanic;
  String? idCardMechanic;
  String? addressMechanic;
  String? phoneMechanic;
  DateTime? createdDate;
  String? idJobDetail;
  String? titleDetail;
  String? textDetail;
  dynamic warringDetail;
  String? statusDetail;

  factory Joindetail.fromJson(Map<String, dynamic> json) => Joindetail(
        idJob: json["id_job"] == null ? null : json["id_job"],
        idCardUser: json["id_card_user"] == null ? null : json["id_card_user"],
        idMechanic: json["id_mechanic"] == null ? null : json["id_mechanic"],
        productType: json["product_type"] == null ? null : json["product_type"],
        detailProduct:
            json["detail_product"] == null ? null : json["detail_product"],
        addressGoProduct: json["address_go_product"] == null
            ? null
            : json["address_go_product"],
        dateGo:
            json["date_go"] == null ? null : DateTime.parse(json["date_go"]),
        status: json["status"] == null ? null : json["status"],
        carateDate: json["carate_date"] == null
            ? null
            : DateTime.parse(json["carate_date"]),
        updateDate: json["update_date"],
        id: json["id"] == null ? null : json["id"],
        fullnameMechanic: json["fullname_mechanic"] == null
            ? null
            : json["fullname_mechanic"],
        idCardMechanic:
            json["id_card_mechanic"] == null ? null : json["id_card_mechanic"],
        addressMechanic:
            json["address_mechanic"] == null ? null : json["address_mechanic"],
        phoneMechanic:
            json["phone_mechanic"] == null ? null : json["phone_mechanic"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        idJobDetail:
            json["id_job_detail"] == null ? null : json["id_job_detail"],
        titleDetail: json["title_detail"] == null ? null : json["title_detail"],
        textDetail: json["text_detail"] == null ? null : json["text_detail"],
        warringDetail: json["warring_detail"],
        statusDetail:
            json["status_detail"] == null ? null : json["status_detail"],
      );

  Map<String, dynamic> toJson() => {
        "id_job": idJob == null ? null : idJob,
        "id_card_user": idCardUser == null ? null : idCardUser,
        "id_mechanic": idMechanic == null ? null : idMechanic,
        "product_type": productType == null ? null : productType,
        "detail_product": detailProduct == null ? null : detailProduct,
        "address_go_product":
            addressGoProduct == null ? null : addressGoProduct,
        "date_go": dateGo == null
            ? null
            : "${dateGo!.year.toString().padLeft(4, '0')}-${dateGo!.month.toString().padLeft(2, '0')}-${dateGo!.day.toString().padLeft(2, '0')}",
        "status": status == null ? null : status,
        "carate_date":
            carateDate == null ? null : carateDate!.toIso8601String(),
        "update_date": updateDate,
        "id": id == null ? null : id,
        "fullname_mechanic": fullnameMechanic == null ? null : fullnameMechanic,
        "id_card_mechanic": idCardMechanic == null ? null : idCardMechanic,
        "address_mechanic": addressMechanic == null ? null : addressMechanic,
        "phone_mechanic": phoneMechanic == null ? null : phoneMechanic,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "id_job_detail": idJobDetail == null ? null : idJobDetail,
        "title_detail": titleDetail == null ? null : titleDetail,
        "text_detail": textDetail == null ? null : textDetail,
        "warring_detail": warringDetail,
        "status_detail": statusDetail == null ? null : statusDetail,
      };
}
