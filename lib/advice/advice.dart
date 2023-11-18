import 'package:flutter/material.dart';
import 'package:flutter_crud/utility/my_constant.dart';

class Advice extends StatefulWidget {
  const Advice({Key? key}) : super(key: key);

  @override
  State<Advice> createState() => _AdviceState();
}

class _AdviceState extends State<Advice> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            head(size: size),
            body(size: size),
          ],
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.red[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      centerTitle: false,
      backgroundColor: Color.fromRGBO(230, 185, 128, 1),
      title: Text(
        "ข้อเสนอแนะ",
        style: MyConstant().title_text(Colors.red.shade600),
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
              Color.fromRGBO(250, 227, 152, 1),
              Color.fromRGBO(164, 128, 10, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
      ),
    );
  }
}

class head extends StatelessWidget {
  const head({
    Key? key,
    required this.size,
  }) : super(key: key);

  final size;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  "*เนื่องจากทางแอปพลิเคชันได้เปลี่ยนระบบ Login ใหม่",
                  style: MyConstant().bold_text(Colors.black),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  "    โปรดอ่านและทำความเข้าใจข้อเสนอแนะ",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body extends StatelessWidget {
  const body({
    Key? key,
    required this.size,
  }) : super(key: key);

  final size;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "    *สำหรับผู้ใช้ที่เคยลงทะเบียนแล้ว โดยที่ใช้เลขบัตรประชาชนในการ Login ณ ตอนนี้ สามารถใช้เลขบัตรประชาชนของผู้ใช้เป็น 'ชื่อผู้ใช้งาน' และ 'รหัสผ่าน' ใช้เลข 6 ตัวท้ายของเลขบัตรประชน ในการ Login และสามารถไปเปลี่ยน 'รหัสผ่าน' ใหม่ได้",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "    *สำหรับผู้ใช้ที่ไม่เคยลงทะเบียน สามารถลงทะเบียนใหม่แล้ว Login ใช้งานได้ทันที",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}
