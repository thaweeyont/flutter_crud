import 'package:flutter/material.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTablet extends StatefulWidget {
  HomeTablet({Key? key}) : super(key: key);

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow, Colors.blue, Colors.purple],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.5, 0.8, 0.9],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "COMING SOON",
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'prompt',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "ในโหมดของ Tablet ยังไม่พร้อมใช้งานในขณะนี้",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'prompt',
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
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
                  launch("https://www.thaweeyont.com/");
                },
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "ไปยังเว็ปไซต์ ทวียนต์",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'prompt',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
