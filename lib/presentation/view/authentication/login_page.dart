// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pick_departure_app/common/extensions/extensions.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';
import 'package:pick_departure_app/presentation/constants/validations_constants.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/authentication/viewmodel/user_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final UserViewModel _userViewModel = inject.get();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _focusNodePassword = FocusNode();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.person_pin,
                  size: 252, color: AppTheme2.buildLightTheme().primaryColor),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Email",
                  suffixIcon: Icon(
                    Icons.person_outline,
                    color: AppTheme2.buildLightTheme().primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  return value!.isEmpty
                      ? "Enter your email"
                      : ValidationsConstants.emailRegex.hasMatch(value)
                          ? null
                          : "Invalid Email Address";
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: isObscure,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure
                        ? Icon(
                            Icons.visibility_outlined,
                            color: AppTheme2.buildLightTheme().primaryColor,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                            color: AppTheme2.buildLightTheme().primaryColor,
                          ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton.extended(
                          heroTag: "fabLogin",
                          onPressed: () {
                            // Validación del usuario para continuar
                            if (_formKey.currentState!.validate()) {
                              _checkUserLogin();
                            }
                          },
                          label: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.login),
                          backgroundColor: AppTheme2.buildLightTheme()
                              .primaryColor, // Puedes ajustar el color según tus preferencias
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5.0,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      FloatingActionButton(
                        heroTag: "fabScan",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5.0,
                        backgroundColor:
                            AppTheme2.buildLightTheme().dialogBackgroundColor,
                        child: Icon(
                          MdiIcons.barcodeScan,
                          color: AppTheme2.buildLightTheme().primaryColor,
                        ),
                        onPressed: () {
                          _scanAndCheckLogin();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future<void> _scanAndCheckLogin() async {
    String userCode;
    try {
      userCode = await FlutterBarcodeScanner.scanBarcode(
          "#63d674", "Close", false, ScanMode.BARCODE);
    } on PlatformException {
      userCode = "Failed to get platform version.";
    }

    if (!mounted) return;

    UserModel? user;
    if (userCode.isNotEmpty && userCode != "-1") {
      user = await _userViewModel.fetchUserByBarcode(userCode);

      if (user != null) {
        _markUserLoggedIn();
        context.go(NavigationRoutes.ORDERS_ROUTE);
      } else {
        context.showSnackBar("User not found");
      }
    }
  }

  _checkUserLogin() async {
    UserModel? user = await _userViewModel.fetchUserByEmailPassword(
        _controllerUsername.text, _controllerPassword.text);

    if (user != null) {
      _markUserLoggedIn();
      context.go(NavigationRoutes.ORDERS_ROUTE);
    } else {
      context.showSnackBar("Email or password  is wrong");
    }
  }

  _markUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
  }
}
