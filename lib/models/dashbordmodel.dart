// To parse this JSON data, do
//
//     final dashbord = dashbordFromJson(jsonString);

import 'dart:convert';

List<Dashbord> dashbordFromJson(String str) => List<Dashbord>.from(json.decode(str).map((x) => Dashbord.fromJson(x)));

String dashbordToJson(List<Dashbord> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dashbord {
    Dashbord({
        this.idBanner,
        this.altName,
        this.imgName,
        this.imgNamePhone,
        this.urlLinkName,
        this.status,
        this.createdDate,
        this.updateDate,
    });

    String? idBanner;
    String? altName;
    String? imgName;
    String? imgNamePhone;
    String? urlLinkName;
    String? status;
    DateTime? createdDate;
    DateTime? updateDate;

    factory Dashbord.fromJson(Map<String, dynamic> json) => Dashbord(
        idBanner: json["id_banner"] == null ? null : json["id_banner"],
        altName: json["alt_name"] == null ? null : json["alt_name"],
        imgName: json["img_name"] == null ? null : json["img_name"],
        imgNamePhone: json["img_name_phone"] == null ? null : json["img_name_phone"],
        urlLinkName: json["url_link_name"] == null ? null : json["url_link_name"],
        status: json["status"] == null ? null : json["status"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"] == null ? null : DateTime.parse(json["update_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id_banner": idBanner == null ? null : idBanner,
        "alt_name": altName == null ? null : altName,
        "img_name": imgName == null ? null : imgName,
        "img_name_phone": imgNamePhone == null ? null : imgNamePhone,
        "url_link_name": urlLinkName == null ? null : urlLinkName,
        "status": status == null ? null : status,
        "created_date": createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date": updateDate == null ? null : updateDate!.toIso8601String(),
    };
}
