import 'dart:async';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/dashbordmodel.dart';
import 'package:flutter_crud/widget/skeleton_container.dart';
import 'package:http/http.dart' as http;

class BanerS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        BannerSlider(),
        CashInfo(),
      ],
    );
  }
}

class BannerSlider extends StatefulWidget {
  BannerSlider({Key? key}) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  List<Dashbord> datadashbord = [];
  StreamController datadashbord_val = StreamController();

  Future<void> _getdashbord() async {
    try {
      var respose =
          await http.get(Uri.http(ipconfig_web, '/api_mobile/banner.php'));
      if (respose.statusCode == 200) {}
      datadashbord = dashbordFromJson(respose.body);
      datadashbord_val.add(datadashbord);
    } catch (e) {
      // print("ไม่มีข้อมูล");
    }
  }

  int? _current;

  @override
  void initState() {
    _current = 0;
    _getdashbord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBanner(),
        _buildIndicator(),
      ],
    );
  }

  Container _buildBanner() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      width: double.infinity,
      child: StreamBuilder(
          stream: datadashbord_val.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: datadashbord
                  .map(
                    (i) => CachedNetworkImage(
                      placeholder: (context, url) {
                        return Container(
                          child: SkeletonContainer.square(
                            width: double.infinity,
                            height: double.infinity,
                            radins: 0,
                          ),
                        );
                      },
                      imageUrl:
                          ('https://www.thaweeyont.com/img/banner/${i.imgNamePhone}'),
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
            );
          }),
    );
  }

  _buildIndicator() => Positioned(
        bottom: 95,
        left: 8,
        child: Row(
          children: datadashbord.map((url) {
            int? index = datadashbord.indexOf(url);
            return Container(
              width: 10,
              height: _current == index ? 10 : 1,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: _current == index ? BoxShape.circle : BoxShape.rectangle,
              ),
            );
          }).toList(),
        ),
      );
}

class CashInfo extends StatelessWidget {
  final verticalDivider = VerticalDivider(
    indent: 5,
    endIndent: 5,
    thickness: 1.5,
    width: 24,
    color: Colors.grey[300],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.2,
              blurRadius: 7,
              offset: Offset(0, 1),
            )
          ]),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.qr_code_rounded,
              size: 48,
              color: Colors.grey.withOpacity(0.9),
            ),
            verticalDivider,
            Image.asset(
              'images/logo_home.png',
              height: MediaQuery.of(context).size.height * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
