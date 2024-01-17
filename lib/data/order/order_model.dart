// To parse this JSON data, do
//
//     final orderModel = orderModelFromMap(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String orderCode;
  Timestamp createAt;
  String status;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.createAt,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json, String id) =>
      OrderModel(
        id: id,
        orderCode: json["orderCode"],
        createAt: json["createAt"],
        status: json["status"],
      );

  factory OrderModel.fromLocalMap(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderCode: json["orderCode"],
        createAt: json["createAt"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "orderCode": orderCode,
        "createAt": createAt,
        "status": status,
      };
}

class OrderDetail {
  String id;
  String orderId;
  String productId;
  int amount;
  String description;
  int pendingAmount;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.amount,
    required this.description,
    required this.pendingAmount,
  });

  factory OrderDetail.fromMap(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderId: json["orderId"],
        productId: json["productId"],
        amount: json["amount"],
        description: json["description"],
        pendingAmount: json["pendingAmount"],
      );

  factory OrderDetail.fromFirestore(Map<String, dynamic> json, String id) =>
      OrderDetail(
        id: id,
        orderId: json["orderId"],
        productId: json["productId"],
        amount: json["amount"],
        description: json["description"],
        pendingAmount: json["pendingAmount"],
      );

  factory OrderDetail.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return OrderDetail(
      id: snapshot.id,
      orderId: data["orderId"] ?? "",
      productId: data["productId"] ?? "",
      amount: data["amount"] ?? 0,
      description: data["description"] ?? "",
      pendingAmount: data["pendingAmount"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "orderId": orderId,
        "productId": productId,
        "amount": amount,
        "description": description,
        "pendingAmount": pendingAmount,
      };
}
