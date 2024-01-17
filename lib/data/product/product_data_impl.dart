import 'package:pick_departure_app/data/product/local/product_local_impl.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/data/product/remote/product_remote_impl.dart';
import 'package:pick_departure_app/domain/products_repository.dart';

class ProductDataImpl extends ProductsRepository {
  final ProductLocalImpl _localImpl;
  final ProductRemoteImpl _remoteImpl;

  ProductDataImpl(
      {required ProductLocalImpl localImpl,
      required ProductRemoteImpl remoteImpl})
      : _localImpl = localImpl,
        _remoteImpl = remoteImpl;

  @override
  addProduct(ProductModel product) {
    _remoteImpl.addProduct(product);
  }

  @override
  Future<List<ProductModel>> getRemoteProducts() {
    return _remoteImpl.getProducts();
  }

  @override
  Future<List<ProductModel>> getLocalProducts() {
    return _localImpl.getProducts();
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    return await _remoteImpl.getProductByBarcode(barcode);
  }

  @override
  updateProduct(ProductModel product) {
    _remoteImpl.updateProduct(product);
  }

  @override
  addProducts(List<ProductModel> products) {
    _remoteImpl.addProducts(products);
  }
}
