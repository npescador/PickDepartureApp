import 'package:flutter/material.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            itemCount: 10,
            itemBuilder: (_, index) {
              return Card(
                child: Text("Products $index"),
              );
            },
          ),
        ),
      ),
    );
  }
}
