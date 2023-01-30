import 'package:flutter/material.dart';

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("ติดตามสถานะสินค้า / ตรวจสอบสัญญา ");
  sliderModel.setTitle("ทวียนต์ แทรค......");
  sliderModel.setImageAssetPath("images/into_logo.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel
      .setDesc("เช็คสถานะสินค้า สถานะสัญญาขั้นตอนต่างๆก่อนทำการจัดส่งสินค้า");
  sliderModel.setTitle("เช็คสถานะสินค้า..... ");
  sliderModel.setImageAssetPath("images/illustration1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "เช็คสถานะการจัดส่ง ระยะเวลาการจัดส่งสินค้าเวลาประมาณ แจ้งเตือนการจัดส่ง");
  sliderModel.setTitle("เช็คสถานะการจัดส่ง........");
  sliderModel.setImageAssetPath("images/illustration2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
