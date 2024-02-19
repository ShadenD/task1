// ignore_for_file: must_be_immutable, annotate_overrides
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/logincontroller.dart';
import 'package:welcom/controller/remember_me_controller.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/view/home.dart';
import 'package:welcom/view/sidebar.dart';
import 'package:welcom/view/signup1.dart';

class Loginpage2 extends GetView<LoginPageController> {
  Loginpage2({super.key});
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  bool isEmailCorrect = false;
  bool passToggle = true;
  LoginPageController controller2 = Get.put(LoginPageController());
  RememberMeController controllerr = Get.put(RememberMeController());

  SqlDB sqldb = SqlDB();
  bool rem = false;

  GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isEmailCorrect == false ? Colors.white : Colors.green,
        leading: IconButton(
          onPressed: () {
            Get.to(HomePage());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: formstate,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                              height: 5,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: GetBuilder<LoginPageController>(
                                  builder: (cont) => TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                    ),
                                    controller:
                                        controller2.textEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                  height: 5,
                                ),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: GetX<LoginPageController>(
                                      builder: (controller2) => TextFormField(
                                        obscureText:
                                            controller2.passToggle.value,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          suffix: InkWell(
                                            onTap: () {
                                              controller2.passToggle.value =
                                                  !controller2.passToggle.value;
                                            },
                                            child: Icon(
                                              passToggle
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        controller:
                                            controller2.passEditingController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter your passward";
                                          } else if (controller2
                                                  .passEditingController
                                                  .text
                                                  .length <
                                              6) {
                                            return "Passward length should be more than 6 characters ";
                                          }
                                          return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: 30,
                          child: Obx(
                            () => Checkbox(
                              value: controllerr.rememberMe.value,
                              onChanged: (value) async {
                                controllerr.toggleRememberMe(value!);
                                if (value) {
                                  sharedPreferences!.setString(
                                      'email', textEditingController.text);
                                  sharedPreferences!.setString(
                                      'pass', passEditingController.text);
                                }
                              },
                            ),
                          ),
                        ),
                        const Text(
                          'Remember Me',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                              if (formstate.currentState!.validate()) {
                                // ignore: unused_local_variable
                                List<Map> response2 = await sqldb.readData(
                                    "SELECT * FROM users WHERE email='${controller2.textEditingController.text}'");
                                // ignore: avoid_print
                                print(response2);
                                // ignore: unrelated_type_equality_checks, use_build_context_synchronously
                                if (response2.isEmpty) {
                                  // ignore: avoid_print
                                  print(
                                      'User with the provided email does not exist!');
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Get.to(() => SideBarPage());
                                }
                              }
                            },
                            color: Colors.greenAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          InkWell(
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            onTap: () {
                              Get.to(SignupPage());
                            },
                          ),
                        ],
                      ))
                ],
              ),
            ),
            FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(60)),
                      image: DecorationImage(
                          image: AssetImage('assets/images/aa.jpg'),
                          fit: BoxFit.cover)),
                ))
          ],
        ),
      ),
    );
  }
}
