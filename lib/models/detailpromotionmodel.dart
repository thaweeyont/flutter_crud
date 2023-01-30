// To parse this JSON data, do
//
//     final detailpromotionmodel = detailpromotionmodelFromJson(jsonString);

import 'dart:convert';

List<Detailpromotionmodel> detailpromotionmodelFromJson(String str) =>
    List<Detailpromotionmodel>.from(
        json.decode(str).map((x) => Detailpromotionmodel.fromJson(x)));

String detailpromotionmodelToJson(List<Detailpromotionmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detailpromotionmodel {
  Detailpromotionmodel({
    this.id,
    this.idPromotion,
    this.idOption,
    this.idProduct,
    this.nameProduct,
    this.priceProdPromo,
    this.productId,
    this.structureId,
    this.productName,
    this.typeCatId,
    this.catId,
    this.idBrand,
    this.productPreiceShipping,
    this.proMostView,
    this.productMostSale,
    this.imgLocation,
    this.imgLocation2,
    this.imgLocation3,
    this.imgLocation4,
    this.imgLocation5,
    this.imgLocationShare,
    this.pdDetail1,
    this.pdDetail2,
    this.pdDetail3,
    this.pdDetail4,
    this.pdDetail5,
    this.pdDetail6,
    this.etcProduct,
    this.productShowHide,
    this.productHotdeal,
    this.timeInsertDataPro,
    this.timeEditDataPro,
  });

  String? id;
  String? idPromotion;
  String? idOption;
  String? idProduct;
  String? nameProduct;
  String? priceProdPromo;
  String? productId;
  String? structureId;
  String? productName;
  String? typeCatId;
  String? catId;
  String? idBrand;
  String? productPreiceShipping;
  String? proMostView;
  String? productMostSale;
  String? imgLocation;
  String? imgLocation2;
  String? imgLocation3;
  String? imgLocation4;
  String? imgLocation5;
  String? imgLocationShare;
  String? pdDetail1;
  String? pdDetail2;
  String? pdDetail3;
  String? pdDetail4;
  String? pdDetail5;
  String? pdDetail6;
  String? etcProduct;
  String? productShowHide;
  String? productHotdeal;
  DateTime? timeInsertDataPro;
  DateTime? timeEditDataPro;

  factory Detailpromotionmodel.fromJson(Map<String, dynamic> json) =>
      Detailpromotionmodel(
        id: json["id"] == null ? null : json["id"],
        idPromotion: json["id_promotion"] == null ? null : json["id_promotion"],
        idOption: json["id_option"] == null ? null : json["id_option"],
        idProduct: json["id_product"] == null ? null : json["id_product"],
        nameProduct: json["name_product"] == null ? null : json["name_product"],
        priceProdPromo:
            json["price_prod_promo"] == null ? null : json["price_prod_promo"],
        productId: json["product_id"] == null ? null : json["product_id"],
        structureId: json["structure_id"] == null ? null : json["structure_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        typeCatId: json["type_cat_id"] == null ? null : json["type_cat_id"],
        catId: json["cat_id"] == null ? null : json["cat_id"],
        idBrand: json["id_brand"] == null ? null : json["id_brand"],
        productPreiceShipping: json["product_preice_shipping"] == null
            ? null
            : json["product_preice_shipping"],
        proMostView:
            json["pro_most_view"] == null ? null : json["pro_most_view"],
        productMostSale: json["product_most_sale"] == null
            ? null
            : json["product_most_sale"],
        imgLocation: json["img_location"] == null ? null : json["img_location"],
        imgLocation2:
            json["img_location_2"] == null ? null : json["img_location_2"],
        imgLocation3:
            json["img_location_3"] == null ? null : json["img_location_3"],
        imgLocation4:
            json["img_location_4"] == null ? null : json["img_location_4"],
        imgLocation5:
            json["img_location_5"] == null ? null : json["img_location_5"],
        imgLocationShare: json["img_location_share"] == null
            ? null
            : json["img_location_share"],
        pdDetail1: json["pd_detail1"] == null ? null : json["pd_detail1"],
        pdDetail2: json["pd_detail2"] == null ? null : json["pd_detail2"],
        pdDetail3: json["pd_detail3"] == null ? null : json["pd_detail3"],
        pdDetail4: json["pd_detail4"] == null ? null : json["pd_detail4"],
        pdDetail5: json["pd_detail5"] == null ? null : json["pd_detail5"],
        pdDetail6: json["pd_detail6"] == null ? null : json["pd_detail6"],
        etcProduct: json["etc_product"] == null ? null : json["etc_product"],
        productShowHide: json["product_show_hide"] == null
            ? null
            : json["product_show_hide"],
        productHotdeal:
            json["product_hotdeal"] == null ? null : json["product_hotdeal"],
        timeInsertDataPro: json["time_insert_data_pro"] == null
            ? null
            : DateTime.parse(json["time_insert_data_pro"]),
        timeEditDataPro: json["time_edit_data_pro"] == null
            ? null
            : DateTime.parse(json["time_edit_data_pro"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "id_promotion": idPromotion == null ? null : idPromotion,
        "id_option": idOption == null ? null : idOption,
        "id_product": idProduct == null ? null : idProduct,
        "name_product": nameProduct == null ? null : nameProduct,
        "price_prod_promo": priceProdPromo == null ? null : priceProdPromo,
        "product_id": productId == null ? null : productId,
        "structure_id": structureId == null ? null : structureId,
        "product_name": productName == null ? null : productName,
        "type_cat_id": typeCatId == null ? null : typeCatId,
        "cat_id": catId == null ? null : catId,
        "id_brand": idBrand == null ? null : idBrand,
        "product_preice_shipping":
            productPreiceShipping == null ? null : productPreiceShipping,
        "pro_most_view": proMostView == null ? null : proMostView,
        "product_most_sale": productMostSale == null ? null : productMostSale,
        "img_location": imgLocation == null ? null : imgLocation,
        "img_location_2": imgLocation2 == null ? null : imgLocation2,
        "img_location_3": imgLocation3 == null ? null : imgLocation3,
        "img_location_4": imgLocation4 == null ? null : imgLocation4,
        "img_location_5": imgLocation5 == null ? null : imgLocation5,
        "img_location_share":
            imgLocationShare == null ? null : imgLocationShare,
        "pd_detail1": pdDetail1 == null ? null : pdDetail1,
        "pd_detail2": pdDetail2 == null ? null : pdDetail2,
        "pd_detail3": pdDetail3 == null ? null : pdDetail3,
        "pd_detail4": pdDetail4 == null ? null : pdDetail4,
        "pd_detail5": pdDetail5 == null ? null : pdDetail5,
        "pd_detail6": pdDetail6 == null ? null : pdDetail6,
        "etc_product": etcProduct == null ? null : etcProduct,
        "product_show_hide": productShowHide == null ? null : productShowHide,
        "product_hotdeal": productHotdeal == null ? null : productHotdeal,
        "time_insert_data_pro": timeInsertDataPro == null
            ? null
            : timeInsertDataPro!.toIso8601String(),
        "time_edit_data_pro":
            timeEditDataPro == null ? null : timeEditDataPro!.toIso8601String(),
      };
}
