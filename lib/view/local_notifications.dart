// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/notificationController.dart';

class LocalNotification extends StatelessWidget {
  LocalNotification({Key? key}) : super(key: key);

  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notificationController.v.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(notificationController.titleo.value),
                      subtitle: Text(notificationController.bodyo.value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
