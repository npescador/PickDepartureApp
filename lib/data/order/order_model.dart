// To parse this JSON data, do
//
//     final orderModel = orderModelFromMap(jsonString);

import 'dart:convert';

OrderModel orderModelFromMap(String str) =>
    OrderModel.fromMap(json.decode(str));

String orderModelToMap(OrderModel data) => json.encode(data.toMap());

class OrderModel {
  int id;
  String orderCode;
  String createAt;
  String status;
  List<OrderDetail> orderDetails;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.createAt,
    required this.status,
    required this.orderDetails,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderCode: json["orderCode"],
        createAt: json["createAt"],
        status: json["status"],
        orderDetails: List<OrderDetail>.from(
            json["orderDetails"].map((x) => OrderDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "orderCode": orderCode,
        "createAt": createAt,
        "status": status,
        "orderDetails": List<dynamic>.from(orderDetails.map((x) => x.toMap())),
      };
}

class OrderDetail {
  int id;
  int orderId;
  int productId;
  int amount;
  String description;
  int? pendingAmount;

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
