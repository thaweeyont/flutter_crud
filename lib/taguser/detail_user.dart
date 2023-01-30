import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/address_installmodel.dart';
import 'package:flutter_crud/models/address_usermodel.dart';
import 'package:flutter_crud/models/getdatausermodel.dart';
import 'package:flutter_crud/models/jobmechanic.dart';
import 'package:flutter_crud/models/product_detail.dart';
import 'package:flutter_crud/models/user_documentmodel.dart';
import 'package:flutter_crud/widget/show_progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class DetailUser extends StatefulWidget {
  var st = 1;
  final String id_job_gen, idproduct, time_install, id_mechanic_staff;
  DetailUser(this.id_job_gen, this.idproduct, this.time_install,
      this.id_mechanic_staff);

  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  var status,
      index = 0,
      indexjob = 0,
      val_id_card_Checked,
      val_id_card_guarantor_Checked,
      val_home_Checked,
      val_home_guarantor_Checked,
      val_income_document,
      phone_staff_credit,
      lat,
      lng,
      isSwitched = false,
      fullname_sale,
      fullname_credit,
      fullname_mechanic,
      status_job_mechanic,
      step_sw = 0,
      active = 0,
      active_mec = 0,
      ary = 0,
      st_data = 0,
      id_st_p;
  int check_function = 0;
  double? a_lat, a_lng;
  List<AddressInstall> data_address = [];
  List<GetDataUser> datauser = [];
  List<GetDataProduct> dataproduct = [];
  List<UserDocument> user_document = [];
  List<Jobmechanic> job_mechanic = [];
  List show_st_pd = [];
  List show_st_pdc = [];
  var show_st_date;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // print('=======>>>>>>${widget.id_mechanic_staff}');
    super.initState();
    // CheckPermission();
    _get_user_document();
    _getdata_product();
    _getdata();
  }

//เช็คการขอสิทใช้ gps
  Future<Null> CheckPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          // Find LatLong
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          // Find LatLong
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      alertLocationService(
          context, 'Location ปิดอยู่?', 'กรุณาเปิด Location ด้วยคะ');
    }
  }

//ดึง lat / lng ปัจจุบัน
  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      a_lat = position!.latitude;
      a_lng = position.longitude;

      print('a_lat = $a_lat, a_lng = $a_lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

//Api แก้ไขสถานที่ติดตั้งสินค้า
  Future edit_location() async {
    if (lat.toString().isNotEmpty && lng.toString().isNotEmpty) {
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/edit_location.php");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['id_job_gen'] = widget.id_job_gen;
      request.fields['lat'] = lat.toString();
      request.fields['lng'] = lng.toString();
      var response = await request.send();
      if (response.statusCode == 200) {
        print("แก้ไขข้อมูลสำเร็จ");
        successDialog('แจ้งเตือน', 'แก้ไขสถานที่ติดตั้งสำเร็จ');
      } else {
        print("แก้ไขไม่สำเร็จ");
      }
    } else {
      print("lat/lng => null");
    }
  }

//Api เพิ่มสถานที่ติดตั้ง
  Future add_location() async {
    if (a_lat.toString().isNotEmpty && a_lng.toString().isNotEmpty) {
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/edit_location.php");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['id_job_gen'] = widget.id_job_gen;
      request.fields['lat'] = a_lat.toString();
      request.fields['lng'] = a_lng.toString();
      var response = await request.send();
      if (response.statusCode == 200) {
        print("แก้ไขข้อมูลสำเร็จ");
        _getdata();
        successDialog('แจ้งเตือน', 'เพิ่มสถานที่ติดตั้งสำเร็จ');
      } else {
        print("แก้ไขไม่สำเร็จ");
      }
    } else {
      print("lat/lng => null");
    }
  }

//เรียกใช้ api แสดง การขอเอกสารเพิ่ม
  Future<Null> _get_user_document() async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig,
          '/flutter_api/api_user/get_user_document.php',
          {"id_gen_job": widget.id_job_gen}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        print("มีข้อมูล");
        setState(() {
          user_document = userDocumentFromJson(respose.body);
          val_id_card_Checked = user_document[0].idCardChecked;
          val_id_card_guarantor_Checked =
              user_document[0].idCardGuarantorChecked;
          val_home_Checked = user_document[0].homeChecked;
          val_home_guarantor_Checked = user_document[0].idCardGuarantorChecked;
          val_income_document = user_document[0].incomeDocument;
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

//เช็คสถานะสินค้าเมื่อช่างรับงานติดตั้ง
  Future<Null> _get_job_mechanic() async {
    print("========>${widget.id_job_gen}");
    try {
      var respose = await http.get(
          Uri.http(ipconfig, '/flutter_api/api_user/get_jbo_mechanic.php', {
        "id_gen_job": widget.id_job_gen,
        "id_staff": widget.id_mechanic_staff,
      }));
      print(respose.body);
      if (respose.statusCode == 200) {
        // print("มีข้อมูล");
        setState(() {
          show_st_pd = [];
          show_st_pdc = [];
          job_mechanic = jobmechanicFromJson(respose.body);
          for (int countt = 0; countt < job_mechanic.length; countt++) {
            if (job_mechanic[0].idStaff == job_mechanic[countt].idStaff) {
              check_function = (check_function + 1);
            }
          }
          // print(" ---------------------->>>> $check_function");
          if (check_function <= 1) {
            for (int name_st = 0; name_st < job_mechanic.length; name_st++) {
              if (job_mechanic[name_st].idProduct == widget.idproduct) {
                ary = name_st;
                status_job_mechanic = job_mechanic[name_st].statusData;
                fullname_mechanic = job_mechanic[name_st].fullnameStaff;
                var st = job_mechanic[name_st].statusData;
                st_data = int.parse(st!);
                id_st_p = job_mechanic[name_st].idStaff;
              }
              if (id_st_p == job_mechanic[name_st].idStaff &&
                  DateFormat('dd/MM/y').format(job_mechanic[name_st].datePd!) ==
                      widget.time_install) {
                show_st_pd.add(job_mechanic[name_st].idProduct);
                show_st_pdc.add(job_mechanic[name_st].machineCode);
                show_st_date = job_mechanic[name_st].datePd;
                // print(show_st_date);
              }
            }
          } else {
            for (int name_st = 0; name_st < job_mechanic.length; name_st++) {
              if (DateFormat('d/MM/y').format(job_mechanic[name_st].datePd!) ==
                  widget.time_install) {
                ary = name_st;
                status_job_mechanic = job_mechanic[name_st].statusData;
                fullname_mechanic = job_mechanic[name_st].fullnameStaff;
                var st = job_mechanic[name_st].statusData;
                st_data = int.parse(st!);
                // print(job_mechanic[name_st].idStaff);
                id_st_p = job_mechanic[name_st].idStaff;
                if (id_st_p == job_mechanic[name_st].idStaff &&
                    DateFormat('d/MM/y')
                            .format(job_mechanic[name_st].datePd!) ==
                        widget.time_install) {
                  show_st_pd.add(job_mechanic[name_st].idProduct);
                  show_st_pdc.add(job_mechanic[name_st].machineCode);
                  show_st_date = job_mechanic[name_st].datePd;
                }
              }

              print(status_job_mechanic);
            }
          }
        });
        // print("${job_mechanic[0].idProduct}");
        case_job_mechanic();
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

//Api แสดงข้อมูล ลูกค้า และ job
  Future<void> _getdata() async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig,
          '/flutter_api/api_user/get_data_user.php',
          {"idjobgen": widget.id_job_gen}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datauser = getDataUserFromJson(respose.body);
          data_addressuser(datauser[0].idJobHead);
          st_data = 1;
          status = datauser[0].statusJob;
          lat = datauser[0].latJob;
          lng = datauser[0].lngJob;
          for (var i = 0; i < datauser.length; i++) {
            print("=========>$i");
            if (datauser[i].statusStaff == "2") {
              phone_staff_credit = datauser[i].phoneStaff;
              fullname_credit = datauser[i].fullnameStaff;
            }
            if (datauser[i].statusStaff == "1") {
              fullname_sale = datauser[i].fullnameStaff;
            }
            // if (datauser[i].statusStaff == "3") {
            //   fullname_mechanic = datauser[i].fullnameStaff;
            // }
          }
          if (datauser[0].statusJob == "8" ||
              datauser[0].statusJob == "7" ||
              datauser[0].statusJob == "9" ||
              datauser[0].statusJob == "5") {
            _get_job_mechanic();
          }
        });
        if (datauser[0].latJob == null || datauser[0].latJob!.isEmpty) {
          Dialog('แจ้งเตือน', 'กรุณาเพิ่มสถานที่ติดตั้ง');
        }
        case_status();
        if (datauser[0].statusJob == "8") {
        } else {
          aboutNotification();
        }
      }
    } catch (e) {}
  }

//Api แสดงสถานที่ติดตั้ง
  Future<void> data_addressuser(idjob) async {
    try {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/address_install.php',
            {"idjob": idjob}),
      );
      print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          data_address = addressInstallFromJson(respose.body);
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

//Api แสดงข้อมูล สินค้า
  Future<void> _getdata_product() async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig,
          '/flutter_api/api_user/get_data_product.php',
          {"idjobgen": widget.id_job_gen}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          dataproduct = getDataProductFromJson(respose.body);
        });
        // print("${dataproduct[0].idProduct}");
        case_status();
      }
    } catch (e) {
      // print("ไม่มีข้อมูล");
    }
  }

