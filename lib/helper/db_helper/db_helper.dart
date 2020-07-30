import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  List<Map<String, dynamic>> products = [
    {
      "name": "Nike 1",
      "image": "assets/images/shoes/1.png",
      "id_brand": 1,
      "price": 123400
    },
    {
      "name": "Nike 2",
      "image": "assets/images/shoes/2.png",
      "id_brand": 1,
      "price": 12422500
    },
    {
      "name": "Nike 3",
      "image": "assets/images/shoes/3.png",
      "id_brand": 1,
      "price": 1234500
    },
    {
      "name": "Nike 4",
      "image": "assets/images/shoes/4.png",
      "id_brand": 1,
      "price": 123435500
    },
    {
      "name": "Puma 1",
      "image": "assets/images/shoes/5.png",
      "id_brand": 2,
      "price": 1267500
    },
    {
      "name": "Puma 2",
      "image": "assets/images/shoes/6.png",
      "id_brand": 2,
      "price": 12673500
    },
    {
      "name": "Puma 3",
      "image": "assets/images/shoes/7.png",
      "id_brand": 2,
      "price": 1673500
    },
    {
      "name": "Puma 4",
      "image": "assets/images/shoes/8.png",
      "id_brand": 2,
      "price": 125673500
    },
    {
      "name": "Vans 1",
      "image": "assets/images/shoes/9.png",
      "id_brand": 3,
      "price": 1673500
    },
    {
      "name": "Vans 2",
      "image": "assets/images/shoes/10.png",
      "id_brand": 3,
      "price": 1278500
    },
    {
      "name": "Vans 3",
      "image": "assets/images/shoes/11.png",
      "id_brand": 3,
      "price": 123678500
    },
    {
      "name": "Vans 4",
      "image": "assets/images/shoes/12.png",
      "id_brand": 3,
      "price": 123786500
    },
    {
      "name": "Adidas 1",
      "image": "assets/images/shoes/13.png",
      "id_brand": 4,
      "price": 1783500
    },
    {
      "name": "Adidas 2",
      "image": "assets/images/shoes/14.png",
      "id_brand": 4,
      "price": 17893500
    },
    {
      "name": "Adidas 3",
      "image": "assets/images/shoes/15.png",
      "id_brand": 4,
      "price": 1893500
    },
    {
      "name": "Adidas 4",
      "image": "assets/images/shoes/16.png",
      "id_brand": 4,
      "price": 1289500
    },
    {
      "name": "DC 1",
      "image": "assets/images/shoes/17.png",
      "id_brand": 5,
      "price": 1456500
    },
    {
      "name": "DC 2",
      "image": "assets/images/shoes/18.png",
      "id_brand": 5,
      "price": 1256500
    },
    {
      "name": "DC 3",
      "image": "assets/images/shoes/19.png",
      "id_brand": 5,
      "price": 1256500
    },
    {
      "name": "DC 4",
      "image": "assets/images/shoes/20.png",
      "id_brand": 5,
      "price": 1256500
    },
  ];
  Future<Database> init_db() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contact.db';
    var database = openDatabase(path, version: 1, onCreate: create_db);
    return database;
  }

  void create_db(Database db, int version) async {
    db.execute('''
      CREATE TABLE users (
        id_user INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        date DATETIME
      )
    ''');
    create_batch(db, "users", {
      "name": "Rizqi",
      "email": "rizqi@gmail.com",
      "password": "123",
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now())
    });

    db.execute('''
      CREATE TABLE brands (
        id_brand INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image TEXT
      )
    ''');

    db.execute('''
      CREATE TABLE favorites (
        id_favorite INTEGER PRIMARY KEY AUTOINCREMENT,
        id_product INTEGER
      )
    ''');

    db.execute('''
      CREATE TABLE carts (
        id_cart INTEGER PRIMARY KEY AUTOINCREMENT,
        id_product INTEGER,
        pcs INTEGER
      )
    ''');

    db.execute('''
      CREATE TABLE products (
        id_product INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image TEXT,
        id_brand INTEGER,
        price INTEGER
      )
    ''');
    create_batch_for_brands(db);
    for (int i = 0; i < products.length; i++) {
      create_batch(db, "products", products[i]);
    }
  }

  create_batch(Database db, String table, Map<String, dynamic> data) {
    var batch = db.batch();
    batch.insert(table, data);
    batch.commit();
  }

  create_batch_for_brands(Database db) {
    create_batch(db, "brands",
        {"name": "Nike", "image": "assets/images/brand/nike.png"});
    create_batch(db, "brands",
        {"name": "Puma", "image": "assets/images/brand/puma.png"});
    create_batch(db, "brands",
        {"name": "Vans", "image": "assets/images/brand/vans.png"});
    create_batch(db, "brands",
        {"name": "Adidas", "image": "assets/images/brand/adidas.png"});
    create_batch(
        db, "brands", {"name": "DC", "image": "assets/images/brand/dc.png"});
  }
}
