import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/advice/advice.dart';
import 'package:flutter_crud/privacy/Privacy.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/login_usermodal.dart';
import 'package:flutter_crud/authentication/register_user.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';

class LOGIN extends StatefulWidget {
  LOGIN({Key? key}) : super(key: key);

  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  TextEditingController idcard = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  List<Loginusermodel> datauser = [];
  var data;
  String? token;
  bool _isLoggedIn = false;
  bool statusReadEye = true;
  Map _userobj = {};
  int currentDialogStyle = 0;

  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  //function select_idcard
  Future<void> login_user(String username, String password) async {
    final NativeIosDialogStyle style = currentDialogStyle == 0
        ? NativeIosDialogStyle.alert
        : NativeIosDialogStyle.actionSheet;
    try {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/login_user_new.php',
            {"username": username, "password": password}),
      );
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datauser = loginusermodelFromJson(respose.body);
        });
        print('data>>${respose.body}');
        gettoken();
      }
    } catch (e) {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/check_id_delete_new.php',
            {"username": username, "password": password}),
      );
      if (respose.statusCode == 200) {
        if (respose.body == "1") {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            NativeIosDialog(
                title: "แจ้งเตือน",
                message: "บัญชีนี้ลบไปแล้ว",
                style: style,
                actions: [
                  NativeIosDialogAction(
                      text: "ตกลง",
                      style: NativeIosDialogActionStyle.defaultStyle,
                      onPressed: () {}),
                ]).show();
            Navigator.pop(context);
          } else if (defaultTargetPlatform == TargetPlatform.android) {
            print('Phone>>android');
            Navigator.pop(context);
            // normalDialog(context, 'แจ้งเตือน', "บัญชีนี้ลบไปแล้ว");
            nDialog(context, 'แจ้งเตือน', 'บัญชีนี้ถูกลบแล้ว');
          }
        } else {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            NativeIosDialog(
                title: "แจ้งเตือน",
                message: "ไม่พบข้อมูลบัญชีนี้",
                style: style,
                actions: [
                  NativeIosDialogAction(
                      text: "ตกลง",
                      style: NativeIosDialogActionStyle.defaultStyle,
                      onPressed: () {}),
                ]).show();
            Navigator.pop(context);
          } else if (defaultTargetPlatform == TargetPlatform.android) {
            print('Phone>>android');
            Navigator.pop(context);
            // normalDialog(context, 'แจ้งเตือน', "ไม่พบข้อมูลบัญชีนี้");
            nDialog(context, 'แจ้งเตือน', 'ไม่พบข้อมูลบัญชีนี้');
          }
        }
      } else {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          NativeIosDialog(
              title: "แจ้งเตือน",
              message: "ไม่มีข้อมูล",
              style: style,
              actions: [
                NativeIosDialogAction(
                    text: "ตกลง",
                    style: NativeIosDialogActionStyle.defaultStyle,
                    onPressed: () {}),
              ]).show();
        } else if (defaultTargetPlatform == TargetPlatform.android) {
          print('Phone>>android');
          print("ไม่มีข้อมูล");
          Navigator.pop(context);
          // normalDialog(context, 'แจ้งเตือน', "ไม่มีข้อมูล");
          nDialog(context, 'แจ้งเตือน', 'ไม่มีข้อมูล');
        }
      }
    }
  }

  Future<Null> loginlog() async {
    // var id_card = datauser[0].idcard;
    var username = datauser[0].username;
    var password = datauser[0].password;
    var name_user = datauser[0].fullname;
    var phone_user = datauser[0].phoneUser;
    var address_user = datauser[0].addressUser;
    var provinces = datauser[0].idProvinces;
    var amphures = datauser[0].idAmphures;
    var districts = datauser[0].idDistricts;
    var profile = datauser[0].profileUser;
    var member = datauser[0].statusMember;
    var status = datauser[0].status;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('id_card', id_card!);
    preferences.setString('username', username!);
    preferences.setString('password', password!);
    preferences.setString('name_user', name_user!);
    preferences.setString('phone_user', phone_user!);
    preferences.setString('address_user', address_user!);
    preferences.setString('provinces_user', provinces!);
    preferences.setString('amphures_user', amphures!);
    preferences.setString('districts_user', districts!);
    preferences.setString('profile_user', profile!);
    preferences.setString('member', member!);
    preferences.setString('status', status!);
    preferences.setString('status_advert', "true");

    if (username != "") {
      print('1>> $profile');
      print('2>> $member');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TapControl("3")),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<Null> gettoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
      if (token != "" || datauser.isNotEmpty) {
        update_token(token!);
      }
    });
  }

  Future<Null> update_token(String token) async {
    print('testToken');
    if (username.text != "") {
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/update_token_new.php");
      var request = new http.MultipartRequest("POST", uri);

      request.fields['token'] = token;
      request.fields['username'] = username.text;
      // request.fields['password'] = password.text;

      var response = await request.send();
      if (response.statusCode == 200) {
        print("==================>update_token_success");
        Navigator.pop(context);
        loginlog();
      } else {
        print("==================>update_token_error");
      }
    }
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? id_card = preferences.getString('id_card');
      String? username = preferences.getString('username');
      String? password = preferences.getString('password');
      String? status = preferences.getString('status');

      if (username != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TapControl("0")),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appbar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Column(
            children: [
              logo(context: context),
              // id_card_user(size),
              inputLogin(size)
              // or_line(),
              // btn_facebook()
            ],
          ),
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.red[700],
          ),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TapControl("3")),
              (Route<dynamic> route) => false,
            );
          }),
      // centerTitle: true,
      backgroundColor: Colors.grey[100],
      title: Text(
        "เข้าสู่ระบบ",
        style: MyConstant().title_text(Colors.black),
      ),
      elevation: 4,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.privacy_tip_outlined,
            color: Colors.red[600],
          ),
        ),
      ],
    );
  }

  Container inputLogin(size) {
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
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    counterText: "",
                    isDense: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    hintText: "ชื่อผู้ใช้งาน",
                    hintStyle: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(Icons.account_circle_sharp),
                    prefixIconConstraints: sizeIcon,
                    // suffixIcon: Icon(Icons.camera_alt),
                    // suffixIconConstraints: sizeIcon,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          new Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: password,
                  obscureText: statusReadEye,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    counterText: "",
                    isDense: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    hintText: "รหัสผ่าน",
                    hintStyle: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          statusReadEye = !statusReadEye;
                        });
                      },
                      icon: statusReadEye
                          ? const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                            ),
                    ),
                    prefixIconConstraints: sizeIcon,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          new Divider(),
          submit_login(size),
          register(context: context),
        ],
      ),
    );
  }

  Container id_card_user(size) {
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
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: idcard,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    counterText: "",
                    isDense: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    hintText: "เลขบัตรประจำตัวประชาชน",
                    hintStyle: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(Icons.account_circle_sharp),
                    prefixIconConstraints: sizeIcon,
                    // suffixIcon: Icon(Icons.camera_alt),
                    // suffixIconConstraints: sizeIcon,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          new Divider(),
          submit_login(size),
          register(context: context),
        ],
      ),
    );
  }

  Widget submit_login(size) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.045,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            animationDuration: Duration(milliseconds: 100),
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            final NativeIosDialogStyle style = currentDialogStyle == 0
                ? NativeIosDialogStyle.alert
                : NativeIosDialogStyle.actionSheet;
            if (username.text.isEmpty) {
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                NativeIosDialog(
                    title: "แจ้งเตือน",
                    message: "กรุณากรอก Username",
                    style: style,
                    actions: [
                      NativeIosDialogAction(
                          text: "ตกลง",
                          style: NativeIosDialogActionStyle.defaultStyle,
                          onPressed: () {}),
                    ]).show();
              } else if (defaultTargetPlatform == TargetPlatform.android) {
                print('Phone>>android');
                // normalDialog(context, 'แจ้งเตือน', "กรุณากรอก Username");
                nDialog(context, 'แจ้งเตือน', 'กรุณากรอก Username');
              }
            } else if (password.text.isEmpty) {
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                NativeIosDialog(
                    title: "แจ้งเตือน",
                    message: "กรุณากรอก Password",
                    style: style,
                    actions: [
                      NativeIosDialogAction(
                          text: "ตกลง",
                          style: NativeIosDialogActionStyle.defaultStyle,
                          onPressed: () {}),
                    ]).show();
              } else if (defaultTargetPlatform == TargetPlatform.android) {
                print('Phone>>android');
                // normalDialog(context, 'แจ้งเตือน', "กรุณากรอก Password");
                nDialog(context, 'แจ้งเตือน', 'กรุณากรอก Password');
              }
            } else {
              showProgressDialog(context);
              login_user(username.text, password.text);
            }
          },
          icon: Icon(Icons.vpn_key_rounded, size: 20),
          label: Text(
            "เข้าสู่ระบบ",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 14,
            ),
          ),
        ),
      );

  // Widget submit_login(size) => Container(
  //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
  //       width: double.infinity,
  //       height: MediaQuery.of(context).size.height * 0.045,
  //       // ignore: deprecated_member_use
  //       child: ElevatedButton.icon(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.red[600],
  //           animationDuration: Duration(milliseconds: 100),
  //           enableFeedback: true,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //         ),
  //         onPressed: () {
  //           final NativeIosDialogStyle style = currentDialogStyle == 0
  //               ? NativeIosDialogStyle.alert
  //               : NativeIosDialogStyle.actionSheet;
  //           if (idcard.text.isEmpty) {
  //             if (defaultTargetPlatform == TargetPlatform.iOS) {
  //               NativeIosDialog(
  //                   title: "แจ้งเตือน",
  //                   message: "กรุณากรอกเลขบัตรประชาชน",
  //                   style: style,
  //                   actions: [
  //                     NativeIosDialogAction(
  //                         text: "ตกลง",
  //                         style: NativeIosDialogActionStyle.defaultStyle,
  //                         onPressed: () {}),
  //                   ]).show();
  //             } else if (defaultTargetPlatform == TargetPlatform.android) {
  //               print('Phone>>android');
  //               normalDialog(context, 'แจ้งเตือน', "กรุณากรอกเลขบัตร....");
  //             }
  //           } else {
  //             showProgressDialog(context);
  //             login_user(idcard.text);
  //           }
  //         },
  //         icon: Icon(Icons.vpn_key_rounded, size: 20),
  //         label: Text(
  //           "เข้าสู่ระบบ",
  //           style: TextStyle(
  //             fontFamily: 'Prompt',
  //             fontSize: 14,
  //           ),
  //         ),
  //       ),
  //     );
}

