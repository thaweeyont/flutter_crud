import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/taguser/detail_user.dart';
import 'package:flutter_crud/connection/ipconfig.dart';
import 'package:flutter_crud/models/jobinstallmodel.dart';
import 'package:flutter_crud/models/jobmodel.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class history_job extends StatefulWidget {
  final String idcard;
  history_job(this.idcard);

  @override
  _history_jobState createState() => _history_jobState();
}

class _history_jobState extends State<history_job> {
  var count = 0, idproduct, st_us, id_st_cr = "null";
  bool check_f = false;
  bool check_i = false;
  List<Job> datajob = [];
  List<Jobinstall> _data_install = [];
  @override
  void initState() {
    super.initState();
    // check_pre();
    _getJob_install(widget.idcard);
    _getJob(widget.idcard);
  }

  void _getJob(String idcard) async {
    try {
      datajob = [];
      var respose = await http.get(Uri.http(
          ipconfig, '/flutter_api/api_user/get_job.php', {"idcard": idcard}));
      print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          datajob = jobFromJson(respose.body);
          for (var item in datajob) {
            if (item.statusJob == "6") {
              check_f = true;
            }
          }
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล--");
    }
  }

  //function select data_install
  void _getJob_install(String idcard) async {
    try {
      var respose = await http.get(Uri.http(ipconfig,
          '/flutter_api/api_user/get_job_install.php', {"idcard": idcard}));
      // print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          _data_install = jobinstallFromJson(respose.body);
          // id_st_cr = _data_install[0].idCredit;
          for (var item in _data_install) {
            if ((item.statusJob == "9" || item.statusJob == "5") &&
                item.statusData == '7') {
              check_i = true;
            }
          }
        });
      }
    } catch (e) {
      print("ไม่มีข้อมูล++");
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: appbar(context),
      body: RefreshIndicator(
        strokeWidth: 2.0,
        edgeOffset: 0.10,
        displacement: 10,
        backgroundColor: Colors.white,
        color: Color.fromRGBO(230, 185, 128, 1),
        onRefresh: () async {
          _getJob_install(widget.idcard);
          _getJob(widget.idcard);
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
              child: detail_button(size),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    if ((check_f == false) && (check_i == false)) ...[
                      no_data(size),
                    ] else ...[
                      Expanded(
                        child: SingleChildScrollView(
                          //ตัวทำยืด
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Column(
                            children: [
                              form_status_history(size),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      backgroundColor: Color.fromRGBO(230, 185, 128, 1),
      elevation: 1,
      title: Text(
        "ประวัติสถานะสินค้า",
        style: MyConstant().title_text(Colors.red.shade600),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.red[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
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
              Color.fromRGBO(164, 128, 10, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
      ),
    );
  }

  Widget detail_button(size) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "รายการของฉัน",
            style: MyConstant().normal_text(Colors.grey),
          ),
        ],
      );

  Widget no_data(size) => Expanded(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox,
                size: size * 0.10,
                color: Colors.grey[350],
              ),
              Text(
                "ไม่พบข้อมูล",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[400],
                  fontFamily: 'Prompt',
                ),
              ),
            ],
          ),
        ),
      );

  Widget form_status_history(size) => Column(
        children: [
          if (datajob.isNotEmpty) ...[
            for (int x = 0; x < datajob.length; x++) ...[
              if (datajob[x].statusJob == "6") ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      var id = datajob[x].idJobHead;
                      var idmec = datajob[x].idStaff;
                      if (datajob[x].idProduct == "" ||
                          datajob[x].idProduct == null) {
                        setState(() {
                          idproduct = "0";
                        });
                      } else {
                        setState(() {
                          idproduct = datajob[x].idProduct;
                        });
                      }
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return DetailUser(id!, idproduct!, "nodata", "nodata");
                      })).then((value) => {
                            _getJob_install(widget.idcard),
                            _getJob(widget.idcard)
                          });
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.history,
                                                size: 6.w,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "ทวียนต์ ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 11.sp,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${datajob[x].date}",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 1.h,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "  สถานะสินค้า : ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 11.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              if (datajob[x].statusJob ==
                                                  "2") ...[
                                                Text(
                                                  "รอดำเนินการ......",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 11.sp,
                                                      color: Colors.blue),
                                                )
                                              ],
                                              if (datajob[x].statusJob ==
                                                  "3") ...[
                                                Text(
                                                  "ตรวจสอบสัญญา......",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 11.sp,
                                                      color: Colors.blue),
                                                )
                                              ],
                                              if (datajob[x].statusJob == "4" ||
                                                  datajob[x].statusJob ==
                                                      "6") ...[
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "สัญญาเสร็จสิ้น......",
                                                    style: TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 11.sp,
                                                        color: Colors.blue),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                              if (datajob[x].statusJob == "7" ||
                                                  datajob[x].statusJob ==
                                                      "5") ...[
                                                Text(
                                                  "รอช่างติดตั้งรับงาน...",
                                                  style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 11.sp,
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   top: size * 0.035,
                        //   child: Container(
                        //       padding: EdgeInsets.all(5),
                        //       decoration: BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(50)),
                        //         color: Colors.white,
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey,
                        //             blurRadius: 1,
                        //             offset: Offset(0, 1), // Shadow position
                        //           ),
                        //         ],
                        //       ),
                        //       child: Container(
                        //         height:
                        //             MediaQuery.of(context).size.width * 0.08,
                        //         width: MediaQuery.of(context).size.width * 0.08,
                        //         child: Icon(
                        //           Icons.history,
                        //           color: Colors.red,
                        //         ),
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ]
          ],
          if (_data_install.isNotEmpty) ...[
            for (int i = 0; i < _data_install.length; i++) ...[
              if ((_data_install[i].statusJob == "9" ||
                      _data_install[i].statusJob == "7" ||
                      _data_install[i].statusJob == "5" ||
                      _data_install[i].statusJob == "8") &&
                  _data_install[i].statusData == "7") ...[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      var id = _data_install[i].idJobHead;
                      var idmec = _data_install[i].idStaff;
                      var time_install = _data_install[i].timeInstall;
                      var id_st_by = _data_install[i].idSale;
                      if (_data_install[i].idCredit.toString().isNotEmpty) {
                        setState(() {
                          var id_st_cr = _data_install[i].idCredit;
                        });
                      }
                      // print("${_data_install[i].statusData}");
                      if (_data_install[i].idProduct == "" ||
                          _data_install[i].idProduct == null) {
                        setState(() {
                          idproduct = "0";
                        });
                      } else {
                        setState(() {
                          idproduct = _data_install[i].idProduct;
                        });
                      }

                      if (_data_install[i].statusData == null) {
                        setState(() {
                          st_us = 0;
                        });
                      } else {
                        var st = _data_install[i].statusData;

                        st_us = int.parse(st!);
                      }

                      if (st_us >= 2) {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return DetailUser(
                              id!, idproduct!, time_install!, idmec!);
                        })).then((value) => {
                              _getJob_install(widget.idcard),
                              _getJob(widget.idcard)
                            });
                      } else {
                        // print("2");
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return DetailUser(
                              id!, idproduct!, time_install!, idmec!);
                        })).then((value) => {
                              _getJob_install(widget.idcard),
                              _getJob(widget.idcard)
                            });
                      }
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.history,
                                                size: 6.w,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "ทวียนต์ ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 11.sp,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${_data_install[i].timeInstall}",
                                                  style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 1.h,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Image.asset(
                                              //   'images/install_logo.png',
                                              //   height: MediaQuery.of(context)
                                              //           .size
                                              //           .width *
                                              //       0.10,
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width *
                                              //       0.10,
                                              // ),
                                              Text(
                                                "  สถานะสินค้า : ",
                                                style: TextStyle(
                                                  fontFamily: 'Prompt',
                                                  fontSize: 11.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "ประวัติการติดตั้ง..",
                                                style: TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 11.sp,
                                                    color: Colors.blue),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   top: size * 0.035,
                        //   child: Container(
                        //     padding: EdgeInsets.all(5),
                        //     decoration: BoxDecoration(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(50)),
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey,
                        //           blurRadius: 1,
                        //           offset: Offset(0, 1), // Shadow position
                        //         ),
                        //       ],
                        //     ),
                        //     child: Container(
                        //       height: MediaQuery.of(context).size.width * 0.08,
                        //       width: MediaQuery.of(context).size.width * 0.08,
                        //       child: Icon(
                        //         Icons.history,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ]
          ],
        ],
      );
}
