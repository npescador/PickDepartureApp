import 'package:get_it/get_it.dart';
import 'package:pick_departure_app/data/order/local/order_local_impl.dart';
import 'package:pick_departure_app/data/order/order_data_impl.dart';
import 'package:pick_departure_app/data/product/local/product_local_impl.dart';
import 'package:pick_departure_app/data/product/product_data_impl.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';
import 'package:pick_departure_app/domain/products_repository.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/viewmodel/orders_viewmodel.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    //_setupMainModule();
    _setupProductsModule();
    _setupOrdersModule();
  }

  // _setupMainModule() {
  //   //inject.registerSingleton(NetworkClient());
  // }

  _setupProductsModule() {
    inject.registerFactory(() =>
        ProductLocalImpl()); //No tengo muy claro si lo tengo que agregar o no
    inject.registerFactory<ProductsRepository>(
        () => ProductDataImpl(localImpl: inject.get()));
    inject.registerFactory(
        () => ProductsViewModel(productsRepository: inject.get()));
  }

  _setupOrdersModule() {
    inject.registerFactory(() =>
        OrderLocalImpl()); //No tengo muy claro si lo tengo que agregar o no
    inject.registerFactory<OrdersRepository>(
        () => OrderDataImpl(localImpl: inject.get()));
    inject
        .registerFactory(() => OrdersViewModel(ordersRepository: inject.get()));
  }
}
