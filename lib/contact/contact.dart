import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  Contact({Key? key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> with TickerProviderStateMixin {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool status_conn = true;
  //validation
  final _formKey = GlobalKey<FormState>();
  //ประกาศตัวแปร
  TextEditingController detail = TextEditingController();

  //เรียกใช้ api เพิ่มข้อมูล
  Future addContact() async {
    var uri =
        Uri.parse("http://110.164.131.46/flutter_api/api_user/add_contact.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['detail'] = detail.text;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("เพิ่มข้อมูลสำเร็จ");
    } else {
      print("ไม่สำเร็จ");
    }
  }

  var count = 0;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
      setState(() {
        status_conn = true;
      });
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: status_conn == false
          ? distconnect(size: size)
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  appbar(),
                ];
              },
              body: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      detail_body(size),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget detail_body(size) => Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: double.infinity,
            child: Container(
              child: Card(
                color: Colors.grey[50],
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Colors.red, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สอบถาม / คำแนะนำ',
                            style: MyConstant().normal_text(Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '     ท่านสามารถส่งความคิดเห็น คำแนะนำ คำติชม หรือสอบถามเกี่ยวกับสินค้าและการบริการของทวียนต์โดยกรอกคำแนะนำหรือติดต่อเบอร์โทร',
                            style: MyConstant().normal_text(Colors.black),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () async {
                              // await launch("fb://page/150711851621535",
                              //     forceWebView: false, forceSafariVC: false);
                              final Uri url =
                                  Uri.parse('fb://page/150711851621535');
                              final Uri url2 = Uri.parse(
                                  'https://www.facebook.com/thaweeyont');

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                await launchUrl(url2);
                              }
                            },
                            child: Row(children: [
                              Image.asset(
                                'images/facebook.png',
                                width: 45,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "ติดต่อผ่านทาง Facebook",
                                style: MyConstant().normal_text(Colors.black),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              // await launch("https://bit.ly/38TNyNa",
                              //     forceWebView: false, forceSafariVC: false);

                              final Uri urlline = Uri.parse(
                                  'https://page.line.me/?accountId=thy0471j');
                              if (!await launchUrl(urlline)) {
                                throw Exception('Could not launch $urlline');
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/line.png',
                                  width: 45,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "ติดต่อผ่านทาง Line",
                                  style: MyConstant().normal_text(Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri phone = Uri.parse('tel:053700353');
                              if (!await canLaunchUrl(phone)) {
                                await launchUrl(phone);
                              } else {
                                throw Exception('Could not launch $phone');
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/phone.png',
                                  width: 45,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "ติดต่อเบอร์โทร : 053700353",
                                  style: MyConstant().normal_text(Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              final Uri tel = Uri.parse('tel:0893200000');
                              if (!await canLaunchUrl(tel)) {
                                await launchUrl(tel);
                              } else {
                                throw Exception('Could not launch $tel');
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/warning_s.png',
                                  width: 45,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "พนักงานบริการไม่สุภาพหรือมีปัญหาการรับบริการ โปรดแจ้ง : 0893200000",
                                        style: MyConstant()
                                            .normal_text(Colors.black),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "คำแนะนำ",
                                style: MyConstant().normal_text(Colors.black),
                              ),
                            ],
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 8,
                                    bottom: 15,
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'Prompt',
                                      fontSize: 16,
                                    ),
                                    minLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: detail,
                                    validator: (String? str) {
                                      if (str == "") {
                                        return "กรุณาป้อนคำแนะนำ";
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                      labelText: "",
                                      labelStyle: TextStyle(
                                        fontFamily: 'Prompt',
                                        fontSize: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              shape: const StadiumBorder(),
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
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: const StadiumBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: size * 0.02),
                                  Text(
                                    'ส่งคำแนะนำ',
                                    style:
                                        MyConstant().normal_text(Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    count++;
                                    if (count > 1) {
                                      contactDialog(context, 'หมายเหตุ !',
                                          "ท่านส่งคำแนะนำแล้ว");
                                    } else {
                                      addContact();
                                      contactDialog(context, 'ส่งคำแนะนำ',
                                          "ขอบคุณที่ให้คำแนะนำ");
                                      detail.clear();
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/TY.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

class appbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(238, 208, 110, 1),
              Color.fromRGBO(250, 227, 152, 0.9),
              Color.fromRGBO(212, 163, 51, 0.8),
              Color.fromRGBO(250, 227, 152, 0.9),
              Color.fromRGBO(164, 128, 44, 1),
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ช่วยเหลือ ",
                style: MyConstant().bold_text(Colors.red.shade600),
              ),
              Icon(
                Icons.contact_support_rounded,
                color: Colors.red[700],
              ),
            ],
          ),
          background: Image.asset(
            "images/contactfilter.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
