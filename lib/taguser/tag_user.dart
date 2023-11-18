import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:flutter_crud/taguser/detail_user.dart';
import 'package:flutter_crud/taguser/history_job.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/jobinstallmodel.dart';
import 'package:flutter_crud/models/jobmodel.dart';
import 'package:flutter_crud/taguser/travel_to_install.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:flutter_crud/widget/coloricon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class TagUser extends StatefulWidget {
  TagUser({Key? key}) : super(key: key);

  @override
  _TagUserState createState() => _TagUserState();
}

class _TagUserState extends State<TagUser> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool status_conn = true;
  //ประกาศตัวแปร
  TextEditingController searchtag = TextEditingController();

  List<Job> datajob = [];
  List<Jobinstall> _data_install = [];
  var count = 0, idproduct, st_us, id_st_cr = "null";
  bool check_status = true;
  bool show_history = false;
  bool check_f = false;
  bool check_i = false;
  String? token;
  bool? st_show = false;
  var username, password, name, profile, member;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    check_pre();
    getprofile_user();
  }

  //function select data
  void _getJob(String idcard) async {
    try {
      datajob = [];
      var respose = await http.get(Uri.http(
          ipconfig, '/flutter_api/api_user/get_job.php', {"idcard": idcard}));
      print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datajob = jobFromJson(respose.body);
          for (var item in datajob) {
            if (item.statusJob != "6" && item.statusJob != "7") {
              check_f = true;
            }
          }
        });
      }
    } catch (e) {
      if (this.mounted) {
        setState(() {
          datajob = [];
          check_f = false;
        });
      }

      print("ไม่มีข้อมูล--");
    }
  }

  //function select data_install
  void _getJob_install(String idcard) async {
    try {
      var respose = await http.get(Uri.http(ipconfig,
          '/flutter_api/api_user/get_job_install.php', {"idcard": idcard}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          _data_install = jobinstallFromJson(respose.body);
          for (var item in _data_install) {
            if ((item.statusJob != "9" || item.statusJob != "5") &&
                item.statusData != '7') {
              check_i = true;
            }
          }
        });
      }
    } catch (e) {
      if (this.mounted) {
        setState(() {
          check_i = false;
          _data_install = [];
        });
      }

      print("ไม่มีข้อมูล++");
    }
  }

  //function select data_install_scarch
  Future<void> _getJob_install_scarch(String idcard) async {
    try {
      var respose = await http.get(Uri.http(ipconfig,
          '/flutter_api/api_user/get_job_install.php', {"idcard": idcard}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          _data_install = jobinstallFromJson(respose.body);
          id_st_cr = _data_install[0].idCredit;
        });
      }
    } catch (e) {
      // print("ไม่มีข้อมูล");
      setState(() {
        _data_install = [];
      });
    }
  }

  Future<Null> update_token(String token) async {
    if (searchtag.text != "") {
      // print("token => $token idcard => ${searchtag.text}");
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/update_token.php");
      var request = new http.MultipartRequest("POST", uri);

      request.fields['token'] = token;
      request.fields['idcard'] = searchtag.text;

      var response = await request.send();
      if (response.statusCode == 200) {
        print("update_token_s");
      } else {
        print("update_token_e");
      }
    }
  }

  Future<Null> check_pre() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id_card = preferences.getString('id_card');
    String? username = preferences.getString('username');
    if (id_card != null && id_card.isNotEmpty) {
      // searchtag.text = id_card;
      // showProgressDialog(context);
      _getJob_install(id_card);
      _getJob(id_card);
      // _getJob_install_scarch(id_card);
    }
  }

  // Future<Null> showProgressDialog(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => WillPopScope(
  //       child: Center(child: CircularProgressIndicator()),
  //       onWillPop: () async {
  //         return false;
  //       },
  //     ),
  //   );
  // }

  //ไปหน้าถัดไปตามสถานะที่ต่างกัน
  void next_page(i) {
    var id = _data_install[i].idJobHead;
    var idmec = _data_install[i].idStaff;
    var time_install = _data_install[i].timeInstall;
    var id_st_by = _data_install[i].idSale;
    if (_data_install[i].idCredit.toString().isNotEmpty) {
      setState(() {
        id_st_cr = _data_install[i].idCredit;
      });
      if (_data_install[i].idProduct == "" ||
          _data_install[i].idProduct == null) {
        setState(() {
          idproduct = "0";
        });
      } else {
        setState(() {
          idproduct = _data_install[i].idProduct;
        });
      }

      if (_data_install[i].statusData == null) {
        setState(() {
          st_us = 0;
        });
      } else {
        var st = _data_install[i].statusData;

        st_us = int.parse(st!);
      }

      if (st_us >= 2) {
        print("1");
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return TravelToInstall(
              id!, idmec!, idproduct!, time_install!, id_st_by!, id_st_cr);
        })).then((value) => {check_pre()});
      } else {
        print("2");
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return DetailUser(id!, idproduct!, "nodata", "nodata");
        })).then((value) => {check_pre()});
      }
    } else {
      if (_data_install[i].idProduct == "" ||
          _data_install[i].idProduct == null) {
        setState(() {
          idproduct = "0";
        });
      } else {
        setState(() {
          idproduct = _data_install[i].idProduct;
        });
      }

      if (_data_install[i].statusData == null) {
        setState(() {
          st_us = 0;
        });
      } else {
        var st = _data_install[i].statusData;

        st_us = int.parse(st!);
      }

      if (st_us >= 2) {
        print("1");
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return TravelToInstall(
              id!, idmec!, idproduct!, time_install!, id_st_by!, id_st_cr);
        })).then((value) => {check_pre()});
      } else {
        print("2");
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return DetailUser(id!, idproduct!, "nodata", "nodata");
        })).then((value) => {check_pre()});
      }
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() {
        status_conn = false;
      });
    } else {
      check_pre();
      setState(() {
        status_conn = true;
      });
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> getprofile_user() async {
    print('IN>>1');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      name = preferences.getString('name_user');
      profile = preferences.getString('profile_user');
      member = preferences.getString('member');

      print('user> $username');
      print('name> $name');
      print('profile> $profile');
      print('member> $member');
    });
    if (username != null && name != null) {
      print('check_login1>>$name');
      setState(() {
        st_show = true;
      });
      print('st_show>>$st_show');
    } else {
      print('check_login2>>$name');
      setState(() {
        st_show = false;
      });
      print('st_show>>$st_show');

      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return LOGIN();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[50],
          body: status_conn == false
              ? distconnect(size)
              : st_show == false
                  ? null
                  : RefreshIndicator(
                      strokeWidth: 2.0,
                      edgeOffset: 0.10,
                      displacement: 10,
                      backgroundColor: Colors.white,
                      color: Color.fromRGBO(230, 185, 128, 1),
                      onRefresh: () async {
                        check_pre();
                      },
                      child: GestureDetector(
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            search_group(),
                            history_button(size),
                            if (check_f == false && check_i == false) ...[
                              no_data(size)
                            ] else ...[
                              SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: [
                                      // Text("กำลังมาติดตั้ง"),
                                      if (_data_install.isNotEmpty) ...[
                                        form_status_install(size),
                                        // Text("1"),
                                      ],

                                      // Text("รอดำเนินการ"),
                                      if (datajob.isNotEmpty) ...[
                                        form_status_first(size),
                                        // show(size),
                                        // Text("2"),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                          // ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  _buildInputSearch() {
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);

    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(4.0),
      ),
    );
    return Expanded(
      child: TextField(
        style: MyConstant().normal_text(Colors.black),
        onChanged: (String keyword) {
          _getJob(keyword);
          _getJob_install(keyword);
        },
        controller: searchtag,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          isDense: true,
          enabledBorder: border,
          focusedBorder: border,
          hintText: "เลขบัตรประชาชน",
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: sizeIcon,
          suffixIcon: Icon(Icons.account_circle),
          suffixIconConstraints: sizeIcon,
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget search_group() => Container(
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
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildInputSearch(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget history_button(size) => Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "รายการของฉัน",
              style: MyConstant().normal_text(Colors.grey),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return history_job(searchtag.text);
                })).then((value) => {check_pre()});
              },
              child: Text(
                "ดูประวัติ",
                style: MyConstant().small_text(Colors.blueAccent),
              ),
            )
          ],
        ),
      );

  Widget detail_button() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "รายการของฉัน",
            style: MyConstant().normal_text(Colors.grey),
          ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       show_history = false;
          //     });
          //   },
          //   child: Text(
          //     "สถานะสินค้า",
          //     style: TextStyle(
          //       fontSize: 15,
          //       fontFamily: 'Prompt',
          //       color: Colors.blue,
          //     ),
          //   ),
          // )
        ],
      );

  Widget no_data(size) => Expanded(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: size * 0.10,
                  color: Colors.grey[350],
                ),
                Text(
                  "ไม่พบข้อมูล",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[400],
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
        ),
      );

