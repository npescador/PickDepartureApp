import 'package:pick_departure_app/data/local/database_helper.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:sqflite/sqflite.dart';

class OrderLocalImpl {
  final DataBaseHelper _dbHelper = DataBaseHelper();

  Future<List<OrderModel>> getOrders() async {
    Database db = await _dbHelper.getDb();

    final dataBaseOrders = await db.query(DataBaseHelper.orderTable);
    final orderList = dataBaseOrders.map((e) => OrderModel.fromMap(e));

    await _dbHelper.closeDb();

    return orderList.toList();
  }

  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    Database db = await _dbHelper.getDb();

    final dataBaseOrderDetails = await db.query(DataBaseHelper.orderDetailTable,
        where: 'id = ?', whereArgs: [orderId]);
    final orderDetailList =
        dataBaseOrderDetails.map((e) => OrderDetail.fromMap(e));

    await _dbHelper.closeDb();

    return orderDetailList.toList();
  }

  addNewOrder(OrderModel order, List<OrderDetail> orderDetails) async {
    Database db = await _dbHelper.getDb();

    int orderId = await db.insert(DataBaseHelper.orderTable, order.toMap());

    for (var detail in orderDetails) {
      detail.orderId = orderId;
      await db.insert(DataBaseHelper.orderDetailTable, detail.toMap());
    }

    await _dbHelper.closeDb();
  }

  updateOrderDetail(OrderDetail detail) async {
    Database db = await _dbHelper.getDb();

    await db.update(DataBaseHelper.orderDetailTable, detail.toMap(),
        where: 'id = ?', whereArgs: [detail.id]);

    await _dbHelper.closeDb();
  }

  deleteOrderDetail(OrderDetail detail) async {
    Database db = await _dbHelper.getDb();

    await db.delete(DataBaseHelper.orderDetailTable,
        where: 'id = ?', whereArgs: [detail.id]);

    await _dbHelper.closeDb();
  }
}
