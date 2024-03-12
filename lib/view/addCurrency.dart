// ignore_for_file: must_be_immutable, avoid_print, file_names, unnecessary_string_interpolations, unused_element
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/api/firebase_notification.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/model/currency.dart';

class AddCurr extends GetView<CurrencyController> {
  AddCurr({super.key});
  TextEditingController controllerCurrName = TextEditingController();
  TextEditingController controllerCurrSymbol = TextEditingController();
  TextEditingController controllerRate = TextEditingController();
  CurrencyController controllerCurr = Get.put(CurrencyController());
  NotificationController notificationController =
      Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      controllerCurrName.text = Get.arguments['currencyName'];
      controllerCurrSymbol.text = Get.arguments['currencySymbol'];
      controllerRate.text = Get.arguments['rate'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Get.arguments == null
            ? const Text(
                'New Currency',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            : const Text(
                'Edit Currency',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: controllerCurrName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Currency Name',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controllerCurrSymbol,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Currency Symbol',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controllerRate,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Currency Rate',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () async {
                Currency currency1 = Currency(
                    currencyName: controllerCurrName.text,
                    currencySymbol: controllerCurrSymbol.text,
                    rate: double.parse(controllerRate.text));
                print(Get.arguments);
                if (Get.arguments == null) {
                  await controller.insert('currency', currency1);
                  await Notifications1()
                      .sendMessage('hi', 'you add currency', 'aa');
                  await Notifications1().initNotifications();
                  notificationController.increase();
                } else {
                  final int? currencyId =
                      int.parse(Get.arguments!['currencyId']);
                  await controller.updateCurrency(
                      'currency', currency1, currencyId!);
                  await Notifications1()
                      .sendMessage('hi', 'you update currency', 'aa');
                  await Notifications1().initNotifications();
                  notificationController.increase();
                }
                Get.back();
              },
              color: Colors.greenAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Get.arguments == null
                  ? const Text('ADD CURRENCY',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18))
                  : const Text('SAVE CHANGES',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            ),
          ),
        ]),
      ),
    );
  }
}
