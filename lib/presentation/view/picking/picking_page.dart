// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';

class PickingPage extends StatefulWidget {
  const PickingPage({super.key});

  @override
  State<PickingPage> createState() => _PickingPageState();
}

class _PickingPageState extends State<PickingPage> {
  final ProductsViewModel _productsViewModel = inject<ProductsViewModel>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _result = "";
  bool _showNewProductForm = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Products")),
      body: Builder(builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.document_scanner, size: 100),
                onPressed: () {
                  _scan();
                  setState(() {});
                },
              ),
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
                          return value!.isEmpty
                              ? "Enter the name product"
                              : null;
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
            ],
          ),
        );
      }),
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
    setState(() {
      _showNewProductForm = false;
    });
    nameController.clear();
    descriptionController.clear();
  }
}
