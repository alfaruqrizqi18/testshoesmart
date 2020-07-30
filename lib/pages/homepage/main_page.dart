import 'package:flutter/material.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/pages/homepage/product.dart';
import 'package:testshoesmart/pages/account/account.dart';
import 'favorites.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int page_active = 0;
  List pages = [Product(), Favorites(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page_active],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: page_active,
          onTap: (val) {
            setState(() {
              page_active = val;
            });
          },
          selectedItemColor: ColorApp.main_color_app,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: TextStyle(
              fontFamily: FontSetting.fontMain,
              fontSize: 13,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              fontFamily: FontSetting.fontMain,
              fontSize: 13,
              fontWeight: FontWeight.normal),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Beranda")),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), title: Text("Favorite")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Account"))
          ]),
    );
  }
}
