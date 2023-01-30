import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/privacy/Privacy.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/login_usermodal.dart';
import 'package:flutter_crud/authentication/register_user.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LOGIN extends StatefulWidget {
  LOGIN({Key? key}) : super(key: key);

  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  TextEditingController idcard = TextEditingController();
  List<Loginusermodel> datauser = [];
  String? token;
  bool _isLoggedIn = false;
  Map _userobj = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferance();
  }

  //function select_idcard
  Future<void> login_user(String id_card) async {
    try {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/login_user.php',
            {"id_card": id_card}),
      );
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datauser = loginusermodelFromJson(respose.body);
        });
        gettoken();
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
      Navigator.pop(context);
      normalDialog(context, 'แจ้งเตือน', "ไม่มีข้อมูล");
    }
  }

  Future<Null> loginlog() async {
    var id_card = datauser[0].idcard;
    var name_user = datauser[0].fullname;
    var phone_user = datauser[0].phoneUser;
    var address_user = datauser[0].addressUser;
    var provinces = datauser[0].idProvinces;
    var amphures = datauser[0].idAmphures;
    var districts = datauser[0].idDistricts;
    var profile = datauser[0].profileUser;
    var member = datauser[0].statusMember;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id_card', id_card!);
    preferences.setString('name_user', name_user!);
    preferences.setString('phone_user', phone_user!);
    preferences.setString('address_user', address_user!);
    preferences.setString('provinces_user', provinces!);
    preferences.setString('amphures_user', amphures!);
    preferences.setString('districts_user', districts!);
    preferences.setString('profile_user', profile!);
    preferences.setString('member', member!);
    preferences.setString('status_advert', "true");

    if (id_card != "") {
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
    if (idcard.text != "") {
      var uri = Uri.parse(
          "http://110.164.131.46/flutter_api/api_user/update_token.php");
      var request = new http.MultipartRequest("POST", uri);

      request.fields['token'] = token;
      request.fields['idcard'] = idcard.text;

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
      String? id_card = preferences.getString('id_card');
      if (id_card != null) {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              logo(context: context),
              id_card_user(size),
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
            Navigator.pop(context);
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
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
        // ignore: deprecated_member_use
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.red[600],
            animationDuration: Duration(milliseconds: 100),
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            if (idcard.text.isEmpty) {
              normalDialog(context, 'แจ้งเตือน', "กรุณากรอกเลขบัตร....");
            } else {
              showProgressDialog(context);
              login_user(idcard.text);
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
