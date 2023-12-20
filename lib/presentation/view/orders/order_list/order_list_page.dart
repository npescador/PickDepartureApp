import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
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
            itemCount: 10,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  context.go(NavigationRoutes.ORDER_DETAIL_ROUTE);
                },
                child: Card(
                  child: Text("Order $index"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