class btn_facebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
          ),
          // color: Colors.blue[600],

          onPressed: () {},
          child: Container(
            width: double.infinity,
            child: Center(
              child: Text(
                "FaceBook",
                style: MyConstant().small_text(Colors.white),
              ),
            ),
          )),
    );
  }
}

class or_line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "หรือ",
              style: MyConstant().small_text(Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: new Divider(),
          ),
        ],
      ),
    );
  }
}

class register extends StatelessWidget {
  const register({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Advice();
                }));
              },
              child: Text(
                '*ข้อเสนอแนะการเข้าใช้งาน',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontFamily: 'Prompt',
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: new Divider(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Register();
                }));
              },
              child: Container(
                child: Text(
                  "ลงทะเบียน",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontFamily: 'Prompt',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              child: new Divider(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Privacy();
                }));
              },
              child: Container(
                child: Text(
                  "ข้อกำหนดและนโยบาย",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontFamily: 'Prompt',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class logo extends StatelessWidget {
  const logo({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.25,
        child: Image.asset(
          'images/logotwy.png',
        ),
      );
}

class iconback extends StatelessWidget {
  const iconback({
    Key? key,
    required Color? ColorIcon,
  })  : _ColorIcon = ColorIcon,
        super(key: key);

  final Color? _ColorIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: _ColorIcon,
        ));
  }
}
