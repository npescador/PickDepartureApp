import 'package:pick_departure_app/data/local/database_helper.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductsRepository {
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
}
