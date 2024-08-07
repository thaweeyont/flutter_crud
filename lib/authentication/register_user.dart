import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/login_usermodal.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nextflow_thai_personal_id/nextflow_thai_personal_id.dart';

import '../privacy/Privacy.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? token;
  String? selectedValue_provinces;
  String? selectedValue_amphures;
  String? selectedValue_districts;
  List provinces_list = [];
  List amphures_list = [];
  List districts_list = [];
  bool show_validation = false;
  bool statusReadEye = true;
  List<Loginusermodel> datauser = [];
  final _formKey = GlobalKey<FormState>();
  int currentDialogStyle = 0;

  TextEditingController idcard = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  // ThaiIdValidator thaiIdValidator = ThaiIdValidator(
  //     errorMessage: 'เลขประจำตัวไม่ถูกต้องกรุณาตรวจสอบอีกครั้ง');

  @override
  void initState() {
    super.initState();
    get_provinces();
    // setState(() {
    //   selectedValue_provinces = "45";
    // });
  }

  //เรียกใช้ api เพิ่มข้อมูล
  Future register() async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/register_user_new.php");
    var request = new http.MultipartRequest("POST", uri);

    // request.fields['idcard'] = idcard.text;
    request.fields['username'] = username.text;
    request.fields['password'] = password.text;
    request.fields['name'] = name.text;
    request.fields['phone'] = phone.text;
    request.fields['address'] = address.text;
    request.fields['provinces'] = selectedValue_provinces.toString();
    request.fields['amphures'] = selectedValue_amphures.toString();
    request.fields['districts'] = selectedValue_districts.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      // var id_card = idcard.text;
      var user_name = username.text;
      var pass_word = password.text;
      var name_user = name.text;
      var phone_user = phone.text;
      var address_user = address.text;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // preferences.setString('id_card', id_card);
      preferences.setString('username', user_name);
      preferences.setString('password', pass_word);
      preferences.setString('name_user', name_user);
      preferences.setString('phone_user', phone_user);
      preferences.setString('address_user', address_user);
      preferences.setString(
          'provinces_user', selectedValue_provinces.toString());
      preferences.setString('amphures_user', selectedValue_amphures.toString());
      preferences.setString(
          'districts_user', selectedValue_districts.toString());
      preferences.setString('member', "normal");
      preferences.setString('profile_user', "");
      preferences.setString('status_advert', "true");

      if (user_name != "" && pass_word != "") {
        update_token(token!);
      }
    } else {
      print("ไม่สำเร็จ");
    }
  }

  Future<Null> gettoken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
      if (token != "" || datauser.isNotEmpty) {
        // update_token(token!);
        print('ok->4');
        register();
      }
    });
  }

  Future<Null> update_token(String token) async {
    if (username.text != "") {
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/update_token_new.php");
      var request = new http.MultipartRequest("POST", uri);

      request.fields['token'] = token;
      request.fields['username'] = username.text;
      // request.fields['password'] = password.text;

      var response = await request.send();
      if (response.statusCode == 200) {
        print('ok->5');
        print("==================>update_token_success");
        // Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TapControl("3")),
          (Route<dynamic> route) => false,
        );
        // register();
      } else {
        print("==================>update_token_error");
      }
    }
  }

  //function select_idcard
  Future<void> check_id_user(String username, name, phone) async {
    print('ok->2');
    final NativeIosDialogStyle style = currentDialogStyle == 0
        ? NativeIosDialogStyle.alert
        : NativeIosDialogStyle.actionSheet;
    try {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/check_id_user_new.php',
            {"username": username, "name": name, "phone": phone}),
      );
      // print(respose.body);
      if (respose.statusCode == 200) {
        if (respose.body == "1") {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            NativeIosDialog(
                title: "แจ้งเตือน",
                message: "ข้อมูลนี้ถูกใช้ลงทะเบียนไปแล้ว",
                style: style,
                actions: [
                  NativeIosDialogAction(
                      text: "ตกลง",
                      style: NativeIosDialogActionStyle.defaultStyle,
                      onPressed: () {}),
                ]).show();
          } else if (defaultTargetPlatform == TargetPlatform.android) {
            print('Phone>>android');
            // normalDialog(
            //     context, 'แจ้งเตือน', "ข้อมูลนี้ถูกใช้ลงทะเบียนไปแล้ว");
            nDialog(context, 'แจ้งเตือน', 'ข้อมูลนี้ถูกใช้ลงทะเบียนไปแล้ว');
          }
        } else if (respose.body == "2") {
          print('ok->3');
          showProgressDialog(context);
          gettoken();
          // Navigator.pop(context);
        }
        // else {
        //   setState(() {
        //     datauser = loginusermodelFromJson(respose.body);
        //   });

        //   if (datauser[0].idcard == idcard.text) {
        //     if (defaultTargetPlatform == TargetPlatform.iOS) {
        //       NativeIosDialog(
        //           title: "แจ้งเตือน",
        //           message: "มีข้อมูลอยู่แล้ว",
        //           style: style,
        //           actions: [
        //             NativeIosDialogAction(
        //                 text: "ตกลง",
        //                 style: NativeIosDialogActionStyle.defaultStyle,
        //                 onPressed: () {}),
        //           ]).show();
        //     } else if (defaultTargetPlatform == TargetPlatform.android) {
        //       print('Phone>>android');
        //       normalDialog(context, 'แจ้งเตือน', "มีข้อมูลอยู่แล้ว");
        //     }
        //   }
        // }
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

  //api ข้อมูลจังหวัด
  Future get_provinces() async {
    var respose = await http
        .get(Uri.http(ipconfig, '/flutter_api/api_staff/get_provinces.php'));
    if (respose.statusCode == 200) {
      if (respose.body != "NO Data Found.") {
        var jsonData_provinces = jsonDecode(respose.body);
        setState(() {
          provinces_list = jsonData_provinces;
        });
      }
    }
  }

  //api ข้อมูลอำเภอ
  Future get_amphures(provinces_id) async {
    var respose = await http.get(Uri.http(
        ipconfig,
        '/flutter_api/api_staff/get_amphures.php',
        {"province_id": provinces_id}));
    if (respose.statusCode == 200) {
      if (respose.body != "NO Data Found.") {
        setState(() {
          var jsonData_amphures = jsonDecode(respose.body);
          amphures_list = jsonData_amphures;
        });
      }
    }
  }

  //api ข้อมูลตำบล
  Future get_districts(amphure_id) async {
    var respose = await http.get(Uri.http(
        ipconfig,
        '/flutter_api/api_staff/get_districts.php',
        {"amphure_id": amphure_id}));
    if (respose.statusCode == 200) {
      if (respose.body != "NO Data Found.") {
        var jsonData_districts = jsonDecode(respose.body);
        setState(() {
          districts_list = jsonData_districts;
        });
      }
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // idcard_input(size),
                  username_input(size),
                  password_input(size),
                  name_input(size),
                  phone_input(size),
                  provinces(),
                  amphures(),
                  districts(),
                  address_input(size),
                  SizedBox(height: 25),
                  submit_register(),
                  policy(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container policy(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("โดยการเปิดบัญชี Thaweeyont ท่านรับทราบและตกลงตาม",
                style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Privacy();
                }));
              },
              child: Text(
                "นโยบายความเป็นส่วนตัว",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                ),
              ),
            )
          ],
        ));
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.red[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Text(
        "สมัคร",
        style: MyConstant().title_text(Colors.black),
      ),
      elevation: 0,
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

  Widget idcard_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLength: 13,
                controller: idcard,
                keyboardType: TextInputType.number,
                // validator: thaiIdValidator.validate,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  isDense: true,
                  counterText: "",
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "เลขบัตรประชาชน",
                  hintStyle: MyConstant().normal_text(Colors.grey),
                  prefixIcon: Icon(Icons.credit_card_outlined),
                  prefixIconConstraints: MyConstant().sizeIcon,
                  filled: true,
                  fillColor: MyConstant.light,
                ),
              ),
            )
          ],
        ),
      );

  Widget name_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLength: 55,
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มชื่อ-นามสกุล';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  counterText: "",
                  isDense: true,
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "ชื่อ-นามสกุล",
                  hintStyle: MyConstant().normal_text(Colors.grey),
                  prefixIcon: Icon(Icons.person),
                  prefixIconConstraints: MyConstant().sizeIcon,
                  filled: true,
                  fillColor: MyConstant.light,
                ),
              ),
            )
          ],
        ),
      );

  Widget phone_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLength: 10,
                controller: phone,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มเบอร์โทร';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  counterText: "",
                  isDense: true,
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "เบอร์โทร",
                  hintStyle: MyConstant().normal_text(Colors.grey),
                  prefixIcon: Icon(Icons.local_phone_rounded),
                  prefixIconConstraints: MyConstant().sizeIcon,
                  filled: true,
                  fillColor: MyConstant.light,
                ),
              ),
            )
          ],
        ),
      );

  Widget username_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มชื่อผู้ใช้งาน';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  counterText: "",
                  isDense: true,
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "ชื่อผู้ใช้งาน",
                  hintStyle: MyConstant().normal_text(Colors.grey),
                  prefixIcon: Icon(Icons.account_circle_sharp),
                  prefixIconConstraints: MyConstant().sizeIcon,
                  filled: true,
                  fillColor: MyConstant.light,
                ),
              ),
            )
          ],
        ),
      );

  Widget password_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: password,
                obscureText: statusReadEye,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มรหัสผ่าน';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  counterText: "",
                  isDense: true,
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "รหัสผ่าน",
                  hintStyle: MyConstant().normal_text(Colors.grey),
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
                  prefixIconConstraints: MyConstant().sizeIcon,
                  filled: true,
                  fillColor: MyConstant.light,
                ),
              ),
            )
          ],
        ),
      );

  Widget address_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.25,
          child: TextFormField(
            maxLength: 100,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Prompt',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาเพิ่มบ้านเลขที่/หมู่บ้าน';
              }
              return null;
            },
            minLines: 5,
            // keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: address,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(4),
              counterText: "",
              isDense: true,
              enabledBorder: MyConstant().border,
              focusedBorder: MyConstant().border,
              hintText: "ที่อยู่",
              hintStyle: MyConstant().normal_text(Colors.grey),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                child: Icon(Icons.add_location_alt_outlined),
              ),
              prefixIconConstraints: MyConstant().sizeIcon,
              filled: true,
              fillColor: MyConstant.light,
            ),
          ),
        ),
      );

  Widget submit_register() => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            // side: BorderSide(color: Colors.white),
          ),
          padding: EdgeInsets.all(8),
        ),
        onPressed: () {
          print('submit');
          final NativeIosDialogStyle style = currentDialogStyle == 0
              ? NativeIosDialogStyle.alert
              : NativeIosDialogStyle.actionSheet;
          if (_formKey.currentState!.validate()) {
            if (username.text.isNotEmpty && password.text.isNotEmpty) {
              String pattern_up = r'^[a-zA-Z0-9]+$';
              RegExp regExp_up = new RegExp(pattern_up);
              String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
              RegExp regExp = new RegExp(pattern);
              if (!regExp_up.hasMatch(username.text)) {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  NativeIosDialog(
                      title: "แจ้งเตือน",
                      message: "ชื่อผู้ใช้ต้องมีตัว A-Z,a-z,0-9 เท่านั้น",
                      style: style,
                      actions: [
                        NativeIosDialogAction(
                            text: "ตกลง",
                            style: NativeIosDialogActionStyle.defaultStyle,
                            onPressed: () {}),
                      ]).show();
                } else if (defaultTargetPlatform == TargetPlatform.android) {
                  print('Phone>>android');
                  // normalDialog(context, 'แจ้งเตือน',
                  //     "ชื่อผู้ใช้ต้องมีตัว A-Z,a-z,0-9 เท่านั้น");
                  nDialog(context, 'แจ้งเตือน',
                      'ชื่อผู้ใช้ต้องมีตัว A-Z,a-z,0-9 เท่านั้น');
                }
              } else if (!regExp_up.hasMatch(password.text)) {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  NativeIosDialog(
                      title: "แจ้งเตือน",
                      message: "รหัสผ่านต้องมีตัว A-Z,a-z,0-9 เท่านั้น",
                      style: style,
                      actions: [
                        NativeIosDialogAction(
                            text: "ตกลง",
                            style: NativeIosDialogActionStyle.defaultStyle,
                            onPressed: () {}),
                      ]).show();
                } else if (defaultTargetPlatform == TargetPlatform.android) {
                  print('Phone>>android');
                  // normalDialog(context, 'แจ้งเตือน',
                  //     "รหัสผ่านต้องมีตัว A-Z,a-z,0-9 เท่านั้น");
                  nDialog(context, 'แจ้งเตือน',
                      'ชื่อผู้ใช้ต้องมีตัว A-Z,a-z,0-9 เท่านั้น');
                }
              } else if (!regExp.hasMatch(phone.text)) {
                print('You know1>>${phone.text.length}');
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  NativeIosDialog(
                      title: "แจ้งเตือน",
                      message: "เบอร์โทรศัพท์ไม่ถูกต้อง",
                      style: style,
                      actions: [
                        NativeIosDialogAction(
                            text: "ตกลง",
                            style: NativeIosDialogActionStyle.defaultStyle,
                            onPressed: () {}),
                      ]).show();
                } else if (defaultTargetPlatform == TargetPlatform.android) {
                  print('Phone>>android');
                  // normalDialog(context, 'แจ้งเตือน', "เบอร์โทรศัพท์ไม่ถูกต้อง");
                  nDialog(context, 'แจ้งเตือน', 'เบอร์โทรศัพท์ไม่ถูกต้อง');
                }
              } else {
                print('You know2>>${phone.text.length}');
                if (selectedValue_provinces != null &&
                    selectedValue_amphures != null &&
                    selectedValue_districts != null) {
                  setState(() {
                    show_validation = false;
                  });

                  //สมัครสมาชิก
                  check_id_user(username.text, name.text, phone.text);
                } else {
                  if (defaultTargetPlatform == TargetPlatform.iOS) {
                    setState(() {
                      show_validation = true;
                    });
                    NativeIosDialog(
                        title: "แจ้งเตือน",
                        message: "กรุณาเพิ่มข้อมูลให้ครบถ้วน",
                        style: style,
                        actions: [
                          NativeIosDialogAction(
                              text: "ตกลง",
                              style: NativeIosDialogActionStyle.defaultStyle,
                              onPressed: () {}),
                        ]).show();
                  } else if (defaultTargetPlatform == TargetPlatform.android) {
                    print('Phone>>android');
                    // normalDialog(
                    //     context, 'แจ้งเตือน', "กรุณาเพิ่มข้อมูลให้ครบถ้วน");
                    nDialog(context, 'แจ้งเตือน', 'กรุณาเพิ่มข้อมูลให้ครบถ้วน');
                    setState(() {
                      show_validation = true;
                    });
                  }
                }
              }
            } else {
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                NativeIosDialog(
                    title: "แจ้งเตือน",
                    message: "กรุณากรอกชื่อผู้ใช้งานและรหัสผ่าน",
                    style: style,
                    actions: [
                      NativeIosDialogAction(
                          text: "ตกลง",
                          style: NativeIosDialogActionStyle.defaultStyle,
                          onPressed: () {}),
                    ]).show();
              } else if (defaultTargetPlatform == TargetPlatform.android) {
                print('Phone>>android');
                // normalDialog(
                //     context, 'แจ้งเตือน', "กรุณากรอกชื่อผู้ใช้งานและรหัสผ่าน");
                nDialog(
                    context, 'แจ้งเตือน', 'กรุณากรอกชื่อผู้ใช้งานและรหัสผ่าน');
              }
            }
          }
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              "สมัคร",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget provinces() => Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        width: double.infinity,
        child: DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          value: selectedValue_provinces,
          hint: Text(
            "เลือกจังหวัด",
            style: MyConstant().normal_text(Colors.grey),
          ),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              amphures_list = [];
              selectedValue_amphures = null;
              districts_list = [];
              selectedValue_districts = null;
              get_amphures(newValue);
            }
            setState(() {
              selectedValue_provinces = newValue!;
            });
          },
          items: provinces_list.map((provinces) {
            return DropdownMenuItem<String>(
              value: provinces['id'].toString(),
              child: Text(provinces['name_th']),
            );
          }).toList(),
        ),
      );

  Widget amphures() => Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        width: double.infinity,
        child: DropdownButton<String>(
          hint: Text(
            "เลือกอำเภอ",
            style: MyConstant().normal_text(Colors.grey),
          ),
          value: selectedValue_amphures,
          // icon: const Icon(
          //     Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              districts_list = [];
              selectedValue_districts = null;
              get_districts(newValue);
            }
            setState(() {
              selectedValue_amphures = newValue;
            });
          },
          items: amphures_list.isEmpty
              ? []
              : amphures_list.map((amphures) {
                  return DropdownMenuItem<String>(
                    value: amphures['id'].toString(),
                    child: Text(amphures['name_th']),
                  );
                }).toList(),
        ),
      );

  Widget districts() => Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        width: double.infinity,
        child: DropdownButton<String>(
          hint: Text(
            "เลือกตำบล",
            style: MyConstant().normal_text(Colors.grey),
          ),
          value: selectedValue_districts,
          // icon: const Icon(
          //     Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              // get_amphures(newValue);
              setState(() {
                selectedValue_districts = newValue;
              });
            }
          },
          items: districts_list.isEmpty
              ? []
              : districts_list.map((districts) {
                  return DropdownMenuItem<String>(
                    value: districts['id'].toString(),
                    child: Text(districts['name_th']),
                  );
                }).toList(),
        ),
      );
}
