import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/viewmodel/orders_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/custom_body_view.dart';
import 'package:pick_departure_app/presentation/widget/custom_list_view.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_view.dart';
import 'package:pick_departure_app/presentation/widget/order/order_row_item.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with TickerProviderStateMixin {
  final OrdersViewModel _ordersViewModel = inject<OrdersViewModel>();
  final ScrollController _scrollController = ScrollController();
  List<OrderModel> _orders = [];

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _ordersViewModel.getOrdersState.stream.listen((state) {
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
            _ordersViewModel.fetchOrders();
          });
          break;
      }
    });

    _ordersViewModel.fetchOrders();
  }

  @override
  void dispose() {
    animationController.dispose();
    _ordersViewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme2.buildLightTheme().primaryColor,
        title: const Text(
          "Orders",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              context.go(NavigationRoutes.NEW_ORDER_ROUTE, extra: () {
                _ordersViewModel.fetchOrders();
              })
            },
          ),
        ],
      ),
      body: CustomBodyView(
        scrollController: _scrollController,
        bodyChildWidget: ListView.builder(
          itemCount: _orders.length,
          padding: const EdgeInsets.only(top: 8),
          itemBuilder: (BuildContext context, int index) {
            final int count = _orders.length > 10 ? 10 : _orders.length;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController.forward();
            return CustomListView(
              callback: () {
                context.go(NavigationRoutes.ORDER_DETAIL_ROUTE,
                    extra: _orders[index]);
              },
              itemRow: OrderRowItem(order: _orders[index]),
              animation: animation,
              animationController: animationController,
            );
          },
        ),
      ),
    );
  }
}
