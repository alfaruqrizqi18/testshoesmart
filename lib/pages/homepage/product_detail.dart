import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/color_app/color_app.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/reusable_widget/button.dart';

class ProductDetail extends StatefulWidget {
  final int id_product;

  const ProductDetail({Key key, this.id_product}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int pcs = 1;
  bool is_favorite = false;
  Map detail_product = {};
  Future check_is_favorite() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
     SELECT * FROM favorites WHERE id_product = ${widget.id_product}
    ''').then((value) {
      print(value);
      if (value.isNotEmpty) {
        setState(() {
          is_favorite = true;
        });
      }
    });
  }

  Future product_detail() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
            SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image
            FROM products, brands
            WHERE products.id_brand = brands.id_brand AND products.id_product = ${widget.id_product}
            ''').then((value) {
      setState(() {
        detail_product = value[0];
      });
    });
  }

  Future add_to_cart() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
            SELECT * FROM carts WHERE id_product = ${widget.id_product}
            ''').then((value) {
      setState(() {
        var batch = db.batch();
        if (value.isEmpty) {
          batch.insert("carts", {"id_product": widget.id_product, "pcs": pcs});
          batch.commit();
          db.query("carts").then((value) => print(value));
        } else {
          int current_pcs = value[0]['pcs'];
          batch.update("carts", {"pcs": current_pcs + pcs},
              where: "id_product = ?", whereArgs: [widget.id_product]);
          batch.commit();
          db.query("carts").then((value) => print(value));
        }
      });
    });
  }

  Future set_favorite() async {
    Database db = await DatabaseHelper().init_db();
    var batch = db.batch();
    batch.insert("favorites", {"id_product": widget.id_product});
    batch.commit();
    setState(() {
      is_favorite = true;
    });
  }

  Future unset_favorite() async {
    Database db = await DatabaseHelper().init_db();
    var batch = db.batch();
    batch.delete("favorites",
        where: "id_product = ? ", whereArgs: [widget.id_product]);
    batch.commit();
    setState(() {
      is_favorite = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_is_favorite();
    product_detail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Detail Produk",
          style: TextStyle(fontFamily: FontSetting.fontMain),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (is_favorite) {
                  unset_favorite();
                } else {
                  set_favorite();
                }
              },
              child: Icon(
                is_favorite ? Icons.favorite : Icons.favorite_border,
                color: is_favorite ? Colors.red : Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: 1, color: Colors.white.withOpacity(1)),
                  image: DecorationImage(
                    image: AssetImage(detail_product['products_image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  detail_product['products_name'],
                  style: TextStyle(
                      fontFamily: FontSetting.fontMain,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  detail_product['brands_name'],
                  style: TextStyle(
                      fontFamily: FontSetting.fontMain,
                      fontSize: 18,
                      color: ColorApp.main_color_app,
                      fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  NumberFormat("#,###", "ID_id")
                      .format(int.parse(detail_product['price'].toString())),
                  style: TextStyle(
                      fontFamily: FontSetting.fontMain,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (pcs != 1) {
                        pcs--;
                      }
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                Text(
                  pcs.toString(),
                  style:
                      TextStyle(fontFamily: FontSetting.fontMain, fontSize: 17),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      pcs++;
                    });
                  },
                  child: Icon(Icons.add),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 20.0, right: 20.0),
        child: PButton().RoundedMainButton("Tambahkan ke Keranjang", () {
          add_to_cart();
        }),
      ),
    );
  }
}
