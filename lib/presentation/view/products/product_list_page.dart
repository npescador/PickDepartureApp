// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _result = "";
  bool _showNewProductForm = false;
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
        backgroundColor: Colors.greenAccent,
        child: const Icon(
          Icons.document_scanner,
          color: Colors.white,
        ),
        onPressed: () {
          _scan();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: _showNewProductForm,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(_result),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Name"),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        return value!.isEmpty ? "Enter the name product" : null;
                      },
                      controller: nameController,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? "Enter a product description"
                            : null;
                      },
                      controller: descriptionController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _addNewProduct();
                          },
                          child: const Text("Create"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showNewProductForm = false;
                            });
                            nameController.clear();
                            descriptionController.clear();
                          },
                          child: const Text("Cancel"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Visibility(
                visible: !_showNewProductForm,
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: _products.length,
                    itemBuilder: (_, index) {
                      final product = _products[index];
                      return Card(
                        color: const Color(0xFF59F1BF),
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nombre: ${product.name}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#63d674", "Close", false, ScanMode.DEFAULT);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version.";
    }

    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty && barcodeScanRes != "-1") {
      _result = barcodeScanRes;
      debugPrint(
          "Comenzamos la comprobación de existencia del código de barras");
      ProductModel? productScanned =
          await _productsViewModel.fetchProductByBarcode(barcodeScanRes);

      debugPrint("Ya tenemos el resultado");
      if (productScanned != null) {
        productScanned.stock += 1;
        _productsViewModel.updateProduct(productScanned);
        _productsViewModel.fetchProducts();
        context.showSnackBar("Entrada del producto realizada");
        setState(() {
          _showNewProductForm = false;
        });
      } else {
        // No existe, preguntamos si lo damos de alta
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Producto no encontrado"),
              content: const Text(
                  "¿Desea agregar un nuevo producto con este código de barras?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showNewProductForm = false;
                      Navigator.of(dialogContext).pop();
                    });
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showNewProductForm = !_showNewProductForm;
                      Navigator.of(dialogContext).pop();
                    });
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {
      _result = barcodeScanRes;
    });
  }

  _addNewProduct() {
    ProductModel newProduct = ProductModel(
      id: UniqueKey().hashCode,
      name: nameController.text,
      description: descriptionController.text,
      barcode: _result,
      stock: 1,
    );
    _productsViewModel.addProduct(newProduct);
    _productsViewModel.fetchProducts();

    setState(() {
      _showNewProductForm = false;
    });
    nameController.clear();
    descriptionController.clear();
  }
}
