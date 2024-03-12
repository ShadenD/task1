// ignore_for_file: must_be_immutable, unnecessary_string_interpolations

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/controller/sidebarcontroller.dart';
import 'package:welcom/view/local_notifications.dart';

SideBarController sideBarController = Get.put(SideBarController());

class SideBarPage extends GetView<SideBarController> {
  SideBarPage({super.key});
  SideBarController sideBarController = Get.put(SideBarController());
  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appName(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(
            () => badges.Badge(
              position: badges.BadgePosition.custom(),
              badgeContent: Text("${notificationController.count}"),
              child: IconButton(
                onPressed: () {
                  Get.to(() => LocalNotification());
                  notificationController.zero();
                },
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   width: 10,
          // ),
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
              ),
            ],
          ),
        ),
      ),
      body: Row(children: [
        Expanded(
            flex: 8,
            child: Obx(() {
              var n = sideBarController.pages[sideBarController.index.value];
              return n;
            })),
      ]),
    );
  }
}

appName() {
  return Builder(builder: (context) {
    return Obx(() => Text('${sideBarController.nameppbar()}'));
  });
}
