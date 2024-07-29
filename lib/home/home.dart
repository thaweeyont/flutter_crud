import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:flutter_crud/provider/Controllerprovider.dart';
import 'package:flutter_crud/provider/producthotprovider.dart';
import 'package:flutter_crud/provider/productprovider.dart';
import 'package:flutter_crud/provider/promotionprovider.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:flutter_crud/widget/banner_slider.dart';
import 'package:flutter_crud/widget/header.dart';
import 'package:flutter_crud/widget/main_menu.dart';
import 'package:flutter_crud/widget/skeleton_container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int offset = 0;
  bool isloading = true;
  bool isChecked = false;

  //เรียกใช้เมื่อมีการเปิดหน้านี้ขึ้นมา
  @override
  void initState() {
    GetListData();
    super.initState();
  }

  //provider
  GetListData() async {
    //provider สินค้าขายดี
    context.read<ProductProvider>().myScroll(_scrollControll, offset);
    context.read<ControllerProvider>().clear_tabbar();
    await context.read<Promotion>().getpromotion();
    await context.read<ControllerProvider>().advert(context);
    await context.read<ProductProvider>().clear_product();
    await context.read<ProductProvider>().getproduct(offset);
    await context.read<ProducthotProvider>().getproduct_hot();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _scrollControll = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      color: MyConstant.load,
      onRefresh: () async {
        await context.read<ProducthotProvider>().clear_product();
        await context.read<ProductProvider>().clear_product();
        await Future.delayed(Duration(seconds: 3));
        await context.read<ProductProvider>().getproduct(0);
        await context.read<ProducthotProvider>().getproduct_hot();
      },
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollControll,
                child: Column(
                  children: [
                    BanerS(),
                    MainMenu(),
                    SizedBox(height: 10),
                    MyConstant().space_box(15),
                    Promotion_data(),
                    title_product_hot(),
                    data_product_hot(),
                    MyConstant().space_box(15),
                    title_product(),
                    data_product(),
                    title_end_page(),
                  ],
                ),
              ),
              Header(_scrollControll, "head"),
            ],
          ),
        ),
      ),
    );
  }
}

