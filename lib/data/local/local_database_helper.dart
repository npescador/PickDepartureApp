import 'package:sqflite/sqflite.dart';

class LocalDataBaseHelper {
  static const String productTable = "product";
  static const String ordersTable = "orders";
  static const String orderDetailTable = "orderDetail";
  static const String userTable = "user";

  Database? _db;

  Future<Database> getDb() async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDatabase('pick_departure.db', version: 1);
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
        "CREATE TABLE IF NOT EXISTS ${LocalDataBaseHelper.productTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, barcode TEXT, stock INTEGER)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${LocalDataBaseHelper.ordersTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, orderCode TEXT, createAt TEXT, status TEXT)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${LocalDataBaseHelper.orderDetailTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, orderId INTEGER, productId INTEGER, amount INTEGER, description TEXT, pendingAmount INTEGER)");
    db.execute(
        "CREATE TABLE IF NOT EXISTS ${LocalDataBaseHelper.userTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, password TEXT, barcode TEXT, email TEXT, phoneNumber TEXT)");
  }
}
