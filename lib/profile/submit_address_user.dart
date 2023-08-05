import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';

class Submit_add_address extends StatefulWidget {
  final double lat, lng;
  final String idcard;
  Submit_add_address(this.lat, this.lng, this.idcard);

  @override
  _Submit_add_addressState createState() => _Submit_add_addressState();
}

class _Submit_add_addressState extends State<Submit_add_address> {
  TextEditingController text_name = TextEditingController();
  TextEditingController text_address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue_provinces;
  String? selectedValue_amphures;
  String? selectedValue_districts;
  List provinces_list = [];
  List amphures_list = [];
  List districts_list = [];
  bool show_validation = false;
  int currentDialogStyle = 0;

  @override
  void initState() {
    super.initState();
    get_provinces();
  }

  //เรียกใช้ api เพิ่มข้อมูล
  Future add_address() async {
    var uri =
        Uri.parse("http://110.164.131.46/flutter_api/api_user/add_address.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['idcard'] = widget.idcard;
    request.fields['name'] = text_name.text;
    request.fields['address'] = text_address.text;
    request.fields['lat'] = widget.lat.toString();
    request.fields['lng'] = widget.lng.toString();
    request.fields['provinces'] = selectedValue_provinces.toString();
    request.fields['amphures'] = selectedValue_amphures.toString();
    request.fields['districts'] = selectedValue_districts.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      Navigator.pop(context);
    } else {
      print("ไม่สำเร็จ");
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: appbar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    name(size),
                    provinces(),
                    amphures(),
                    districts(),
                    address(size),
                    SizedBox(height: 20),
                    submit_btn(size),
                  ],
                ),
              ),
            ),
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
      backgroundColor: Color.fromRGBO(230, 185, 128, 1),
      title: Text(
        "สถานที่ตั้ง",
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
          ),
        ),
      ),
    );
  }

  Widget showmap() => GoogleMap(
        compassEnabled: false,
        mapType: MapType.normal,
        tiltGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 17,
        ),
        onMapCreated: (controller) {},
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        // myLocationEnabled: true,
        markers: <Marker>[mark()].toSet(),
        onTap: (argument) {
          // setState(() {
          //   n_lat = argument.latitude;
          //   n_lng = argument.longitude;
          // });
        },
      );

  Marker mark() {
    return Marker(
      markerId: MarkerId('id'),
      position: LatLng(widget.lat, widget.lng),
      // icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'สถานที่ติดตั้ง',
        // snippet: 'Lat = $lat , lng = $lng'
      ),
    );
  }

  Widget name(size) => Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: MyConstant().normal_text(Colors.black),
                      controller: text_name,
                      // keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเพิ่มชื่อสถานที่';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(4),
                        isDense: true,
                        enabledBorder: MyConstant().border,
                        focusedBorder: MyConstant().border,
                        hintText: "ชื่อสถานที่",
                        hintStyle: MyConstant().normal_text(Colors.grey),
                        prefixIcon: Icon(Icons.location_city),
                        prefixIconConstraints: MyConstant().sizeIcon,
                        filled: true,
                        fillColor: MyConstant.light,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget address(size) => Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            // height: 20.h,
            child: TextFormField(
              style: MyConstant().normal_text(Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณาเพิ่มบ้านเลขที่/หมู่บ้าน';
                }
                return null;
              },
              minLines: 5,
              maxLength: 120,
              // keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: text_address,
              decoration: InputDecoration(
                counterText: "",
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
        ),
      );

  Widget submit_btn(size) => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            // side: BorderSide(color: Colors.white),
          ),
          padding: EdgeInsets.all(8),
        ),
        // color: Colors.red,

        onPressed: () {
          final NativeIosDialogStyle style = currentDialogStyle == 0
              ? NativeIosDialogStyle.alert
              : NativeIosDialogStyle.actionSheet;
          if (_formKey.currentState!.validate()) {
            if (selectedValue_provinces != null &&
                selectedValue_amphures != null &&
                selectedValue_districts != null) {
              // print("success");
              add_address();
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
                normalDialog(
                    context, 'แจ้งเตือน', "กรุณาเพิ่มข้อมูลให้ครบถ้วน");
              }
            }
          }
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              "เพิ่ม",
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
          // icon: const Icon(
          //     Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
              fontFamily: 'Prompt', fontSize: 16, color: Colors.black),

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
