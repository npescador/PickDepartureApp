import 'package:flutter/material.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class OrderRowItem extends StatelessWidget {
  const OrderRowItem({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: Image.asset(
                  'assets/images/order.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: AppTheme2.buildLightTheme().colorScheme.background,
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
                              order.orderCode,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  order.status,
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
                                  Text(
                                    order.createAt,
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
