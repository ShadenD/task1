// ignore_for_file: must_be_immutable, avoid_print
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:welcom/api/firebase_notification.dart';
import 'package:welcom/controller/archivecontroller.dart';
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/controller/signupcontroller.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/view/login2.dart';

class SignupPage extends GetView<SignupPageController> {
  SignupPage({super.key});
  SignupPageController controller3 = Get.put(SignupPageController());
  ArchiveController controller2 = Get.put(ArchiveController());
  NotificationController notificationController =
      Get.put(NotificationController());
  SqlDB sqldb = SqlDB();
  String? vall;
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      Users users = Get.arguments;
      controller3.textEditingController.text = users.email;
      controller3.userEditingController.text = users.username;
      controller3.passEditingController.text = users.pass;
      controller3.selectedImagePath.value = users.photo;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: sharedPreferences!.getString('email') != null
            ? Get.arguments == null
                ? const Text("SignUp")
                : const Text("UPDATE")
            : const Text("SignUp"),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 30,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        "Create an account, It's free",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Form(
                key: controller3.formstate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Obx(
                          () => SizedBox(
                              height: 100,
                              width: 100,
                              child: controller3.selectedImagePath.value == ''
                                  ? const Text(
                                      "select image from camera/gallery")
                                  : ClipOval(
                                      child: Image.file(File(
                                          controller3.selectedImagePath.value)),
                                    )),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Obx(() => Text(
                              controller3.selectedImageSize.value == ''
                                  ? ''
                                  : controller3.selectedImageSize.value,
                              style: const TextStyle(fontSize: 20),
                            )),
                        IconButton(
                            onPressed: () {
                              controller3.pickImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera_alt_outlined)),
                        IconButton(
                            onPressed: () {
                              controller3.pickImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo_album_outlined)),
                      ],
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ]),
                    const SizedBox(
                      height: 2,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: GetBuilder<SignupPageController>(
                          builder: (c) => TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                            ),
                            controller: controller3.textEditingController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              vall = value!;
                              if (value.isEmpty) {
                                return "الحقل فارغ";
                              } else if (RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value)) {
                              } else {
                                return "Enter valid Email";
                              }
                              return null;
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "User Name",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ]),
                    const SizedBox(
                      height: 2,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                          ),
                          controller: controller3.userEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            vall = value!;
                            if (value.isEmpty) {
                              return "الحقل فارغ";
                            }
                            return null;
                          },
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "passward",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ]),
                    const SizedBox(
                      height: 2,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Obx(
                          () => TextFormField(
                            obscureText: controller3.passToggle.value,
                            decoration: InputDecoration(
                              suffix: InkWell(
                                onTap: () {
                                  controller3.passToggle.value =
                                      !controller3.passToggle.value;
                                },
                                child: Icon(
                                  controller3.passToggle.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                            ),
                            controller: controller3.passEditingController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your passward";
                              } else if (controller3
                                      .passEditingController.text.length <
                                  6) {
                                return "Passward length should be more than 6 characters ";
                              }
                              return null;
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 2,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Confirm passward",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Obx(
                          () => TextFormField(
                            obscureText: controller3.passToggle.value,
                            decoration: InputDecoration(
                              suffix: InkWell(
                                onTap: () {
                                  controller3.passToggle.value =
                                      !controller3.passToggle.value;
                                },
                                child: Icon(
                                  controller3.passToggle.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                            ),
                            controller: controller3.confirmpassword,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please re-enter password';
                              }

                              if (controller3.passEditingController.text !=
                                  controller3.confirmpassword.text) {
                                return "Password does not match";
                              }

                              return null;
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 2,
                    ),
                    GetBuilder<SignupPageController>(
                      builder: (c) => FlutterPwValidator(
                        defaultColor: Colors.black,
                        controller: controller3.passEditingController,
                        successColor: Colors.green.shade700,
                        minLength: 8,
                        uppercaseCharCount: 1,
                        numericCharCount: 2,
                        specialCharCount: 1,
                        normalCharCount: 4,
                        width: 350,
                        height: 150,
                        onSuccess: () {
                          controller3.succ;
                        },
                        onFail: () {
                          controller3.fail;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
              FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        Users myObject = Users(
                            username: controller3.userEditingController.text,
                            email: controller3.textEditingController.text,
                            pass: controller3.passEditingController.text,
                            bod: '20-2-2000',
                            photo: controller3.selectedImagePath.value);
                        if (controller3.formstate.currentState!.validate()) {
                          if (Get.arguments == null) {
                            await controller2.inseretuser('users', myObject);
                            await Notifications1()
                                .sendMessage('hi', 'you add user', 'aa');
                            await Notifications1().initNotifications();
                            notificationController.increase();
                          } else {
                            await controller2.updateUser(
                                'users', myObject, Get.arguments['id']);
                            await Notifications1()
                                .sendMessage('hi', 'you update user', 'aa');
                            await Notifications1().initNotifications();
                            notificationController.increase();
                          }
                          print("Data filled successfully");
                          controller3.textEditingController.clear();
                          controller3.textEditingController.clear();
                          controller3.passEditingController.clear();
                          controller3.confirmpassword.clear();
                        }
                        print(controller2.users);
                        Get.back();
                        // controller2.users.clear();
                        // controller2.readData();
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeInUp(
                  duration: const Duration(milliseconds: 1600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      InkWell(
                        onTap: () {
                          Get.to(Loginpage2());
                        },
                        child: const Text(
                          " Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
