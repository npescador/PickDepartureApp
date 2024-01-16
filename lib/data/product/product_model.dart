import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel productModelFromMap(String str) =>
    ProductModel.fromMap(json.decode(str));

String productModelToMap(ProductModel data) => json.encode(data.toMap());

class ProductModel {
  String id;
  String name;
  String description;
  String barcode;
  int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.stock,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        barcode: json["barcode"],
        stock: json["stock"],
      );

  factory ProductModel.fromFirestore(Map<String, dynamic> json, String id) =>
      ProductModel(
        id: id,
        name: json["name"],
        description: json["description"],
        barcode: json["barcode"],
        stock: json["stock"],
      );

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return ProductModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      barcode: data['barcode'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "barcode": barcode,
        "stock": stock,
      };
}
