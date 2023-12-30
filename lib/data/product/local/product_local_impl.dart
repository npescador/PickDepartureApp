import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/local/database_helper.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalImpl {
  final DataBaseHelper _dbHelper = DataBaseHelper();

  Future<List<ProductModel>> getProducts() async {
    Database db = await _dbHelper.getDb();

    final dataBaseProducts = await db.query(DataBaseHelper.productTable);
    final productList = dataBaseProducts.map((e) => ProductModel.fromMap(e));

    await _dbHelper.closeDb();

    return productList.toList();
  }

  addProduct(ProductModel product) async {
    Database db = await _dbHelper.getDb();

    await db.insert(DataBaseHelper.productTable, product.toMap());

    await _dbHelper.closeDb();
  }

  updateProduct(ProductModel product) async {
    Database db = await _dbHelper.getDb();

    await db.update(DataBaseHelper.productTable, product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);

    await _dbHelper.closeDb();
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      Database db = await _dbHelper.getDb();

      final dataBaseProduct = await db.rawQuery(
          "SELECT * FROM ${DataBaseHelper.productTable} WHERE barcode = ?",
          [barcode]);

      ProductModel? user;
      if (dataBaseProduct.isNotEmpty) {
        user = ProductModel.fromMap(dataBaseProduct.first);
      }

      return user;
    } catch (e) {
      debugPrint('Error al obtener el producto: $e');
      return null;
    } finally {
      await _dbHelper.closeDb();
    }
  }
}
