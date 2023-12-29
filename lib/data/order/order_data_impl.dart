import 'package:pick_departure_app/data/order/local/order_local_impl.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/domain/orders_repository.dart';

class OrderDataImpl extends OrdersRepository {
  final OrderLocalImpl _localImpl;

  OrderDataImpl({required OrderLocalImpl localImpl}) : _localImpl = localImpl;

  @override
  addNewOrder(OrderModel order, List<OrderDetail> orderDetails) {
    _localImpl.addNewOrder(order, orderDetails);
  }

  @override
  deleteOrderDetail(OrderDetail detail) {
    _localImpl.deleteOrderDetail(detail);
  }

  @override
  Future<List<OrderDetail>> getOrderDetails(int orderId) {
    return _localImpl.getOrderDetails(orderId);
  }

  @override
  Future<List<OrderModel>> getOrders() {
    return _localImpl.getOrders();
  }

  @override
  updateOrderDetail(OrderDetail detail) {
    _localImpl.updateOrderDetail(detail);
  }
}
