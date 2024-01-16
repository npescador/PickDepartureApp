// ignore_for_file: void_checks

import 'dart:async';

import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/domain/products_repository.dart';
import 'package:pick_departure_app/presentation/base/base_view_model.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';

class ProductsViewModel extends BaseViewModel {
  final ProductsRepository _productsRepository;

  final StreamController<ResourceState<List<ProductModel>>> getProductsState =
      StreamController();

  final StreamController<ResourceState<void>> addProductState =
      StreamController();

  ProductsViewModel({required ProductsRepository productsRepository})
      : _productsRepository = productsRepository;

  @override
  void dispose() {
    getProductsState.close();
    //getProductBarcodeState.close();
    //updateProductState.close();
    addProductState.close();
  }

  fetchProducts() {
    getProductsState.add(ResourceState.loading());

    _productsRepository
        .getRemoteProducts()
        .then((value) => getProductsState.add(ResourceState.success(value)))
        .catchError(
            (error) => getProductsState.add(ResourceState.error(error)));
  }

  // ignore: body_might_complete_normally_nullable
  Future<ProductModel?> fetchProductByBarcode(String barcode) async {
    return await _productsRepository.getProductByBarcode(barcode);
    // _productsRepository
    //     .getProductByBarcode(barcode)
    //     .then(
    //         (value) => getProductBarcodeState.add(ResourceState.success(value)))
    //     .catchError(
    //         (error) => getProductBarcodeState.add(ResourceState.error(error)));
  }

  sincronizeProductsToLocal() {
    _productsRepository.getRemoteProducts().then((value) => addProducts(value));
  }

  updateProduct(ProductModel product) {
    _productsRepository.updateProduct(product);

    // updateProductState.add(ResourceState.loading());

    // _productsRepository
    //     .updateProduct(product)
    //     .then((value) => updateProductState.add(ResourceState.success(value)))
    //     .catchError(
    //         (error) => updateProductState.add(ResourceState.error(error)));
  }

  addProduct(ProductModel product) {
    addProductState.add(ResourceState.loading());

    _productsRepository.addProduct(product);
    //.catchError((error) => addProductState.add(ResourceState.error(error)));
  }

  addProducts(List<ProductModel> products) {
    _productsRepository.addProducts(products);
  }
}
