import 'package:pick_departure_app/data/product/local/product_local_impl.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/domain/products_repository.dart';

class ProductDataImpl extends ProductsRepository {
  final ProductLocalImpl _localImpl;

  ProductDataImpl({required ProductLocalImpl localImpl})
      : _localImpl = localImpl;

  @override
  addProduct(ProductModel product) {
    _localImpl.addProduct(product);
  }

  @override
  Future<List<ProductModel>> getProducts() {
    return _localImpl.getProducts();
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) {
    return _localImpl.getProductByBarcode(barcode);
  }

  @override
  updateProduct(ProductModel product) {
    _localImpl.updateProduct(product);
  }
}
