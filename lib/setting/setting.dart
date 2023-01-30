import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/privacy/Privacy.dart';
import 'package:flutter_crud/profile/edit_profile.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  var name, idcard, phone, address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofile_user();
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name_user');
      idcard = preferences.getString('id_card');
      phone = preferences.getString('phone_user');
      address = preferences.getString('address_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 17.sp,
              color: Colors.red[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(230, 185, 128, 1),
        title: Text(
          "ตั้งค่า",
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
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
      ),
      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            SizedBox(height: size * 0.04),
            showdata_user(size),
            SizedBox(height: size * 0.04),
            showdata_app(size),
            SizedBox(height: size * 0.04),
            exit(size),
          ],
        ),
      ),
    );
  }

  Widget showdata_user(double size) => Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 2.h),
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
                              Text(
                                "โปรไฟล์",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Edit_profile();
                })).then((value) => {
                      getprofile_user(),
                    });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "แก้ไขข้อมูลส่วนตัว",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 10.sp,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 6.w,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    under_line(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "เลขบัตรประชาชน",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "$idcard",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  under_line(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ชื่อ-นามสกุล",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "$name",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  under_line(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "เบอร์โทรศัพท์",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "$phone",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget showdata_app(double size) => Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 2.h),
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
                              Text(
                                "แอปพลิเคชั่น",
                                style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Privacy();
                }));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ข้อกำหนดและนโยบาย",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 10.sp,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 6.w,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    under_line(),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                launch("tel://053700353");
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ติดต่อแจ้งปัญหา",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 10.sp,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 6.w,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    // under_line(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget exit(double size) => Container(
        width: double.infinity,
        color: Colors.white,
        child: TextButton(
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();
            preferences.setString('st_isf', "true");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LOGIN()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            "ออกจากระบบ",
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 11.sp, color: Colors.red),
          ),
        ),
      );

  Widget under_line() => Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: new Divider(),
      );
}
