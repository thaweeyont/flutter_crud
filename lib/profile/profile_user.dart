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
import 'package:flutter_crud/profile/address_user.dart';
import 'package:flutter_crud/profile/edit_profile.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:flutter_crud/authentication/register_user.dart';
import 'package:flutter_crud/home/search_product.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  var username, password, name, idcard, profile, member, status_advert;
  var notification, version_app;
  bool _switchValue = false;
  int currentDialogStyle = 0;

  @override
  void initState() {
    super.initState();
    random_noti();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getprofile_user();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
    version_app = packageInfo.version;
  }

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    // installerStore: 'Unknown',
  );

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
      // getprofile_user();
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
      setState(() {
        print('IN>>2');
        st_show = true;
      });
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
      var result = await ImagePicker().pickImage(
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
          'http://$ipconfig/flutter_api/image_profile.php?username=$username';
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
                        edit_address(name, username),
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
                          delete_account(context),
                        ],
                      ],
                    ),
                  ),
                  sizebox(),
                  version(version_app),
                  if (st_show == true) ...[
                    exit_ac(),
                  ],
                ],
              ),
            ),
    );
  }

  InkWell delete_account(BuildContext context) {
    final NativeIosDialogStyle style = currentDialogStyle == 0
        ? NativeIosDialogStyle.alert
        : NativeIosDialogStyle.actionSheet;
    return InkWell(
      onTap: () async {
        print(idcard);

        if (defaultTargetPlatform == TargetPlatform.iOS) {
          NativeIosDialog(
              title: "ต้องการลบบัญชีผู้ใช้?",
              message: "หากท่านลบบัญชีจะไม่สามารถกู้บัญชีคืน",
              style: style,
              actions: [
                NativeIosDialogAction(
                    text: "ลบบัญชี",
                    style: NativeIosDialogActionStyle.destructive,
                    onPressed: () {
                      delete_account_user(username);
                      showProgressDialog(context);
                    }),
                NativeIosDialogAction(
                    text: "ยกเลิก",
                    style: NativeIosDialogActionStyle.cancel,
                    onPressed: () {}),
              ]).show();
        } else if (defaultTargetPlatform == TargetPlatform.android) {
          print('Phone>>android');
          // Dialog_deleteAccount(context);
          NdialogdeleteUser(context);
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
                                          : EdgeInsets.all(5)
                                      : EdgeInsets.all(5),
                                ),
                                onPressed: () async {
                                  if (username != null) {
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
                                            "http://110.164.131.46/flutter_api/profile/$username/$profile"),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                              ),
                              if (name != null && st_show == true) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$name",
                                        style: MyConstant().normal_text(
                                            Colors.blueGrey.shade800),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("ssssss");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 5,
                                              top: 0,
                                              bottom: 0),
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
                                                        .very_small_text(
                                                            Colors.white)),
                                              ] else ...[
                                                Text("$member Member",
                                                    style: MyConstant()
                                                        .very_small_text(
                                                            Colors.white)),
                                              ],
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Icon(
                                                Icons.navigate_next_rounded,
                                                size: 20,
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
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return LOGIN();
                                    }));
                                  },
                                  child: Container(
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

  Widget exit_ac() {
    final NativeIosDialogStyle style = currentDialogStyle == 0
        ? NativeIosDialogStyle.actionSheet
        : NativeIosDialogStyle.alert;
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: TextButton(
        onPressed: () {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            NativeIosDialog(
                message: "คุณต้องการออกจากระบบนี้ใช่หรือไม่",
                style: style,
                actions: [
                  NativeIosDialogAction(
                      text: "ออกจากระบบ",
                      style: NativeIosDialogActionStyle.destructive,
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.clear();
                        preferences.setString('st_isf', "true");
                        setState(() {
                          st_show = false;
                          name = null;
                          username = null;
                          profile = null;
                          file = null;
                        });
                      }),
                  NativeIosDialogAction(
                      text: "ยกเลิก",
                      style: NativeIosDialogActionStyle.cancel,
                      onPressed: () {
                        // Navigator.pop(context);
                      }),
                ]).show();
          } else if (defaultTargetPlatform == TargetPlatform.android) {
            print('Phone>>android');
            // Dialog_exit(context);
            Ndialogexit(context);
          }
        },
        child: Text(
          "ออกจากระบบ",
          style: MyConstant().normal_text(Colors.red),
        ),
      ),
    );
  }

  Future<Null> delete_account_user(username) async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/delete_account_user.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['username'] = username;

    var response = await request.send();
    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.clear();
      preferences.setString('st_isf', "true");
      setState(() {
        st_show = false;
        username = null;
        name = null;
        profile = null;
      });
      print("success");
      Navigator.pop(context);
      // successDialog(context, 'แจ้งเตือน', 'ลบบัญชีผู้ใช้สำเร็จ');
    } else {
      print("error");
    }
  }

  Dialog_deleteAccount(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "ยกเลิก",
        style:
            TextStyle(fontFamily: 'Prompt', fontSize: 16, color: Colors.blue),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "ลบบัญชี",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16, color: Colors.red),
      ),
      onPressed: () {
        delete_account_user(username);
        showProgressDialog(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "ต้องการลบบัญชีผู้ใช้?",
        style: TextStyle(
            fontFamily: 'Prompt', fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: Text(
        "หากท่านลบบัญชีจะไม่สามารถกู้บัญชีคืน",
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

  Dialog_exit(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "ยกเลิก",
        style:
            TextStyle(fontFamily: 'Prompt', fontSize: 16, color: Colors.blue),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "ออกจากระบบ",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16, color: Colors.red),
      ),
      onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.clear();
        preferences.setString('st_isf', "true");
        setState(() {
          st_show = false;
          username = null;
          name = null;
          // idcard = null;
          profile = null;
          file = null;
        });
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "คุณต้องออกจากระบบหรือไม่?",
        style: TextStyle(
            fontFamily: 'Prompt', fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: Text(
        "เรายินดีต้อนรับคุณเสมอ",
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

  Ndialogexit(BuildContext context) {
    NDialog(
      dialogStyle:
          DialogStyle(titleDivider: true, contentPadding: EdgeInsets.all(10)),
      title: Text(
        "ออกจากระบบ",
        textAlign: TextAlign.center,
        style: MyConstant().title_text(Colors.black87),
      ),
      content: Text(
        "คุณต้องการออกจากระบบนี้?",
        textAlign: TextAlign.center,
        style: MyConstant().normal_text(Color.fromARGB(255, 81, 81, 81)),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              "ยกเลิก",
              style: MyConstant().textDialog(Colors.blueAccent),
            ),
            onPressed: () => Navigator.pop(context)),
        TextButton(
            child: Text(
              "ออกจากระบบ",
              style: MyConstant().textDialog(Colors.redAccent),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              preferences.clear();
              preferences.setString('st_isf', "true");
              setState(() {
                st_show = false;
                username = null;
                name = null;
                // idcard = null;
                profile = null;
                file = null;
              });
              Navigator.pop(context);
            }),
      ],
    ).show(context);
  }

  NdialogdeleteUser(BuildContext context) {
    NDialog(
      dialogStyle:
          DialogStyle(titleDivider: true, contentPadding: EdgeInsets.all(10)),
      title: Text(
        "ต้องการลบบัญชีนี้?",
        textAlign: TextAlign.center,
        style: MyConstant().title_text(Colors.black87),
      ),
      content: Text(
        "หากลบบัญชีแล้วจะไม่สามารถกู้บัญชีคืนได้",
        textAlign: TextAlign.center,
        style: MyConstant().normal_text(Color.fromARGB(255, 81, 81, 81)),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              "ยกเลิก",
              style: MyConstant().textDialog(Colors.blueAccent),
            ),
            onPressed: () => Navigator.pop(context)),
        TextButton(
            child: Text(
              "ตกลง",
              style: MyConstant().textDialog(Colors.redAccent),
            ),
            onPressed: () {
              showProgressDialog(context);
              delete_account_user(username);
              Navigator.pop(context);
            }),
      ],
    ).show(context);
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
  final String? appVersion;
  version(this.appVersion);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        "Thaweeyont v ${appVersion}",
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
      onTap: () async {
        final Uri phone = Uri.parse('tel:053700353');
        if (!await canLaunchUrl(phone)) {
          print('telll');
          await launchUrl(phone);
        } else {
          throw Exception('Could not launch $phone');
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
  final name, username;
  const edit_address(this.name, this.username);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (name != null) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return Address_user(username);
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
