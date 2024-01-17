// Implementacion de la lectura de la base de datos remota// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';

class OrderRemoteImpl extends OrdersRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  deleteOrderDetail(OrderDetail detail) {
    //
  }

  @override
  Future<List<OrderDetail>> getOrderDetails(String orderId) async {
    List<OrderDetail> orders = [];
    await _firestore
        .collection("ordersDetails")
        .where("orderId", isEqualTo: orderId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          orders.add(OrderDetail.fromFirestore(element.data(), element.id));
        }
      }
    });
    return orders;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> orders = [];
    await _firestore.collection("orders").get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          orders.add(OrderModel.fromMap(element.data(), element.id));
        }
      }
    });
    return orders;
  }

  @override
  updateOrderDetail(OrderDetail detail) async {
    await _firestore
        .collection("ordersDetails")
        .doc(detail.id)
        .set(detail.toMap());
  }

  @override
  updateOrder(OrderModel order) async {
    await _firestore.collection("orders").doc(order.id).set(order.toMap());
  }
}
