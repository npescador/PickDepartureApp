// ignore_for_file: unused_field

import 'package:pick_departure_app/data/order/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderDetail>> getOrderDetails(String orderId);
  updateOrderDetail(OrderDetail detail);
  updateOrder(OrderModel order);
  deleteOrderDetail(OrderDetail detail);
}
