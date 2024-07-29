import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/profile/edit_submit_address.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class Edit_address extends StatefulWidget {
  final String id, lat, lng, name, address, provinces, amphures, districts;
  Edit_address(this.id, this.lat, this.lng, this.name, this.address,
      this.provinces, this.amphures, this.districts);
  @override
  _Edit_addressState createState() => _Edit_addressState();
}

class _Edit_addressState extends State<Edit_address> {
  //เรียกใช้ api ลบที่อยู่

  Future delete_address() async {
    var uri = Uri.parse(
        "http://110.164.131.46/flutter_api/api_user/delete_user_address.php");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['id'] = widget.id;

    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      print("ลบข้อมูลสำเร็จ");
    } else {
      print("ลบข้อมูลไม่สำเร็จ");
    }
  }

  var n_lat, n_lng;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
          backgroundColor: Colors.transparent,
          title: Text(
            "แก้ไขที่อยู่",
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
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: SizedBox(),
              // showmap(),
            ),
            next(size),
            delete(size),
          ],
        ));
  }

  //แสดงแผนที่
  // Widget showmap() => GoogleMap(
  //       compassEnabled: false,
  //       mapType: MapType.normal,
  //       tiltGesturesEnabled: false,
  //       initialCameraPosition: CameraPosition(
  //         target: LatLng(double.parse(widget.lat), double.parse(widget.lng)),
  //         zoom: 16,
  //       ),
  //       onMapCreated: (controller) {},
  //       zoomControlsEnabled: false,
  //       myLocationButtonEnabled: true,
  //       myLocationEnabled: true,
  //       markers: n_lat == null
  //           ? <Marker>[mark()].toSet()
  //           : <Marker>[new_mark()].toSet(),
  //       onTap: (argument) {
  //         setState(() {
  //           n_lat = argument.latitude;
  //           n_lng = argument.longitude;
  //         });
  //       },
  //     );

  // Marker mark() {
  //   return Marker(
  //     markerId: MarkerId('id'),
  //     position: LatLng(double.parse(widget.lat), double.parse(widget.lng)),
  //     // icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
  //     infoWindow: InfoWindow(
  //       title: 'สถานที่',
  //       // snippet: 'Lat = $lat , lng = $lng'
  //     ),
  //   );
  // }

  // Marker new_mark() {
  //   return Marker(
  //     markerId: MarkerId('id'),
  //     position: LatLng(n_lat, n_lng),
  //     // icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
  //     infoWindow: InfoWindow(
  //       title: 'สถานที่',
  //       // snippet: 'Lat = $lat , lng = $lng'
  //     ),
  //   );
  // }

  Widget next(size) => Positioned(
        bottom: 7.h,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(12),
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
                'ถัดไป',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (n_lat == null) {
                  // print("${widget.lat}");
                  // print("${widget.lng}");
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return Edit_submit_address(
                        widget.id,
                        widget.lat,
                        widget.lng,
                        widget.name,
                        widget.address,
                        widget.provinces,
                        widget.amphures,
                        widget.districts);
                  }));
                } else {
                  // print("${n_lat}");
                  // print("${n_lng}");
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return Edit_submit_address(
                        widget.id,
                        n_lat.toString(),
                        n_lng.toString(),
                        widget.name,
                        widget.address,
                        widget.provinces,
                        widget.amphures,
                        widget.districts);
                  }));
                }
              },
            ),
          ),
        ),
      );

  Widget delete(size) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.red.shade800,
                ],
              ),
            ),
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
              child: Text(
                'ลบ',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                showProgressDialog(context);
                delete_address();
              },
            ),
          ),
        ),
      );
}
