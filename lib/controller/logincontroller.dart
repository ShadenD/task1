import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/sqlitedb2.dart';

class LoginPageController extends GetxController {
  SqlDB sqldb = SqlDB();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  RxBool passToggle = true.obs;

  Future<List<Map>> readData() async {
    List<Map> response = await sqldb.readData(
        "SELECT email,pass FROM users where email= '{$textEditingController}'");
    return response;
  }

  @override
  void onInit() {
    super.onInit();
    readData();
    //remember();
  }
save(){ 
   textEditingController.text =
        sharedPreferences!.getString('email').toString();
    passEditingController.text =
        sharedPreferences!.getString('pass').toString();

}
  @override
  void onReady() {
    // called after the widget is rendered on screen
    super.onReady();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    textEditingController.dispose();
    super.onClose();
  }

  // remember() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   textEditingController.text =
  //       sharedPreferences.getString('email').toString();
  //   passEditingController.text = sharedPreferences.getString('pass').toString();
  // }
}
