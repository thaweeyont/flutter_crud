import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/advertmodel.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ControllerProvider with ChangeNotifier {
  //header
  Color backgroundColor = Colors.transparent;
  Color backgroundColorSearch = Colors.white;
  Color ColorIcon = Colors.white;
  double opacity = 0.0;
  double offset = 0.0;
  double opcityMax = 0.01;
  var status_adverts;
  //
  List<Advertmodel> listadvert = [];
  bool isChecked = false;

  //List โฆษณา
  advert(context) async {
    try {
      var respose =
          await http.get(Uri.http(ipconfig_web, '/api_mobile/advert.php'));
      if (respose.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        listadvert = advertmodelFromJson(respose.body);
        status_adverts = preferences.getString('status_advert');
        // print("------------------>$status_adverts");
        await Future.delayed(const Duration(seconds: 3), () {
          if (status_adverts == "true") {
            advert_img(context);
          }
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

  //Widget โฆษณา
  advert_img(context) async {
    double size = MediaQuery.of(context).size.width;
    showAnimatedDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          launch("${listadvert[0].urlLinkName}");
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://www.thaweeyont.com/img/advert/${listadvert[0].imgName}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                color: Colors.white54,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) async {
                          isChecked = false;
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.remove('status_advert');
                          isChecked = value!;
                          if (value == true) {
                            preferences.setString('status_advert', "false");
                          } else {
                            preferences.setString('status_advert', "true");
                          }

                          setState(() {});
                        },
                      ),
                      Text(
                        "ไม่ต้องแสดงอีก",
                        style: MyConstant().normal_text(Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1),
    );
  }

  //header สีการเลื่อนจอ
  onScroll(scrollOffset) async {
    if (scrollOffset > 100) {
      //up
      opacity = double.parse((opacity + 0.03).toStringAsFixed(2));
      if (opacity >= 1.0) {
        opacity = 1.0;
      }
    } else {
      //down
      opacity = double.parse((opacity - opcityMax).toStringAsFixed(2));
      if (opacity <= 0) {
        opacity = 0.0;
      }
    }

    // setState(() {
    if (scrollOffset == 0) {
      backgroundColorSearch = Colors.white;
      ColorIcon = Colors.white;
      opacity = 0.0;
      offset = 0.0;
    } else {
      backgroundColorSearch = Colors.grey.shade200;
      ColorIcon = Colors.red.shade400;
    }

    backgroundColor = Colors.white.withOpacity(opacity);
    // });
    // up_date_page.add(_backgroundColor);
    notifyListeners();
  }

  //เคลีย tabbar
  clear_tabbar() async {
    backgroundColor = Colors.transparent;
    backgroundColorSearch = Colors.white;
    ColorIcon = Colors.white;
    opacity = 0.0;
    offset = 0.0;
    opcityMax = 0.01;
  }
}
