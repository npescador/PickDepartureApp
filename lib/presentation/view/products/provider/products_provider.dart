import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/product/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductModel> products = [];

  void reloadProducts(List<ProductModel> productsList) {
    products = productsList;
    notifyListeners();
  }
}
