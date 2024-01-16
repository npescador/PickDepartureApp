import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class OrderDetailRowItem extends StatelessWidget {
  const OrderDetailRowItem({super.key, required this.orderDetail});

  final OrderDetail orderDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppTheme2.buildLightTheme().colorScheme.background,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                orderDetail.description,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.packageVariant,
                    color: AppTheme2.buildLightTheme().primaryColor,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Amount: ${orderDetail.amount.toString()}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.packageVariant,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Pending amount: ${orderDetail.pendingAmount.toString()}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
