import 'package:pick_departure_app/data/product/product_model.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> getRemoteProducts();
  Future<List<ProductModel>> getLocalProducts();
  addProduct(ProductModel product);
  addProducts(List<ProductModel> products);
  updateProduct(ProductModel product);
  Future<ProductModel?> getProductByBarcode(String barcode);
}
