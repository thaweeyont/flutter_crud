import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/contact/contact.dart';
import 'package:flutter_crud/home/home.dart';
import 'package:flutter_crud/profile/profile_user.dart';
import 'package:flutter_crud/taguser/tag_user.dart';

// import 'package:custom_navigator/custom_navigator.dart';

class TapControl extends StatefulWidget {
  final index;
  TapControl(this.index);

  @override
  _TapControlState createState() => _TapControlState();
}

class _TapControlState extends State<TapControl> {
  bool navBarMode = true;
  void check_index() {
    var index_page = widget.index;
    switch (index_page) {
      case "0":
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case "1":
        setState(() {
          _selectedIndex = 1;
        });
        break;
      case "2":
        setState(() {
          _selectedIndex = 2;
        });
        break;
      case "3":
        setState(() {
          _selectedIndex = 3;
        });
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_index();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    TagUser(),
    Contact(),
    PROFILE(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> check_emu() async {
    setState(() {
      if (defaultTargetPlatform == TargetPlatform.android) {
        PROFILE();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        print('ios success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: (orientation == Orientation.portrait)
          ? bottonNavigator(size, size_h)
          : null,
    );
  }

  Widget bottonNavigator(size, size_h) => BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 15,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Prompt',
          fontSize: size_h * 0.016,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: 'Prompt'),
        showSelectedLabels: true,
        // showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: size_h * 0.014,
        unselectedFontSize: size_h * 0.014,
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.grey[400],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: size * 0.06,
            ),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pin_drop_sharp,
              size: size * 0.06,
            ),
            label: 'ติดตามสินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contact_support_rounded,
              size: size * 0.06,
            ),
            label: 'ช่วยเหลือ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: size * 0.06,
            ),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
}
