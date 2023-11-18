import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:native_ios_dialog/native_ios_dialog.dart';

class Edit_profile extends StatefulWidget {
  Edit_profile({Key? key}) : super(key: key);

  @override
  _Edit_profileState createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {
  var username,
      password,
      name,
      idcard,
      phone,
      address,
      provinces_u,
      amphures_u,
      districts_u,
      profile,
      member;
  TextEditingController username_t = TextEditingController();
  TextEditingController password_t = TextEditingController();
  TextEditingController idcar_t = TextEditingController();
  TextEditingController name_t = TextEditingController();
  TextEditingController phone_t = TextEditingController();
  TextEditingController address_t = TextEditingController();
  bool show_validation = false;
  bool statusReadEye = true;
  String? selectedValue_provinces;
  String? selectedValue_amphures;
  String? selectedValue_districts;
  List provinces_list = [];
  List amphures_list = [];
  List districts_list = [];
  final _formKey = GlobalKey<FormState>();
  int currentDialogStyle = 0;

  @override
  void initState() {
    super.initState();
    getprofile_user();
  }

  //เรียกใช้ api เพิ่มข้อมูล
  Future update_profile() async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/edit_profile_new.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['username'] = username;
    request.fields['password'] = password_t.text.toString();
    request.fields['name'] = name_t.text.toString();
    request.fields['phone'] = phone_t.text.toString();
    request.fields['address'] = address_t.text.toString();
    request.fields['provinces'] = selectedValue_provinces.toString();
    request.fields['amphures'] = selectedValue_amphures.toString();
    request.fields['districts'] = selectedValue_districts.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      var username_log = username;
      var password_log = password_t.text.toString();
      var name_log = name_t.text.toString();
      var phone_log = phone_t.text.toString();
      var address_log = address_t.text.toString();
      var provinces_log = selectedValue_provinces.toString();
      var amphures_log = selectedValue_amphures.toString();
      var districts_log = selectedValue_districts.toString();
      var profile_log = profile.toString();
      var member_log = member.toString();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      preferences.setString('username', username_log!);
      preferences.setString('password', password_log);
      preferences.setString('name_user', name_log);
      preferences.setString('phone_user', phone_log);
      preferences.setString('address_user', address_log);
      preferences.setString('provinces_user', provinces_log);
      preferences.setString('amphures_user', amphures_log);
      preferences.setString('districts_user', districts_log);
      preferences.setString('profile_user', profile_log);
      preferences.setString('member', member_log);

      print('profile>$profile_log');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TapControl("3")),
        (Route<dynamic> route) => false,
      );
    } else {
      print("แก้ไขข้อมูลไม่สำเร็จ");
    }
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
      password = preferences.getString('password');
      name = preferences.getString('name_user');
      phone = preferences.getString('phone_user');
      address = preferences.getString('address_user');
      provinces_u = preferences.getString('provinces_user');
      amphures_u = preferences.getString('amphures_user');
      districts_u = preferences.getString('districts_user');
      profile = preferences.getString('profile_user');
      member = preferences.getString('member');
      get_provinces();
      get_amphures(provinces_u);
      get_districts(amphures_u);
      print('p>>$profile');
      print('m>>$member');

      username_t.text = username;
      password_t.text = password;
      name_t.text = name;
      phone_t.text = phone;
      address_t.text = address;
      selectedValue_provinces = provinces_u;
      selectedValue_amphures = amphures_u;
      selectedValue_districts = districts_u;
    });
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: appbar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    username_input(size),
                    password_input(size),
                    name_input(size),
                    phone_input(size),
                    provinces(),
                    amphures(),
                    districts(),
                    address_input(size),
                    submit_register(size),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.red[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Text(
        "แก้ไขข้อมูลส่วนตัว",
        style: MyConstant().title_text(Colors.red.shade600),
      ),
      elevation: 1,
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
    );
  }

  Widget username_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                style: MyConstant().normal_text(Colors.black),
                controller: username_t,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มชื่อผู้ใช้งาน';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.all(4),
                  // isDense: true,
                  enabled: false,
                  enabledBorder: MyConstant().border,
                  focusedBorder: MyConstant().border,
                  hintText: "ชื่อผู้ใช้งาน",
                  hintStyle: MyConstant().normal_text(Colors.grey),
                  prefixIcon: Icon(Icons.account_circle),
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
                style: MyConstant().normal_text(Colors.black),
                controller: password_t,
                obscureText: statusReadEye,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มรหัสผ่าน';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
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

  Widget name_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                style: MyConstant().normal_text(Colors.black),
                controller: name_t,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มชื่อ-นามสกุล';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
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
                style: MyConstant().normal_text(Colors.black),
                maxLength: 10,
                controller: phone_t,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเพิ่มเบอร์โทร';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.all(4),
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

  Widget address_input(size) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: TextFormField(
            style: MyConstant().normal_text(Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาเพิ่มบ้านเลขที่/หมู่บ้าน';
              }
              return null;
            },
            minLines: 5,
            maxLines: null,
            controller: address_t,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(4),
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

  Widget submit_register(size) => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(8),
        ),
        onPressed: () {
          final NativeIosDialogStyle style = currentDialogStyle == 0
              ? NativeIosDialogStyle.alert
              : NativeIosDialogStyle.actionSheet;
          if (_formKey.currentState!.validate()) {
            if (selectedValue_provinces != null &&
                selectedValue_amphures != null &&
                selectedValue_districts != null) {
              showProgressDialog(context);
              update_profile();
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
                setState(() {
                  show_validation = true;
                });
                // normalDialog(
                //     context, 'แจ้งเตือน', "กรุณาเพิ่มข้อมูลให้ครบถ้วน");
                nDialog(context, 'แจ้งเตือน', 'กรุณาเพิ่มข้อมูลให้ครบถ้วน');
              }
            }
          }
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              "แก้ไข",
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
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 16, color: Colors.grey),
          ),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          style: TextStyle(
              fontFamily: 'Prompt', fontSize: 16, color: Colors.black),
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
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 16, color: Colors.grey),
          ),
          value: selectedValue_amphures,
          // icon: const Icon(
          //     Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          style: TextStyle(
              fontFamily: 'Prompt', fontSize: 16, color: Colors.black),

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
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 16, color: Colors.grey),
          ),
          value: selectedValue_districts,
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          style: TextStyle(
              fontFamily: 'Prompt', fontSize: 16, color: Colors.black),
          underline: SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedValue_districts = newValue;
              });
            }
          },
          items: districts_list.isEmpty
              ? []
              : districts_list.map(
                  (districts) {
                    return DropdownMenuItem<String>(
                      value: districts['id'].toString(),
                      child: Text(districts['name_th']),
                    );
                  },
                ).toList(),
        ),
      );
}
