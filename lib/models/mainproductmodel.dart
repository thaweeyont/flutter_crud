// To parse this JSON data, do
//
//     final mainProduct = mainProductFromJson(jsonString);

import 'dart:convert';

List<MainProduct> mainProductFromJson(String str) => List<MainProduct>.from(
    json.decode(str).map((x) => MainProduct.fromJson(x)));

String mainProductToJson(List<MainProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainProduct {
  MainProduct({
    this.id,
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
    this.idPro,
    this.textDetail,
    this.optionPrice,
    this.promotionPrice,
    this.optionStock,
    this.img,
    this.idLink,
    this.titleOption,
  });

  String? id;
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
  String? idPro;
  String? textDetail;
  String? optionPrice;
  String? promotionPrice;
  String? optionStock;
  String? img;
  String? idLink;
  String? titleOption;

  factory MainProduct.fromJson(Map<String, dynamic> json) => MainProduct(
        id: json["id"] == null ? null : json["id"],
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
        idPro: json["id_pro"] == null ? null : json["id_pro"],
        textDetail: json["text_detail"] == null ? null : json["text_detail"],
        optionPrice: json["option_price"] == null ? null : json["option_price"],
        promotionPrice:
            json["promotion_price"] == null ? null : json["promotion_price"],
        optionStock: json["option_stock"] == null ? null : json["option_stock"],
        img: json["img"] == null ? null : json["img"],
        idLink: json["id_link"] == null ? null : json["id_link"],
        titleOption: json["title_option"] == null ? null : json["title_option"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
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
        "id_pro": idPro == null ? null : idPro,
        "text_detail": textDetail == null ? null : textDetail,
        "option_price": optionPrice == null ? null : optionPrice,
        "promotion_price": promotionPrice == null ? null : promotionPrice,
        "option_stock": optionStock == null ? null : optionStock,
        "img": img == null ? null : img,
        "id_link": idLink == null ? null : idLink,
        "title_option": titleOption == null ? null : titleOption,
      };
}
