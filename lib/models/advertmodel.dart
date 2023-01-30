// To parse this JSON data, do
//
//     final advertmodel = advertmodelFromJson(jsonString);

import 'dart:convert';

List<Advertmodel> advertmodelFromJson(String str) => List<Advertmodel>.from(
    json.decode(str).map((x) => Advertmodel.fromJson(x)));

String advertmodelToJson(List<Advertmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Advertmodel {
  Advertmodel({
    this.idAdvert,
    this.altName,
    this.imgName,
    this.urlLinkName,
    this.advertSt,
    this.status,
    this.createdDate,
    this.updateDate,
  });

  String? idAdvert;
  String? altName;
  String? imgName;
  String? urlLinkName;
  String? advertSt;
  String? status;
  DateTime? createdDate;
  DateTime? updateDate;

  factory Advertmodel.fromJson(Map<String, dynamic> json) => Advertmodel(
        idAdvert: json["id_advert"] == null ? null : json["id_advert"],
        altName: json["alt_name"] == null ? null : json["alt_name"],
        imgName: json["img_name"] == null ? null : json["img_name"],
        urlLinkName:
            json["url_link_name"] == null ? null : json["url_link_name"],
        advertSt: json["advert_st"] == null ? null : json["advert_st"],
        status: json["status"] == null ? null : json["status"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"] == null
            ? null
            : DateTime.parse(json["update_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id_advert": idAdvert == null ? null : idAdvert,
        "alt_name": altName == null ? null : altName,
        "img_name": imgName == null ? null : imgName,
        "url_link_name": urlLinkName == null ? null : urlLinkName,
        "advert_st": advertSt == null ? null : advertSt,
        "status": status == null ? null : status,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date":
            updateDate == null ? null : updateDate!.toIso8601String(),
      };
}
