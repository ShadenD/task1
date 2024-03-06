// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:welcom/main.dart';
import 'package:welcom/view/CurrencyPage.dart';
import 'package:welcom/view/OrderPage.dart';
import 'package:welcom/view/login2.dart';
import 'package:welcom/view/signup1.dart';
import 'package:welcom/view/userPage.dart';

class SideBarController extends GetxController {
  RxInt index = 0.obs;
  RxString text = ''.obs;
  String nameppbar() {
    if (index.value == 0) {
      text.value = 'Users';
    } else if (index.value == 1) {
      text.value = 'Currencies';
    } else if (index.value == 2) {
      text.value = 'Orders';
    }
    return text.value;
  }

  Future<void> handleSignOut() => GoogleSignIn().disconnect();
  logout() {
    return IconButton(
        onPressed: () {
          sharedPreferences!.clear();
          handleSignOut();
          Get.to(() => Loginpage2());
        },
        icon: const Icon(Icons.logout));
  }

  add() {
    if (index.value == 0) {
      return IconButton(
          onPressed: () {
            Get.to(() => SignupPage());
          },
          icon: const Icon(Icons.add));
    }
  }

  RxList pages = [
    Archives(),
    Currency(),
    Orders(),
  ].obs;
}
