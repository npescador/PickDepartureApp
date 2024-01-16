// Implementacion de la lectura de la base de datos remota// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_departure_app/data/product/product_model.dart';

class ProductRemoteImpl {
  final _firestore = FirebaseFirestore.instance;

  addProduct(ProductModel product) {
    //
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    ProductModel? product;
    await _firestore
        .collection("products")
        .where("barcode", isEqualTo: barcode)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final productFireBase = querySnapshot.docs.first;
        product = ProductModel.fromFirestore(
            productFireBase.data(), productFireBase.id);
      }
    });

    return product;
  }

  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> products = [];

    await _firestore.collection("products").get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          products.add(ProductModel.fromSnapshot(element));
        }
      }
    });

    return products;
  }

  updateProduct(ProductModel product) async {
    await _firestore
        .collection("products")
        .doc(product.id)
        .set(product.toMap());
  }

  addProducts(List<ProductModel> product) {
    //
  }
}
