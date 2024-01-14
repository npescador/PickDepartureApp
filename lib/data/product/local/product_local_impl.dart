import 'package:pick_departure_app/data/local/local_database_helper.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalImpl {
  final LocalDataBaseHelper _dbHelper = LocalDataBaseHelper();

  Future<List<ProductModel>> getProducts() async {
    Database db = await _dbHelper.getDb();

    final dataBaseProducts = await db.query(LocalDataBaseHelper.productTable);
    final productList = dataBaseProducts.map((e) => ProductModel.fromMap(e));

    await _dbHelper.closeDb();

    return productList.toList();
  }

  addProduct(ProductModel product) async {
    Database db = await _dbHelper.getDb();

    await db.insert(LocalDataBaseHelper.productTable, product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    await _dbHelper.closeDb();
  }

  updateProduct(ProductModel product) async {
    Database db = await _dbHelper.getDb();

    await db.update(LocalDataBaseHelper.productTable, product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);

    await _dbHelper.closeDb();
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    Database db = await _dbHelper.getDb();

    final dataBaseProduct = await db.rawQuery(
        "SELECT * FROM ${LocalDataBaseHelper.productTable} WHERE barcode = ?",
        [barcode]);

    ProductModel? product;
    if (dataBaseProduct.isNotEmpty) {
      product = ProductModel.fromMap(dataBaseProduct.first);
    }

    await _dbHelper.closeDb();

    return product;
  }
}
