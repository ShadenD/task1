// ignore_for_file: file_names, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/view/addCurrency.dart';

// ignore: must_be_immutable
class Currency extends GetView<CurrencyController> {
  Currency({super.key});
  var scaffoldKey2 = GlobalKey<ScaffoldState>();
  TextEditingController teSeach1 = TextEditingController();
  CurrencyController controllerCurrency = Get.put(CurrencyController());
  NotificationController notificationController =
      Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => AddCurr());
            // notificationController.decrease();
          }),
      body: Row(children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onSubmitted: (value) async {
                    await controller.filter(teSeach1.text);
                  },
                  onChanged: (value) async {
                    //FocusScope.of(context).unfocus();
                    await controllerCurrency.filter(teSeach1.text);
                    if (value == '') {
                      controllerCurrency.currency.clear();
                      controllerCurrency.readData2();
                    }
                  },
                  controller: teSeach1,
                  decoration: InputDecoration(
                      hintText: 'Search...',
                      labelText: 'Search',
                      prefixIcon: TextButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            await controllerCurrency.filter(teSeach1.text);
                          },
                          child: const Icon(Icons.search)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      )),
                ),
              ),
              GetX<CurrencyController>(
                  builder: (CurrencyController controller) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.currency.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Card(
                            elevation: 9,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: ListTile(
                              dense: false,
                              leading: Text(
                                  '${controller.currency[i]['currencySymbol']}'),
                              title: Column(children: [
                                Text(
                                  "${controller.currency[i]['rate']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ]),
                              subtitle: Text(
                                "${controller.currency[i]['currencyName']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await controllerCurrency.delete(
                                              controllerCurrency.currency[i]
                                                  ['currencyId']);
                                          print("delete currency");
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          Get.to(AddCurr(), arguments: {
                                            "currencyId": controller.currency[i]
                                                    ['currencyId']
                                                .toString(),
                                            'currencyName': controller
                                                .currency[i]['currencyName']!
                                                .toString(),
                                            'currencySymbol': controller
                                                .currency[i]['currencySymbol']!
                                                .toString(),
                                            'rate': controller.currency[i]
                                                    ['rate']!
                                                .toString()
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                        )),
                                  ]),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ]),
    );
  }
}
