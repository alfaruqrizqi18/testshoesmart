import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'package:testshoesmart/helper/shared_preference_key/shared_preference_key.dart';
import 'package:testshoesmart/pages/auth/sign_in.dart';
import 'package:testshoesmart/pages/homepage/main_page.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool is_logged_in = false;
  bool is_guest = false;
  String token = "";
  SharedPreferences prefs;
  get_status_login() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool(SPKey.is_logged_in) != null) {
        if (prefs.getBool(SPKey.is_logged_in)) {
          is_logged_in = true;
        } else {
          is_logged_in = false;
        }
      }
      if (prefs.getBool(SPKey.is_guest) != null) {
        if (prefs.getBool(SPKey.is_guest)) {
          is_guest = true;
        } else {
          is_guest = false;
        }
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    DatabaseHelper().init_db();
    get_status_login();
    timeout();
  }

  Future<Timer> timeout() async {
    return new Timer(Duration(milliseconds: 2000), on_done_oading);
  }

  on_done_oading() async {
    is_logged_in || is_guest ? go_to_main_page() : go_to_auth_page();
  }

  go_to_auth_page() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    RouteShortcut().PushReplacement(context, SignIn());
  }

  go_to_onboarding() {
//    RouteShortcut().PushReplacement(context, OnBoardingPage());
  }

  go_to_main_page() {
    // WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    RouteShortcut().PushReplacement(context, MainPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlutterLogo(
          size: 76,
          colors: Colors.green,
        ),
      ),
    );
  }
}
