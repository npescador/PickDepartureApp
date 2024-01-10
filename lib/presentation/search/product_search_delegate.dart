import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';
import 'package:pick_departure_app/presentation/widget/custom_list_view.dart';
import 'package:pick_departure_app/presentation/widget/product/product_row_item.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductModel> products;
  final AnimationController animationController;

  ProductSearchDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.products,
      required this.animationController});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: const Icon(Icons.arrow_circle_left_outlined),
      onPressed: () {
        close(context, null);
      },
    );
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductModel> productsFiltered = [];

    if (query.isEmpty) {
      productsFiltered = products;
    } else {
      productsFiltered = products
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              element.barcode.toLowerCase().contains(query.toLowerCase()) ||
              element.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (productsFiltered.isNotEmpty) {
      return ListView.builder(
        itemCount: productsFiltered.length,
        padding: const EdgeInsets.only(top: 8),
        itemBuilder: (BuildContext context, int index) {
          final int count =
              productsFiltered.length > 10 ? 10 : productsFiltered.length;
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return CustomListView(
            callback: () {},
            itemRow: ProductRowItem(product: productsFiltered[index]),
            animation: animation,
            animationController: animationController,
          );
        },
      );
    } else {
      return Center(
          child: Text(
        "No results found",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme2.buildLightTheme().primaryColor),
      ));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const ListTile(
      title: Text(""),
    );
  }
}
