import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pick_departure_app/data/product/product_model.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';

class ProductRowItem extends StatelessWidget {
  const ProductRowItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: AppTheme.buildLightTheme().colorScheme.background,
                padding: const EdgeInsets.only(
                    left: 48, right: 48, top: 16, bottom: 8),
                child: AspectRatio(
                  aspectRatio: 3,
                  child: BarcodeWidget(
                    barcode: Barcode.code93(),
                    data: product.barcode,
                    width: 200,
                    height: 80,
                  ),
                ),
              ),
              Container(
                color: AppTheme.buildLightTheme().colorScheme.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  product.description,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.packageVariant,
                                    color:
                                        AppTheme.buildLightTheme().primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    product.stock.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
