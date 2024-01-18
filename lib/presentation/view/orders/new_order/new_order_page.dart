import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key, required this.saveOrder});

  final Function() saveOrder;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage>
    with TickerProviderStateMixin {
  List<DropdownMenuItem<int>> statusList = [];
  List<ProductModel> prductList = [];
  String _orderCode = "";
  final String _productSearchCode = "";
  int _selectedStatusOrder = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _orderCodeController = TextEditingController();
  final TextEditingController _productSearchCodeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadStatusList();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.buildLightTheme().primaryColor,
        title: const Text(
          "New Order",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.showSnackBar("Order saved");
              widget.saveOrder.call();
              context.pop();
            },
            child: Row(
              children: [
                Icon(Icons.save,
                    color: AppTheme.buildLightTheme().secondaryHeaderColor),
                const SizedBox(
                  width: 2,
                ),
                Text("Save",
                    style: TextStyle(
                        color:
                            AppTheme.buildLightTheme().secondaryHeaderColor)),
              ],
            ),
          ),
        ],
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
                      Expanded(
                        child: NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [];
                          },
                          controller: scrollController,
                          body: Container(
                            color: AppTheme.buildLightTheme()
                                .colorScheme
                                .background,
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 4,
                                                right: 8,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 2,
                                                    color: AppTheme
                                                            .buildLightTheme()
                                                        .primaryColor),
                                                color: Colors.transparent),
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              controller: _orderCodeController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Enter order code",
                                                hintStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onChanged: (value) {
                                                _orderCode = value;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Order code is mandatory";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                top: 4,
                                                right: 8,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 2,
                                                    color: AppTheme
                                                            .buildLightTheme()
                                                        .primaryColor),
                                                color: Colors.transparent),
                                            child: DropdownButtonFormField(
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                hint: const Text(
                                                    "Select order status"),
                                                items: statusList,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedStatusOrder =
                                                        int.parse(
                                                            value.toString());
                                                  });
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                              right: 8,
                                              bottom: 4,
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 2,
                                                    color: AppTheme
                                                            .buildLightTheme()
                                                        .primaryColor),
                                                color: Colors.transparent),
                                            child: TextField(
                                              textInputAction:
                                                  TextInputAction.search,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              controller:
                                                  _productSearchCodeController,
                                              onChanged: (value) {
                                                //
                                              },
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search a product",
                                                hintStyle: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                prefixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.search_rounded,
                                                      color: AppTheme
                                                              .buildLightTheme()
                                                          .primaryColor),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          "Sending Message"),
                                                    ));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
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

  _loadStatusList() {
    statusList = [];
    statusList.add(const DropdownMenuItem(
      value: 0,
      child: Text('Created'),
    ));
    statusList.add(const DropdownMenuItem(
      value: 1,
      child: Text('In preparation process'),
    ));
    statusList.add(const DropdownMenuItem(
      value: 2,
      child: Text('Completed'),
    ));
  }
}
