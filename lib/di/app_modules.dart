import 'package:get_it/get_it.dart';
import 'package:pick_departure_app/data/order/local/order_local_impl.dart';
import 'package:pick_departure_app/data/order/order_data_impl.dart';
import 'package:pick_departure_app/data/order/remote/order_remote_impl.dart';
import 'package:pick_departure_app/data/product/local/product_local_impl.dart';
import 'package:pick_departure_app/data/product/product_data_impl.dart';
import 'package:pick_departure_app/data/product/remote/product_remote_impl.dart';
import 'package:pick_departure_app/data/users/local/user_local_impl.dart';
import 'package:pick_departure_app/data/users/remote/user_remote_impl.dart';
import 'package:pick_departure_app/data/users/user_data_impl.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';
import 'package:pick_departure_app/domain/products_repository.dart';
import 'package:pick_departure_app/domain/users_repository.dart';
import 'package:pick_departure_app/presentation/view/authentication/viewmodel/user_viewmodel.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/viewmodel/orders_viewmodel.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupProductsModule();
    _setupOrdersModule();
    _setupUsersModule();
  }

  _setupProductsModule() {
    inject.registerFactory(() => ProductLocalImpl());
    inject.registerFactory(() => ProductRemoteImpl());
    inject.registerFactory<ProductsRepository>(() =>
        ProductDataImpl(localImpl: inject.get(), remoteImpl: inject.get()));
    inject.registerFactory(
        () => ProductsViewModel(productsRepository: inject.get()));
  }

  _setupOrdersModule() {
    inject.registerFactory(() => OrderLocalImpl());
    inject.registerFactory(() => OrderRemoteImpl());
    inject.registerFactory<OrdersRepository>(
        () => OrderDataImpl(localImpl: inject.get(), remoteImpl: inject.get()));
    inject
        .registerFactory(() => OrdersViewModel(ordersRepository: inject.get()));
  }

  _setupUsersModule() {
    inject.registerFactory(() => UserLocalImpl());
    inject.registerFactory(() => UserRemoteImpl());
    inject.registerFactory<UsersRepository>(
        () => UserDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(() => UserViewModel(usersRepository: inject.get()));
  }
}
