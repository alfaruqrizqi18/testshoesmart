import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';
import 'package:testshoesmart/pages/splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.white));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: HexColor("#FAFAFA"),
          accentColor: ColorApp.main_color_app,
          hintColor: ColorApp.main_color_app,
        ),
        debugShowCheckedModeBanner: false,
        home: Splashscreen()));
  });
}
