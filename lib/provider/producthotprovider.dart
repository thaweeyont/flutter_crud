import 'package:flutter/foundation.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:http/http.dart' as http;

class ProducthotProvider with ChangeNotifier {
  //ดึงข้อมูล
  List<MainProduct> dataproduct_hot = [];
  //ข้อมูลสินค้า
  getproduct_hot() async {
    var respose =
        await http.get(Uri.http(ipconfig_web, '/api_mobile/product_hot.php'));
    if (respose.statusCode == 200) {
      dataproduct_hot = mainProductFromJson(respose.body);
    }
    notifyListeners();
  }

  //ล้างข้อมูลใน list product
  clear_product() async {
    dataproduct_hot.clear();
    notifyListeners();
  }
}
