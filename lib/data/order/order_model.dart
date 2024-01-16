// To parse this JSON data, do
//
//     final orderModel = orderModelFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

OrderModel orderModelFromMap(String str) =>
    OrderModel.fromMap(json.decode(str));

String orderModelToMap(OrderModel data) => json.encode(data.toMap());

class OrderModel {
  int id;
  String orderCode;
  Timestamp createAt;
  String status;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.createAt,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
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
  int id;
  int orderId;
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

  Map<String, dynamic> toMap() => {
        "id": id,
        "orderId": orderId,
        "productId": productId,
        "amount": amount,
        "description": description,
        "pendingAmount": pendingAmount,
      };
}
