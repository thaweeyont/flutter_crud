// To parse this JSON data, do
//
//     final categorymodel = categorymodelFromJson(jsonString);

import 'dart:convert';

List<Categorymodel> categorymodelFromJson(String str) =>
    List<Categorymodel>.from(
        json.decode(str).map((x) => Categorymodel.fromJson(x)));

String categorymodelToJson(List<Categorymodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categorymodel {
  Categorymodel({
    this.catId,
    this.catName,
    this.catImg,
    this.imgPath,
    this.statusUse,
    this.setOrderByCat,
  });

  String? catId;
  String? catName;
  String? catImg;
  String? imgPath;
  String? statusUse;
  String? setOrderByCat;

  factory Categorymodel.fromJson(Map<String, dynamic> json) => Categorymodel(
        catId: json["cat_id"] == null ? null : json["cat_id"],
        catName: json["cat_name"] == null ? null : json["cat_name"],
        catImg: json["cat_img"] == null ? null : json["cat_img"],
        imgPath: json["img_path"] == null ? null : json["img_path"],
        statusUse: json["status_use"] == null ? null : json["status_use"],
        setOrderByCat:
            json["set_order_by_cat"] == null ? null : json["set_order_by_cat"],
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId == null ? null : catId,
        "cat_name": catName == null ? null : catName,
        "cat_img": catImg == null ? null : catImg,
        "img_path": imgPath == null ? null : imgPath,
        "status_use": statusUse == null ? null : statusUse,
        "set_order_by_cat": setOrderByCat == null ? null : setOrderByCat,
      };
}
