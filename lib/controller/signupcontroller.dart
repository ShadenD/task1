// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:welcom/model/sqlitedb2.dart';

class SignupPageController extends GetxController {
  SqlDB sqldb = SqlDB();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();

  RxBool passToggle = true.obs;
  bool succ = true;
  bool fail = false;

  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  void pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value =
          ((File(selectedImagePath.value).lengthSync() / 1024 / 1024))
                  .toStringAsFixed(2) +
              "MB";
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<List<Map>> readData() async {
    List<Map> response = await sqldb.readData("SELECT * FROM users");
    return response;
  }

  // inseretuser(Map insertuser) async {
  //   await sqldb.insertData(
  //       "INSERT INTO 'users' ('username','email','pass','bod','photo') VALUES('${insertuser['username']}','${insertuser['email']}','${insertuser['pass']}','20-1-2000','${insertuser['photo']}')");
  
  //     users  
  // }

  @override
  void onInit() {
    super.onInit();
    readData();
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
}
