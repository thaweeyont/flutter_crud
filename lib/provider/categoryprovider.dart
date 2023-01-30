import 'package:flutter/foundation.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:http/http.dart' as http;

class CategoryProvider with ChangeNotifier {
  //ดึงข้อมูล
  List<MainProduct> dataproduct = [];
  bool isloading = true;
  //ข้อมูลสินค้า
  getproduct(offset, id_cate) async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig_web,
          '/api_mobile/product_category_new.php',
          {"id_cate": id_cate, "offset": offset.toString()}));
      print(respose.body);
      if (respose.statusCode == 200) {
        var dataproduct_value = mainProductFromJson(respose.body);
        dataproduct.addAll(dataproduct_value);
      }
    } catch (e) {
      isloading = false;
    }
    notifyListeners();
  }

  //ล้างข้อมูลใน list product
  clear_product() async {
    dataproduct.clear();
  }

  //โหลดข้อมูลเมื่อเลือนสุดจอ
  void myScroll(_scrollControll, offset, id_cate) {
    _scrollControll.addListener(() async {
      double currentScroll = _scrollControll.position.pixels;
      if (_scrollControll.position.pixels ==
          _scrollControll.position.maxScrollExtent) {
        await Future.delayed(const Duration(seconds: 2), () {
          offset = offset + 10;
          getproduct(offset, id_cate);
        });
      }
    });
  }
}
