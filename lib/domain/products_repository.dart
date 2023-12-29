import 'package:pick_departure_app/data/product/product_model.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> getProducts();
  addProduct(ProductModel product);
}
