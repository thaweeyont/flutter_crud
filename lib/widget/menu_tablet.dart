import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/contact/contact.dart';
import 'package:flutter_crud/profile/profile_user.dart';
import 'package:flutter_crud/taguser/tag_user.dart';

Future<Null> menu(BuildContext context) async {
  double size = MediaQuery.of(context).size.width;
  showAnimatedDialog(
    // barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: true,
    builder: (context) => SimpleDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                // color: Colors.white,

                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TapControl("0")),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  width: size * 0.07,
                  height: size * 0.07,
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        size: size * 0.05,
                        color: Color.fromRGBO(230, 185, 128, 1),
                      ),
                      Text(
                        "หน้าหลัก",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TapControl("1")),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  width: size * 0.07,
                  height: size * 0.07,
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: size * 0.05,
                        color: Color.fromRGBO(230, 185, 128, 1),
                      ),
                      Text(
                        "ติดตามสินค้า",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TapControl("2")),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  width: size * 0.07,
                  height: size * 0.07,
                  child: Column(
                    children: [
                      Icon(
                        Icons.contact_support_rounded,
                        size: size * 0.05,
                        color: Color.fromRGBO(230, 185, 128, 1),
                      ),
                      Text(
                        "ช่วยเหลือ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TapControl("3")),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  width: size * 0.07,
                  height: size * 0.07,
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: size * 0.05,
                        color: Color.fromRGBO(230, 185, 128, 1),
                      ),
                      Text(
                        "โปรไฟล์",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'prompt',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(seconds: 1),
  );
}
