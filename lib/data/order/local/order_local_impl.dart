import 'package:pick_departure_app/data/local/local_database_helper.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:sqflite/sqflite.dart';

class OrderLocalImpl {
  final LocalDataBaseHelper _dbHelper = LocalDataBaseHelper();

  Future<List<OrderModel>> getOrders() async {
    Database db = await _dbHelper.getDb();

    final dataBaseOrders = await db.query(LocalDataBaseHelper.ordersTable);
    final orderList = dataBaseOrders.map((e) => OrderModel.fromMap(e));

    await _dbHelper.closeDb();

    return orderList.toList();
  }

  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    Database db = await _dbHelper.getDb();

    final dataBaseOrderDetails = await db.query(
        LocalDataBaseHelper.orderDetailTable,
        where: 'id = ?',
        whereArgs: [orderId]);
    final orderDetailList =
        dataBaseOrderDetails.map((e) => OrderDetail.fromMap(e));

    await _dbHelper.closeDb();

    return orderDetailList.toList();
  }

  addNewOrder(OrderModel order, List<OrderDetail> orderDetails) async {
    Database db = await _dbHelper.getDb();

    int orderId =
        await db.insert(LocalDataBaseHelper.ordersTable, order.toMap());

    for (var detail in orderDetails) {
      detail.orderId = orderId;
      await db.insert(LocalDataBaseHelper.orderDetailTable, detail.toMap());
    }

    await _dbHelper.closeDb();
  }

  updateOrderDetail(OrderDetail detail) async {
    Database db = await _dbHelper.getDb();

    await db.update(LocalDataBaseHelper.orderDetailTable, detail.toMap(),
        where: 'id = ?', whereArgs: [detail.id]);

    await _dbHelper.closeDb();
  }

  deleteOrderDetail(OrderDetail detail) async {
    Database db = await _dbHelper.getDb();

    await db.delete(LocalDataBaseHelper.orderDetailTable,
        where: 'id = ?', whereArgs: [detail.id]);

    await _dbHelper.closeDb();
  }
}
