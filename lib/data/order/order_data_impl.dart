import 'package:pick_departure_app/data/order/local/order_local_impl.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/data/order/remote/order_remote_impl.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';

class OrderDataImpl extends OrdersRepository {
  final OrderLocalImpl _localImpl;
  final OrderRemoteImpl _remoteImpl;

  OrderDataImpl(
      {required OrderLocalImpl localImpl, required OrderRemoteImpl remoteImpl})
      : _localImpl = localImpl,
        _remoteImpl = remoteImpl;

  @override
  deleteOrderDetail(OrderDetail detail) {
    _localImpl.deleteOrderDetail(detail);
  }

  @override
  Future<List<OrderDetail>> getOrderDetails(String orderId) {
    return _remoteImpl.getOrderDetails(orderId);
  }

  @override
  Future<List<OrderModel>> getOrders() {
    return _remoteImpl.getOrders();
  }

  @override
  updateOrderDetail(OrderDetail detail) {
    _remoteImpl.updateOrderDetail(detail);
  }

  @override
  updateOrder(OrderModel order) {
    _remoteImpl.updateOrder(order);
  }
}
