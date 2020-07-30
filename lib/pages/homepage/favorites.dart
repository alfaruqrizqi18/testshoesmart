import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'package:testshoesmart/pages/homepage/product_detail.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Map> favorites = [];

  Future get_favorites() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
    SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM favorites
            LEFT JOIN products ON products.id_product = favorites.id_product
            LEFT JOIN brands ON brands.id_brand = products.id_brand
    ''').then((value) {
      setState(() {
        favorites = value;
      });
      print(favorites);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_favorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Favorites",
          style: TextStyle(fontFamily: FontSetting.fontMain),
        ),
      ),
      body: GridView.builder(
          padding: EdgeInsets.only(top: 10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.7),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  RouteShortcut().Push(
                      context,
                      ProductDetail(
                        id_product: favorites[index]['id_product'],
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: HexColor("#DFDFDF")),
                          image: DecorationImage(
                            image:
                                AssetImage(favorites[index]['products_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        favorites[index]['brands_name'],
                        style: TextStyle(
                            fontFamily: FontSetting.fontMain,
                            color: ColorApp.main_color_app,
                            fontWeight: FontWeight.w600,
                            fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        favorites[index]['products_name'],
                        style: TextStyle(
                            fontFamily: FontSetting.fontMain,
                            color: Colors.black,
                            fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Rp ',
                            style: TextStyle(
                                fontFamily: FontSetting.fontMain,
                                color: HexColor("#7E7E7E"),
                                fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                  text: NumberFormat("#,###", "ID_id").format(
                                      int.parse(favorites[index]['price']
                                          .toString())),
                                  style: TextStyle(
                                      fontFamily: FontSetting.fontMain,
                                      color: HexColor("#656565"),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
