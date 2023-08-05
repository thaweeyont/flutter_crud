import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/privacy/Privacy.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/profile/address_user.dart';
import 'package:flutter_crud/profile/edit_profile.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:flutter_crud/authentication/register_user.dart';
import 'package:flutter_crud/home/search_product.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class PROFILE extends StatefulWidget {
  PROFILE({Key? key}) : super(key: key);

  @override
  _PROFILEState createState() => _PROFILEState();
}

class _PROFILEState extends State<PROFILE> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool status_conn = true;
  bool? st_show = false;
  File? file; //ภาพprofile
  var name, idcard, profile, status_advert, member;
  var notification;
  bool _switchValue = false;

  @override
  void initState() {
    random_noti();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getprofile_user();
    super.initState();
  }

  Future<Null> random_noti() async {
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      setState(() {
        notification = rng.nextInt(30);
      });
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
      getprofile_user();
      setState(() {
        status_conn = true;
      });
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name_user');
      idcard = preferences.getString('id_card');
      profile = preferences.getString('profile_user');
      status_advert = preferences.getString('status_advert');
      member = preferences.getString('member');
      // if(member =="beyond"){
      //   textmember="";
      // }else if(member ==""){
      //   textmember="";
      // }else{
      //   textmember="";
      // }
    });
    if (name != null) {
      st_show = true;
    }
    if (status_advert == "true") {
      setState(() {
        _switchValue = true;
      });
    } else {
      setState(() {
        _switchValue = false;
      });
    }
  }

  Future<Null> setprofile_img(img) async {
    //ทำ set image preferrance
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('profile_user');
    preferences.setString('profile_user', img!);
    setState(() {
      profile = preferences.getString('profile_user');
    });
    Navigator.pop(context);
  }

  Future<Null> processImagePicker(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result!.path);
      });
      up_profile();
    } catch (e) {}
  }

  Future<Null> up_profile() async {
    showProgressDialog(context);
    if (file != null) {
      int i = Random().nextInt(10000000);
      var nameFile = 'profile$i.jpg';
      String apisaveimg =
          'http://$ipconfig/flutter_api/image_profile.php?id_card=$idcard';
      Map<String, dynamic> map_receipt = {};
      map_receipt['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);

      FormData data_img = FormData.fromMap(map_receipt);
      var response = await Dio().post(apisaveimg, data: data_img).then((value) {
        setprofile_img(nameFile);
      });
    }
  }

  Future<Null> member_card() async {}

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: status_conn == false
          ? distconnect(size: size)
          : SingleChildScrollView(
              child: Column(
                children: [
                  search_group(),
                  sizebox(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        title_profile(),
                        new Divider(),
                        edit_profile(name),
                        new Divider(),
                        edit_address(name, idcard)
                      ],
                    ),
                  ),
                  sizebox(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        title_app(),
                        new Divider(),
                        privacy(),
                        new Divider(),
                        call(),
                        new Divider(),
                        advert_button(),
                        if (st_show == true) ...[
                          new Divider(),
                          // delete_account(idcard),
                          delete_account(context),
                        ],
                      ],
                    ),
                  ),
                  sizebox(),
                  version(),
                  if (st_show == true) ...[exit_ac()],
                ],
              ),
            ),
    );
  }

  InkWell delete_account(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(idcard);
        Dialog_deleteAccount(context, idcard);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.no_accounts_rounded,
                      color: Colors.red,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "ลบบัญชีผู้ใช้",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.navigate_next_rounded,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: TextField(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return SearchProduct();
            }));
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            isDense: true,
            enabledBorder: border,
            focusedBorder: border,
            hintText: "Thaweeyont",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
            prefixIcon: Icon(Icons.search),
            prefixIconConstraints: sizeIcon,
            suffixIcon: Icon(Icons.camera_alt),
            suffixIconConstraints: sizeIcon,
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  _buildIconButton(
          {VoidCallback? onPressed, IconData? icon, int notification = 0}) =>
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
                onTap: onPressed,
                child: Icon(
                  icon,
                  color: Colors.white,
                )),
          ),
          notification == 0
              ? SizedBox()
              : Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      maxHeight: 20,
                    ),
                    child: Text(
                      '$notification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
        ],
      );

  Widget search_group() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.04,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       // _buildInputSearch(),
                //       // _buildIconButton(
                //       //   onPressed: () async {
                //       //     await launch("https://www.thaweeyont.com/");
                //       //   },
                //       //   icon: Icons.shopping_cart,
                //       //   notification: notification,
                //       // ),
                //       // _buildIconButton(
                //       //   onPressed: () => Navigator.pushAndRemoveUntil(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //         builder: (context) => TapControl("1")),
                //       //     (Route<dynamic> route) => false,
                //       //   ),
                //       //   icon: Icons.pin_drop_rounded,
                //       // ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: CircleBorder(),
                                  padding: profile == null || profile == ""
                                      ? file == null
                                          ? EdgeInsets.all(15)
                                          : null
                                      : null,
                                ),
                                onPressed: () async {
                                  if (idcard != null) {
                                    processImagePicker(ImageSource.gallery);
                                  } else {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return LOGIN();
                                    }));
                                  }
                                },
                                child: profile == null || profile == ""
                                    ? file == null
                                        ? Container(
                                            child: Icon(
                                            Icons.person_add_alt_rounded,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            color: Colors.grey[400],
                                          ))
                                        : CircleAvatar(
                                            backgroundImage:
                                                new FileImage(file!),
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                          )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "http://110.164.131.46/flutter_api/profile/$idcard/$profile"),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                              ),
                              // FlatButton(
                              //   color: Colors.white,
                              //   shape: CircleBorder(),
                              //   padding: profile == null || profile == ""
                              //       ? file == null
                              //           ? EdgeInsets.all(15)
                              //           : null
                              //       : null,
                              //   onPressed: () async {
                              //     if (idcard != null) {
                              //       processImagePicker(ImageSource.gallery);
                              //     } else {
                              //       Navigator.push(context,
                              //           CupertinoPageRoute(builder: (context) {
                              //         return LOGIN();
                              //       }));
                              //     }
                              //   },
                              //   child: profile == null || profile == ""
                              //       ? file == null
                              //           ? Container(
                              //               child: Icon(
                              //               Icons.person_add_alt_rounded,
                              //               size: MediaQuery.of(context)
                              //                       .size
                              //                       .width *
                              //                   0.08,
                              //               color: Colors.grey[400],
                              //             ))
                              //           : CircleAvatar(
                              //               backgroundImage:
                              //                   new FileImage(file!),
                              //               radius: MediaQuery.of(context)
                              //                       .size
                              //                       .width *
                              //                   0.08,
                              //             )
                              //       : CircleAvatar(
                              //           backgroundImage: NetworkImage(
                              //               "http://110.164.131.46/flutter_api/profile/$idcard/$profile"),
                              //           radius:
                              //               MediaQuery.of(context).size.width *
                              //                   0.08,
                              //         ),
                              // ),
                              if (name != null && st_show == true) ...[
                                // SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$name ",
                                        style: MyConstant().normal_text(
                                            Colors.blueGrey.shade800),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("ssssss");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 2,
                                              bottom: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  if (member == "normal") ...[
                                                    Colors.yellow,
                                                    Colors.red
                                                  ] else if (member ==
                                                      "platinum") ...[
                                                    Colors.grey.shade300,
                                                    Colors.grey.shade700,
                                                  ] else if (member ==
                                                      "beyond") ...[
                                                    Colors.white70,
                                                    Colors.black,
                                                  ]
                                                ],
                                              )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (member == "normal") ...[
                                                Text("Member Card",
                                                    style: MyConstant()
                                                        .small_text(
                                                            Colors.white)),
                                              ] else ...[
                                                Text("$member Member",
                                                    style: MyConstant()
                                                        .small_text(
                                                            Colors.white)),
                                              ],
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Icon(
                                                Icons.navigate_next_rounded,
                                                size: 25,
                                                color: Colors.grey[600],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          )
                        ],
                      ),
                      if (st_show == false) ...[
                        Column(
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.all(8)),
                                  // color: Colors.white,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(5),
                                  //   // side: BorderSide(color: Colors.white),
                                  // ),
                                  // padding: EdgeInsets.all(8),
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return LOGIN();
                                    }));
                                  },
                                  child: Container(
                                    // color: Colors.white,
                                    child: Text(
                                      "เข้าสู่ระบบ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return Register();
                                    }));
                                  },
                                  child: Container(
                                    // color: Colors.white,
                                    child: Text(
                                      "ลงทะเบียน",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget exit_ac() => Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: TextButton(
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            preferences.clear();
            preferences.setString('st_isf', "true");
            setState(() {
              st_show = false;
              name = null;
              idcard = null;
              profile = null;
            });
          },
          child: Text(
            "ออกจากระบบ",
            style: MyConstant().normal_text(Colors.red),
          ),
        ),
      );

  Future<Null> delete_account_user(idcard) async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/delete_account_user.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['idcard'] = idcard;

    var response = await request.send();
    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.clear();
      preferences.setString('st_isf', "true");
      setState(() {
        st_show = false;
        name = null;
        idcard = null;
        profile = null;
      });
      print("success");
      successDialog(context, 'แจ้งเตือน', 'ลบบัญชีผู้ใช้สำเร็จ');
    } else {
      print("error");
    }
  }

  Dialog_deleteAccount(BuildContext context, idcard) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "ยกเลิก",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "ตกลง",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
      ),
      onPressed: () {
        delete_account_user(idcard);
        Navigator.pop(context);
        showProgressDialog(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "ต้องการลบบัญชีผู้ใช้?",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
      ),
      content: Text(
        "หากท่านลบบัญชีนี้ไปแล้วจะไม่สามารถกู้คืนบัญชีนี้ได้อีก",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Container advert_button() => Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.featured_play_list,
                      size: 25,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "แจ้งเตือนหน้าหลัก",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) async {
                      showProgressDialog(context);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove('status_advert');

                      setState(() {
                        _switchValue = value;
                        if (value == true) {
                          Navigator.pop(context);
                          preferences.setString('status_advert', "true");
                        } else {
                          Navigator.pop(context);
                          preferences.setString('status_advert', "false");
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class distconnect extends StatelessWidget {
  const distconnect({
    Key? key,
    required this.size,
  }) : super(key: key);

  final size;

  @override
  Widget build(BuildContext context) => SafeArea(
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
}

class version extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        "Thaweeyont v 2.1.20",
        style: TextStyle(
          fontFamily: 'Prompt',
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
    );
  }
}

class call extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launch("tel://053700353");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "ติดต่อแจ้งปัญหา",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.navigate_next_rounded,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class delete_account extends StatelessWidget {
//   final idcard;
//   const delete_account(this.idcard);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         print(idcard);
//         Dialog_deleteAccount(context, idcard);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.no_accounts_rounded,
//                       color: Colors.red,
//                       size: 25,
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       "ลบบัญชีผู้ใช้",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Prompt',
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Column(
//               children: [
//                 Icon(
//                   Icons.navigate_next_rounded,
//                   size: 25,
//                   color: Colors.grey[600],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return Privacy();
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "ข้อกำหนดและนโยบาย",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.navigate_next_rounded,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class title_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "แอปพลิเคชัน",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Prompt',
          ),
        ),
      ],
    );
  }
}

class edit_address extends StatelessWidget {
  final name, idcard;
  const edit_address(this.name, this.idcard);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (name != null) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return Address_user(idcard);
          }));
        } else {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return LOGIN();
          }));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_pin_circle_sharp,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "ที่อยู่",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.navigate_next_rounded,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class edit_profile extends StatelessWidget {
  final name;
  const edit_profile(this.name);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (name != null) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return Edit_profile();
          }));
        } else {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return LOGIN();
          }));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.red,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "แก้ไขข้อมูลส่วนตัว",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Prompt',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.navigate_next_rounded,
                  size: 25,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class title_profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "โปรไฟล์",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Prompt',
          ),
        ),
      ],
    );
  }
}

class sizebox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        color: Colors.grey[200],
      ),
    );
  }
}
