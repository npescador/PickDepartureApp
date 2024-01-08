import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

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
    await Future.delayed(const Duration(seconds: 3));

    //Utilizamos la variable mounted para saber si la pantalla aún está activa o ya no esta.
    if (mounted) {
      context.go(NavigationRoutes.ORDERS_ROUTE);
    }
  }
}
