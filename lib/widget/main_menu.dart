// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/home/category.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/categorymodel.dart';
import 'package:flutter_crud/widget/skeleton_container.dart';
import 'package:http/http.dart' as http;

class MainMenu extends StatefulWidget {
  MainMenu();

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Categorymodel> category = [];
  StreamController category_val = StreamController();

  Future<void> _category() async {
    try {
      var respose =
          await http.get(Uri.http(ipconfig_web, '/api_mobile/category.php'));
      if (respose.statusCode == 200) {
        // setState(() {
        category = categorymodelFromJson(respose.body);
        category_val.add(category);
        // });
      }
    } catch (e) {
      print("ไม่มีข้อมูล");
    }
  }

  @override
  void initState() {
    _category();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size_h = MediaQuery.of(context).size.height;
    var size_w = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: category_val.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return listmenu(category);
          } else {
            return skeleton_listmenu();
          }
        });
  }
}

class listmenu extends StatelessWidget {
  final category;
  listmenu(this.category);

  @override
  Widget build(BuildContext context) {
    var size_h = MediaQuery.of(context).size.height;
    var size_w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 18),
      height: size_h * 0.27,
      child: GridView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          childAspectRatio: 1.15,
        ),
        itemBuilder: (context, index) {
          final Categorymodel menu = category[index];
          return Container(
            child: Column(
              children: [
                Container(
                  width: size_w * 0.12,
                  height: size_w * 0.12,
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.black26),
                      ),
                      padding: EdgeInsets.all(8),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CateGory(menu.catId)),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Image.network(
                        "https://www.thaweeyont.com/${menu.imgPath}"),
                  ),
                ),
                Text(
                  menu.catName.toString(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
        itemCount: category.length,
      ),
    );
  }
}

class skeleton_listmenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size_h = MediaQuery.of(context).size.height;
    var size_w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 18),
      height: size_h * 0.27,
      child: GridView.builder(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          childAspectRatio: 1.15,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Container(
                  width: size_w * 0.12,
                  height: size_w * 0.12,
                  margin: EdgeInsets.only(bottom: 8),
                  child: SkeletonContainer.square(
                    width: double.infinity,
                    height: double.infinity,
                    radins: 15,
                  ),
                ),
                SkeletonContainer.square(
                  width: size_w * 0.2,
                  height: 10,
                  radins: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
