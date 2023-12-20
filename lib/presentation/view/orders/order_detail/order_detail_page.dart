import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Text("Order 1"),
          ],
        ),
      ),
    );
  }
}
