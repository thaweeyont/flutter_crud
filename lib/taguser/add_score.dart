import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/main.dart';
import 'package:flutter_crud/models/data_get_receiptmodel.dart';
import 'package:flutter_crud/models/datastaffmodel.dart';
import 'package:flutter_crud/widget/coloricon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';

class AddScore extends StatefulWidget {
  final String id_job_gen,
      id_mechanic,
      name_mechanic,
      time_install,
      id_sale,
      id_credit;
  AddScore(this.id_job_gen, this.id_mechanic, this.name_mechanic,
      this.time_install, this.id_sale, this.id_credit);

  @override
  _AddScoreState createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  bool status_show = false, load_progress = false;
  var name_sale, name_credit;
  List<DataStaffScore> datastaff = [];
  List<DataGetReceipt> datareceipt = [];
  File? file; //ภาพใบเสร็จ
  File? file2; //ภาพการติดตั้ง
  var score_buy = 0;
  var score_credit = 0;
  var score_mechanic = 0;
  var count_add;
  var nameFile2;
  var nameFile;
  ScrollController _controller = new ScrollController();
  bool check_re1 = false;
  bool check_re2 = false;
  bool loading = false;
  final key1 = UniqueKey();
  final key2 = UniqueKey();

  bool loading_cr = false;
  final key1_cr = UniqueKey();
  final key2_cr = UniqueKey();

  bool loading_mec = false;
  final key1_mec = UniqueKey();
  final key2_mec = UniqueKey();

  int currentDialogStyle = 0;

  TextEditingController message_by = TextEditingController();
  TextEditingController message_cr = TextEditingController();
  TextEditingController message_mec = TextEditingController();

  @override
  void initState() {
    super.initState();
    data_staff();
    data_get_receipt();
  }

