import 'dart:io';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/introduction/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Simple_introduction extends StatefulWidget {
  @override
  _Simple_introduction createState() => _Simple_introduction();
}

class _Simple_introduction extends State<Simple_introduction> {
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color:
            isCurrentPage ? Color.fromRGBO(230, 185, 128, 1) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  Future<Null> first_start() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('st_isf', "true");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TapControl("0")),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      // style: TextButton.styleFrom(
                      //   // splashColor: Colors.blue[50],
                      //   splashColor

                      // ),
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },

                      child: Text(
                        "ข้าม",
                        style: TextStyle(
                          color: Color.fromRGBO(230, 185, 128, 1),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Prompt',
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("this is slideIndex: $slideIndex");
                        controller.animateToPage(slideIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      // splashColor: Colors.blue[50],
                      child: Text(
                        "ถัดไป",
                        style: TextStyle(
                          color: Color.fromRGBO(230, 185, 128, 1),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Prompt',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () {
                  first_start();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // Color.fromRGBO(238, 208, 110, 0.9),
                        // Color.fromRGBO(164, 128, 44, 1),
                        Color.fromRGBO(238, 208, 110, 1),
                        Color.fromRGBO(250, 227, 152, 0.9),
                        Color.fromRGBO(212, 163, 51, 0.8),
                        Color.fromRGBO(250, 227, 152, 0.9),
                        Color.fromRGBO(164, 128, 44, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  height: Platform.isIOS ? 70 : 60,
                  // color: Color.fromRGBO(238, 208, 110, 1),
                  alignment: Alignment.center,
                  child: Text(
                    "เริ่มต้นใช้งาน",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Prompt',
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              // const Color.fromRGBO(230, 185, 128, 1),
              // const Color.fromRGBO(234, 205, 163, 1),
              Color.fromRGBO(238, 208, 110, 1),
              Color.fromRGBO(250, 227, 152, 0.9),
              Color.fromRGBO(212, 163, 51, 0.8),
              // Color.fromRGBO(250, 227, 152, 0.9),
              // Color.fromRGBO(164, 128, 44, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // stops: [0.0, 1.0],
            tileMode: TileMode.mirror),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath!),
          SizedBox(
            height: 40,
          ),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontFamily: 'Prompt',
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(desc!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Prompt',
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
