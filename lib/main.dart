import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud/Tap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_crud/provider/Controllerprovider.dart';
import 'package:flutter_crud/provider/categoryprovider.dart';
import 'package:flutter_crud/provider/producthotprovider.dart';
import 'package:flutter_crud/provider/productprovider.dart';
import 'package:flutter_crud/provider/promotionprovider.dart';
import 'package:flutter_crud/responsive.dart';
import 'package:flutter_crud/tablet/home_tablet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ControllerProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return ProductProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return ProducthotProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return CategoryProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return Promotion();
        })
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Thaweeyont',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: Responsive(
              mobile: TapControl("0"),
              tablet: HomeTablet(),
              desktop: Text("desktop"),
            ),
          );
        },
      ),
    );
  }
}
