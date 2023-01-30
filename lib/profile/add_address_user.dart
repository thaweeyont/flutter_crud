import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/profile/submit_address_user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Address_add extends StatefulWidget {
  final String idcard;
  Address_add(this.idcard);
  @override
  _Address_addState createState() => _Address_addState();
}

class _Address_addState extends State<Address_add> {
  var lat, lng;
  //เช็คการขอสิทใช้ gps
  Future<Null> CheckPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          // Find LatLong
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ location');
        } else {
          // Find LatLong
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      alertLocationService(
          context, 'Location ปิดอยู่?', 'กรุณาเปิด Location ด้วยคะ');
    }
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;

      // print('a_lat = $a_lat, a_lng = $a_lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckPermission();
  }

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
                size: 25,
                color: Colors.red[700],
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "เพิ่มที่อยู่",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
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
        body: lat == null
            ? WillPopScope(
                child: Center(child: CircularProgressIndicator()),
                onWillPop: () async {
                  return false;
                },
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: showmap(),
                  ),
                  next(size),
                  back(size),
                ],
              ));
  }

  //แสดงแผนที่
  Widget showmap() => GoogleMap(
        compassEnabled: false,
        mapType: MapType.normal,
        tiltGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
        onMapCreated: (controller) {},
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: <Marker>[mark()].toSet(),
        onTap: (argument) {
          setState(() {
            lat = argument.latitude;
            lng = argument.longitude;
          });
        },
      );

  Marker mark() {
    return Marker(
      markerId: MarkerId('id'),
      position: LatLng(lat, lng),
      // icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'ที่อยู่คุณ',
        // snippet: 'Lat = $lat , lng = $lng'
      ),
    );
  }

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
                if (lat != "") {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return Submit_add_address(lat, lng, widget.idcard);
                  }));
                }
              },
            ),
          ),
        ),
      );

  Widget back(size) => Positioned(
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
                'ยกเลิก',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      );
}
