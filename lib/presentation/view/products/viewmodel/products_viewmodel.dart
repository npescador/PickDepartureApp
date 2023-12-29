import 'dart:async';

import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/domain/products_repository.dart';
import 'package:pick_departure_app/presentation/base/base_view_model.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';

class ProductsViewModel extends BaseViewModel {
  final ProductsRepository _productsRepository;

  final StreamController<ResourceState<List<ProductModel>>> getProductsState =
      StreamController();

  ProductsViewModel({required ProductsRepository productsRepository})
      : _productsRepository = productsRepository;

  @override
  void dispose() {
    getProductsState.close();
  }

  fetchProducts() {
    getProductsState.add(ResourceState.loading());

    _productsRepository
        .getProducts()
        .then((value) => getProductsState.add(ResourceState.success(value)))
        .catchError(
            (error) => getProductsState.add(ResourceState.error(error)));
  }
}
