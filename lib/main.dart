// ignore_for_file: unused_label, avoid_print, unused_element

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welcom/api/firebase_notification.dart';
import 'package:welcom/middleware/auth_middleware.dart';
import 'package:welcom/view/addCurrency.dart';
import 'package:welcom/view/addorder.dart';
import 'package:welcom/view/home.dart';
import 'package:welcom/view/login2.dart';
import 'package:welcom/view/sidebar.dart';
import 'package:welcom/view/signup1.dart';

SharedPreferences? sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();

  await Notifications1().initNotifications();

  locale:
  const Locale('ar', 'AR');

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
