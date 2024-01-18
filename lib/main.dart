import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/firebase_options.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppModules().setup();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.buildLightTheme(),
    );
  }
}
