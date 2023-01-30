import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  double size = MediaQuery.of(context).size.width;
  showAnimatedDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      title: ListTile(
        leading: Icon(Icons.warning_rounded, color: Colors.red, size: 45),
        title: Text(
          title,
          style: MyConstant().title_text(Colors.black87),
        ),
        subtitle: Text(
          message,
          style: MyConstant().normal_text(Colors.grey.shade600),
        ),
      ),
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Column(
            children: [
              Text(
                "ตกลง",
                style: MyConstant().small_text(Colors.red),
              ),
            ],
          ),
        ),
      ],
    ),
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 800),
  );
}

Future<Null> successDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Image.asset('images/success.png'),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
      ),
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}

Future<Null> alertLocationService(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: ListTile(
          leading: Image.asset('images/error_pin.gif'),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            message,
            style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
          ),
        ),
        children: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Null> contactDialog(
    BuildContext context, String title, String message) async {
  double size = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      title: ListTile(
        leading: Image.asset(
          'images/TY.png',
          // width: size * 0.3,
          height: size * 0.55,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontFamily: 'Prompt', fontSize: 16),
        ),
      ),
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  "ตกลง",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 16,
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}

Future<Null> showProgressDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => WillPopScope(
      child: Center(
          child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Color.fromRGBO(230, 185, 128, 1)),
      )),
      onWillPop: () async {
        return false;
      },
    ),
  );
}
