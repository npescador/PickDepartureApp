import 'package:flutter/material.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("New Order"),
    );
  }
}
