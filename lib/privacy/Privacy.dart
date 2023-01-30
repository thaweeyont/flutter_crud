import 'package:flutter/material.dart';
import 'package:flutter_crud/utility/my_constant.dart';
import 'package:sizer/sizer.dart';

class Privacy extends StatefulWidget {
  Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: appbar(context),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Scrollbar(
              radius: Radius.circular(30),
              thickness: 2,
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  head(size: size),
                  body1(size: size),
                  body2(size: size),
                  body3(size: size),
                  body4(size: size),
                  body5(size: size),
                  body6(size: size),
                  head2(size: size),
                ],
              ),
            ),
          ),
        );
      },
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
        "นโยบายความเป็นส่วนตัว",
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

class head2 extends StatelessWidget {
  const head2({
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
                  "ข้อมูลที่รวบรวมและเหตุผลที่รวบรวม",
                  style: MyConstant().normal_text(Colors.black),
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
                  "ข้อมูลที่ท่านให้บริษัท",
                  style: MyConstant().normal_text(Colors.grey.shade800),
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
                  "ให้ท่านแจ้งหรือกรอกข้อมูลส่วนบุคคลของท่าน เช่น ชื่อ-นามสกุล ที่อยู่ หมายเลขโทรศัพท์ หมายเลขบัตรประจำตัวประชาชน เป็นต้น สำหรับแอพพลิเคชั่นที่ต้องให้มีการลงทะเบียนก่อนการใช้งาน เพื่อจัดเก็บและบันทึกไว้ในบัญชีผู้ใช้งาน นอกจากนี้ หากท่านประสงค์ที่จะใช้ประโยชน์อย่างเต็มที่จากการใช้งานแอพพลิเคชั่น บริษัทอาจต้องขอให้ท่านสร้างโปรไฟล์ของท่านด้วย",
                  style: MyConstant().small_text(Colors.grey),
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
                  "ข้อมูลที่บริษัทได้รับจากการใช้งานแอพพลิชั่นของท่านข้อมูลที่ท่านให้บริษัท",
                  style: MyConstant().normal_text(Colors.grey.shade800),
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
                  "บริษัทรวบรวมข้อมูลจากการใช้งานแอพพลิเคชั่นของท่าน เช่น เมื่อท่านเรียกดูและโต้ตอบกับโฆษณาและเนื้อหาของบริษัท เป็นต้น ซึ่งประกอบด้วยข้อมูลอย่างน้อยดังนี้",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(1) ข้อมูลที่ถูกบันทึก : เมื่อท่านเรียกดูข้อมูลและ/หรือเนื้อหาจากแอพพลิเคชั่นนี้ บริษัทจะบันทึกการเรียกดูข้อมูลและ/หรือเนื้อหาดังกล่าวไว้ในแหล่งรวบรวมดังต่อไปนี้ ในเซิร์ฟเวอร์ของบริษัทเอง และ/หรือของบริษัทในเครือ และ/หรือของคู่สัญญาที่เชื่อถือได้ของบริษัทที่ทำหน้าที่บริหารจัดการข้อมูลในแอพพลิเคชั่นตามสัญญา",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(2) ข้อมูลกล้องถ่ายรูป (Camera) : เมื่อท่านใช้งานแอพพลิเคชั่นนี้ บริษัทอาจเข้าถึงรวบรวม และประมวลผลข้อมูลรูปถ่าย วิดีโอ และสถานที่ของรูปถ่ายและ/หรือวิดีโอของท่าน วัตถุประสงค์ดังนี้ เพื่อใช้ในการยื่นยันจัดส่งและติดตั้งสินค้าของผู้ใช้งาน",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(3) ข้อมูลบัญชีผู้ใช้งานแอพพลิเคชั่น (Account) : เมื่อท่านใช้งานแอพพลิเคชั่นของบริษัท บริษัทอาจเข้าถึง รวบรวมและประมวลผลข้อมูลเกี่ยวกับบัญชีผู้ใช้งานแอพพลิเคชั่น (Account) ของท่าน สำหรับการตรวจสอบ Token และ/หรือ UDID ของเครื่องโทรศัพท์เคลื่อนที่ วัตถุประสงค์ดังนี้ เพื่อการจัดทำข้อความแจ้งโฆษณาประชาสัมพันธ์เกี่ยวกับแอพพลิเคชั่นไปยังท่าน การส่งข้อความแจ้งข้อมูลสถานะสินค้าไปยังแอพพลิเคชั่น",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(4) ข้อมูลพื้นที่การจัดเก็บข้อมูลในตัวเครื่อง (Storage) : บริษัทอาจรวบรวมและจัดเก็บข้อมูล พื้นที่การจัดเก็บข้อมูลในตัวเครื่อง รวมถึงข้อมูลส่วนบุคคลที่อยู่ในอุปกรณ์ของท่าน โดยใช้วิธีการต่างๆ เช่น พื้นที่จัดเก็บข้อมูลเว็บบราวเซอร์ และแคชของข้อมูลแอพพลิเคชั่น วัตถุประสงค์ดังนี้ เพื่ออนุญาตให้แอพพลิเคชั่นสามารถอ่าน เพื่อแสดงข้อมูลของผู้ใช้ตามการเข้าใช้งานบนแอพพลิเคชั่น",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(5) คุกกี้และเทคโนโลยีที่คล้ายกัน (Cookies and SharedPreferences) : บริษัท กับบริษัทในเครือ และ/หรือพันธมิตรทางธุรกิจของบริษัท อาจใช้เทคโนโลยีต่างๆ ในการรวบรวมและจัดเก็บข้อมูลเมื่อท่านเยี่ยมชมเว็บไซต์และ/หรือบริการของบริษัท โดยการใช้คุกกี้และเทคโนโลยีที่คล้ายกัน เพื่อระบุบราวเซอร์หรืออุปกรณ์ และ/หรือเพื่อรวบรวมและจัดเก็บข้อมูลเมื่อท่านมีการโต้ตอบกับบริการที่บริษัทให้กับบริษัทในเครือ และ/หรือพันธมิตรทางธุรกิจของบริษัท เช่น บริการโฆษณา เป็นต้น",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(6) ข้อมูลหมายเลขเฉพาะของแอพพลิเคชั่น (Unique Application Number) : แอพพลิเคชั่นนี้มีหมายเลขเฉพาะของแอพพลิเคชั่น สำหรับการส่งข้อมูลมายังบริษัท เมื่อผู้ใช้บริการทำการติดตั้ง หรือถอนการติดตั้งแอพพลิเคชั่นนั้นๆ หรือเมื่อแอพพลิเคชั่นนั้นติดต่อกับระบบเซิร์ฟเวอร์การให้บริการของบริษัทเป็นคราวๆไป วัตถุประสงค์ดังนี้ เพื่อการอัปเดตข้อมูลแอพพลิเคชั่น",
                  style: MyConstant().small_text(Colors.grey),
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
                  "(7) ข้อมูลตำแหน่งที่ตั้ง (GPS) : บริษัทอาจรวบรวมและจัดเก็บข้อมูล ตำแหน่งที่ตั้ง โดยใช้วิธีการต่างๆ เช่น เรียกใช้งาน GPS ภายในแอปพลิเคชั่น วัตถุประสงค์ดังนี้ เพื่อให้รู้สถานที่ติดตั้งสินค้าได้ถูกต้อง",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body6 extends StatelessWidget {
  const body6({
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
                  "6. การเข้าถึงและอัปเดตข้อมูลส่วนบุคคล",
                  style: MyConstant().normal_text(Colors.black),
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
                  "บริษัทมุ่งหวังเป็นอย่างยิ่งว่า ในการใช้แอพพลิเคชั่น ท่านสามารถเข้าถึงข้อมูลส่วนบุคคลของท่านได้ หากข้อมูลดังกล่าวมีความบกพร่องหรือไม่ถูกต้อง บริษัทจะพยายามจัดหาวิธีการ และ/หรือช่องทางให้ท่านสามารถอัปเดตและ/หรือลบข้อมูลส่วนบุคคลของท่านได้อย่างเหมาะสม เว้นแต่ ในกรณีมีความจำเป็นที่บริษัทจะต้องจัดเก็บข้อมูลส่วนบุคคลของท่านไว้ เพื่อประโยชน์ทางธุรกิจ และ/หรือเพื่อการปฏิบัติตามกฎหมายที่ใช้บังคับ เมื่อท่านดำเนินการอัปเดตข้อมูลส่วนบุคคลของท่าน บริษัทอาจร้องขอให้ท่านยืนยันตัวตนก่อนที่บริษัทจะดำเนินการตามคำขอของท่านได้ ทั้งนี้ บริษัทขอสงวนสิทธิ์ปฏิเสธการทำคำขออัปเดตและการเข้าถึงข้อมูลส่วนบุคคลของท่าน ในกรณีดังต่อไปนี้ (1) การทำคำขอที่ซับซ้อนและมีจำนวนมากเกินกว่าปกติ (2) การดำเนินการตามคำขออาจทำให้บริษัทต้องจัดหา และ/หรือพัฒนาเทคโนโลยีจากที่บริษัทมีอยู่เกินสมควร (3) การดำเนินการตามคำขออาจกระทบข้อมูลส่วนบุคคลของผู้ใช้งานแอพพลิเคชั่นอื่นๆ หรือ (4) การดำเนินการตามคำขอไม่สามารถปฏิบัติได้จริง เช่น คำขอเกี่ยวกับการเรียกดูข้อมูลส่วนบุคคลที่อยู่ในระบบสำรองข้อมูล",
                  style: MyConstant().small_text(Colors.grey),
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
                  "บริษัทมุ่งหวังที่จะดำเนินการให้บริการแอพพลิเคชั่นของบริษัทเป็นไปอย่างปลอดภัย และสามารถป้องกันการทำลายข้อมูลจากอุบัติเหตุหรือการมุ่งร้ายอื่นๆ ด้วยเหตุนี้ ภายหลังจากที่ท่านลบข้อมูลออกจากแอพพลิเคชั่นของบริษัทแล้ว บริษัทอาจยังไม่ดำเนินการลบสำเนาข้อมูลส่วนบุคคลที่มีอยู่ออกจากเซิร์ฟเวอร์ที่ใช้งานอยู่ หรือนำข้อมูลออกจากระบบสำรองของบริษัทในทันที",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body5 extends StatelessWidget {
  const body5({
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
                  "5. การเปลี่ยนแปลงนโยบายความเป็นส่วนตัว",
                  style: MyConstant().normal_text(Colors.black),
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
                  "บริษัทขอสงวนสิทธิ์ในการแก้ไขเปลี่ยนแปลงนโยบายความเป็นส่วนตัวนี้ได้ตลอดเวลา โดยไม่ต้องได้รับความยินยอมจากท่านล่วงหน้า เว้นแต่เป็นการแก้ไขเปลี่ยนแปลงที่เป็นการริดรอนสิทธิของท่านตามนโยบายความเป็นส่วนตัวนี้ บริษัทจะกระทำมิได้หากไม่ได้รับความยินยอมจากท่านก่อน",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body4 extends StatelessWidget {
  const body4({
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
                  "4. การปฏิบัติตามกฎหมายและการให้ความร่วมมือกับหน่วยงานกำกับดูแล",
                  style: MyConstant().normal_text(Colors.black),
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
                  "บริษัทดำเนินการตรวจสอบและทบทวนการปฏิบัติตามนโยบายความเป็นส่วนตัว และการปฏิบัติตามกฎหมายที่เกี่ยวข้อง ภายในองค์กรอย่างสม่ำเสมอ (Self-Regulator) หากบริษัทได้รับหนังสือร้องเรียนเกี่ยวกับการใช้ข้อมูลส่วนบุคคล บริษัทจะดำเนินการติดตามผล ตลอดจนให้ความร่วมมือกับหน่วยงานของรัฐที่มีอำนาจกำกับดูแลการให้บริการแอพพลิเคชั่น และหน่วยงานคุ้มครองผู้บริโภคต่างๆ",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body3 extends StatelessWidget {
  const body3({
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
                  "3. ข้อจำกัดการใช้นโยบายความเป็นส่วนตัว",
                  style: MyConstant().normal_text(Colors.black),
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
                  "นโยบายความเป็นส่วนตัวฉบับนี้ มีผลใช้บังคับกับแอพพลิเคชั่นนี้เท่านั้น ไม่รวมถึงแอพพลิเคชั่นและ/หรือบริการที่มีนโยบายความเป็นส่วนตัว แยกต่างหาก และ/หรือที่ไม่ได้กำหนดโดยชัดแจ้งให้ใช้ร่วมกันกับนโยบายความเป็นส่วนตัวนี้ ตลอดจนไม่มีผลใช้บังคับกับแอพพลิเคชั่นและบริการ หรือเว็บไซต์อื่นๆ ที่เชื่อมต่อ (link) กับแอพพลิเคชั่นนี้ รวมถึงไม่ครอบคลุมหลักปฏิบัติด้านข้อมูลส่วนบุคคลของบริษัทอื่นๆ หรือองค์กรอื่นๆ ที่โฆษณาแอพพลิเคชั่นของบริษัท ซึ่งอาจใช้คุกกี้ พิกเซลแท็ก และเทคโนโลยีอื่นๆ ในการนำเสนอและแสดงโฆษณาที่เกี่ยวข้อง",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body2 extends StatelessWidget {
  const body2({
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
                  "2. ความปลอดภัยของข้อมูล",
                  style: MyConstant().normal_text(Colors.black),
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
                  "บริษัทพยายามอย่างยิ่งที่จะปกป้องข้อมูลของท่านจากการเข้าถึง การแก้ไขเปลี่ยนแปลง การเปิดเผย หรือการทำลายโดยไม่ได้รับอนุญาต อย่างน้อยดังนี้",
                  style: MyConstant().small_text(Colors.grey),
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
                  "   บริษัทจำกัดการเข้าถึงข้อมูลส่วนบุคคลไว้เฉพาะกับพนักงาน ลูกจ้าง และตัวแทนของบริษัท ที่มีความจำเป็นต้องเข้าถึงข้อมูลนั้นๆ (Need to Know Basis) เพื่อทำการประมวลผลข้อมูล โดยที่บุคคลดังกล่าวนั้น จะต้องปฏิบัติตามข้อกำหนดเกี่ยวกับการรักษาข้อมูลที่เป็นความลับตามสัญญาอย่างเคร่งครัด หากฝ่าฝืนจะมีบทลงโทษขั้นรุนแรง",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}

class body1 extends StatelessWidget {
  const body1({
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
                  "1. วัตถุประสงค์ของนโยบายความเป็นส่วนตัว",
                  style: MyConstant().normal_text(Colors.black),
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
                  "ในการใช้งานแอพพลิเคชั่นนี้ บริษัทมีความประสงค์ที่จะแจ้งให้ท่านทราบอย่างชัดเจนว่าบริษัทรวบรวมข้อมูลอะไรของท่านบ้าง มีวิธีการใช้และแบ่งปันข้อมูลของท่านอย่างไร นโยบายความเป็นส่วนตัวนี้จะอธิบายถึง ข้อมูลที่รวบรวมและเหตุผลที่รวบรวม/การใช้ข้อมูลที่รวบรวม",
                  style: MyConstant().small_text(Colors.grey),
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
                  "   บริษัทจะใช้ข้อมูลที่รวบรวมจากแอพพลิเคชั่นทั้งหมดของบริษัท เพื่อให้บริการ บำรุงรักษา ป้องกัน ปรับปรุง พัฒนาบริการใหม่ๆ และปกป้องบริษัทและท่าน ตลอดจนเพื่อนำเสนอเนื้อหาที่ได้รับการปรับแต่ง (Customize) ให้เหมาะสมกับการใช้งานของท่านโดยเฉพาะ เช่น แสดงโฆษณาประชาสัมพันธ์บริการที่ท่านอาจสนใจและเป็นประโยชน์แก่ท่าน",
                  style: MyConstant().small_text(Colors.grey),
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
                  "   บริษัทอาจใช้ข้อมูลที่รวบรวมได้จากคุกกี้และเทคโนโลยีอื่นๆ ในการปรับปรุงประสบการณ์การใช้งานของท่าน และคุณภาพโดยรวมของแอพพลิเคชั่น",
                  style: MyConstant().small_text(Colors.grey),
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
                  "ข้อมูลที่แบ่งปัน",
                  style: MyConstant().normal_text(Colors.black),
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
                  "   บริษัทจะไม่นำข้อมูลของท่านไปแบ่งปันหรือเปิดเผยให้กับบริษัท และ/หรือองค์กรอื่น และ/หรือบุคคลภายนอก ยกเว้นกรณี ดังต่อไปนี้ เมื่อได้รับความยินยอมจากท่าน บริษัทอาจแบ่งปันหรือเปิดเผยข้อมูลส่วนบุคคลของท่านกับบริษัท และ/หรือองค์กรอื่น และ/หรือบุคคลภายนอก เมื่อได้รับความยิมยอมจากท่านให้แบ่งปันหรือเปิดเผยข้อมูลส่วนบุคคลที่ละเอียดอ่อนของท่านก่อนเพื่อ “การใช้ข้อมูลที่รวบรวม”บริษัทอาจแบ่งปันหรือเปิดเผยข้อมูลส่วนบุคคลของท่านกับบริษัทในเครือ บริษัทในกลุ่ม ตลอดจนคู่สัญญาที่มีหน้าที่บริหารจัดการแอพพลิเคชั่นตามสัญญากับบริษัทโดยตรง หรือบริษัทอื่นที่มีนโยบายเกี่ยวกับข้อมูลส่วนบุคคลที่น่าเชื่อถือ เพื่อให้บริการ บำรุงรักษา ป้องกัน ปรับปรุง พัฒนาบริการใหม่ๆ และปกป้องบริษัทและท่าน ตลอดจนเพื่อนำเสนอเนื้อหาที่ได้รับการปรับแต่ง (Customize) ให้เหมาะสมกับการใช้งานของท่านโดยเฉพาะ เช่น แสดงโฆษณาประชาสัมพันธ์บริการที่ท่านอาจสนใจและเป็นประโยชน์แก่ท่าน โดยดำเนินการตามคำแนะนำและตามนโยบายส่วนบุคคลของบริษัท รวมถึงมาตรการการรักษาข้อมูลที่เป็นความลับและการรักษาความปลอดภัยที่เหมาะสม",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 10.sp,
                    color: Colors.grey[600],
                  ),
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
                  "   สำหรับเหตุผลทางกฎหมาย บริษัทอาจแบ่งปันหรือเปิดเผยข้อมูลของท่านกับบริษัท และ/หรือองค์กรอื่น และ/หรือบุคคลภายนอก หากบริษัทเชื่อโดยสุจริตว่าการเข้าถึง การใช้ การเก็บรักษา หรือการเปิดเผยข้อมูลนั้น มีเหตุจำป็นอันสมควร (1) เพื่อการปฏิบัติตามกฎหมาย ระเบียบข้อบังคับ หลักเกณฑ์ คำสั่งที่เกี่ยวข้องและการร้องขอข้อมูลจากทางราชการ (2) เพื่อบังคับใช้ข้อกำหนดในการให้บริการที่เกี่ยวข้อง รวมถึงการตรวจสอบการละเมิดที่อาจเกิดขึ้น (3) เพื่อตรวจจับ ป้องกัน หรือตรวจสอบการทุจริต ปัญหาด้านความปลอดภัยหรือด้านเทคนิค (4) เพื่อป้องกันอันตรายต่อสิทธิ ทรัพย์สิน หรือความปลอดภัยของบริษัทและ/หรือของท่าน หรือบุคคลอื่นตามที่กฎหมายกำหนด",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 10.sp,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
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
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "   นโยบายความเป็นส่วนตัวของบริษัทสำหรับการใช้งาน “แอพพลิเคชั่น”",
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
                  "    โปรดอ่านและทำความเข้าใจนโยบายความเป็นส่วนตัวนี้อย่างละเอียด การที่ท่านได้ติดตั้ง และ/หรือเข้าใช้งานแอพพลิเคชั่นนี้แล้ว ถือว่าท่านตกลงยอมรับข้อกำหนดที่ระบุในนโยบายความเป็นส่วนตัวนี้แล้วทุกประการ หากท่านไม่สามารถยอมรับข้อกำหนดนโยบายความเป็นส่วนตัวนี้ได้ ขอให้ท่านปฏิเสธการใช้งานแอพพลิเคชั่นโดยถอนการติดตั้งแอพพลิเคชั่นจากเครื่องโทรศัพท์เคลื่อนที่/อุปกรณ์ดิจิตอลของท่านทันที",
                  style: MyConstant().small_text(Colors.grey),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      );
}
