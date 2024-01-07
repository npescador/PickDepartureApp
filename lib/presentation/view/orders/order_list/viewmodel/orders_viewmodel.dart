// ignore_for_file: void_checks

import 'dart:async';

import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';
import 'package:pick_departure_app/presentation/base/base_view_model.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';

class OrdersViewModel extends BaseViewModel {
  final OrdersRepository _ordersRepository;

  final StreamController<ResourceState<List<OrderModel>>> getOrdersState =
      StreamController();

  final StreamController<ResourceState<void>> addOrderState =
      StreamController();

  OrdersViewModel({required OrdersRepository ordersRepository})
      : _ordersRepository = ordersRepository;

  @override
  void dispose() {
    getOrdersState.close();
    addOrderState.close();
  }

  fetchProducts() {
    getOrdersState.add(ResourceState.loading());

    _ordersRepository
        .getOrders()
        .then((value) => getOrdersState.add(ResourceState.success(value)))
        .catchError((error) => getOrdersState.add(ResourceState.error(error)));
  }

  addProduct(OrderModel order, List<OrderDetail> orderDetails) {
    addOrderState.add(ResourceState.loading());

    _ordersRepository.addNewOrder(order, orderDetails);
  }
}