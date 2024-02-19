// ignore_for_file: must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/sidebarcontroller.dart';

SideBarController sideBarController = Get.put(SideBarController());

class SideBarPage extends GetView<SideBarController> {
  SideBarPage({super.key});
  SideBarController sideBarController = Get.put(SideBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appName(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          sideBarController.logout(),
        ],
      ),
      drawer: Drawer(
        child: Obx(
          () => ListView(
            children: [
              const DrawerHeader(
                  padding: EdgeInsets.all(70), child: Text("My App")),
              ListTile(
                title: const Text(" Users"),
                leading: const Icon(Icons.supervised_user_circle),
                onTap: () {
                  sideBarController.index.value = 0;
                  Get.back();
                },
                selected: sideBarController.index.value == 0,
              ),
              ListTile(
                title: const Text(" Currencies"),
                leading: const Icon(Icons.currency_exchange),
                onTap: () {
                  sideBarController.index.value = 1;
                  Get.back();
                },
                selected: sideBarController.index.value == 1,
              ),
              ListTile(
                title: const Text(" Orders"),
                leading: const Icon(Icons.online_prediction_sharp),
                onTap: () {
                  sideBarController.index.value = 2;
                  Get.back();
                },
                selected: sideBarController.index.value == 2,
              )
            ],
          ),
        ),
      ),
      body: Row(children: [
        Expanded(
            flex: 8,
            child: Obx(
                () => sideBarController.pages[sideBarController.index.value])),
      ]),
    );
  }
}

appName() {
  return Obx(() => Text('${sideBarController.nameppbar()}'));
}
