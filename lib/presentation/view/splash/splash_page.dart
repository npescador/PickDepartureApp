import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _getLoginStatus().then((isLoggedIn) {
      setState(() {
        this.isLoggedIn = isLoggedIn;
      });
    });

    _navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          repeat: true,
          animate: true,
          height: 400,
          width: 400,
        ),
      ),
    );
  }

  _navigateToNextPage() async {
    await Future.delayed(
        const Duration(seconds: 4), navigateToHomePageOrLoginPage);
  }

  Future<bool> _getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> navigateToHomePageOrLoginPage() async {
    if (isLoggedIn) {
      context.go(NavigationRoutes.ORDERS_ROUTE);
    } else {
      context.go(NavigationRoutes.LOGIN_ROUTE);
    }
  }
}