//สถานะทั่วไป
  Widget form_status_first(size) => Column(
        children: [
          if (datajob.isNotEmpty) ...[
            for (int x = 0; x < datajob.length; x++) ...[
              if (datajob[x].statusJob != "6" &&
                  datajob[x].statusJob != "7") ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      var id = datajob[x].idJobHead;
                      var idmec = datajob[x].idStaff;
                      if (datajob[x].idProduct == "" ||
                          datajob[x].idProduct == null) {
                        setState(() {
                          idproduct = "0";
                        });
                      } else {
                        setState(() {
                          idproduct = datajob[x].idProduct;
                        });
                      }
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return DetailUser(id!, idproduct!, "nodata", "nodata");
                      })).then((value) => {check_pre()});
                    },
                    child: Container(
                      // height: size * 0.20,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: SizedBox(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "ทวียนต์ ",
                                                    style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 11.sp,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${datajob[x].date}",
                                                      style: TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 10.sp,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 5.w,
                                            right: 5.w,
                                            top: 1.h,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "  สถานะสินค้า : ",
                                                    style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 11.sp,
                                                      color: Colors.grey[700],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (datajob[x].statusJob ==
                                                      "2") ...[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "รอดำเนินการ......",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 11.sp,
                                                            color: Colors.blue),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                  if (datajob[x].statusJob ==
                                                      "3") ...[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "ตรวจสอบสัญญา......",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 11.sp,
                                                            color: Colors.blue),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                  if (datajob[x].statusJob ==
                                                          "4" ||
                                                      datajob[x].statusJob ==
                                                          "6") ...[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "สัญญาเสร็จสิ้น......",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 11.sp,
                                                            color: Colors.blue),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                  if (datajob[x].statusJob ==
                                                          "7" ||
                                                      datajob[x].statusJob ==
                                                          "5") ...[
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "รอช่างติดตั้งรับงาน...",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 11.sp,
                                                            color: Colors.blue),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // Shadow position
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'images/logo_contact.png',
                                height: 5.h,
                                width: 5.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ]
          ],
        ],
      );
