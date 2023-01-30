import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/dialog/dialog.dart';
import 'package:flutter_crud/home/home.dart';
import 'package:flutter_crud/models/mainproductmodel.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:flutter_crud/widget/skeleton_container.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class SearchProduct extends StatefulWidget {
  SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  List<MainProduct> dataproduct = [];
  List<MainProduct> dataproduct_value = [];
  final _scrollControll = TrackingScrollController();
  TextEditingController input_search_text = TextEditingController();
  int offset = 0;
  bool isloading = true;

  //function รับข้อมูลสินค้า
  Future<void> _getproduct(keyword, offset) async {
    print(keyword);
    try {
      var respose =
          await http.get(Uri.http(ipconfig_web, '/api_mobile/search.php', {
        "keyword": keyword.toString(),
        "offset": offset.toString(),
      }));
      if (respose.statusCode == 200) {
        setState(() {
          dataproduct_value = mainProductFromJson(respose.body);
          dataproduct.addAll(dataproduct_value);
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }

  //โหลดข้อมูลเมื่อเลือนสุดจอ
  void myScroll() {
    _scrollControll.addListener(() async {
      double currentScroll = _scrollControll.position.pixels;

      if (_scrollControll.position.pixels ==
          _scrollControll.position.maxScrollExtent) {
        await Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            offset = offset + 10;
            _getproduct(input_search_text.text, offset);
          });
        });
      }
    });
  }

  @override
  void initState() {
    myScroll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollControll,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                title_product(),
                if (dataproduct.isEmpty) ...[
                  empty_product()
                ] else ...[
                  data_product(),
                  if (isloading == true) ...[load_data()],
                ],
              ],
            ),
          ),
          title_product(),
          search_head(),
        ],
      ),
    );
  }

  Container data_product() {
    final orientation = MediaQuery.of(context).orientation;
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
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 4,
          childAspectRatio: (orientation == Orientation.portrait) ? 0.73 : 0.80,
        ),
        itemCount: dataproduct.length,
        itemBuilder: (context, index) {
          var max = int.parse(dataproduct[index].optionPrice.toString());
          var min = int.parse(dataproduct[index].promotionPrice.toString());
          var value_min = max - min;
          return Stack(
            children: [
              InkWell(
                onTap: () async {
                  await launch(
                      "https://www.thaweeyont.com/detail_product?product_id=${dataproduct[index].productId}");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://www.thaweeyont.com/${dataproduct[index].imgLocation}",
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
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                // height: 5,
                                width: double.infinity,
                                child: Text(
                                  "${dataproduct[index].productName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
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
                                    " \฿${dataproduct[index].optionPrice}",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "฿${dataproduct[index].promotionPrice}",
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
            ],
          );
        },
      ),
    );
  }

  Container search_head() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              children: [
                iconback(ColorIcon: (Colors.red)),
                input_search(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded input_search() {
    final sizeIcon = BoxConstraints(minWidth: 40, minHeight: 40);

    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(
        const Radius.circular(4.0),
      ),
    );
    return Expanded(
      child: TextField(
        onChanged: (keyword) {
          setState(() {
            dataproduct.clear();
            dataproduct = [];
          });
          _getproduct(keyword, 0);
        },
        controller: input_search_text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          isDense: true,
          enabledBorder: border,
          focusedBorder: border,
          hintText: "Thaweeyont",
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: sizeIcon,
          suffixIcon: Icon(Icons.camera_alt),
          suffixIconConstraints: sizeIcon,
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Text show_per(index) {
    var max = int.parse(dataproduct[index].optionPrice.toString());
    var min = int.parse(dataproduct[index].promotionPrice.toString());
    var val_min = max - min;
    var persen = (val_min / max) * 100;

    return Text(
      "${persen.toStringAsFixed(0)}%",
      style: MyConstant().small_text(Colors.deepOrange),
    );
  }
}

class load_data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "กำลังโหลด",
      style: TextStyle(
        color: Colors.red[400],
        fontFamily: 'prompt',
        fontSize: 14,
      ),
    );
  }
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
                "สินค้าที่ค้นหา",
                style: MyConstant().bold_text(Colors.red.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                await launch("https://www.thaweeyont.com");
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

class empty_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                size: 25,
                color: Colors.grey,
              ),
              Text(
                "ไม่พบสินค้าที่ค้นหาอยู่",
                style: MyConstant().normal_text(Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class iconback extends StatelessWidget {
  const iconback({
    Key? key,
    required Color? ColorIcon,
  })  : _ColorIcon = ColorIcon,
        super(key: key);

  final Color? _ColorIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TapControl("0")),
          (Route<dynamic> route) => false,
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: _ColorIcon,
        ),
      ),
    );
  }
}
