import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const String productTable = "product";
  static const String orderTable = "order";
  static const String orderDetailTable = "orderDetail";
  static const String userTable = "user";

  Database? _db;

  Future<Database> getDb() async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDatabase('shopping_list.db', version: 1);
    }

    await _createTables(_db!);

    return _db!;
  }

  closeDb() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
  }

  _createTables(Database db) async {
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${DataBaseHelper.productTable} (id INTEGER PRIMARY KEY, name TEXT, description TEXT, barcode TEXT, stock INTEGER)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${DataBaseHelper.orderTable} (id INTEGER PRIMARY KEY, orderCode TEXT, createAt TEXT, status TEXT)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${DataBaseHelper.orderDetailTable} (id INTEGER PRIMARY KEY, orderId INTEGER, productId INTEGER, amount INTEGER, description TEXT, pendingAmount INTEGER"
        "FOREIGN KEY (orderId) REFERENCES ${DataBaseHelper.orderTable} (id) ON DELETE CASCADE,"
        "FOREIGN KEY (productId) REFERENCES ${DataBaseHelper.productTable} (id) ON DELETE CASCADE)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${DataBaseHelper.userTable} (id INTEGER PRIMARY KEY, name TEXT, password TEXT, barcode TEXT, email TEXT, phoneNumber TEXT)");
  }
}