// case เช็คสถานะ
  Future<Null> case_status() async {
    switch (status) {
      case "2":
        setState(() {
          index = 0;
          active = 1;
        });
        break;
      case "3":
        setState(() {
          if (user_document.isNotEmpty) {
            index = 2;
            active = 3;
          } else {
            active = 2;
            step_sw = 1;
            index = 1;
          }
        });
        break;
      case "4":
        setState(() {
          active = 4;
          index = 3;
        });
        break;
      case "6":
        setState(() {
          active = 4;
          index = 3;
        });
        break;
    }
  }

// case เช็ค สถานะสิค้า ช่างติดตั้ง
  Future<Null> case_job_mechanic() async {
    switch (status_job_mechanic) {
      case "2":
        setState(() {
          indexjob = 0;
          active_mec = 1;
        });
        break;
      case "3":
        setState(() {
          indexjob = 1;
          active_mec = 2;
        });
        break;
      case "4":
        setState(() {
          indexjob = 2;
          active_mec = 3;
        });
        break;
      case "5":
        setState(() {
          indexjob = 3;
          active_mec = 4;
        });
        break;
      case "6":
        setState(() {
          indexjob = 4;
          active_mec = 5;
        });
        // score_Dialog();
        break;
    }
  }

//แสดงแผนที่
  Future<Null> showmap(double size) async {
    LocationPermission locationPermission;
    locationPermission = await Geolocator.requestPermission();
    bool btn_edit = false;
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black12,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // SizedBox(
                            //   height: size * 0.03,
                            // ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "สถานที่ติดตั้งสินค้า",
                                        style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 10.sp,
                                          color: Colors.red[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                            print(isSwitched);
                                          });
                                        },
                                        activeTrackColor: Colors.lightBlue[200],
                                        activeColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                            offset:
                                                Offset(0, 0), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: size * 0.04,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                              ),
                              height: size * 1.3,
                              // color: Colors.amber,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: GoogleMap(
                                  myLocationEnabled:
                                      datauser[0].statusJob == "8" &&
                                              st_data >= 2
                                          ? false
                                          : true,
                                  mapType: isSwitched == false
                                      ? MapType.normal
                                      : MapType.hybrid,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(double.parse('$lat'),
                                        double.parse('$lng')),
                                    zoom: 18,
                                  ),
                                  onMapCreated: (controller) async {},
                                  gestureRecognizers: Set()
                                    ..add(Factory<EagerGestureRecognizer>(
                                        () => EagerGestureRecognizer())),
                                  markers: <Marker>[
                                    Marker(
                                      markerId: MarkerId('id'),
                                      position: LatLng(double.parse('$lat'),
                                          double.parse('$lng')),
                                      infoWindow: InfoWindow(
                                          title: 'สถานที่ติดตั้ง',
                                          snippet: 'Lat = $lat , lng = $lng'),
                                    ),
                                  ].toSet(),
                                  onTap: (argument) {
                                    if (datauser[0].statusJob == "8" &&
                                        st_data >= 2) {
                                    } else {
                                      setState(() {
                                        lat = argument.latitude;
                                        lng = argument.longitude;
                                        btn_edit = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (btn_edit == true) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      edit_location();
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "แก้ไข",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 10.sp,
                                            color: Colors.yellowAccent[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "ยกเลิก",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 10.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      animationType: DialogTransitionType.slideFromRightFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

//เพิ่มสถานที่ติดตั้งหากไม่มี
  Future<Null> add_map() async {
    double size = MediaQuery.of(context).size.width;
    // bool btn_edit = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "บันทึกสถานที่ติดตั้งสินค้า",
                                      style: TextStyle(
                                        fontFamily: 'Prompt',
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          print(isSwitched);
                                        });
                                      },
                                      activeTrackColor: Colors.lightBlue[200],
                                      activeColor: Colors.blue,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            height: size * 1.3,
                            width: double.infinity,
                            child: a_lat == null
                                ? ShowProgress()
                                : GoogleMap(
                                    myLocationEnabled: true,
                                    mapType: isSwitched == false
                                        ? MapType.normal
                                        : MapType.hybrid,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(a_lat!, a_lng!),
                                      zoom: 18,
                                    ),
                                    onMapCreated: (controller) async {},
                                    gestureRecognizers: Set()
                                      ..add(Factory<EagerGestureRecognizer>(
                                          () => EagerGestureRecognizer())),
                                    markers: <Marker>[
                                      Marker(
                                        markerId: MarkerId('id'),
                                        position: LatLng(a_lat!, a_lng!),
                                        infoWindow: InfoWindow(
                                            title: 'สถานที่ติดตั้ง',
                                            snippet:
                                                'Lat = $a_lat , lng = $a_lng'),
                                      ),
                                    ].toSet(),
                                    onTap: (argument) {
                                      setState(() {
                                        a_lat = argument.latitude;
                                        a_lng = argument.longitude;
                                      });
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  add_location();
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    Text(
                                      "เพิ่ม",
                                      style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 16,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Notification
  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print("ANDROID");

      FirebaseMessaging.onMessage.listen((message) async {
        // RemoteNotification? notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        // var sss = notification!.body;
        // print("ทดสอบ ---------> 1");
        // successDialog('แจ้งเตือน', 'สถานะมีการอัปเดท');
        _get_user_document();
        _get_user_document();
        _getdata_product();
        _getdata();
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        // print('Noti onmessage ==>${message.toString()}');
        // print("ทดสอบ ---------> 2");
        _get_user_document();
        _get_user_document();
        _getdata_product();
        _getdata();
      });

      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } else if (Platform.isIOS) {
      print("IOS");
    }
  }

//dialog notification
  Future<Null> successDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('images/success.png'),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            message,
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
        ),
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Text(
                    "ตกลง",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

//dialog no_map
  Future<Null> Dialog(String title, String message) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_pin.gif'),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            message,
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
        ),
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (a_lat != null) {
                  add_map();
                } else {
                  findLatLng();
                }
              },
              child: Column(
                children: [
                  Text(
                    "ตกลง",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return a_lat == null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: a_lat == null
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17.sp,
                    color: Colors.red[700],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17.sp,
                    color: Colors.red[700],
                  ),
                  onPressed: () {
                    if (a_lat != null) {
                      Navigator.of(context).pop();
                    }
                  }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // Color.fromRGBO(230, 185, 128, 1),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(238, 208, 110, 1),
                  Color.fromRGBO(250, 227, 152, 0.9),
                  Color.fromRGBO(212, 163, 51, 0.8),
                  Color.fromRGBO(250, 227, 152, 0.9),
                  Color.fromRGBO(164, 128, 44, 1),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
          ),
          title: Text(
            "รายละเอียดสินค้า",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
        ),
        body: datauser.isEmpty
            ? WillPopScope(
                child: Center(child: CircularProgressIndicator()),
                onWillPop: () async {
                  return false;
                },
              )
            : Column(
                children: [
                  // if ((datauser[0].statusJob == "5" ||
                  //       datauser[0].statusJob == "7" ||
                  //       st_data < 2) &&
                  //   status_job_mechanic != "7") ...[
                  // if (datauser[0].statusJob != "6" &&
                  //     datauser[0].statusJob != "4")
                  if ((datauser[0].statusJob == "5" ||
                          datauser[0].statusJob == "7") &&
                      status_job_mechanic != "7" &&
                      datauser[0].statusJob != "2" &&
                      datauser[0].statusJob != "3" &&
                      st_data <= 2) ...[
                    if (datauser[0].statusJob != "6" &&
                        datauser[0].statusJob != "4") ...[
                      cash(size),
                    ],
                  ] else ...[
                    tapbar(size),
                  ],
                  Expanded(
                    child: SafeArea(
                      child: Scrollbar(
                        radius: Radius.circular(30),
                        thickness: 1.2.w,
                        // isAlwaysShown: true,
                        // showTrackOnHover: true,
                        child: RefreshIndicator(
                          strokeWidth: 2.0,
                          edgeOffset: 0.10,
                          displacement: 10,
                          backgroundColor: Colors.white,
                          color: Color.fromRGBO(230, 185, 128, 1),
                          onRefresh: () async {
                            _get_user_document();
                            _getdata_product();
                            // _getdata();
                          },
                          child: SingleChildScrollView(
                            //ตัวทำยืด
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Column(
                              children: [
                                if (st_data == 0) ...[
                                  load(size)
                                ] else ...[
                                  if (datauser[0].statusJob == "8") ...[
                                    if (job_mechanic.isNotEmpty) ...[
                                      if (st_data >= 2) ...[
                                        SizedBox(
                                          width: double.infinity,
                                          height: 2.h,
                                          child: const DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFAFAFA)),
                                          ),
                                        ),
                                        timest_end(size),
                                      ],
                                    ],
                                  ],
                                  if (datauser[0].statusJob == "4" ||
                                      datauser[0].statusJob == "6") ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 2.h,
                                      child: const DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFAFAFA)),
                                      ),
                                    ),
                                    contractstatus(size),
                                  ],
                                  if (user_document.isNotEmpty &&
                                      datauser[0].statusJob == "3") ...[
                                    if (val_id_card_Checked == "false" &&
                                        val_id_card_guarantor_Checked ==
                                            "false" &&
                                        val_home_Checked == "false" &&
                                        val_home_guarantor_Checked == "false" &&
                                        val_income_document == "false")
                                      ...[]
                                    else ...[
                                      SizedBox(
                                        width: double.infinity,
                                        height: 2.h,
                                        child: const DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFAFAFA)),
                                        ),
                                      ),
                                      adddocument(),
                                    ],
                                  ],
                                  SizedBox(
                                    width: double.infinity,
                                    height: 2.h,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFAFAFA)),
                                    ),
                                  ),
                                  showdata_user(size),
                                  // if (dataproduct.isNotEmpty) ...[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 2.h,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFAFAFA)),
                                    ),
                                  ),
                                  showdata_product(size),
                                  // ],
                                  if (fullname_sale.toString().isNotEmpty ||
                                      fullname_credit.toString().isNotEmpty ||
                                      fullname_sale != null ||
                                      fullname_credit != null) ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 2.h,
                                      child: const DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFAFAFA)),
                                      ),
                                    ),
                                    showdata_staff(size),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // tapbar
  Widget tapbar(double size) => Stack(
        children: [
          Positioned(
            // top: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                gradient: LinearGradient(
                    colors: [
                      // const Color.fromRGBO(230, 185, 128, 1),
                      // const Color.fromRGBO(234, 205, 163, 1),
                      Color.fromRGBO(238, 208, 110, 1),
                      Color.fromRGBO(250, 227, 152, 0.9),
                      Color.fromRGBO(212, 163, 51, 0.8),
                      Color.fromRGBO(250, 227, 152, 0.9),
                      Color.fromRGBO(164, 128, 44, 1),
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                    // stops: [0.0, 1.0],
                    tileMode: TileMode.mirror),
              ),
              width: size,
              height: size * 0.20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 5,
                left: 20,
                right: 20,
                top: MediaQuery.of(context).size.width * 0.05),
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((datauser[0].statusJob == "9" ||
                          datauser[0].statusJob == "7" ||
                          datauser[0].statusJob == "8" ||
                          datauser[0].statusJob == "5") &&
                      status_job_mechanic == "7") ...[
                    buildStepIndicator_install_history(size),
                  ] else ...[
                    if (datauser[0].statusJob == "8" || st_data >= 2) ...[
                      buildStepIndicator_install(size),
                    ] else ...[
                      buildStepIndicator(size),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      );

  //เมื่ออยู่ในสถานะสินเชื่อตรวจสอบ
  Widget buildStepIndicator(size) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 15,
            ),
            child: Text(
              "สถานะการตรวจสอบ",
              style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 7.0),
                  child: StepsIndicator(
                    //widget ในปุ่มที่ selectไปแล้ว
                    doneStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 2.w,
                        color: Colors.white,
                      ),
                    ),
                    //widget ในปุ่มที่เลือก อยุ๋
                    selectedStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 2.w,
                        color: Colors.white,
                      ),
                    ),
                    enableStepAnimation: true, // อนิเมชั่น
                    undoneLineColor:
                        Colors.grey.shade300, //สีเส้นที่ไม่ได้ select
                    unselectedStepColorIn:
                        Colors.grey.shade300, //สีปุ่มที่ไม้ได้ select
                    unselectedStepColorOut:
                        Colors.grey.shade300, //สีเส้นที่ไม้ได้ select
                    selectedStepColorOut:
                        Colors.red.shade400, //สีเส้นที่เลือก อยู่
                    selectedStepColorIn:
                        Colors.red.shade400, //สีปุ่มที่เลือก อยู่
                    doneStepColor: Colors.red.shade400, //สีปุ่มที่ selectไปแล้ว
                    doneLineColor: Colors.red.shade400, //สีเส้นที่ selectไปแล้ว
                    doneStepSize: 2.w, //ขนาดปุ่ม
                    doneLineThickness: size * 0.005, //ขนาดเส้น
                    lineLength: 19.w,
                    selectedStep: index,
                    nbSteps: 4,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "รอดำเนินการ",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 9.sp,
                        color: active == 1 ? Colors.red[400] : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "ตรวจสอบ",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 9.sp,
                        color: active == 2 ? Colors.red[400] : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "ขอเอกสาร",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 9.sp,
                        color: active == 3 ? Colors.red[400] : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "เสร็จสิ้น",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 9.sp,
                        color: active == 4 ? Colors.red[400] : Colors.grey[500],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );

  //ผ่านสัญญา / ไม่ผ่านสัญญา
  Widget contractstatus(double size) => Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              color: datauser[0].statusJob == "4"
                  ? Colors.green[400]
                  : Colors.orange[300],
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (datauser[0].statusJob == "4") ...[
                      Text(
                        "สัญญาผ่าน",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        " รอดำเนินการถัดไป",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      )
                    ] else ...[
                      Text(
                        "ไม่เข้าเงื่อนไขตามที่บริษัทกำหนด",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  //แจ้งเตื่อนขอเอกสารเพิ่มเติม
  Widget adddocument() => Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "หมายเหตุ! / ฝ่ายสินเชื่อ",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    launch("tel://$phone_staff_credit");
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "ขอเอกสารเพิ่มเติม",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                    if (val_id_card_Checked == "true") ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "- สำเนาบัตรประชาชนผู้ซื้อ",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    if (val_home_Checked == "true") ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "- สำเนาทะเบียนบ้านผู้ซื้อ",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    if (val_id_card_guarantor_Checked == "true") ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "- สำเนาบัตรประชาชนผู้ค้ำประกัน",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    if (val_home_guarantor_Checked == "true") ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "- สำเนาทะเบียนบ้านผู้ค้ำประกัน",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    if (val_income_document == "true") ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "- เอกสารแสดงรายได้ผู้เช่าซื้อ (ถ้ามี)",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ],
                ))
          ],
        ),
      );

  //แสดงข้อมูลผู้สั่ง
  Widget showdata_user(double size) => Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 6.w,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "ชื่อผู้รับสินค้า",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      // ปุ่มแสดงแผนที่ติดตั้งสินค้า
                      // InkWell(
                      //   onTap: () {
                      //     if (datauser[0].latJob == null ||
                      //         datauser[0].latJob == "") {
                      //       add_map();
                      //     } else {
                      //       showmap(size);
                      //     }
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(8),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(30),
                      //       ),
                      //       color: Colors.white,
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey,
                      //           blurRadius: 2,
                      //           offset: Offset(0, 0), // Shadow position
                      //         ),
                      //       ],
                      //     ),
                      //     child: Column(
                      //       children: [
                      //         Icon(
                      //           Icons.map_outlined,
                      //           color: Colors.red,
                      //           size: 4.w,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Row(
                      children: [
                        Text(
                          "${datauser[0].fullname}",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop,
                        size: 6.w,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "ที่อยู่จัดส่ง",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: data_address.isEmpty
                              ? Text("loading....")
                              : Text(
                                  "${data_address[0].addressDeliver} ต.${data_address[0].nameDistricts} อ.${data_address[0].nameAmphures} จ.${data_address[0].nameProvinces} ${data_address[0].zipCode}",
                                  style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.call,
                        size: 6.w,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "เบอร์โทรผู้รับสินค้า",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${datauser[0].phoneUser}",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  //แสดงข้อมูลสินค้า
  Widget showdata_product(size) => Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        size: 6.w,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "ข้อมูลสินค้า",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  if ((datauser[0].statusJob == "9" ||
                          datauser[0].statusJob == "7" ||
                          datauser[0].statusJob == "5") &&
                      status_job_mechanic == "7") ...[
                    product_install(size),
                  ] else ...[
                    if (job_mechanic.toString().isNotEmpty &&
                        job_mechanic != null &&
                        datauser[0].statusJob == "8" &&
                        st_data >= 2) ...[
                      product_install(size),
                    ] else ...[
                      product_wait(size),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      );

  //โหลดข้อมูล
  Widget load(double size) => Container(
        width: double.infinity,
        // height: size * 1.50,
        child: ShowProgress(),
      );

  //ข้อมูลพนักงาน
  Widget showdata_staff(size) => Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 6.w,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "ข้อมูลพนักงาน",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fullname_sale.toString().isNotEmpty &&
                      fullname_sale != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "พนักงานขาย  ",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "$fullname_sale",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                        child: new Divider()),
                  ],
                  if (fullname_credit.toString().isNotEmpty &&
                      fullname_credit != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "พนักงานสินเชื่อ  ",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "$fullname_credit",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                        child: new Divider()),
                  ],
                  if (job_mechanic.toString().isNotEmpty &&
                      job_mechanic != null &&
                      datauser[0].statusJob == "8" &&
                      st_data >= 2) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "ช่างติดตั้ง  ",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "$fullname_mechanic",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if ((datauser[0].statusJob == "9" ||
                          datauser[0].statusJob == "7" ||
                          datauser[0].statusJob == "5") &&
                      status_job_mechanic == "7") ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "ช่างติดตั้ง  ",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "$fullname_mechanic",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );

  //สถานะซื้อเงินสด
  Widget cash(double size) => Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [],
              ),
            ),
            Container(
              color: Colors.green[300],
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " รอดำเนินการถัดไป",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.033,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  //สถานะเมื่อส่งสินค้า
  Widget buildStepIndicator_install(size) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 15,
            ),
            child: Text(
              "สถานะสินค้า",
              style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 7.0),
                  child: StepsIndicator(
                    //widget ในปุ่มที่ selectไปแล้ว
                    doneStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 2.w,
                        color: Colors.white,
                      ),
                    ),
                    //widget ในปุ่มที่เลือก อยุ๋
                    selectedStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 2.w,
                        color: Colors.white,
                      ),
                    ),
                    enableStepAnimation: true, // อนิเมชั่น
                    undoneLineColor:
                        Colors.grey.shade300, //สีเส้นที่ไม่ได้ select
                    unselectedStepColorIn:
                        Colors.grey.shade300, //สีปุ่มที่ไม้ได้ select
                    unselectedStepColorOut:
                        Colors.grey.shade300, //สีเส้นที่ไม้ได้ select
                    selectedStepColorOut:
                        Colors.red.shade400, //สีเส้นที่เลือก อยู่
                    selectedStepColorIn:
                        Colors.red.shade400, //สีปุ่มที่เลือก อยู่
                    doneStepColor: Colors.red.shade400, //สีปุ่มที่ selectไปแล้ว
                    doneLineColor: Colors.red.shade400, //สีเส้นที่ selectไปแล้ว
                    doneStepSize: size * 0.02, //ขนาดปุ่ม
                    doneLineThickness: size * 0.005, //ขนาดเส้น
                    lineLength: size * 0.16,
                    selectedStep: indexjob,
                    nbSteps: 5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "รับงาน",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 1
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "เตรียมอุปกรณ์",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 2
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "กำลังจัดส่ง",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 3
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "ติดตั้งสินค้า",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 4
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "เสร็จสิ้น",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 5
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );

  //ประวัติ
  Widget buildStepIndicator_install_history(size) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 15,
            ),
            child: Text(
              "สถานะสินค้า",
              style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: size * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 7.0),
                  child: StepsIndicator(
                    //widget ในปุ่มที่ selectไปแล้ว
                    doneStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: size * 0.02,
                        color: Colors.white,
                      ),
                    ),
                    //widget ในปุ่มที่เลือก อยุ๋
                    selectedStepWidget: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red.shade400,
                      ),
                      child: Icon(
                        Icons.check,
                        size: size * 0.02,
                        color: Colors.white,
                      ),
                    ),
                    enableStepAnimation: true, // อนิเมชั่น
                    undoneLineColor:
                        Colors.grey.shade300, //สีเส้นที่ไม่ได้ select
                    unselectedStepColorIn:
                        Colors.grey.shade300, //สีปุ่มที่ไม้ได้ select
                    unselectedStepColorOut:
                        Colors.grey.shade300, //สีเส้นที่ไม้ได้ select
                    selectedStepColorOut:
                        Colors.red.shade400, //สีเส้นที่เลือก อยู่
                    selectedStepColorIn:
                        Colors.red.shade400, //สีปุ่มที่เลือก อยู่
                    doneStepColor: Colors.red.shade400, //สีปุ่มที่ selectไปแล้ว
                    doneLineColor: Colors.red.shade400, //สีเส้นที่ selectไปแล้ว
                    doneStepSize: size * 0.02, //ขนาดปุ่ม
                    doneLineThickness: size * 0.005, //ขนาดเส้น
                    lineLength: size * 0.16,
                    selectedStep: 5,
                    nbSteps: 5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "รับงาน",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 1
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "เตรียมอุปกรณ์",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 2
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "กำลังจัดส่ง",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 3
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "ติดตั้งสินค้า",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 4
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                    Text(
                      "เสร็จสิ้น",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: size * 0.025,
                        color: active_mec == 5
                            ? Colors.red[400]
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );

  //เวลารับสินค้า
  Widget timest_end(size) => Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 0,
                  offset: Offset.zero)
            ]),
        child: Container(
          // padding: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ช่างจะเดินทางไปถึงเวลาประมาณ ${job_mechanic[ary].timeStart} - ${job_mechanic[ary].timeEnd} น.",
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 10.sp,
                  // fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ),
      );

  Widget success_product() => Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.green[300],
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: Text(
          "ติดตั้งครบแล้ว",
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

  Widget process_product() => Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.grey[400],
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: Text(
          "รอดำเนินการติดตั้ง",
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

  Widget await_product() => Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.amber[400],
          boxShadow: [
            BoxShadow(
              color: Colors.amber,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: Text(
          "ดำเนินการ",
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

  //แสดงสินค้าที่จัดส่ง
  Widget product_install(size) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int p = 0; p < dataproduct.length; p++) ...[
            // if (dataproduct[p].productStatus != "2") ...[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     // success_product(),
            //     if (job_mechanic.toString().isNotEmpty &&
            //         job_mechanic != null &&
            //         datauser[0].statusJob == "8" &&
            //         st_data >= 2) ...[
            //       success_product(),
            //     ] else ...[
            //       if (int.parse(datauser[0].statusJob!) <= 7) ...[
            //         process_product(),
            //       ],
            //       if (int.parse(datauser[0].statusJob!) == 8) ...[
            //         await_product(),
            //       ],
            //     ],

            //     // process_product(),
            //     // await_product(),
            //   ],
            // ),
            for (var i = 0; i < show_st_pd.length; i++) ...[
              if (show_st_pd[i] == dataproduct[p].idProduct) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "หมายเลขเครื่อง  ",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${show_st_pdc[i]}",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "ประเภทสินค้า  ",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${dataproduct[p].productType}",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "แบรนด์สินค้า  ",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${dataproduct[p].productBrand}",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "ข้อมูลสินค้า",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${dataproduct[p].productDetail}",
                              style: TextStyle(
                                fontFamily: 'Prompt',
                                fontSize: 10.sp,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "ประเภทสัญญา  ",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "เงิน${dataproduct[p].productTypeContract}",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "x 1",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                    child: new Divider()),
              ],
            ],
          ],
        ],
        // ],
      );
  //แสดงสินค้าที่ซื้อ
  Widget product_wait(size) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int p = 0; p < dataproduct.length; p++) ...[
            // if (dataproduct[p].productPrice == "0") ...[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       success_product(),
            //     ],
            //   )
            // ] else ...[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       process_product(),
            //     ],
            //   ),
            // ],
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    "ประเภทสินค้า  ",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    "${dataproduct[p].productType}",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 10.sp,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    "แบรนด์สินค้า  ",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    "${dataproduct[p].productBrand}",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 10.sp,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "ข้อมูลสินค้า",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${dataproduct[p].productDetail}",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "ประเภทสัญญา  ",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "เงิน${dataproduct[p].productTypeContract}",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      // if (dataproduct[p].productPrice != "" &&
                      //     dataproduct[p].productPrice != "0") ...[
                      //   Text(
                      //     "x ${dataproduct[p].productPrice}",
                      //     style: TextStyle(
                      //       fontFamily: 'Prompt',
                      //       fontSize: 14,
                      //       color: Colors.grey[600],
                      //     ),
                      //   ),
                      // ] else ...[
                      Text(
                        "x ${dataproduct[p].productCount}",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    // ],
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                child: new Divider()),
          ],
        ],
        // ],
      );
}

