import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppTheme.buildLightTheme().primaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.inventory),
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.shopping_bag,
            ),
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.people),
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