  Future addscore(String nameFile, nameFile2) async {
    print("=============================================>");
    var uri =
        Uri.parse("http://110.164.131.46/flutter_api/api_user/add_score.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['id_gen'] = widget.id_job_gen;

    if (status_show == true) {
      if (name_sale != "" && name_sale != null) {
        if (score_buy == 0) {
          setState(() {
            score_buy = 1;
          });
        }
        //ข้อมูลพนักงานขาย
        request.fields['id_sale'] = widget.id_sale;
        request.fields['message_by'] = message_by.text;
        request.fields['score_by'] = score_buy.toString();
      }
      if (name_credit != "" && name_credit != null) {
        if (score_credit == 0) {
          setState(() {
            score_credit = 1;
          });
        }
        //ข้อมูลพนักงานสินเชื่อ
        request.fields['id_credit'] = widget.id_credit;
        request.fields['message_cr'] = message_cr.text;
        request.fields['score_cr'] = score_credit.toString();
      }
    }
    if (score_mechanic == 0) {
      setState(() {
        score_mechanic = 1;
      });
    }
    //ข้อมูลพนักงานช่างติดตั้ง
    request.fields['id_mechanic'] = widget.id_mechanic;
    request.fields['message_mec'] = message_mec.text;
    request.fields['score_mec'] = score_mechanic.toString();

    request.fields['time_install'] = widget.time_install;
    request.fields['count'] = count_add.toString();
    request.fields['name_img'] = nameFile;
    request.fields['name_img2'] = nameFile2;
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TapControl("1")),
        (Route<dynamic> route) => false,
      );
    } else {
      print("ไม่สำเร็จ");
    }
  }

  void insert_img() async {
    if (file2 != null) {
      int install = Random().nextInt(10000000);
      nameFile2 = 'img_install$install.jpg';
      String apisaveimg =
          'http://$ipconfig/flutter_api/ad_img_score.php?id_gen=${widget.id_job_gen}';
      Map<String, dynamic> map_receipt2 = {};
      map_receipt2['file'] =
          await MultipartFile.fromFile(file2!.path, filename: nameFile2);
      FormData data_img2 = FormData.fromMap(map_receipt2);
      var response =
          await Dio().post(apisaveimg, data: data_img2).then((value) {
        if (file == null && file2 != null) {
          addscore("", nameFile2);
        }
      });
    }
    if (file != null) {
      int i = Random().nextInt(10000000);
      nameFile = 'img_adscore$i.jpg';
      String apisaveimg =
          'http://$ipconfig/flutter_api/ad_img_score.php?id_gen=${widget.id_job_gen}';
      Map<String, dynamic> map_receipt = {};
      map_receipt['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData data_img = FormData.fromMap(map_receipt);
      var response = await Dio().post(apisaveimg, data: data_img).then((value) {
        if (nameFile == null) {
          addscore("", nameFile2);
        } else {
          addscore(nameFile, nameFile2);
        }
      });
    }
  }

  Future<void> data_get_receipt() async {
    try {
      var respose = await http.get(
          Uri.http(ipconfig, '/flutter_api/api_user/get_data_receipt.php', {
        "id_job_gen": widget.id_job_gen,
        "id_mechanic": widget.id_mechanic,
      }));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datareceipt = dataGetReceiptFromJson(respose.body);
        });
      }
    } catch (e) {
      setState(() {
        count_add = 0;
        load_progress = true;
      });
      print("ไม่มีข้อมูล");
    }
  }

  Future<void> data_staff() async {
    try {
      var respose = await http.get(
          Uri.http(ipconfig, '/flutter_api/api_user/get_data_staff_score.php', {
        "id_job_gen": widget.id_job_gen,
      }));
      // print(respose.body);
      if (respose.statusCode == 200) {
        var sum = 1;
        setState(() {
          datastaff = dataStaffScoreFromJson(respose.body);
          for (var i = 0; i < datastaff.length; i++) {
            sum++;
            if (datastaff[i].idStaff == widget.id_credit) {
              name_credit = datastaff[i].fullnameStaff;
            } else if (datastaff[i].idStaff == widget.id_sale) {
              name_sale = datastaff[i].fullnameStaff;
            }
          }
          load_progress = true;
          status_show = true;
          count_add = sum;
        });
      }
    } catch (e) {
      setState(() {
        count_add = 0;
        load_progress = true;
      });
      print("ไม่มีข้อมูล");
    }
  }

  Future<Null> zoom_img() async {
    double size = MediaQuery.of(context).size.width;
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SimpleDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(0, 0), // Shadow position
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: size * 0.04,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    file!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1),
    );
  }

  Future<Null> zoom_img2() async {
    double size = MediaQuery.of(context).size.width;
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SimpleDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(0, 0), // Shadow position
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: size * 0.04,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    file2!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1),
    );
  }

  Future<Null> delete_img() async {
    setState(() {
      file = null;
      // files[index] = null;
    });
  }

  Future<Null> delete_img2() async {
    setState(() {
      file2 = null;
      // files[index] = null;
    });
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
    } catch (e) {}
  }

  Future<Null> processImagePicker2(ImageSource source) async {
    try {
      var result2 = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file2 = File(result2!.path);
      });
    } catch (e) {}
  }

  Future<Null> img_score() async {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Icon(
            Icons.image,
            size: 55,
          ),
          title: Text(
            'ภาพใบเสร็จ',
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            'โปรดเลือกภาพจากรูปภาพในเครื่อง หรือ ถ่ายภาพ',
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery);
                },
                child: Text(
                  "คลังภาพ",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera);
                },
                child: Text(
                  "เปิดกล้อง",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    // color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  Future<Null> img_score2() async {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Icon(
            Icons.image,
            size: 55,
          ),
          title: Text(
            'ภาพการติดตั้ง',
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            'โปรดเลือกภาพจากรูปภาพในเครื่อง หรือ ถ่ายภาพ',
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker2(ImageSource.gallery);
                },
                child: Text(
                  "คลังภาพ",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker2(ImageSource.camera);
                },
                child: Text(
                  "เปิดกล้อง",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    // color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 17.sp,
              color: Colors.red[700],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(230, 185, 128, 1),
        elevation: 0,
        title: Text(
          "ให้คะแนนพนักงาน",
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
        ),
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
            ),
          ),
        ),
      ),
      body: load_progress == false
          ? WillPopScope(
              child: Center(child: CircularProgressIndicator()),
              onWillPop: () async {
                return false;
              },
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: RefreshIndicator(
                strokeWidth: 2.0,
                edgeOffset: 0.10,
                displacement: 10,
                backgroundColor: Colors.white,
                color: Color.fromRGBO(230, 185, 128, 1),
                onRefresh: () async {
                  data_staff();
                },
                child: Scrollbar(
                  radius: Radius.circular(30),
                  thickness: 6,
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      //ภาพใบเสร็จ
                      image_install(size),
                      SizedBox(
                        width: double.infinity,
                        height: 15,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      image(size),
                      SizedBox(
                        width: double.infinity,
                        height: 15,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      show_score(size),
                      SizedBox(
                        width: double.infinity,
                        height: 15,
                      ),
                      submit_add_score(size),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget image(size) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "แนบใบเสร็จ/ใบรับของ",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: size * 0.034,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    if (datareceipt[0].imageReceipt1 != "" ||
                        datareceipt[0].imageReceipt2 != "") ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                img_score();
                              },
                              child: file == null
                                  ? DottedBorder(
                                      color: Colors.grey.shade400,
                                      strokeWidth: 1,
                                      dashPattern: [10, 5],
                                      customPath: (size) {
                                        return Path()
                                          ..moveTo(10, 0)
                                          ..lineTo(size.width - 10, 0)
                                          ..arcToPoint(Offset(size.width, 10),
                                              radius: Radius.circular(10))
                                          ..lineTo(size.width, size.height - 10)
                                          ..arcToPoint(
                                              Offset(
                                                  size.width - 10, size.height),
                                              radius: Radius.circular(10))
                                          ..lineTo(10, size.height)
                                          ..arcToPoint(
                                              Offset(0, size.height - 10),
                                              radius: Radius.circular(10))
                                          ..lineTo(0, 10)
                                          ..arcToPoint(Offset(10, 0),
                                              radius: Radius.circular(10));
                                      },
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: size * 0.25,
                                        color: Colors.grey[400],
                                      ),
                                    )
                                  : Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () => zoom_img(),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                color: Colors.white),
                                            alignment: Alignment.center,
                                            height: size * 0.55,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                file!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: InkWell(
                                            onTap: () {
                                              delete_img();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                                color: Colors.white38,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,

                                                    offset: Offset(0,
                                                        0), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      )
                    ] else ...[
                      CheckboxListTile(
                        title: Text("ไม่มีใบเสร็จ/ใบรับของ",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.034,
                              color: Colors.grey[700],
                            )),
                        value: check_re1,
                        onChanged: (newValue) {
                          setState(() {
                            check_re1 = newValue!;

                            if (newValue == true) {
                              check_re2 = false;
                              delete_img();
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                      CheckboxListTile(
                        title: Text("มีใบเสร็จหรือได้รับใบเสร็จเพิ่มเติม",
                            style: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.034,
                              color: Colors.grey[700],
                            )),
                        value: check_re2,
                        onChanged: (newValue) {
                          setState(() {
                            check_re2 = newValue!;
                            if (newValue == true) {
                              check_re1 = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                      Container(
                        child: check_re2 == false
                            ? null
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        img_score();
                                      },
                                      child: file == null
                                          ? DottedBorder(
                                              color: Colors.grey.shade400,
                                              strokeWidth: 1,
                                              dashPattern: [10, 5],
                                              customPath: (size) {
                                                return Path()
                                                  ..moveTo(10, 0)
                                                  ..lineTo(size.width - 10, 0)
                                                  ..arcToPoint(
                                                      Offset(size.width, 10),
                                                      radius:
                                                          Radius.circular(10))
                                                  ..lineTo(size.width,
                                                      size.height - 10)
                                                  ..arcToPoint(
                                                      Offset(size.width - 10,
                                                          size.height),
                                                      radius:
                                                          Radius.circular(10))
                                                  ..lineTo(10, size.height)
                                                  ..arcToPoint(
                                                      Offset(
                                                          0, size.height - 10),
                                                      radius:
                                                          Radius.circular(10))
                                                  ..lineTo(0, 10)
                                                  ..arcToPoint(Offset(10, 0),
                                                      radius:
                                                          Radius.circular(10));
                                              },
                                              child: Icon(
                                                Icons.add_rounded,
                                                size: size * 0.25,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          : Stack(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () => zoom_img(),
                                                  child: Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                            color:
                                                                Colors.white),
                                                    alignment: Alignment.center,
                                                    height: size * 0.55,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                        file!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: InkWell(
                                                    onTap: () {
                                                      delete_img();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(30),
                                                        ),
                                                        color: Colors.white38,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white,

                                                            offset: Offset(0,
                                                                0), // Shadow position
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget image_install(size) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "ภาพการติดตั้ง",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: size * 0.034,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              img_score2();
                            },
                            child: file2 == null
                                ? DottedBorder(
                                    color: Colors.grey.shade400,
                                    strokeWidth: 1,
                                    // radius: Radius.circular(10.0),
                                    dashPattern: [10, 5],
                                    customPath: (size) {
                                      return Path()
                                        ..moveTo(10, 0)
                                        ..lineTo(size.width - 10, 0)
                                        ..arcToPoint(Offset(size.width, 10),
                                            radius: Radius.circular(10))
                                        ..lineTo(size.width, size.height - 10)
                                        ..arcToPoint(
                                            Offset(
                                                size.width - 10, size.height),
                                            radius: Radius.circular(10))
                                        ..lineTo(10, size.height)
                                        ..arcToPoint(
                                            Offset(0, size.height - 10),
                                            radius: Radius.circular(10))
                                        ..lineTo(0, 10)
                                        ..arcToPoint(Offset(10, 0),
                                            radius: Radius.circular(10));
                                    },
                                    child: Icon(
                                      Icons.add_rounded,
                                      size: size * 0.25,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => zoom_img2(),
                                        child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.white),
                                          alignment: Alignment.center,
                                          height: size * 0.55,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              file2!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: InkWell(
                                          onTap: () {
                                            delete_img2();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                              color: Colors.white38,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white,

                                                  offset: Offset(
                                                      0, 0), // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget show_score(size) => Container(
        child: Column(
          children: [
            //พนักงานขาย
            if (status_show == true) ...[
              if (name_sale != "" && name_sale != null) ...[
                score_by(size),
                Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                    child: new Divider()),
              ],
              if (name_credit != "" && name_credit != null) ...[
                score_cr(size),
                Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                    child: new Divider()),
              ],
            ],
            if (widget.id_mechanic.isNotEmpty) ...[
              score_mec(size),
              Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                  child: new Divider()),
            ],
          ],
        ),
      );

  Widget score_by(size) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "คะแนนพนักงานขาย",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "ชื่อพนักงาน : $name_sale",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  case_score(score_buy),
                  InkWell(
                    onTap: () {
                      setState(() {
                        loading = !loading;
                        message_by.clear();
                      });
                    },
                    child: loading
                        ? Icon(Icons.delete_forever, color: Colors.red)
                        : Icon(Icons.message, color: Colors.grey[600]),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: animate_by(size),
              ),
            ],
          ),
        ),
      );

  Widget score_cr(size) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "คะแนนพนักงานสินเชื่อ",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "ชื่อพนักงาน : $name_credit",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  case_score_cr(score_credit),
                  InkWell(
                    onTap: () {
                      setState(() {
                        loading_cr = !loading_cr;
                        message_cr.clear();
                      });
                    },
                    child: loading_cr
                        ? Icon(Icons.delete_forever, color: Colors.red)
                        : Icon(Icons.message, color: Colors.grey[600]),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: animate_cr(size),
              ),
            ],
          ),
        ),
      );

  Widget score_mec(size) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "คะแนนพนักงานติดตั้ง",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "ชื่อพนักงาน : ${widget.name_mechanic}",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: size * 0.034,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  case_score_mec(score_mechanic),
                  InkWell(
                    onTap: () {
                      setState(() {
                        loading_mec = !loading_mec;
                        message_mec.clear();
                      });
                    },
                    child: loading_mec
                        ? Icon(Icons.delete_forever, color: Colors.red)
                        : Icon(Icons.message, color: Colors.grey[600]),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: animate_mec(size),
              ),
            ],
          ),
        ),
      );

  Widget case_score(int st) => Row(
        children: [
          if (st == 0) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 1) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 2) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 3) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 4) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 5) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_buy = 5;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
          ]
        ],
      );

  Widget case_score_cr(int st) => Row(
        children: [
          if (st == 0) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 1) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 2) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 3) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 4) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 5) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_credit = 5;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
          ]
        ],
      );

  Widget case_score_mec(int st) => Row(
        children: [
          if (st == 0) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 1) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 2) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 3) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 4) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: Icon(Icons.star, size: 35, color: Colors.grey[400]),
            ),
          ] else if (st == 5) ...[
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 1;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 2;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 3;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 4;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                setState(() {
                  score_mechanic = 5;
                });
              },
              child: LinearGradientMask(
                  child: Icon(Icons.star, size: 35, color: Colors.white)),
            ),
          ]
        ],
      );

  Widget submit_add_score(size) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(238, 208, 110, 1),
              Color.fromRGBO(250, 227, 152, 0.9),
              Color.fromRGBO(212, 163, 51, 0.8),
              Color.fromRGBO(250, 227, 152, 0.9),
              Color.fromRGBO(164, 128, 44, 1),
            ],
          ),
        ),
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          child: Text(
            'ให้คะแนน',
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 11.sp,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            final NativeIosDialogStyle style = currentDialogStyle == 0
                ? NativeIosDialogStyle.alert
                : NativeIosDialogStyle.actionSheet;
            if (file2 != null) {
              if (score_buy != 0 || score_credit != 0 || score_mechanic != 0) {
                showProgressDialog(context);
                insert_img();
              } else {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  NativeIosDialog(
                      title: "แจ้งเตือน",
                      message: "กรุณาให้คะแนนพนักงาน",
                      style: style,
                      actions: [
                        NativeIosDialogAction(
                            text: "ตกลง",
                            style: NativeIosDialogActionStyle.defaultStyle,
                            onPressed: () {}),
                      ]).show();
                } else if (defaultTargetPlatform == TargetPlatform.android) {
                  print('Phone>>android');
                  // normalDialog(context, 'แจ้งเตือน', 'กรุณาให้คะแนนพนักงาน');
                  nDialog(context, 'แจ้งเตือน', 'กรุณาให้คะแนนพนักงาน');
                }
              }
            } else {
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                NativeIosDialog(
                    title: "แจ้งเตือน",
                    message: "กรุณาเพิ่มใบเสร็จ / ภาพการติดตั้ง",
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
                //     context, 'แจ้งเตือน', 'กรุณาเพิ่มใบเสร็จ / ภาพการติดตั้ง');
                nDialog(
                    context, 'แจ้งเตือน', 'กรุณาเพิ่มใบเสร็จ / ภาพการติดตั้ง');
              }
            }
          },
        ),
      ));

  Widget animate_by(size) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: loading
            ? Container(
                key: key1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: size * 0.035,
                            fontFamily: 'Prompt',
                          ),
                          minLines: 5,
                          // keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: message_by,
                          decoration: InputDecoration(
                            hintText: "หมายเหตุ !",
                            hintStyle: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.035,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                key: key2,
              ),
      );

  Widget animate_cr(size) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: loading_cr
            ? Container(
                key: key1_cr,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: size * 0.035,
                            fontFamily: 'Prompt',
                          ),
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: message_cr,
                          decoration: InputDecoration(
                            hintText: "หมายเหตุ !",
                            hintStyle: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.035,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                key: key2_cr,
              ),
      );

  Widget animate_mec(size) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: loading_mec
            ? Container(
                key: key1_mec,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: size * 0.035,
                            fontFamily: 'Prompt',
                          ),
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: message_mec,
                          decoration: InputDecoration(
                            hintText: "หมายเหตุ !",
                            hintStyle: TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: size * 0.035,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                key: key2_mec,
              ),
      );

  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(child: CircularProgressIndicator()),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}
