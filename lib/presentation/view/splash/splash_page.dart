import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/authentication/login_page.dart';
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

    // Retrieve the user's login status from SharedPreferences
    Future<bool> getLoginStatus() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool("isLoggedIn") ?? false;
    }

    getLoginStatus().then((isLoggedIn) {
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
    // await Future.delayed(const Duration(seconds: 3));

    // //Utilizamos la variable mounted para saber si la pantalla aún está activa o ya no esta.
    // if (mounted) {
    //     context.go(NavigationRoutes.HOME_ROUTE);
    // }
  }

  Future<void> navigateToHomePageOrLoginPage() async {
    // If the user is logged in, navigate to the home page
    if (isLoggedIn) {
      context.go(NavigationRoutes.INITIAL_ROUTE);
    } else {
      // If the user is not logged in, navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
