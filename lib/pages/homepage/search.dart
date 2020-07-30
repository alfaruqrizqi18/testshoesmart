import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'package:testshoesmart/pages/homepage/product_detail.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchForm = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map> search_list = [];

  Future get_product_list() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
            SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products
            LEFT JOIN brands ON products.id_brand = brands.id_brand
            WHERE products.name LIKE '%${searchForm.text.trim()}' 
            OR products.name LIKE '%${searchForm.text.trim()}%'
            OR products.name LIKE '${searchForm.text.trim()}%'
            OR brands.name LIKE '%${searchForm.text.trim()}'
            OR brands.name LIKE '%${searchForm.text.trim()}%'
            OR brands.name LIKE '${searchForm.text.trim()}%'
            GROUP BY products.id_product
            ''').then((value) {
      setState(() {
        search_list = value;
      });
      print(search_list);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NestedScrollView(
//          physics: BouncingScrollPhysics(),
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
                leading: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    alignment: Alignment.center,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                title: SABT(
                  child: Text("Pencarian Kelas",
                      style: TextStyle(
                          color: HexColor("#2F2F2F"),
                          fontFamily: FontSetting.fontMain,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
                expandedHeight: MediaQuery.of(context).size.height * 0.22,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.06,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.09),
                          child: Text(
                            "Pencarian Kelas",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: HexColor("#414141"),
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontSetting.fontMain,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Theme(
                              child: TextFormField(
                                controller: searchForm,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                autofocus: true,
                                style: TextStyle(
                                    fontFamily: FontSetting.fontMain,
                                    fontSize: 20),
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ketik disini...",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontSetting.fontMain,
                                        color: Colors.grey)),
                                onFieldSubmitted: (val) {
                                  if (val.isEmpty) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: HexColor("#f67280"),
                                      elevation: 0,
                                      duration: Duration(milliseconds: 2500),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Masukkan 1-3 kata kunci terlebih dahulu ya",
                                        style: TextStyle(
                                          fontFamily: FontSetting.fontMain,
                                        ),
                                      ),
                                    ));
                                  } else {
                                    get_product_list();
                                  }
                                },
                              ),
                              data: Theme.of(context).copyWith(
                                primaryColor: ColorApp.main_color_app,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.center,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          searchForm.clear();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Reset",
                          style: TextStyle(
                              color: ColorApp.main_color_app,
                              fontFamily: FontSetting.fontMain,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ])
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(bottom: 0.0, top: 0.0),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            search_list.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Hasil pencarian",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: HexColor("#939393"),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontSetting.fontMain,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Opacity(
                    opacity: 0,
                  ),
            search_list.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        top: 10.0),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: search_list.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ListTile(
                        onTap: () {
                          RouteShortcut().Push(
                              context,
                              ProductDetail(
                                id_product: search_list[index]['id_product'],
                              ));
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              AssetImage(search_list[index]['products_image']),
                        ),
                        title: Text(
                          search_list[index]['products_name'],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: HexColor("#585858"),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontSetting.fontMain,
                          ),
                        ),
                        subtitle: Text(
                          search_list[index]['brands_name'],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorApp.main_color_app,
                            fontSize: 12,
                            fontFamily: FontSetting.fontMain,
                          ),
                        ),
                        trailing: Text(
                          NumberFormat("#,###", "ID_id").format(int.parse(
                              search_list[index]['price'].toString())),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: FontSetting.fontMain,
                          ),
                        ),
                      );
                    })
                : Opacity(
                    opacity: 0.0,
                  ),
          ],
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
