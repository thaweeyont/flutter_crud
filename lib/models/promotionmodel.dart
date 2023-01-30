// To parse this JSON data, do
//
//     final promotionmodel = promotionmodelFromJson(jsonString);

import 'dart:convert';

List<Promotionmodel> promotionmodelFromJson(String str) =>
    List<Promotionmodel>.from(
        json.decode(str).map((x) => Promotionmodel.fromJson(x)));

String promotionmodelToJson(List<Promotionmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Promotionmodel {
  Promotionmodel({
    this.id,
    this.idRunPromotion,
    this.namePromotion,
    this.labelPromotion,
    this.ribbonPromotion,
    this.promotionBaner,
    this.startPromotion,
    this.endPromotion,
    this.statusPromotion,
    this.activePromotion,
  });

  String? id;
  String? idRunPromotion;
  String? namePromotion;
  String? labelPromotion;
  String? ribbonPromotion;
  String? promotionBaner;
  DateTime? startPromotion;
  DateTime? endPromotion;
  String? statusPromotion;
  String? activePromotion;

  factory Promotionmodel.fromJson(Map<String, dynamic> json) => Promotionmodel(
        id: json["id"] == null ? null : json["id"],
        idRunPromotion:
            json["id_run_promotion"] == null ? null : json["id_run_promotion"],
        namePromotion:
            json["name_promotion"] == null ? null : json["name_promotion"],
        labelPromotion:
            json["label_promotion"] == null ? null : json["label_promotion"],
        ribbonPromotion:
            json["ribbon_promotion"] == null ? null : json["ribbon_promotion"],
        promotionBaner:
            json["promotion_baner"] == null ? null : json["promotion_baner"],
        startPromotion: json["start_promotion"] == null
            ? null
            : DateTime.parse(json["start_promotion"]),
        endPromotion: json["end_promotion"] == null
            ? null
            : DateTime.parse(json["end_promotion"]),
        statusPromotion:
            json["status_promotion"] == null ? null : json["status_promotion"],
        activePromotion:
            json["active_promotion"] == null ? null : json["active_promotion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "id_run_promotion": idRunPromotion == null ? null : idRunPromotion,
        "name_promotion": namePromotion == null ? null : namePromotion,
        "label_promotion": labelPromotion == null ? null : labelPromotion,
        "ribbon_promotion": ribbonPromotion == null ? null : ribbonPromotion,
        "promotion_baner": promotionBaner == null ? null : promotionBaner,
        "start_promotion":
            startPromotion == null ? null : startPromotion!.toIso8601String(),
        "end_promotion":
            endPromotion == null ? null : endPromotion!.toIso8601String(),
        "status_promotion": statusPromotion == null ? null : statusPromotion,
        "active_promotion": activePromotion == null ? null : activePromotion,
      };
}
