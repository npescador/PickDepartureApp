// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/search/product_search_delegate.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/custom_list_view.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_overlay.dart';
import 'package:pick_departure_app/presentation/widget/product/product_row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage>
    with TickerProviderStateMixin {
  final ProductsViewModel _productsViewModel = inject<ProductsViewModel>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _result = "";
  bool _showNewProductForm = false;
  List<ProductModel> _products = [];
  final ScrollController _scrollController = ScrollController();
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _productsViewModel.getProductsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingOverlay.show(context);
          break;
        case Status.SUCCESS:
          LoadingOverlay.hide();
          setState(() {
            _products = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingOverlay.hide();
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
    animationController.dispose();
    _scrollController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.buildLightTheme().primaryColor,
        title: const Text("Products",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppTheme.buildLightTheme().secondaryHeaderColor,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                    searchFieldStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    searchFieldLabel: " Search product",
                    products: _products,
                    animationController: animationController),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout_outlined,
              color: AppTheme.buildLightTheme().secondaryHeaderColor,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);
              context.pushReplacementNamed(NavigationRoutes.LOGIN_ROUTE);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.buildLightTheme().dialogBackgroundColor,
        child: Icon(
          MdiIcons.barcodeScan,
          color: AppTheme.buildLightTheme().primaryColor,
        ),
        onPressed: () {
          _scan();
        },
      ),
      body: SafeArea(
        child: Material(
          child: Theme(
            data: AppTheme.buildLightTheme(),
            child: Stack(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: [
                      Visibility(
                        visible: _showNewProductForm,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 32),
                          child: Column(
                            children: [
                              Text(_result),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: "Name"),
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
                                decoration: const InputDecoration(
                                    labelText: "Description"),
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
                      Visibility(
                        visible: !_showNewProductForm,
                        child: Expanded(
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [];
                            },
                            controller: _scrollController,
                            body: Container(
                              color: AppTheme.buildLightTheme()
                                  .colorScheme
                                  .background,
                              child: ListView.builder(
                                itemCount: _products.length,
                                padding: const EdgeInsets.only(top: 8),
                                itemBuilder: (BuildContext context, int index) {
                                  final int count = _products.length > 10
                                      ? 10
                                      : _products.length;
                                  final Animation<double> animation =
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve:
                                                      Curves.fastOutSlowIn)));
                                  animationController.forward();
                                  return CustomListView(
                                    callback: () {},
                                    itemRow: ProductRowItem(
                                        product: _products[index]),
                                    animation: animation,
                                    animationController: animationController,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#63d674", "Close", false, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version.";
    }

    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty && barcodeScanRes != "-1") {
      _result = barcodeScanRes;

      if (_products.isNotEmpty &&
          _products.any((element) => element.barcode == barcodeScanRes)) {
        ProductModel productScanned = _products
            .firstWhere((element) => element.barcode == barcodeScanRes);

        productScanned.stock += 1;
        _productsViewModel.updateProduct(productScanned);
        _productsViewModel.fetchProducts();
        context.showSnackBar("Product entry done");
        setState(() {
          _showNewProductForm = false;
        });
      } else {
        // No existe, preguntamos si lo damos de alta
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Product not found"),
              content: const Text(
                  "¿You want to add a new product with this barcode?"),
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
      id: "",
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