class Promotion_data extends StatelessWidget {
  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }

  const Promotion_data({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, Promotion controllerprovider, child) {
      var items = controllerprovider.datapromotion;
      var item = controllerprovider.detailpromotion;
      if (items.isEmpty) {
        return Container();
      } else {
        return GridView.builder(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.95,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  // color: Color.fromARGB(255, 197, 16, 16),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          items[index].ribbonPromotion.toString().isNotEmpty
                              ? Image.memory(
                                  convertBase64Image(
                                      items[index].ribbonPromotion.toString()),
                                  gaplessPlayback: true,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                )
                              : SizedBox(),
                          date_time_st(context, items[index].startPromotion,
                              items[index].endPromotion)
                        ],
                      ),
                      Container(
                        // color: Colors.cyan,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.35,
                        child: ClipRRect(
                            child: Image.memory(
                          convertBase64Image(
                              items[index].labelPromotion.toString()),
                          gaplessPlayback: true,
                          width: MediaQuery.of(context).size.width * 0.4,
                        )
                            //  CachedNetworkImage(
                            //   fit: BoxFit.fill,
                            //   imageUrl:
                            //       "https://www.thaweeyont.com/img/banner/${items[index].labelPromotion}",
                            //   placeholder: (context, url) {
                            //     return Container(
                            //       child: SkeletonContainer.square(
                            //         width: double.infinity,
                            //         height: double.infinity,
                            //         radins: 0,
                            //       ),
                            //     );
                            //   },
                            //   errorWidget: (context, url, error) =>
                            //       Icon(Icons.error),
                            // ),
                            ),
                      ),
                      Container(
                        // color: Colors.deepPurple,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: GridView(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.3,
                          ),
                          children: [
                            for (var i = 0; i < item.length; i++)
                              if (item[i].idPromotion ==
                                  items[index].idRunPromotion) ...[
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // print('test11');
                                        // await launch(
                                        //     "https://www.thaweeyont.com/detail_product?product_id=${item[i].idProduct}");

                                        Uri url = Uri.parse(
                                            'https://www.thaweeyont.com/detail_product?product_id=${item[i].idProduct}');

                                        if (!await launcher.launchUrl(
                                          url,
                                          mode: launcher
                                              .LaunchMode.externalApplication,
                                        )) {
                                          throw Exception(
                                              'Could not launch $url');
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 8, right: 10),
                                        color:
                                            Color.fromARGB(255, 238, 238, 238),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ClipRect(
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          "https://www.thaweeyont.com/${item[i].imgLocation}",
                                                      placeholder:
                                                          (context, url) {
                                                        return Container(
                                                          child:
                                                              SkeletonContainer
                                                                  .square(
                                                            width:
                                                                double.infinity,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.20,
                                                            radins: 0,
                                                          ),
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    Positioned(
                                                      left: 0,
                                                      bottom: 0,
                                                      child: ClipPath(
                                                        child: items[index]
                                                                .ribbonPromotion
                                                                .toString()
                                                                .isNotEmpty
                                                            ? Image.memory(
                                                                convertBase64Image(items[
                                                                        index]
                                                                    .ribbonPromotion
                                                                    .toString()),
                                                                gaplessPlayback:
                                                                    true,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.2,
                                                              )
                                                            : SizedBox(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 4),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Text(
                                                          "${item[i].nameProduct}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4,
                                                    right: 2,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipPath(
                                                            clipper:
                                                                CuponClipper(),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              color:
                                                                  Colors.yellow,
                                                              child:
                                                                  hiddent_price(
                                                                      item, i),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: Container(
                    color: Colors.grey[200],
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }

  Row date_time_st(context, items, itemslast) {
    String day = DateFormat('dd').format(items);
    String month = DateFormat('MM').format(items);
    String year = DateFormat('yyyy').format(items);
    var total = int.parse(year) + 543;
    String year_format = "$total";

    String lastday = DateFormat('dd').format(itemslast);
    String lastmonth = DateFormat('MM').format(itemslast);
    String lastyear = DateFormat('yyyy').format(itemslast);
    var lasttotal = int.parse(year) + 543;
    String lastyear_format = "$lasttotal";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$day/$month/${year_format[2]}${year_format[3]} ",
          style: TextStyle(fontSize: 13),
        ),
        Text(" - "),
        Text(
          "$lastday/$lastmonth/${lastyear_format[2]}${lastyear_format[3]} ",
          style: TextStyle(fontSize: 13),
        ),
        Icon(
          Icons.date_range,
          size: MediaQuery.of(context).size.width * 0.05,
          color: Colors.red.shade400,
        ),
      ],
    );
  }

  Text hiddent_price(item, i) {
    var setarray = item[i].priceProdPromo;
    var setarray_length = setarray.toString().length;
    String totle_value;
    switch (setarray_length) {
      case 1:
        {
          totle_value = setarray;
        }
        break;
      case 2:
        {
          totle_value = setarray;
        }
        break;
      case 3:
        {
          totle_value = "?" + setarray[1] + setarray[2];
        }
        break;
      case 4:
        {
          totle_value = setarray[0] + "?" + setarray[2] + setarray[3];
        }
        break;
      case 5:
        {
          totle_value = setarray[0] + "?" + "?" + setarray[3] + setarray[4];
        }
        break;
      default:
        {
          totle_value = setarray;
        }
        break;
    }
    return Text(
      "฿$totle_value",
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class buildSkeleton_promotion extends StatelessWidget {
  const buildSkeleton_promotion({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: SkeletonContainer.square(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: MediaQuery.of(context).size.height * 0.015,
                  radins: 15,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.32,
            color: Colors.grey[300],
            child: SkeletonContainer.square(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.32,
              radins: 0,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: GridView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                childAspectRatio: 1.3,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                  margin: EdgeInsets.only(right: 8, top: 8),
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonContainer.square(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18,
                        radins: 0,
                      ),
                      // SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: SkeletonContainer.square(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.015,
                          radins: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: SkeletonContainer.square(
                          width: MediaQuery.of(context).size.width * 0.23,
                          height: MediaQuery.of(context).size.height * 0.015,
                          radins: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class buildSkeleton_product extends StatelessWidget {
  const buildSkeleton_product({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 0),
        margin: EdgeInsets.only(top: 0),
        color: Colors.white,
        child: GridView.builder(
          padding: EdgeInsets.all(2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.73,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              color: Colors.grey[300],
              // height: 200,

              child: SkeletonContainer.square(
                width: double.infinity,
                height: 0,
                radins: 0,
              ),
            );
          },
        ),
      );
}

class buildSkeleton_producthot extends StatelessWidget {
  const buildSkeleton_producthot({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 0),
        height: MediaQuery.of(context).size.height * 0.27,
        child: GridView.builder(
          padding: EdgeInsets.only(left: 4),
          // physics:
          //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // padding: EdgeInsets.symmetric(horizontal: 15),
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 5,
            childAspectRatio: 1.3,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.height * 0.27,
              height: MediaQuery.of(context).size.height * 0.27,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonContainer.square(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.20,
                    radins: 0,
                  ),
                  // SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SkeletonContainer.square(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.02,
                      radins: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SkeletonContainer.square(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.02,
                      radins: 15,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class title_end_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ProductProvider controllerprovider, child) {
      if (controllerprovider.isloading) {
        return load_data();
      } else {
        return end_page();
      }
    });
  }
}

class data_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProductProvider controllerprovider, child) {
        var items = controllerprovider.dataproduct;
        if (items.isEmpty) {
          return buildSkeleton_product();
        } else {
          return list_product(items: items);
        }
      },
    );
  }
}

class list_product extends StatelessWidget {
  const list_product({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MainProduct> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(top: 0),
      color: Colors.grey[200],
      child: GridView.builder(
        padding: EdgeInsets.all(2),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.73,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var max = int.parse(items[index].optionPrice.toString());
          var min = int.parse(items[index].promotionPrice.toString());
          var value_min = max - min;
          return Stack(children: [
            InkWell(
              onTap: () async {
                print('test4');
                // await launch(
                //     "https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}");
                Uri url = Uri.parse(
                    'https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}');
                if (!await launcher.launchUrl(
                  url,
                  mode: launcher.LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ClipRect(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://www.thaweeyont.com/${items[index].imgLocation}",
                            placeholder: (context, url) {
                              return Container(
                                child: SkeletonContainer.square(
                                  width: double.infinity,
                                  height: double.infinity,
                                  radins: 0,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "${items[index].productName}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  " \฿${items[index].optionPrice}",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "฿${items[index].promotionPrice}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (value_min > 300) ...[
              Positioned(
                right: 0,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    color: Colors.yellow,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(
                          "ลด",
                          style: MyConstant().small_text(Colors.white),
                        ),
                        show_per(index),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ]);
        },
      ),
    );
  }

  Text show_per(index) {
    var max = int.parse(items[index].optionPrice.toString());
    var min = int.parse(items[index].promotionPrice.toString());
    var val_min = max - min;
    var persen = (val_min / max) * 100;

    return Text(
      "${persen.toStringAsFixed(0)}%",
      style: MyConstant().small_text(Colors.deepOrange),
    );
  }
}

class data_product_hot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ProducthotProvider controllerprovider, child) {
      var items = controllerprovider.dataproduct_hot;
      if (items.isEmpty) {
        return buildSkeleton_producthot(context: context);
      } else {
        return list_product_hot(items: items);
      }
    });
  }
}

class list_product_hot extends StatelessWidget {
  const list_product_hot({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MainProduct> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 6),
      height: MediaQuery.of(context).size.height * 0.27,
      child: GridView.builder(
        // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.only(left: 4),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          childAspectRatio: 1.3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              InkWell(
                onTap: () async {
                  print('test3');
                  // await launch(
                  //     "https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}");
                  Uri linkProductHot = Uri.parse(
                      'https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}');
                  if (!await launcher.launchUrl(
                    linkProductHot,
                    mode: launcher.LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $linkProductHot');
                  }
                  ;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://www.thaweeyont.com/${items[index].imgLocation}",
                        placeholder: (context, url) {
                          return Container(
                            child: SkeletonContainer.square(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.20,
                              radins: 0,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              // height: 5,
                              width: double.infinity,
                              child: Text(
                                "${items[index].productName}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    " \฿${items[index].optionPrice}",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "฿${items[index].promotionPrice}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    color: Colors.yellow,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(
                          "ลด",
                          style: MyConstant().small_text(Colors.white),
                        ),
                        show_per(index),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Text show_per(index) {
    var max = int.parse(items[index].optionPrice.toString());
    var min = int.parse(items[index].promotionPrice.toString());
    var val_min = max - min;
    var persen = (val_min / max) * 100;

    return Text(
      "${persen.toStringAsFixed(0)}%",
      style: MyConstant().small_text(Colors.deepOrange),
    );
  }
}

class end_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "สิ้นสุดหน้า",
      style: TextStyle(
        color: Colors.red[400],
        fontFamily: 'prompt',
        fontSize: 14,
      ),
    );
  }
}

class load_data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "กำลังโหลด",
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class distconnect extends StatelessWidget {
  const distconnect({
    Key? key,
    required this.size,
  }) : super(key: key);

  final size;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            height: size * 0.07,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: Colors.red[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "OFFLINE",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  SizedBox(
                    width: 12.0,
                    height: size * 0.03,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.grey[400],
                ),
                Text(
                  "ไม่มีการเชื่อมต่ออินเตอร์เน็ต",
                  style: TextStyle(
                      fontFamily: 'Prompt',
                      color: Colors.grey[400],
                      fontSize: 17),
                ),
              ],
            ),
          )
        ],
      );
}

class load extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Center(
          child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Color.fromRGBO(230, 185, 128, 1)),
      )),
      onWillPop: () async {
        return false;
      },
    );
  }
}

class title_product_hot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "สินค้าขายดี",
                style: MyConstant().bold_text(Colors.red.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                print('test');
                // await launch("https://www.thaweeyont.com/hotproduct");
                Uri link = Uri.parse('https://www.thaweeyont.com/hotproduct');
                if (!await launcher.launchUrl(
                  link,
                  mode: launcher.LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $link');
                }
                ;
              },
              child: Row(
                children: [
                  Text(
                    "ดูเพิ่มเติม",
                    style: MyConstant().small_text(Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

class title_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "สินค้าทั้งหมด",
                style: MyConstant().bold_text(Colors.red.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                print('test2');
                // await launch("https://www.thaweeyont.com");
                Uri url = Uri.parse('https://www.thaweeyont.com');
                if (!await launcher.launchUrl(
                  url,
                  mode: launcher.LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Row(
                children: [
                  Text(
                    "ดูเพิ่มเติม",
                    style: MyConstant().small_text(Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

class CuponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);

    final radius = size.height * .065;

    Path holePath = Path();

    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(0, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }
    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(size.width, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / 4;
    const smallLineHeight = 4;
    var path = Path();

    path.lineTo(0, size.height);
    for (int i = 1; i <= 20; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, size.height);
      } else {
        path.lineTo(smallLineLength * i, size.height - smallLineHeight);
      }
    }
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
