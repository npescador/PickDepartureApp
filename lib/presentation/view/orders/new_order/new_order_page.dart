import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key, required this.saveOrder});

  final Function() saveOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme2.buildLightTheme().primaryColor,
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
              saveOrder.call();
              context.pop();
            },
            child: Row(
              children: [
                Icon(Icons.save,
                    color: AppTheme2.buildLightTheme().secondaryHeaderColor),
                const SizedBox(
                  width: 2,
                ),
                const Text("Save"),
              ],
            ),
          ),
        ],
      ),
      body: const SafeArea(child: SizedBox()),
    );
  }
}
