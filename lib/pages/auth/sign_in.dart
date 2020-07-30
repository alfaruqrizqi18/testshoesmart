import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/reusable_widget/button.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'package:testshoesmart/helper/shared_preference_key/shared_preference_key.dart';
import 'package:testshoesmart/pages/auth/sign_up.dart';
import 'package:testshoesmart/pages/homepage/main_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final form_key = GlobalKey<FormState>();
  final scaffold_key = GlobalKey<ScaffoldState>();
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  SharedPreferences prefs;

  bool is_process_start = false;

  validation() {
    if (form_key.currentState.validate()) {
      print("semua berhasil");
      sign_in();
    } else {
      scaffold_key.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
          content: Text(
            "Mohon lengkapi formnya ya",
          )));
    }
  }

  String validate_email(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isNotEmpty) {
      if (!regex.hasMatch(value)) {
        return 'Masukkan email yang valid ya';
      } else {
        return null;
      }
    } else {
      return 'Email tidak boleh kosong ya';
    }
  }

  Future sign_in() async {
    setState(() {
      is_process_start = true;
    });

    //init shared pref
    prefs = await SharedPreferences.getInstance();

    //init DB
    Database db = await DatabaseHelper().init_db();
    //mengecek apakah email dan password yang dimasukkan ada yang cocok
    db.rawQuery('''
    SELECT * 
    FROM users 
    WHERE email = "${email.text.trim()}" 
    AND password = "${password.text.trim()}"
    ''').then((value) {
      if (value.isEmpty) {
        // tidak ada data yang cocok
        scaffold_key.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[400],
            elevation: 0,
            content: Text(
              "Email atau password yang kamu masukkan tidak ada yang cocok",
            )));
      } else {
        // data ada yang cocok
        set_up_shared_preferences(value);
        RouteShortcut().PushReplacement(context, MainPage());
      }
    });
    setState(() {
      is_process_start = false;
    });
  }

  set_up_shared_preferences(value) {
    prefs.setBool(SPKey.is_guest, false);
    prefs.setBool(SPKey.is_logged_in, true);
    prefs.setString(SPKey.user_id, value[0]['id_user'].toString());
    prefs.setString(SPKey.email, value[0]['email']);
    prefs.setString(SPKey.name, value[0]['name']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_data();
  }

  check_data() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery("SELECT * FROM brands").then((value) => print(value));
    db.rawQuery("SELECT * FROM products").then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_key,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Login ',
              style: TextStyle(
                  fontFamily: FontSetting.fontMain,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                    text: 'Flutter Shoes',
                    style: TextStyle(
                        fontFamily: FontSetting.fontMain,
                        color: ColorApp.main_color_app,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
              ],
            )),
      ),
      body: Form(
        key: form_key,
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text('Halo, selamat datang kembali!',
                    style: TextStyle(
                        fontFamily: FontSetting.fontMain,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                subtitle: Text('Masuk untuk melanjutkan',
                    style: TextStyle(
                        fontFamily: FontSetting.fontMain,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 12)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email",
                    style: TextStyle(
                        fontFamily: FontSetting.fontMain,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.0),
                  ),
                  Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      child: Theme(
                          child: TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            cursorColor: ColorApp.main_color_app,
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: FontSetting.fontMain,
                                fontSize: 15),
                            validator: validate_email,
                            obscureText: false,
                            decoration: InputDecoration(
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black12)),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: ColorApp.main_color_app)),
                                hintText: "Masukkan alamat email disini...",
                                hintStyle: TextStyle(
                                    fontFamily: FontSetting.fontMain,
                                    color: Colors.grey)),
                          ),
                          data: Theme.of(context).copyWith(
                            primaryColor: ColorApp.main_color_app,
                          ))),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Katasandi",
                    style: TextStyle(
                        fontFamily: FontSetting.fontMain,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.0),
                  ),
                  Container(
                      transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                      child: Theme(
                          child: TextFormField(
                            controller: password,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            cursorColor: ColorApp.main_color_app,
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: FontSetting.fontMain,
                                fontSize: 15),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Katasandi masih kosong";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black12)),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: ColorApp.main_color_app)),
                                hintText: "Masukkan katasandi disini...",
                                hintStyle: TextStyle(
                                    fontFamily: FontSetting.fontMain,
                                    color: Colors.grey)),
                          ),
                          data: Theme.of(context).copyWith(
                            primaryColor: ColorApp.main_color_app,
                          ))),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 15.0),
                alignment: Alignment.centerRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Lupa katasandi?",
                      style: TextStyle(
                          color: ColorApp.main_color_app,
                          fontFamily: FontSetting.fontMain,
                          fontSize: 13,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15, right: 15, top: 5.0),
              child: is_process_start
                  ? Loading(
                      indicator: BallScaleIndicator(),
                      size: 24,
                      color: ColorApp.main_color_app,
                    )
                  : PButton().RoundedMainButton("Masuk ke akunku", () {
                      validation();
                    }),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: MediaQuery.of(context).size.height * 0.05),
//                          child: is_process_start
//                              ? Loading(
//                                  indicator: BallScaleIndicator(),
//                                  size: 24,
//                                  color: ColorApp.main_color_app,
//                                )
//                              : PButton().MainButton("Masuk ke akunku", () {
//                                  login();
//                                }),
              child: PButton().IconImageButton(
                  textButton: "Masuk dengan Google",
                  urlIcon: "assets/images/icon/google.png",
                  function: () {},
                  colorTextButton: Colors.black87,
                  colorBorderButton: Colors.grey,
                  colorHighlightButton: Colors.red.withOpacity(0.2)),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: MediaQuery.of(context).size.height * 0.01),
//                          child: is_process_start
//                              ? Loading(
//                                  indicator: BallScaleIndicator(),
//                                  size: 24,
//                                  color: ColorApp.main_color_app,
//                                )
//                              : PButton().MainButton("Masuk ke akunku", () {
//                                  login();
//                                }),
              child: PButton().IconImageButton(
                  textButton: "Masuk dengan Facebook",
                  urlIcon: "assets/images/icon/facebook.png",
                  function: () {},
                  colorTextButton: Colors.black87,
                  colorBorderButton: Colors.grey,
                  colorHighlightButton: Colors.blueAccent.withOpacity(0.2)),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 60.0,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              RouteShortcut().PushReplacement(context, SignUp());
            },
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Belum punya akun? ',
                  style: TextStyle(
                      fontFamily: FontSetting.fontMain,
                      color: Colors.grey[500],
                      fontSize: 12.5),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\nBuat akun baru sekarang',
                        style: TextStyle(
                            fontFamily: FontSetting.fontMain,
                            color: ColorApp.main_color_app,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5)),
                  ],
                )),
          )),
    );
  }
}
