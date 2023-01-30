import 'package:flutter/foundation.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  //ดึงข้อมูล
  List<MainProduct> dataproduct = [];
  bool isloading = true;
  //ข้อมูลสินค้า
  getproduct(offset) async {
    try {
      isloading = true;
      var respose = await http.get(Uri.http(ipconfig_web,
          '/api_mobile/product.php', {"offset": offset.toString()}));
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
    notifyListeners();
  }

  //โหลดข้อมูลเมื่อเลือนสุดจอ
  void myScroll(_scrollControll, offset) {
    _scrollControll.addListener(() async {
      double currentScroll = _scrollControll.position.pixels;
      if (_scrollControll.position.pixels ==
          _scrollControll.position.maxScrollExtent) {
        await Future.delayed(const Duration(seconds: 1), () {
          offset = offset + 10;
          getproduct(offset);
        });
      }
    });
  }
}
