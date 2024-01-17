// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/viewmodel/orders_viewmodel.dart';
import 'package:pick_departure_app/presentation/view/products/viewmodel/products_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/custom_body_view.dart';
import 'package:pick_departure_app/presentation/widget/custom_list_view.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_view.dart';
import 'package:pick_departure_app/presentation/widget/order_detail/order_detail_row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({super.key, required this.order});

  OrderModel order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with TickerProviderStateMixin {
  List<OrderDetail> _details = [];
  final OrdersViewModel _ordersViewModel = inject<OrdersViewModel>();
  final ProductsViewModel _productsViewModel = inject<ProductsViewModel>();
  final ScrollController _scrollController = ScrollController();
  Color _orderStatusColor = Colors.blueAccent;
  bool _showScanButton = false;

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _ordersViewModel.getOrderDetailsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _details = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _ordersViewModel.fetchOrderDetails(widget.order.id);
          });
          break;
      }
    });

    _ordersViewModel.fetchOrderDetails(widget.order.id);

    switch (widget.order.status) {
      case "Created":
        _orderStatusColor = Colors.blueAccent;
        _showScanButton = true;
        break;
      case "In preparation process":
        _orderStatusColor = Colors.amber;
        _showScanButton = true;
        break;
      case "Completed":
        _orderStatusColor = AppTheme2.buildLightTheme().primaryColor;
        _showScanButton = false;
        break;
    }
  }

  @override
  void dispose() {
    _ordersViewModel.dispose();
    _productsViewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme2.buildLightTheme().primaryColor,
        title: Text(
          "Order ${widget.order.orderCode}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.logout_outlined,
            color: AppTheme2.buildLightTheme().secondaryHeaderColor,
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool("isLoggedIn", false);
            context.pushReplacementNamed(NavigationRoutes.LOGIN_ROUTE);
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: _showScanButton,
        child: FloatingActionButton(
          backgroundColor: AppTheme2.buildLightTheme().dialogBackgroundColor,
          child: Icon(
            MdiIcons.barcodeScan,
            color: AppTheme2.buildLightTheme().primaryColor,
          ),
          onPressed: () {
            _scan();
          },
        ),
      ),
      body: CustomBodyView(
        scrollController: _scrollController,
        bodyChildWidget: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: _orderStatusColor,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.order.status,
                    style: TextStyle(fontSize: 18, color: _orderStatusColor),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.order.orderCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 56,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm')
                    .format(widget.order.createAt.toDate())
                    .toString(),
                style: TextStyle(
                    fontSize: 18, color: Colors.grey.withOpacity(0.8)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _details.length,
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final int count =
                        _details.length > 10 ? 10 : _details.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    return CustomListView(
                      callback: () {},
                      itemRow: OrderDetailRowItem(orderDetail: _details[index]),
                      animation: animation,
                      animationController: animationController,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkStatusOrder() async {
    bool allDetailsPendinAmountZero =
        _details.every((element) => element.pendingAmount == 0);
    if (allDetailsPendinAmountZero) {
      widget.order.status = "Completed";
      _orderStatusColor = AppTheme2.buildLightTheme().primaryColor;
      _showScanButton = false;
    } else if (_details
        .any((element) => element.amount != element.pendingAmount)) {
      widget.order.status = "In preparation process";
      _orderStatusColor = Colors.amber;
    } else {
      widget.order.status = "Created";
      _orderStatusColor = Colors.blueAccent;
    }

    await _ordersViewModel.updateOrder(widget.order);
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
      ProductModel? productScanned =
          await _productsViewModel.fetchProductByBarcode(barcodeScanRes);

      if (productScanned != null) {
        if (_details.any((detail) => detail.productId == productScanned.id)) {
          OrderDetail orderDetail = _details
              .firstWhere((detail) => detail.productId == productScanned.id);
          if (orderDetail.pendingAmount == 0) {
            context.showSnackBar("Product without units pending preparation");
          } else {
            if (productScanned.stock == 0) {
              context.showSnackBar("No stock available");
            } else {
              productScanned.stock -= 1;
              orderDetail.pendingAmount -= 1;
              _productsViewModel.updateProduct(productScanned);
              _ordersViewModel.updateOrderDetail(orderDetail);
              _ordersViewModel.fetchOrderDetails(widget.order.id);
              // _productsViewModel.fetchProducts();
              _checkStatusOrder();

              context.showSnackBar("Successful scanning");

              setState(() {});
            }
          }
        } else {
          context
              .showSnackBar("There is no detail matching the scanned product.");
        }
      } else {
        context.showSnackBar("Product not found");
      }
    }
  }
}
