import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppTheme2.buildLightTheme().primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              MdiIcons.shopping,
              color: AppTheme2.buildLightTheme().primaryColor,
            ),
            icon: Icon(MdiIcons.shoppingOutline),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            activeIcon: Icon(Icons.inventory),
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}
