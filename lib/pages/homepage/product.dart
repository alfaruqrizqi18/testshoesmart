import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';
import 'package:testshoesmart/helper/route_shortcut/route_shortcut.dart';
import 'product_detail.dart';
import 'cart.dart';
import 'search.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String current_sql = "";
  RangeValues range_price = RangeValues(0, 500000);
  PageController banner_controller = PageController(
    initialPage: 0,
  );
  List banner_image = [
    "assets/images/banner/1.jpg",
    "assets/images/banner/2.png",
    "assets/images/banner/3.jpg",
  ];
  List<Map> brands = [];
  List<Map> products = [];
  List<Map> products_list = [];

  Future filter_brand(int id_brand) async {
    Database db = await DatabaseHelper().init_db();
    setState(() {
      current_sql =
          ''' SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand AND products.id_brand = ${id_brand}''';
    });
    db.rawQuery('''
            SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand AND products.id_brand = ${id_brand}
            ''').then((value) {
      setState(() {
        products = value;
        products_list = value;
      });
      print(products);
    });
  }

  Future filter_price(String type) async {
    Database db = await DatabaseHelper().init_db();
    if (type == "cheap") {
      db.rawQuery('''
            ${current_sql} ORDER BY products.price ASC
            ''').then((value) {
        setState(() {
          products = value;
          products_list = value;
        });
        print(products);
      });
    } else {
      db.rawQuery('''
            ${current_sql} ORDER BY products.price DESC
            ''').then((value) {
        setState(() {
          products = value;
          products_list = value;
        });
        print(products);
      });
    }
  }

  Future get_brand() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery("SELECT * FROM brands").then((value) {
      setState(() {
        brands = value;
      });
      print(brands);
    });
  }

  Future get_product_grid() async {
    setState(() {
      current_sql = '''
      SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand
      ''';
    });
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
            SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand
            ''').then((value) {
      setState(() {
        products = value;
      });
      print(products);
    });
  }

  Future get_product_list() async {
    setState(() {
      current_sql = '''
      SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand
      ''';
    });
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
            SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand
            ''').then((value) {
      setState(() {
        products_list = value;
      });
      print(products_list);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_brand();
    get_product_grid();
    get_product_list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
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
                title: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Card(
                    elevation: 0,
                    color: HexColor("#F3F3F3"),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        RouteShortcut().Push(context, Search());
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 16,
                        margin: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ingin cari barang apa?",
                          style: TextStyle(
                            color: HexColor("#929292"),
                            fontFamily: FontSetting.fontMain,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: PageView.builder(
                    controller: banner_controller,
                    physics: ClampingScrollPhysics(),
                    itemCount: banner_image.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Image.asset(banner_image[index],
                          fit: BoxFit.cover);
                    },
                  ),
                ),
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 3.0, right: 10),
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        RouteShortcut().Push(context, Cart());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 24,
                          color: Colors.amber[400],
                        ),
                      ),
                    ),
                  ),
                ])
          ];
        },
        body: ListView(
            padding: EdgeInsets.only(
                top: 10.0, bottom: MediaQuery.of(context).size.height * 0.1),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10, bottom: 10),
                child: ScrollingPageIndicator(
                    dotColor: Colors.grey.withOpacity(0.2),
                    dotSelectedColor: ColorApp.main_color_app,
                    dotSize: 10,
                    dotSelectedSize: 10,
                    dotSpacing: 20,
                    visibleDotCount: 5,
                    controller: banner_controller,
                    itemCount: banner_image.length,
                    orientation: Axis.horizontal),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 5),
                child: ListTile(
                  title: Text(
                    "Filter",
                    style: TextStyle(fontFamily: FontSetting.fontMain),
                  ),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            filter_price("cheap");
                          },
                          child: Icon(Icons.vertical_align_bottom),
                        ),
                        Container(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            filter_price("expensive");
                          },
                          child: Icon(Icons.vertical_align_top),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                margin: EdgeInsets.only(bottom: 15),
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 20.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: brands.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            filter_brand(brands[index]['id_brand']);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: HexColor("#DFDFDF")),
                              image: DecorationImage(
                                image: AssetImage(brands[index]['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width * 0.60,
//                    color: Colors.grey.withOpacity(0.1),
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 20.0),
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (BuildContext ctxItemEachCategory,
                              int indexItem) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  RouteShortcut().Push(
                                      context,
                                      ProductDetail(
                                        id_product: products[indexItem]
                                            ['id_product'],
                                      ));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: HexColor("#DFDFDF")),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                products[indexItem]
                                                    ['products_image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Text(
                                        products[indexItem]['brands_name'],
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
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Text(
                                        products[indexItem]['products_name'],
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
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text: 'Rp ',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontSetting.fontMain,
                                                color: HexColor("#7E7E7E"),
                                                fontSize: 10),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: NumberFormat(
                                                          "#,###", "ID_id")
                                                      .format(int.parse(
                                                          products[indexItem]
                                                                  ['price']
                                                              .toString())),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontSetting.fontMain,
                                                      color:
                                                          HexColor("#656565"),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12)),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25.0),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: products_list.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            RouteShortcut().Push(
                                context,
                                ProductDetail(
                                  id_product: products[index]['id_product'],
                                ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(products_list[index]
                                          ['products_image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    child: Text(
                                      products_list[index]['products_name'],
                                      style: TextStyle(
                                          fontFamily: FontSetting.fontMain,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
//                            SizedBox(height: 20),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, top: 5.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          products_list[index]['brands_name'],
                                          style: TextStyle(
                                              fontFamily: FontSetting.fontMain,
                                              fontSize: 11,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                        FlatButton.icon(
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.monetization_on,
                                              color: ColorApp.main_color_app,
                                              size: 17,
                                            ),
                                            label: Text(
                                              "Rp. " +
                                                  NumberFormat("#,###", "ID_id")
                                                      .format(int.parse(
                                                          products_list[index]
                                                                  ['price']
                                                              .toString())),
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontSetting.fontMain,
                                                  fontSize: 11,
                                                  color: Colors.black54),
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ]),
      ),
    );
  }

  Widget buildUpperMenu(
      HexColor cardColor, String imageAssets, String title, Function f) {
    return InkWell(
      onTap: f,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Card(
              color: cardColor,
              child: Container(
                padding: EdgeInsets.all(10.5),
                child: Image.asset(
                  imageAssets,
                  width: 25,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 0.1, color: Colors.grey)),
              elevation: 0.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: FontSetting.fontMain,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}
