import 'dart:convert';

ProductModel productModelFromMap(String str) =>
    ProductModel.fromMap(json.decode(str));

String productModelToMap(ProductModel data) => json.encode(data.toMap());

class ProductModel {
  int id;
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

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "barcode": barcode,
        "stock": stock,
      };
}
