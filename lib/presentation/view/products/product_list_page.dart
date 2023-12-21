import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/product/product_model.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final List<ProductModel> _products = [
    ProductModel(
        id: 1,
        name: "Naranjas",
        description: "Bolsa de naranjas de 5 kgs",
        barcode: "085469954",
        stock: 15),
    ProductModel(
        id: 1,
        name: "Coca Cola",
        description: "Latas de coca cola",
        barcode: "085469414",
        stock: 10),
    ProductModel(
        id: 1,
        name: "Jamón",
        description: "Maza de Jamón",
        barcode: "085465649",
        stock: 18),
  ];

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
            itemCount: _products.length,
            //itemCount: 2,
            itemBuilder: (_, index) {
              final product = _products[index];
              return Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre: ${product.name}',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text('Descripción: ${product.description}'),
                      const SizedBox(height: 8.0),
                      Text('Stock: ${product.stock} unidades'),
                      const SizedBox(height: 8.0),
                      Text('Código de Barras: ${product.barcode}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
