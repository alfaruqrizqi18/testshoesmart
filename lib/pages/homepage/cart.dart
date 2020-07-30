import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testshoesmart/helper/db_helper/db_helper.dart';
import 'package:testshoesmart/helper/font_setting/font_setting.dart';
import 'package:testshoesmart/helper/hex_color/hex_color.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List carts = [];
  int total = 0;
  Future get_carts() async {
    Database db = await DatabaseHelper().init_db();
    db.rawQuery('''
    SELECT products.id_product as id_product, products.name as products_name, products.price, products.image as products_image,
            brands.name as brands_name, brands.image as brands_image,
            carts.pcs
            FROM carts
            LEFT JOIN products ON products.id_product = carts.id_product
            LEFT JOIN brands ON brands.id_brand = products.id_brand
    ''').then((value) {
      setState(() {
        carts = value;
      });
      print(carts);
      setState(() {
        total = 0;
      });
      get_all_total();
    });
  }

  Future decrease_qty(int id_product, int current_qty) async {
    Database db = await DatabaseHelper().init_db();
    var batch = db.batch();

    batch.update('carts', {'pcs': current_qty - 1},
        where: 'id_product = ?', whereArgs: [id_product]);
    batch.commit();
    get_carts();
  }

  Future remove_qty(int id_product) async {
    Database db = await DatabaseHelper().init_db();
    var batch = db.batch();

    batch.delete('carts', where: 'id_product = ?', whereArgs: [id_product]);
    batch.commit();
    get_carts();
  }

  Future increase_qty(int id_product, int current_qty) async {
    Database db = await DatabaseHelper().init_db();
    var batch = db.batch();

    batch.update('carts', {'pcs': current_qty + 1},
        where: 'id_product = ?', whereArgs: [id_product]);
    batch.commit();
    get_carts();
  }

  get_all_total() {
    for (int i = 0; i < carts.length; i++) {
      total += carts[i]['pcs'] * carts[i]['price'];
    }
    print(total);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_carts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Cart",
          style: TextStyle(fontFamily: FontSetting.fontMain),
        ),
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(top: 10.0),
          itemCount: carts.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                leading: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: HexColor("#DFDFDF")),
                    image: DecorationImage(
                      image: AssetImage(carts[index]['products_image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  carts[index]['products_name'],
                  style: TextStyle(fontFamily: FontSetting.fontMain),
                ),
                trailing: Text(
                  NumberFormat("#,###", "ID_id").format(int.parse(
                      (carts[index]['price'] * carts[index]['pcs'])
                          .toString())),
                  style: TextStyle(fontFamily: FontSetting.fontMain),
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print(carts);
                          if (carts[index]['pcs'] > 1) {
                            decrease_qty(carts[index]['id_product'],
                                carts[index]['pcs']);
                          } else {
                            remove_qty(carts[index]['id_product']);
                          }
                        },
                        child: Icon(Icons.remove),
                      ),
                      Text(
                        carts[index]['pcs'].toString(),
                        style: TextStyle(
                            fontFamily: FontSetting.fontMain, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          increase_qty(
                              carts[index]['id_product'], carts[index]['pcs']);
                        },
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        // height: 50.0,
        child: ListTile(
          title: Text(
            "Grand total",
            style: TextStyle(fontFamily: FontSetting.fontMain, fontSize: 13),
          ),
          subtitle: Text(
            NumberFormat("#,###", "ID_id").format(int.parse(total.toString())),
            style: TextStyle(fontFamily: FontSetting.fontMain, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