//  if ((datauser[0].statusJob == "5" ||
//                           datauser[0].statusJob == "7") &&
//                       status_job_mechanic != "7") ...[
//                     if (datauser[0].statusJob != "6" &&
//                         datauser[0].statusJob != "4") ...[
//                       cash(size),
//                     ],
//                   ] else ...[
//                     tapbar(size),
//                   ],



  // //แสดงข้อมูลสินค้า
  // Widget showdata_product() => Container(
  //       padding:
  //           EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
  //       width: double.infinity,
  //       color: Colors.white,
  //       child: Column(
  //         children: [
  //           Container(
  //             margin: EdgeInsets.only(bottom: 10.0),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.shopping_cart_rounded,
  //                       color: Colors.red,
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       "ข้อมูลสินค้า",
  //                       style: TextStyle(
  //                         fontFamily: 'Prompt',
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey[700],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(bottom: 10.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 for (int p = 0; p < dataproduct.length; p++) ...[
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       // if (status_job_mechanic == "6") ...[
  //                       //   Container(
  //                       //     padding: EdgeInsets.all(2.0),
  //                       //     decoration: BoxDecoration(
  //                       //       borderRadius: BorderRadius.all(
  //                       //         Radius.circular(5),
  //                       //       ),
  //                       //       color: Colors.green[300],
  //                       //       boxShadow: [
  //                       //         BoxShadow(
  //                       //           color: Colors.green,
  //                       //           offset: Offset(0, 0), // Shadow position
  //                       //         ),
  //                       //       ],
  //                       //     ),
  //                       //     child: Text(
  //                       //       "ติดตั้งแล้ว",
  //                       //       style: TextStyle(
  //                       //         fontFamily: 'Prompt',
  //                       //         fontSize: 12,
  //                       //         color: Colors.white,
  //                       //       ),
  //                       //     ),
  //                       //   )
  //                       // ] else ...[
  //                       //   if (job_mechanic.isNotEmpty) ...[
  //                       //     if (check_function <= 1) ...[
  //                       //       if (job_mechanic[p].idProduct ==
  //                       //           widget.idproduct) ...[
  //                       //         Container(
  //                       //           padding: EdgeInsets.all(2.0),
  //                       //           decoration: BoxDecoration(
  //                       //             borderRadius: BorderRadius.all(
  //                       //               Radius.circular(5),
  //                       //             ),
  //                       //             color: Colors.amber[200],
  //                       //             boxShadow: [
  //                       //               BoxShadow(
  //                       //                 color: Colors.amber,
  //                       //                 offset: Offset(0, 0), // Shadow position
  //                       //               ),
  //                       //             ],
  //                       //           ),
  //                       //           child: Text(
  //                       //             "ดำเนินการ",
  //                       //             style: TextStyle(
  //                       //               fontFamily: 'Prompt',
  //                       //               fontSize: 12,
  //                       //               color: Colors.grey[600],
  //                       //             ),
  //                       //           ),
  //                       //         )
  //                       //       ] else ...[
  //                       //         if (dataproduct[p].productStatus == "1") ...[
  //                       //           Container(
  //                       //             padding: EdgeInsets.all(2.0),
  //                       //             decoration: BoxDecoration(
  //                       //               borderRadius: BorderRadius.all(
  //                       //                 Radius.circular(5),
  //                       //               ),
  //                       //               color: Colors.grey[200],
  //                       //               boxShadow: [
  //                       //                 BoxShadow(
  //                       //                   color: Colors.grey,
  //                       //                   offset:
  //                       //                       Offset(0, 0), // Shadow position
  //                       //                 ),
  //                       //               ],
  //                       //             ),
  //                       //             child: Text(
  //                       //               "รอติดตั้งสินค้า",
  //                       //               style: TextStyle(
  //                       //                 fontFamily: 'Prompt',
  //                       //                 fontSize: 12,
  //                       //                 color: Colors.grey[700],
  //                       //               ),
  //                       //             ),
  //                       //           )
  //                       //         ] else if (dataproduct[p].productStatus ==
  //                       //             "2") ...[
  //                       //           Container(
  //                       //             padding: EdgeInsets.all(2.0),
  //                       //             decoration: BoxDecoration(
  //                       //               borderRadius: BorderRadius.all(
  //                       //                 Radius.circular(5),
  //                       //               ),
  //                       //               color: Colors.green[300],
  //                       //               boxShadow: [
  //                       //                 BoxShadow(
  //                       //                   color: Colors.green,
  //                       //                   offset:
  //                       //                       Offset(0, 0), // Shadow position
  //                       //                 ),
  //                       //               ],
  //                       //             ),
  //                       //             child: Text(
  //                       //               "ติดตั้งแล้ว",
  //                       //               style: TextStyle(
  //                       //                 fontFamily: 'Prompt',
  //                       //                 fontSize: 12,
  //                       //                 color: Colors.white,
  //                       //               ),
  //                       //             ),
  //                       //           )
  //                       //         ]
  //                       //       ],
  //                       //     ] else ...[
  //                       //       if (job_mechanic[p].idProduct ==
  //                       //           dataproduct[p].idProduct) ...[
  //                       //         Container(
  //                       //           padding: EdgeInsets.all(2.0),
  //                       //           decoration: BoxDecoration(
  //                       //             borderRadius: BorderRadius.all(
  //                       //               Radius.circular(5),
  //                       //             ),
  //                       //             color: Colors.amber[200],
  //                       //             boxShadow: [
  //                       //               BoxShadow(
  //                       //                 color: Colors.amber,
  //                       //                 offset: Offset(0, 0), // Shadow position
  //                       //               ),
  //                       //             ],
  //                       //           ),
  //                       //           child: Text(
  //                       //             "ดำเนินการ",
  //                       //             style: TextStyle(
  //                       //               fontFamily: 'Prompt',
  //                       //               fontSize: 12,
  //                       //               color: Colors.grey[600],
  //                       //             ),
  //                       //           ),
  //                       //         )
  //                       //       ] else ...[
  //                       //         if (dataproduct[p].productStatus == "1") ...[
  //                       //           Container(
  //                       //             padding: EdgeInsets.all(2.0),
  //                       //             decoration: BoxDecoration(
  //                       //               borderRadius: BorderRadius.all(
  //                       //                 Radius.circular(5),
  //                       //               ),
  //                       //               color: Colors.grey[200],
  //                       //               boxShadow: [
  //                       //                 BoxShadow(
  //                       //                   color: Colors.grey,
  //                       //                   offset:
  //                       //                       Offset(0, 0), // Shadow position
  //                       //                 ),
  //                       //               ],
  //                       //             ),
  //                       //             child: Text(
  //                       //               "รอติดตั้งสินค้า",
  //                       //               style: TextStyle(
  //                       //                 fontFamily: 'Prompt',
  //                       //                 fontSize: 12,
  //                       //                 color: Colors.grey[700],
  //                       //               ),
  //                       //             ),
  //                       //           )
  //                       //         ] else if (dataproduct[p].productStatus ==
  //                       //             "2") ...[
  //                       //           Container(
  //                       //             padding: EdgeInsets.all(2.0),
  //                       //             decoration: BoxDecoration(
  //                       //               borderRadius: BorderRadius.all(
  //                       //                 Radius.circular(5),
  //                       //               ),
  //                       //               color: Colors.green[300],
  //                       //               boxShadow: [
  //                       //                 BoxShadow(
  //                       //                   color: Colors.green,
  //                       //                   offset:
  //                       //                       Offset(0, 0), // Shadow position
  //                       //                 ),
  //                       //               ],
  //                       //             ),
  //                       //             child: Text(
  //                       //               "ติดตั้งแล้ว",
  //                       //               style: TextStyle(
  //                       //                 fontFamily: 'Prompt',
  //                       //                 fontSize: 12,
  //                       //                 color: Colors.white,
  //                       //               ),
  //                       //             ),
  //                       //           )
  //                       //         ]
  //                       //       ],
  //                       //     ],
  //                       //   ] else ...[
  //                       //     if (dataproduct[p].productStatus == "1") ...[
  //                       //       Container(
  //                       //         padding: EdgeInsets.all(2.0),
  //                       //         decoration: BoxDecoration(
  //                       //           borderRadius: BorderRadius.all(
  //                       //             Radius.circular(5),
  //                       //           ),
  //                       //           color: Colors.grey[200],
  //                       //           boxShadow: [
  //                       //             BoxShadow(
  //                       //               color: Colors.grey,
  //                       //               offset: Offset(0, 0), // Shadow position
  //                       //             ),
  //                       //           ],
  //                       //         ),
  //                       //         child: Text(
  //                       //           "รอติดตั้งสินค้า",
  //                       //           style: TextStyle(
  //                       //             fontFamily: 'Prompt',
  //                       //             fontSize: 12,
  //                       //             color: Colors.grey[700],
  //                       //           ),
  //                       //         ),
  //                       //       )
  //                       //     ] else if (dataproduct[p].productStatus == "2") ...[
  //                       //       Container(
  //                       //         padding: EdgeInsets.all(2.0),
  //                       //         decoration: BoxDecoration(
  //                       //           borderRadius: BorderRadius.all(
  //                       //             Radius.circular(5),
  //                       //           ),
  //                       //           color: Colors.green[300],
  //                       //           boxShadow: [
  //                       //             BoxShadow(
  //                       //               color: Colors.green,
  //                       //               offset: Offset(0, 0), // Shadow position
  //                       //             ),
  //                       //           ],
  //                       //         ),
  //                       //         child: Text(
  //                       //           "ติดตั้งแล้ว",
  //                       //           style: TextStyle(
  //                       //             fontFamily: 'Prompt',
  //                       //             fontSize: 12,
  //                       //             color: Colors.white,
  //                       //           ),
  //                       //         ),
  //                       //       )
  //                       //     ]
  //                       //   ]
  //                       // ]
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           "ประเภทสินค้า  ",
  //                           style: TextStyle(
  //                             fontFamily: 'Prompt',
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.grey[700],
  //                           ),
  //                         ),
  //                         Text(
  //                           "${dataproduct[p].productType}",
  //                           style: TextStyle(
  //                             fontFamily: 'Prompt',
  //                             fontSize: 14,
  //                             color: Colors.grey[600],
  //                           ),
  //                           overflow: TextOverflow.fade,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           "แบรนด์สินค้า  ",
  //                           style: TextStyle(
  //                             fontFamily: 'Prompt',
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.grey[700],
  //                           ),
  //                         ),
  //                         Text(
  //                           "${dataproduct[p].productBrand}",
  //                           style: TextStyle(
  //                             fontFamily: 'Prompt',
  //                             fontSize: 14,
  //                             color: Colors.grey[600],
  //                           ),
  //                           overflow: TextOverflow.fade,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "ข้อมูลสินค้า",
  //                               style: TextStyle(
  //                                 fontFamily: 'Prompt',
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.grey[700],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: Text(
  //                                 "${dataproduct[p].productDetail}",
  //                                 style: TextStyle(
  //                                   fontFamily: 'Prompt',
  //                                   fontSize: 14,
  //                                   color: Colors.grey[600],
  //                                 ),
  //                                 overflow: TextOverflow.fade,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "ประเภทสัญญา  ",
  //                                   style: TextStyle(
  //                                     fontFamily: 'Prompt',
  //                                     fontSize: 14,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.grey[700],
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   "เงิน${dataproduct[p].productTypeContract}",
  //                                   style: TextStyle(
  //                                     fontFamily: 'Prompt',
  //                                     fontSize: 14,
  //                                     color: Colors.grey[600],
  //                                   ),
  //                                   overflow: TextOverflow.fade,
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                         Column(
  //                           children: [
  //                             Text(
  //                               "x ${dataproduct[p].productCount}",
  //                               style: TextStyle(
  //                                 fontFamily: 'Prompt',
  //                                 fontSize: 14,
  //                                 color: Colors.grey[600],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.only(
  //                           left: 8.0, right: 8.0, bottom: 10.0),
  //                       child: new Divider()),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );