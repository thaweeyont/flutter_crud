import 'package:flutter/cupertino.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/detailpromotionmodel.dart';
import 'package:flutter_crud/models/promotionmodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Promotion with ChangeNotifier {
  //ดึงข้อมูล
  List<Promotionmodel> datapromotion = [];
  List<Detailpromotionmodel> detailpromotion = [];
  List listdetail = [];
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  //ข้อมูลโปรโมชั่น
  getpromotion() async {
    var date = formatter.format(now);
    try {
      var respose = await http.get(Uri.http(
        ipconfig_web,
        '/api_mobile/promotion.php',
        {
          "datenow": date.toString(),
        },
      ));
      if (respose.statusCode == 200) {
        // print(respose.body);
        datapromotion = promotionmodelFromJson(respose.body);

        getdetailpromotion();
      }
      notifyListeners();
    } catch (e) {
      print("error ->$e");
    }
  }

  getdetailpromotion() async {
    try {
      var respose = await http
          .get(Uri.http(ipconfig_web, '/api_mobile/detail_promotion.php'));
      if (respose.statusCode == 200) {
        detailpromotion = detailpromotionmodelFromJson(respose.body);
      }
      notifyListeners();
    } catch (e) {
      print("error ->$e");
    }
  }
}
