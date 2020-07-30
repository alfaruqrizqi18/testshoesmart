import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';
import 'package:testshoesmart/helper/reusable_widget/button.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'package:testshoesmart/helper/shared_preference_key/shared_preference_key.dart';
import 'package:testshoesmart/pages/auth/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  SharedPreferences prefs;
  String name = "";
  String email = "";

  setting_shared_preference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(SPKey.name);
      email = prefs.getString(SPKey.email);
    });
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setting_shared_preference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.main_color_app,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  elevation: 1,
                  automaticallyImplyLeading: true,
                  forceElevated: false,
                  backgroundColor: Colors.white,
                  snap: false,
                  centerTitle: true,
                  floating: false,
                  pinned: true,
                  titleSpacing: 1,
                  expandedHeight: MediaQuery.of(context).size.height * 0.1,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                          color: ColorApp.main_color_app,
                          border: Border.all(
                              width: 0, color: ColorApp.main_color_app)),
                    ),
                    collapseMode: CollapseMode.parallax,
                  ),
                  title: SABT(
                    child: ListTile(
                      title: Text(name == "" ? "" : name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: HexColor("#2F2F2F"),
                              fontFamily: FontSetting.fontMain,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  actions: <Widget>[])
            ];
          },
          body: Container(
            color: Colors.transparent,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.17,
                    width: MediaQuery.of(context).size.width * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1, color: Colors.white.withOpacity(1)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/brand/adidas.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 30.0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        child: Text(
                          name == "" ? "" : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontSetting.fontMain,
                              fontWeight: FontWeight.w800,
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          email == "" ? "" : email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontSetting.fontMain,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 12),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06),
                        child: ListTile(
                          title: Text(
                            "Menu",
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: FontSetting.fontMain,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      buildMenu(
                          title: "Tentang Developer",
                          color: "6CBFFB",
                          initialTitle: "Tk",
                          f: () async {
                            const url = 'https://instagram.com/alfaruqrizqi18';
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          subtitle: "Sekilas tentang developer"),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.05,
                            left: MediaQuery.of(context).size.width * 0.06,
                            right: MediaQuery.of(context).size.width * 0.06),
                        child: PButton().RedButton("Keluar dari aplikasi", () {
                          showConfirm();
                        }),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void showConfirm() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(8)),
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Ingin keluar?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: HexColor("#000000"),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontSetting.fontMain,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Apakah kamu ingin keluar dari aplikasi?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontFamily: FontSetting.fontMain,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(left: 15),
                            child: PButton().MainButton("Ya", () {
                              logout();
                              Navigator.of(context).pop();
                              RouteShortcut()
                                  .PushReplacement(context, SignIn());
                            }),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(right: 15),
                            child: PButton().WhiteButton("Tidak", () {
                              Navigator.of(context).pop();
                            }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  buildMenu(
      {String initialTitle,
      String title,
      String subtitle,
      String color,
      Function f}) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          bottom: 10.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () {
          f();
        },
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: HexColor("#${color}"),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              initialTitle,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: FontSetting.fontMain,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        dense: true,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 13,
              fontFamily: FontSetting.fontMain,
              color: HexColor("#505050"),
              fontWeight: FontWeight.w600),
        ),
        subtitle: Container(
          transform: Matrix4.translationValues(0.0, -0.0, 0.0),
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 11,
                fontFamily: FontSetting.fontMain,
                color: HexColor("#9A9A9A"),
                fontWeight: FontWeight.normal),
          ),
        ),
        trailing: Container(
          width: 10.0,
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            highlightColor: ColorApp.main_color_app,
            splashColor: ColorApp.main_color_app,
            onTap: () {
              f();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black54,
                size: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}
