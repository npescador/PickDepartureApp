import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pick_departure_app/data/order/order_model.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class OrderRowItem extends StatelessWidget {
  const OrderRowItem({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    Color orderStatusColor = Colors.blueAccent;
    switch (order.status) {
      case "Created":
        orderStatusColor = Colors.blueAccent;
        break;
      case "In preparation process":
        orderStatusColor = Colors.amber;
        break;
      case "Completed":
        orderStatusColor = AppTheme2.buildLightTheme().primaryColor;
        break;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: orderStatusColor, // Color del borde
                width: 2.0, // Ancho del trazo
              ),
              borderRadius:
                  BorderRadius.circular(16.0), // Radio de la esquina del card
            ),
            color: AppTheme2.buildLightTheme().colorScheme.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                              maxWidth: 100,
                              maxHeight:
                                  100), // Ajusta estos valores según tus necesidades
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              'assets/images/order.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Column(
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
                                    color: orderStatusColor,
                                  ),
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
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(order.createAt.toDate())
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
