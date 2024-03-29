import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/profile/edit_submit_address.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/address_usermodel.dart';
import 'package:flutter_crud/profile/submit_address_user.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:native_ios_dialog/native_ios_dialog.dart';
import 'package:sizer/sizer.dart';

class Address_user extends StatefulWidget {
  final username;
  Address_user(this.username);

  @override
  _Address_userState createState() => _Address_userState();
}

class _Address_userState extends State<Address_user> {
  List<AddressUsermodel> data_address = [];
  int currentDialogStyle = 0;

  @override
  void initState() {
    super.initState();
    data_addressuser();
  }

  Future<void> data_addressuser() async {
    print('username>${widget.username}');
    setState(() {
      data_address = [];
    });
    try {
      var respose = await http.get(
        Uri.http(ipconfig, '/flutter_api/api_user/data_address_new.php',
            {"username": widget.username}),
      );
      print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          data_address = addressUsermodelFromJson(respose.body);
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

  Future delete_address(id) async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/delete_user_address.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['id'] = id;

    var response = await request.send();
    if (response.statusCode == 200) {
      data_addressuser();
      Navigator.pop(context);
      print("ลบข้อมูลสำเร็จ");
    } else {
      print("ลบข้อมูลไม่สำเร็จ");
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: appbar(context),
      body: RefreshIndicator(
        strokeWidth: 2.0,
        edgeOffset: 0.10,
        displacement: 10,
        // backgroundColor: Colors.white,
        color: Color.fromRGBO(230, 185, 128, 1),
        onRefresh: () async {
          data_addressuser();
        },
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            // SizedBox(height: size * 0.04),
            address_app(size),
            SizedBox(height: size * 0.02),
            add_address_btn(size),
          ],
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
      backgroundColor: Colors.transparent,
      title: Text(
        "ที่อยู่",
        style: MyConstant().title_text(Colors.red),
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

  Widget address_app(double size) => Column(
        children: [
          SizedBox(height: 10),
          if (data_address.isNotEmpty) ...[
            for (var item in data_address) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      left: 5.w, right: 5.w, bottom: 0, top: 1.h),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_city,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          " ${item.nameUserAddress}",
                                          style: MyConstant()
                                              .normal_text(Colors.black),
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
                      Container(
                        margin: EdgeInsets.only(left: 10.w, right: 6.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${item.addressUser} ต.${item.nameDistricts} อ.${item.nameAmphures} จ.${item.nameProvinces} ${item.zipCode}",
                                    style:
                                        MyConstant().small_text(Colors.black),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            // under_line(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    final NativeIosDialogStyle style =
                                        currentDialogStyle == 0
                                            ? NativeIosDialogStyle.alert
                                            : NativeIosDialogStyle.actionSheet;
                                    if (defaultTargetPlatform ==
                                        TargetPlatform.iOS) {
                                      NativeIosDialog(
                                          title: "ต้องการลบที่อยู่?",
                                          message: "${item.nameUserAddress}",
                                          style: style,
                                          actions: [
                                            NativeIosDialogAction(
                                                text: "ลบที่อยู่",
                                                style:
                                                    NativeIosDialogActionStyle
                                                        .destructive,
                                                onPressed: () {
                                                  delete_address(
                                                      item.idUserAddress);
                                                  showProgressDialog(context);
                                                }),
                                            NativeIosDialogAction(
                                                text: "ยกเลิก",
                                                style:
                                                    NativeIosDialogActionStyle
                                                        .cancel,
                                                onPressed: () {}),
                                          ]).show();
                                    } else if (defaultTargetPlatform ==
                                        TargetPlatform.android) {
                                      print('Phone>>android');
                                      Dialog_deleteaddress(
                                          context,
                                          item.idUserAddress,
                                          item.nameUserAddress);
                                    }

                                    // delete_address_user(item.idUserAddress);
                                  },
                                  child: Text(
                                    'ลบ',
                                    style: MyConstant().small_text(Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return Edit_submit_address(
                                          item.idUserAddress!,
                                          item.lat!,
                                          item.lng!,
                                          item.nameUserAddress!,
                                          item.addressUser!,
                                          item.idProvinces!,
                                          item.idAmphures!,
                                          item.idDistricts!);
                                    })).then((value) {
                                      showProgressDialog(context);
                                      data_addressuser();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(
                                    'แก้ไข',
                                    style: MyConstant()
                                        .small_text(Colors.amberAccent),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      );

  Dialog_deleteaddress(BuildContext context, idUserAddress, nameUserAddress) {
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
        "ลบที่อยู่",
        style: TextStyle(fontFamily: 'Prompt', fontSize: 16, color: Colors.red),
      ),
      onPressed: () {
        delete_address(idUserAddress);
        showProgressDialog(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "ต้องการลบที่อยู่?",
        style: TextStyle(
            fontFamily: 'Prompt', fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: Text(
        "ที่อยู่ ${nameUserAddress}",
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

  Widget add_address_btn(size) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(8),
          ),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return Submit_add_address(
                  19.872728055076823, 99.82792486694699, widget.username);
            })).then((value) {
              showProgressDialog(context);
              data_addressuser();
              Navigator.pop(context);
            });
          },
          child: Container(
            width: double.infinity,
            child: Center(
              child: Text(
                "เพิ่มที่อยู่",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

  Widget under_line() => Padding(
        padding: const EdgeInsets.all(0),
        child: Divider(),
      );
}
