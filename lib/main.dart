import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welcom/middleware/auth_middleware.dart';
import 'package:welcom/view/addCurrency.dart';
import 'package:welcom/view/addorder.dart';
import 'package:welcom/view/home.dart';
import 'package:welcom/view/login2.dart';
import 'package:welcom/view/sidebar.dart';
import 'package:welcom/view/signup1.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(
          name: "/", page: () => HomePage(), middlewares: [AuthMiddleware()]),
      GetPage(name: "/login", page: () => Loginpage2()),
      GetPage(name: "/signup", page: () => SignupPage()),
      GetPage(name: "/sidebar", page: () => SideBarPage()),
      GetPage(name: "/addcurr", page: () => AddCurr()),
      GetPage(name: "/orderAdd", page: () => Add()),
    ],
  ));
}
