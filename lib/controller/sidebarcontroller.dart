// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/view/CurrencyPage.dart';
import 'package:welcom/view/OrderPage.dart';
import 'package:welcom/view/adduser.dart';
import 'package:welcom/view/login2.dart';
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

  logout() {
    return IconButton(
        onPressed: () {
          Get.to(() => Loginpage2());
        },
        icon: const Icon(Icons.logout));
  }

  add() {
    if (index.value == 0) {
      return IconButton(
          onPressed: () {
            Get.to(() => AddUser());
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
