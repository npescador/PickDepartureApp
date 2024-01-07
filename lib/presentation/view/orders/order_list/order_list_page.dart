import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/viewmodel/orders_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_view.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrdersViewModel _orderessViewModel = inject<OrdersViewModel>();
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();

    _orderessViewModel.getOrdersState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _orders = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _orderessViewModel.fetchProducts();
          });
          break;
      }
    });

    _orderessViewModel.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {context.go(NavigationRoutes.NEW_ORDER_ROUTE)},
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            itemCount: _orders.length,
            itemBuilder: (_, index) {
              final order = _orders[index];
              return GestureDetector(
                onTap: () {
                  context.go(NavigationRoutes.ORDER_DETAIL_ROUTE);
                },
                child: Card(
                  child: Text(
                      "Order ${order.orderCode}  - Status: ${order.status}"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
