import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // ignore: unrelated_type_equality_checks
    if (sharedPreferences!.getString('email') != null) {
      return const RouteSettings(name: "/sidebar");
    } else  {
      return const RouteSettings(name: "/login");
    }
  }
}