//สถานะเมื่อมีการติดตั้ง
  Widget form_status_install(size) => Column(
        children: [
          if (_data_install.isNotEmpty) ...[
            for (int i = 0; i < _data_install.length; i++) ...[
              if ((_data_install[i].statusJob != "9" ||
                      _data_install[i].statusJob != "5") &&
                  _data_install[i].statusData != '7') ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () async {
                      next_page(i);
                    },
                    child: Container(
                      // height: size * 0.20,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 1,
                                color: Colors.white,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "ทวียนต์ ",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 11.sp,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${_data_install[i].timeInstall}",
                                                    style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 10.sp,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 5.w,
                                          right: 5.w,
                                          top: 1.h,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "  สถานะสินค้า : ",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 11.sp,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "1") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "รอดำเนินการ..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "2") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "ช่างติดตั้งรับงาน..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "3") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "จัดเตรียมอุปกรณ์..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "4") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "กำลังจัดส่ง..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "5") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "ดำเนินงานติดตั้ง..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                                if (_data_install[i]
                                                        .statusData ==
                                                    "6") ...[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "ให้คะแนนพนักงาน..",
                                                      style: TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 11.sp,
                                                          color: Colors.blue),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // Shadow position
                                  ),
                                ],
                              ),
                              child: _data_install[i].statusData == "6"
                                  ? LinearGradientMask(
                                      child: Icon(
                                        Icons.auto_awesome,
                                        size: 5.h,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.local_shipping_rounded,
                                      size: 5.h,
                                      color: Colors.red[400],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ]
          ],
        ],
      );

  Widget form_status_history() => Column(
        children: [
          if (datajob.isNotEmpty) ...[
            for (int x = 0; x < datajob.length; x++) ...[
              if (datajob[x].statusJob == "6") ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      var id = datajob[x].idJobHead;
                      var idmec = datajob[x].idStaff;
                      if (datajob[x].idProduct == "" ||
                          datajob[x].idProduct == null) {
                        setState(() {
                          idproduct = "0";
                        });
                      } else {
                        setState(() {
                          idproduct = datajob[x].idProduct;
                        });
                      }
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return DetailUser(id!, idproduct!, "nodata", "nodata");
                      })).then((value) => {check_pre()});
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "ทวียนต์ ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 15,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${datajob[x].date}",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 15,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "  สถานะสินค้า : ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 15,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              if (datajob[x].statusJob ==
                                                  "2") ...[
                                                Text(
                                                  "รอดำเนินการ......",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 14,
                                                      color: Colors.blue),
                                                )
                                              ],
                                              if (datajob[x].statusJob ==
                                                  "3") ...[
                                                Text(
                                                  "ตรวจสอบสัญญา......",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 14,
                                                      color: Colors.blue),
                                                )
                                              ],
                                              if (datajob[x].statusJob == "4" ||
                                                  datajob[x].statusJob ==
                                                      "6") ...[
                                                Text(
                                                  "สัญญาเสร็จสิ้น......",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 14,
                                                      color: Colors.blue),
                                                )
                                              ],
                                              if (datajob[x].statusJob == "7" ||
                                                  datajob[x].statusJob ==
                                                      "5") ...[
                                                Text(
                                                  "รอช่างติดตั้งรับงาน...",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 14,
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // Shadow position
                                  ),
                                ],
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                                width: MediaQuery.of(context).size.width * 0.08,
                                child: Icon(
                                  Icons.history,
                                  color: Colors.red,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ]
          ],
          if (_data_install.isNotEmpty) ...[
            for (int i = 0; i < _data_install.length; i++) ...[
              if ((_data_install[i].statusJob == "9" ||
                      _data_install[i].statusJob == "7" ||
                      _data_install[i].statusJob == "5" ||
                      _data_install[i].statusJob == "8") &&
                  _data_install[i].statusData == "7") ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      var id = _data_install[i].idJobHead;
                      var idmec = _data_install[i].idStaff;
                      var time_install = _data_install[i].timeInstall;
                      var id_st_by = _data_install[i].idSale;
                      if (_data_install[i].idCredit.toString().isNotEmpty) {
                        setState(() {
                          var id_st_cr = _data_install[i].idCredit;
                        });
                      }
                      // print("${_data_install[i].statusData}");
                      if (_data_install[i].idProduct == "" ||
                          _data_install[i].idProduct == null) {
                        setState(() {
                          idproduct = "0";
                        });
                      } else {
                        setState(() {
                          idproduct = _data_install[i].idProduct;
                        });
                      }

                      if (_data_install[i].statusData == null) {
                        setState(() {
                          st_us = 0;
                        });
                      } else {
                        var st = _data_install[i].statusData;

                        st_us = int.parse(st!);
                      }

                      if (st_us >= 2) {
                        // print("=======>$idmec");
                        // print("1");
                        // Navigator.push(context,
                        //     CupertinoPageRoute(builder: (context) {
                        //   return TravelToInstall(id!, idmec!, idproduct!,
                        //       time_install!, id_st_by!, id_st_cr);
                        // })).then((value) => {check_pre()});
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return DetailUser(
                              id!, idproduct!, time_install!, idmec!);
                        })).then((value) => {check_pre()});
                      } else {
                        // print("2");
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return DetailUser(
                              id!, idproduct!, time_install!, idmec!);
                        })).then((value) => {check_pre()});
                      }
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "ทวียนต์ ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 15,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${_data_install[i].timeInstall}",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 15,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Image.asset(
                                              //   'images/install_logo.png',
                                              //   height: MediaQuery.of(context)
                                              //           .size
                                              //           .width *
                                              //       0.10,
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width *
                                              //       0.10,
                                              // ),
                                              Text(
                                                "  สถานะสินค้า : ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 15,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "ประวัติการติดตั้ง..",
                                                style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 14,
                                                    color: Colors.blue),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  offset: Offset(0, 1), // Shadow position
                                ),
                              ],
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.08,
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Icon(
                                Icons.history,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ]
          ],
        ],
      );

  Widget distconnect(size) => SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              height: size * 0.07,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.red[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "OFFLINE",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    SizedBox(
                      width: 12.0,
                      height: size * 0.03,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.grey[400],
                  ),
                  Text(
                    "ไม่มีการเชื่อมต่ออินเตอร์เน็ต",
                    style: TextStyle(
                        fontFamily: 'Prompt',
                        color: Colors.grey[400],
                        fontSize: 17),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  // Widget card_test(size) => Container(
  //       height: size * 0.20,
  //       margin: const EdgeInsets.only(left: 46.0),
  //       decoration: new BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         color: Colors.white,
  //         borderRadius: new BorderRadius.circular(5.0),
  //         boxShadow: <BoxShadow>[
  //           new BoxShadow(
  //               color: Colors.grey,
  //               // offset: new Offset(0.0, 10.0),
  //               blurRadius: 1.0)
  //         ],
  //       ),
  //     );

  // Widget planeImage(size) => Container(
  //       margin: new EdgeInsets.symmetric(vertical: 20.0),
  //       alignment: FractionalOffset.centerLeft,
  //       child: Image.asset(
  //         'images/logo_contact.png',
  //         height: MediaQuery.of(context).size.width * 0.10,
  //         width: MediaQuery.of(context).size.width * 0.10,
  //       ),
  //     );

  // Widget show(size) => Container(
  //       margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
  //       child: new Stack(
  //         children: <Widget>[
  //           card_test(size),
  //           planeImage(size),
  //         ],
  //       ),
  //     );
}
