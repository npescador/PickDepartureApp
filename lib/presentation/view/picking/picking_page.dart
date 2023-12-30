import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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

  Future<void> scan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#63d674', "Close", false, ScanMode.DEFAULT);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version.";
    }

    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty) {
      _result = barcodeScanRes;
      ProductModel? productScanned =
          _productsViewModel.getProductByBarcode(barcodeScanRes);

      if (productScanned != null) {
        productScanned.stock += 1;
        _productsViewModel.updateProduct(productScanned);
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
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    _showNewProductForm = !_showNewProductForm;
                    Navigator.of(dialogContext).pop();
                    setState(() {});
                  },
                  child: const Text("Aceptar"),
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
                icon: const Icon(Icons.document_scanner),
                onPressed: () {
                  setState(() {
                    _showNewProductForm = false;
                  });
                  scan();
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
                      ElevatedButton(
                        onPressed: () {
                          ProductModel newProduct = ProductModel(
                            id: -1,
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
                        },
                        child: const Text("Create product"),
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
}
