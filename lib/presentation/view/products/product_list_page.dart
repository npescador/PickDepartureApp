import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_view.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key, required this.reloadProductList});

  final Function reloadProductList;

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final ProductsViewModel _productsViewModel = inject<ProductsViewModel>();

  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();

    _productsViewModel.getProductsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _products = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _productsViewModel.fetchProducts();
          });
          break;
      }
    });

    _productsViewModel.fetchProducts();
  }

  @override
  void dispose() {
    _productsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(
          Icons.replay_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          _getProducts();
          setState(() {});
        },
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            itemCount: _products.length,
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

  _getProducts() async {
    _products = await _productsViewModel.reloadProductList();
  }
}
