// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/view/sidebar.dart';

class LoginPageController extends GetxController {
  SqlDB sqldb = SqlDB();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  RxBool passToggle = true.obs;
  RxString alert = ''.obs;

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential != null) {
      Users users = Users(
          username: userCredential.user!.displayName.toString(),
          email: userCredential.user!.email.toString(),
          pass: '',
          bod: '',
          photo: '');
      List<Map> reg = await login(userCredential.user!.email.toString());
      if (reg.isEmpty) {
        print('User with the provided email does not exist!');
        Map<String, dynamic> userMap = users.toMap();
        await sqldb.insert('users', userMap);
        Get.to(() => SideBarPage());
        // Get.to(() => Archives());
      } else {
        alert.value = "This email was registered";
        print("Error");
        handleSignOut();
      }
    }
  }

  Future<void> handleSignOut() => GoogleSignIn().disconnect();

  login(String email) async {
    List<Map> response2 =
        await sqldb.readData("SELECT * FROM users WHERE email='$email'");
    return response2;
  }

  Future<List<Map>> readData() async {
    List<Map> response = await sqldb.readData(
        "SELECT email,pass FROM users where email= '{$textEditingController}'");
    return response;
  }

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
