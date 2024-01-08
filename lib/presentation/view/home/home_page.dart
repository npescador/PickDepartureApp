import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.white,
        backgroundColor: AppTheme2.buildLightTheme().secondaryHeaderColor,
        indicatorColor: AppTheme2.buildLightTheme().indicatorColor,
        indicatorShape: const CircleBorder(),
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (value) {
          widget.navigationShell.goBranch(value,
              initialLocation: value == widget.navigationShell.currentIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: "Orders",
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory),
            label: "Products",
          ),
        ],
      ),
    );
  }
}
