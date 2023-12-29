// ignore_for_file: unused_field

import 'package:pick_departure_app/data/order/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderDetail>> getOrderDetails(int orderId);
  addNewOrder(OrderModel order, List<OrderDetail> orderDetails);
  updateOrderDetail(OrderDetail detail);
  deleteOrderDetail(OrderDetail detail);
}
