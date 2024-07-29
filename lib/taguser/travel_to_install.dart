import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/profile/profile_user.dart';
import 'package:flutter_crud/taguser/add_score.dart';
import 'package:flutter_crud/taguser/detail_user.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/getprofilemecmodel.dart';
import 'package:flutter_crud/models/jobmechanic.dart';
import 'package:flutter_crud/widget/coloricon.dart';
import 'package:flutter_crud/widget/show_progress.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class TravelToInstall extends StatefulWidget {
  final String id_job_gen, idmec, idproduct, time_install, id_sale, id_credit;
  TravelToInstall(this.id_job_gen, this.idmec, this.idproduct,
      this.time_install, this.id_sale, this.id_credit);
  @override
  _TravelToInstallState createState() => _TravelToInstallState();
}

class _TravelToInstallState extends State<TravelToInstall>
    with WidgetsBindingObserver {
  var status_job_mechanic,
      indexjob = 0,
      name_mec,
      phone_mec,
      distance,
      value_km,
      time_mark,
      isSwitched = false,
      h,
      m,
      waring,
      active_mec = 0,
      ary = 0,
      setarry,
      date_ad_score,
      id_mechanic_staff;
  // late BitmapDescriptor myIcon;
  Key key = UniqueKey();
  double? a_lat, a_lng;
  List<Jobmechanic> job_mechanic = [];
  List<Getprofilemec> job_profile_mechanic = [];
  double? lat, lng, lat_mec, lng_mec;
  // Completer<GoogleMapController> _controller = Completer();
  // BitmapDescriptor? customIcon;
  @override
  void initState() {
    super.initState();
    print("==========================>${widget.id_credit}");
    WidgetsBinding.instance!.addObserver(this);
    // SetCustomMarker();
    // CheckPermission();
    _get_job_mechanic();
    _get_profile_mechanic();
    aboutNotification();
  }

// ตัวจัดการ
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        // ออกแอป
        break;
      case AppLifecycleState.resumed:
        //กลับมาเปิดแอป
        restartApp();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
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
        // _get_profile_mechanic();
        _get_job_mechanic();
        successDialog(context, 'แจ้งเตือน', 'เพิ่มสถานที่ติดตั้งสำเร็จ');
      } else {
        print("แก้ไขไม่สำเร็จ");
      }
    } else {
      print("lat/lng => null");
    }
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
                              child: a_lat == null ? ShowProgress() : sizebox()
                              // : GoogleMap(
                              //     myLocationEnabled: true,
                              //     mapType: isSwitched == false
                              //         ? MapType.normal
                              //         : MapType.hybrid,
                              //     initialCameraPosition: CameraPosition(
                              //       target: LatLng(a_lat!, a_lng!),
                              //       zoom: 18,
                              //     ),
                              //     onMapCreated: (controller) async {},
                              //     gestureRecognizers: Set()
                              //       ..add(Factory<EagerGestureRecognizer>(
                              //           () => EagerGestureRecognizer())),
                              //     markers: <Marker>[
                              //       Marker(
                              //         markerId: MarkerId('id'),
                              //         position: LatLng(a_lat!, a_lng!),
                              //         infoWindow: InfoWindow(
                              //             title: 'สถานที่ติดตั้ง',
                              //             snippet:
                              //                 'Lat = $a_lat , lng = $a_lng'),
                              //       ),
                              //     ].toSet(),
                              //     onTap: (argument) {
                              //       setState(() {
                              //         a_lat = argument.latitude;
                              //         a_lng = argument.longitude;
                              //       });
                              //     },
                              //   ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          )
        ],
      ),
    );
  }

  //mark home install
  // Marker user_mark() {
  //   return Marker(
  //     markerId: MarkerId('id'),
  //     position: LatLng(lat!, lng!),
  //     icon: BitmapDescriptor.defaultMarker,
  //     infoWindow: InfoWindow(
  //       title: 'คุณอยู่ที่นี้',
  //       // snippet: 'Lat = $lat , lng = $lng'
  //     ),
  //   );
  // }

  // late BitmapDescriptor mapMarker;

  // void SetCustomMarker() async {
  //   BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration(size: Size(48, 48)), 'images/mec_im.png')
  //       .then((onValue) {
  //     myIcon = onValue;
  //   });

  //   // mapMarker = await BitmapDescriptor.fromAssetImage(
  //   //     ImageConfiguration(size: Size(48, 48)), 'images/TY.png');
  // }

  //mark home install
  // Marker mec_mark() {
  //   return Marker(
  //     markerId: MarkerId('id'),
  //     position: LatLng(lat_mec!, lng_mec!),
  //     icon: myIcon,
  //     infoWindow: InfoWindow(
  //       title: 'ช่างติดตั้ง',
  //       // snippet: 'Lat = $lat , lng = $lng'
  //     ),
  //   );
  // }

  //set mark
  // Set<Marker> myset() {
  //   return <Marker>[
  //     // user_mark(),
  //     mec_mark()
  //   ].toSet();
  // }

  //เช็คข้อมูลช่างติดตั้ง
  Future<Null> _get_profile_mechanic() async {
    try {
      var respose = await http
          .get(Uri.http(ipconfig, '/flutter_api/api_user/get_profile_mec.php', {
        "id_gen_job": widget.id_job_gen,
        "id_mec": widget.idmec,
        "time_install": widget.time_install,
      }));
      // print(respose.body);

      if (respose.statusCode == 200) {
        setState(() {
          job_profile_mechanic = getprofilemecFromJson(respose.body);

          var llat = job_profile_mechanic[0].latJob;
          var llng = job_profile_mechanic[0].lngJob;
          lat = double.parse(llat!);
          lng = double.parse(llng!);

          distance = calculateDistance();
          var format_distance = NumberFormat('##.0#', 'en_US');
          value_km = format_distance.format(distance);
          double result = double.parse(value_km) / 25;
          print("===>ddd");
          h = result.toInt();
          // var m = format_distance.format(result);
          var vvvv = result.toString().substring(1, 5);
          var nnn = "0$vvvv";
          var par_int = double.parse(nnn);
          m = (par_int * 60).toInt();
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล ===>");
    }
  }

  //เช็คสถานะสินค้าเมื่อช่างรับงานติดตั้ง
  Future<Null> _get_job_mechanic() async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig,
          '/flutter_api/api_user/get_jbo_mechanic.php',
          {"id_gen_job": widget.id_job_gen, "id_staff": widget.idmec}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        print("มีข้อมูล");
        setState(() {
          job_mechanic = jobmechanicFromJson(respose.body);

          for (int name_st = 0; name_st < job_mechanic.length; name_st++) {
            // var cvcv =
            //     DateFormat('dd/MM/y').format(job_mechanic[name_st].datePd!);
            // print(cvcv);
            if (DateFormat('dd/MM/y').format(job_mechanic[name_st].datePd!) ==
                widget.time_install) {
              // print("ssssssssssssssssssssssss");
              id_mechanic_staff = job_mechanic[name_st].idStaff;
              name_mec = job_mechanic[name_st].fullnameStaff;
              phone_mec = job_mechanic[name_st].phoneStaff;
              status_job_mechanic = job_mechanic[name_st].statusData;
              ary = name_st;
              status_job_mechanic = job_mechanic[name_st].statusData;
              var llat_mec = job_mechanic[name_st].latData;
              var llng_mec = job_mechanic[name_st].lngData;
              lat_mec = double.parse(llat_mec!);
              lng_mec = double.parse(llng_mec!);
              waring = job_mechanic[name_st].waring;
              date_ad_score = job_mechanic[name_st].datePd;
            }
            // print(
            //     "============>>${DateFormat('d/MM/y').format(job_mechanic[name_st].datePd!)}");
            // print('---------------->${widget.time_install}');
          }
        });
        case_job_mechanic();
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
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
        score_Dialog(MediaQuery.of(context).size.width);
        break;
      case "7":
        setState(() {
          indexjob = 4;
          active_mec = 5;
        });
        break;
    }
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

  //Notification
  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print("ANDROID");

      FirebaseMessaging.onMessage.listen((message) async {
        _get_job_mechanic();
        // RemoteNotification? notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        // var sss = notification!.body;
        // print("$sss");
        // successDialog('แจ้งเตือน', 'สถานะมีการอัปเดท');
        // _get_user_document();
        // _getdata_product();
        // _getdata();
      });

      // FirebaseMessaging.onMessageOpenedApp
      //     .listen((RemoteMessage message) async {
      //   // print('Noti onmessage ==>${message.toString()}');
      //   // _get_user_document();
      //   // _getdata_product();
      //   // _getdata();
      // });

      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } else if (Platform.isIOS) {
      print("IOS");
    }
  }

  //คำนวณหาระยะทาง
  double calculateDistance() {
    double distance = 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat_mec! - lat!) * p) / 2 +
        c(lat! * p) * c(lat_mec! * p) * (1 - c((lng_mec! - lng!) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    return distance;
  }

  //รีสตาร์ทแอป
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return a_lat == null;
      },
      child: Scaffold(
        key: key,
        extendBodyBehindAppBar: true,
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: a_lat == null
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17.sp,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17.sp,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    if (a_lat != null) {
                      Navigator.of(context).pop();
                    }
                  }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:
            // lat_mec == null
            // ?
            // :
            Stack(
          children: [
            Positioned.fill(
                // child: lat == null ? load(size) : showmap(),
                child: lat == null ? load(size) : sizebox()),
            if (job_mechanic.isNotEmpty) ...[time_show(size)],
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                      colors: [
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
                child: detail_tracking(size),
              ),
            )
          ],
        ),
      ),
    );
  }

  //ข้อมูลช่างติดตั้ง
  Widget detail_mechanic(size) => Container(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
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
                        Icons.engineering_rounded,
                        size: size * 0.05,
                        color: Color.fromRGBO(230, 185, 128, 1),
                      ),
                    ),
                    Text(
                      "  $name_mec",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                launch("tel://$phone_mec");
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
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
                          size: size * 0.04,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );

  //สถานะการส่งสินค้า
  Widget detail_tracking(size) => Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "ทวียนต์",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "www.thaweeyont.com",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 5.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (indexjob >= 2) ...[
                                  if (m != null) ...[
                                    if (m == 0)
                                      ...[]
                                    else ...[
                                      Text(
                                        "คุณจะได้รับสินค้า",
                                        style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 8.sp,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                    if (h == 0) ...[
                                      if (m == 0) ...[
                                        Text(
                                          "ช่างติดตั้งไกล้ถึงคุณแล้ว",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 8.sp,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      ] else ...[
                                        Text(
                                          "เวลาประมาณ $m น.",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 8.sp,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ] else ...[
                                      Text(
                                        "เวลาประมาณ $h:$m น.",
                                        style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 8.sp,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ],
                                ] else ...[
                                  if (status_job_mechanic == "7")
                                    ...[]
                                  else ...[
                                    if (waring != "" && waring != null) ...[
                                      Container(
                                        width: size * 0.40,
                                        child: Text(
                                          "หมายเหตุ! : $waring",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 8.sp,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ],
                            ),
                          )
                          // ],
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return DetailUser(widget.id_job_gen, widget.idproduct,
                            widget.time_install, id_mechanic_staff);
                      })).then((value) => {
                            restartApp(),
                            _get_job_mechanic(),
                            aboutNotification(),
                          });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "รายละเอียด",
                              style: TextStyle(
                                fontFamily: 'Prompt',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 4.5.w,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            buildStepIndicator(size),
            detail_mechanic(size)
          ],
        ),
      );

  //เมื่ออยู่ในสถานะสินเชื่อตรวจสอบ
  Widget buildStepIndicator(size) => Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
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
                    undoneLineColor: Colors.white, //สีเส้นที่ไม่ได้ select
                    unselectedStepColorIn:
                        Colors.white, //สีปุ่มที่ไม้ได้ select
                    unselectedStepColorOut:
                        Colors.white, //สีเส้นที่ไม้ได้ select
                    selectedStepColorOut:
                        Colors.red.shade400, //สีเส้นที่เลือก อยู่
                    selectedStepColorIn:
                        Colors.red.shade400, //สีปุ่มที่เลือก อยู่
                    doneStepColor: Colors.red.shade400, //สีปุ่มที่ selectไปแล้ว
                    doneLineColor: Colors.red.shade400, //สีเส้นที่ selectไปแล้ว
                    doneStepSize: size * 0.02, //ขนาดปุ่ม
                    doneLineThickness: size * 0.005, //ขนาดเส้น
                    lineLength: 18.w,
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
                        fontSize: 8.sp,
                        color: active_mec == 1 ? Colors.red[400] : Colors.white,
                      ),
                    ),
                    Text(
                      "เตรียมอุปกรณ์",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 8.sp,
                        color: active_mec == 2 ? Colors.red[400] : Colors.white,
                      ),
                    ),
                    Text(
                      "กำลังจัดส่ง",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 8.sp,
                        color: active_mec == 3 ? Colors.red[400] : Colors.white,
                      ),
                    ),
                    Text(
                      "ติดตั้งสินค้า",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 8.sp,
                        color: active_mec == 4 ? Colors.red[400] : Colors.white,
                      ),
                    ),
                    Text(
                      "เสร็จสิ้น",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 8.sp,
                        color: active_mec == 5 ? Colors.red[400] : Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );

  //แสดงแผนที่
  // Widget showmap() => GoogleMap(
  //       compassEnabled: false,
  //       mapType: MapType.normal,
  //       tiltGesturesEnabled: false,
  //       initialCameraPosition: CameraPosition(
  //         target: LatLng(lat!, lng!),
  //         zoom: 12,
  //       ),
  //       onMapCreated: (controller) {},
  //       markers: myset(),
  //       onTap: (argument) {
  //         // _get_job_mechanic();
  //       },
  //     );

  //โหลดข้อมูล
  Widget load(double size) => Container(
        width: double.infinity,
        height: size * 1.62,
        child: ShowProgress(),
      );

  //dialog add score
  Future<Null> score_Dialog(size) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddScore(
            widget.id_job_gen,
            widget.idmec,
            name_mec,
            date_ad_score.toString(),
            widget.id_sale,
            widget.id_credit),
      ),
    );
    // showAnimatedDialog(
    //   barrierColor: Colors.transparent,
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SimpleCustomAlert(
    //         "กรุณาให้คะแนนเพื่อลุ้นรับรางวัล",
    //         widget.id_job_gen,
    //         widget.idmec,
    //         name_mec,
    //         date_ad_score.toString(),
    //         widget.id_sale,
    //         widget.id_credit);
    //   },
    //   animationType: DialogTransitionType.fadeScale,
    //   curve: Curves.fastOutSlowIn,
    //   duration: Duration(seconds: 1),
    // );
  }

  //shwo time
  Widget time_show(size) => Positioned(
        top: 10.h,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          decoration: BoxDecoration(
              // color: Colors.white70,
              gradient: LinearGradient(
                  colors: [
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
        ),
      );
}

// Future<Null> score_Dialog(size) async {
//   showAnimatedDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) => Container(
//       child: SimpleDialog(
//         // backgroundColor: Colors.amber,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(20.0),
//           ),
//         ),
//         title: ListTile(
//           leading: Image.asset('images/gif.gif'),
//           title: Text(
//             'ให้คะแนนพนักงาน',
//             style: TextStyle(
//               fontFamily: 'Prompt',
//               fontSize: size * 0.040,
//             ),
//           ),
//           subtitle: Text(
//             'กรุณาให้คะแนนเพื่อลุ้นรับรางวัล',
//             style: TextStyle(
//               fontFamily: 'Prompt',
//               fontSize: size * 0.035,
//             ),
//           ),
//         ),
//         children: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => AddScore(
//                         widget.id_job_gen,
//                         widget.idmec,
//                         name_mec,
//                         date_ad_score.toString(),
//                         widget.id_sale,
//                         widget.id_credit),
//                   ),
//                 ).then((value) => {score_Dialog(size)});
//               },
//               child: Column(
//                 children: [
//                   Text(
//                     "ตกลง",
//                     style: TextStyle(
//                       fontFamily: 'Prompt',
//                       fontSize: size * 0.035,
//                     ),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     ),
//     animationType: DialogTransitionType.fadeScale,
//     curve: Curves.fastOutSlowIn,
//     duration: Duration(seconds: 1),
//   );
// }

class SimpleCustomAlert extends StatelessWidget {
  final title, id_job_gen, idmec, name_mec, date_ad_score, id_sale, id_credit;
  SimpleCustomAlert(this.title, this.id_job_gen, this.idmec, this.name_mec,
      this.date_ad_score, this.id_sale, this.id_credit);
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeh = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Colors.white70,
        child: Container(
          // color: Colors.transparent,
          height: sizeh * 0.27,
          child: Column(
            children: [
              SizedBox(height: sizeh * 0.03),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearGradientMask(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: size * 0.08,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearGradientMask(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: size * 0.1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearGradientMask(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: size * 0.15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearGradientMask(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: size * 0.1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearGradientMask(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: size * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: sizeh * 0.03),
              Expanded(
                child: Container(
                  // color: Colors.redAccent,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(238, 208, 110, 1),
                      Color.fromRGBO(250, 227, 152, 0.9),
                      Color.fromRGBO(212, 163, 51, 0.8),
                      Color.fromRGBO(250, 227, 152, 0.9),
                      Color.fromRGBO(164, 128, 44, 1),
                    ], tileMode: TileMode.mirror),
                  ),
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.040,
                              color: Colors.red[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              shape: const StadiumBorder(),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white70,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: const StadiumBorder(),
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 11.sp,
                                  color: Colors.red[700],
                                ),
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => AddScore(
                                        id_job_gen,
                                        idmec,
                                        name_mec,
                                        date_ad_score,
                                        id_sale,
                                        id_credit),
                                  ),
                                ).then((value) => {SimpleCustomAlert});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
