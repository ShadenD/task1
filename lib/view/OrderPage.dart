// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/api/pdf_invoice_api.dart';
import 'package:welcom/controller/archivecontroller.dart';
import 'package:welcom/controller/autocomplete.dart';
import 'package:welcom/controller/itemController.dart';
import 'package:welcom/controller/ordercontroller.dart';
import 'package:welcom/model/currency.dart';
import 'package:welcom/model/order.dart';
import 'package:welcom/model/orderArguments.dart';
import 'package:welcom/model/pdfmodel.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/view/addorder.dart';
import 'package:welcom/view/pdf_page.dart';

// ignore: must_be_immutable
class Orders extends GetView<OrederController> {
  Orders({super.key});
  var scaffoldkey3 = GlobalKey<ScaffoldState>();
  OrederController controller6 = Get.put(OrederController());
  OrederController orederController = Get.put(OrederController());
  TextEditingController fitercontroller = TextEditingController();
  ArchiveController archiveController = Get.put(ArchiveController());
  itemController itemcontroller = Get.put(itemController());
  AutoComplete1 autoComplete1 = Get.put(AutoComplete1());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          onPressed: () {
            print(orederController.orders);
            Get.to(() => Add());
          }),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Form(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 1.0,
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: fitercontroller,
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          labelText: 'Search',
                          suffix: GetX<OrederController>(
                              builder: (OrederController controller) {
                            return TextButton(
                              child: controller.sorted.value
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      color: Color.fromARGB(255, 64, 99, 67),
                                      size: 30.0,
                                    )
                                  : const Icon(
                                      Icons.arrow_downward,
                                      color: Color.fromARGB(255, 64, 99, 67),
                                      size: 30.0,
                                    ),
                              onPressed: () {
                                controller.invertSorting();
                                controller.sorting();
                              },
                            );
                          }),
                          prefixIcon: TextButton(
                              onPressed: () async {
                                if (fitercontroller.text.toLowerCase() ==
                                    "paid") {
                                  orederController.getAllPaid();
                                } else {
                                  if (fitercontroller.text.toLowerCase() ==
                                      "not paid") {
                                    controller.getAllNotPaid();
                                  } else {
                                    orederController
                                        .filter(fitercontroller.text);
                                  }
                                }
                                if (fitercontroller.text == '') {
                                  controller.states!.clear();
                                  controller.orders.clear();
                                  controller.readDataOrder();
                                }
                              },
                              child: const Icon(Icons.search)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          )),
                      onChanged: (value) {
                        if (fitercontroller.text.toLowerCase() == "paid") {
                          orederController.getAllPaid();
                        } else {
                          if (fitercontroller.text.toLowerCase() ==
                              "not paid") {
                            controller.getAllNotPaid();
                          } else {
                            orederController.filter(fitercontroller.text);
                          }
                        }
                        if (value == '') {
                          orederController.states!.clear();
                          orederController.orders.clear();
                          orederController.readDataOrder();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GetX<OrederController>(
            builder: (OrederController orederController) => Expanded(
              child: ListView.builder(
                itemCount: orederController.orders.length,
                itemBuilder: (context, i) {
                  print(orederController.orders[i]['username']);
                  return Card(
                      child: Obx(
                    () => ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" ${orederController.orders[i]['username']}"),
                            Text(
                                " ${orederController.orders[i]['order_date']}"),
                            Obx(() => Text(i < orederController.orders.length
                                ? orederController.orders[i]['status'] == 1
                                    ? "Paid"
                                    : orederController.orders[i]['status'] == 0
                                        ? "Not Paid"
                                        : ""
                                : "Invalid Index")),
                            Text(" ${orederController.orders[i]['type']}"),
                            Text(" ${orederController.orders[i]['amount']}"),
                            Text(
                                " ${orederController.orders[i]['equalAmount']}"),
                            Text(
                                " ${orederController.orders[i]['currencyName']}"),
                            // ListView.builder(
                            //   itemCount: itemcontroller.cartItems.length,
                            //   itemBuilder: ((context, index) {
                            //     return ListTile(
                            //       leading: Image.file(
                            //         File(itemcontroller.cartItems[index]
                            //             ['image']),
                            //       ),
                            //       title: Text(
                            //         itemcontroller.cartItems[index]['itemName'],
                            //       ),
                            //       trailing: SizedBox(
                            //         width:
                            //             120, // Provide a fixed width for the SizedBox
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             IconButton(
                            //               onPressed: () {
                            //                 itemcontroller.incre(itemcontroller
                            //                     .cartItems[index]['price']);
                            //               },
                            //               icon: const Icon(Icons.add),
                            //             ),
                            //             Obx(() => Text(
                            //                 '${itemcontroller.counter2.value}')),
                            //             IconButton(
                            //               onPressed: () {
                            //                 itemcontroller.decrement(
                            //                     itemcontroller.cartItems[index]
                            //                         ['price']);
                            //               },
                            //               icon: const Icon(Icons.remove),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   }),
                            // ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await orederController.delete('orders',
                                    orederController.orders[i]['order_Id']);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () async {
                                final date = DateTime.now();
                                final dueDate =
                                    date.add(const Duration(days: 7));
                                final invoice = Invoice(
                                  order: Orderss(
                                    order_date: orederController.orders[i]
                                            ['order_date']
                                        .toString(),
                                    order_amount: orederController.orders[i]
                                        ['amount'],
                                    equal_order_amount: double.parse(
                                        orederController.orders[i]
                                                ['equalAmount']
                                            .toString()),
                                    curr_id: orederController.orders[i]
                                        ['curr_id'],
                                    status: orederController.orders[i]
                                                ['status'] ==
                                            1
                                        ? true
                                        : false,
                                    type: orederController.orders[i]['type']
                                        .toString(),
                                    user_id: orederController.orders[i]
                                        ['user_id'],
                                    item_id: orederController.orders[i]
                                        ['itemId'],
                                  ),
                                  Supplier: Users(
                                    username: "Spinel Technology",
                                    email: " spinel@gmail.com",
                                    pass: '',
                                    bod: " ",
                                    photo: '',
                                  ),
                                  Customer: Users(
                                    username: controller.orders[i]['username'],
                                    email: controller.orders[i]['email'],
                                    pass: '',
                                    photo: '',
                                    bod: controller.orders[i]['bod'],
                                  ),
                                  info: InvoiceInfo(
                                      description: 'Goods sold',
                                      number: 'INV-001',
                                      date: date,
                                      dueDate: dueDate,
                                      descriptionPdf: [
                                        " 1- Universal Compatibility: PDF documents can be viewed, printed, and shared across \n various platforms and devices without the need for specific\n software or operating systems. This universal\n compatibility makes PDFs a popular choice for document sharing.",
                                        " 2- Preservation of Formatting: PDF documents accurately preserve\n the layout, formatting, fonts, and graphics of the original document, regardless of the software\n used to create them."
                                      ]),
                                );
                                final File pdfFile =
                                    await PdfInvoiceApi.generate(invoice);
                                Get.to(() => PdfOpen(), arguments: {
                                  "File": pdfFile.path,
                                });
                              },
                              icon: const Icon(Icons.picture_as_pdf_outlined),
                            ),
                            IconButton(
                              color: const Color.fromARGB(255, 64, 99, 67),
                              onPressed: () {
                                Get.to(() => Add(),
                                    arguments: OrderArgument(
                                        id: controller.orders[i]['order_Id'],
                                        currency: Currency1(
                                          currencyName: controller.orders[i]
                                              ['currencyName'],
                                          currencySymbol: '',
                                          rate: controller.orders[i]['rate'] ??
                                              0.0,
                                        ),
                                        order: Orderss(
                                          order_date: orederController.orders[i]
                                                  ['order_date']
                                              .toString(),
                                          order_amount: orederController
                                              .orders[i]['amount'],
                                          equal_order_amount: double.parse(
                                              orederController.orders[i]
                                                      ['equalAmount']
                                                  .toString()),
                                          curr_id: orederController.orders[i]
                                              ['curr_id'],
                                          status: orederController.orders[i]
                                                      ['status'] ==
                                                  1
                                              ? true
                                              : false,
                                          type: orederController.orders[i]
                                                  ['type']
                                              .toString(),
                                          user_id: orederController.orders[i]
                                              ['user_id'],
                                          item_id: orederController.orders[i]
                                              ['itemId'],
                                        )));
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 30.0,
                              ),
                            ),
                            Obx(
                              () => Switch(
                                value: orederController.orders[i]['status'] == 1
                                    ? true
                                    : false,
                                onChanged: (bool value) async {
                                  await orederController.updateOrderState(
                                      value ? 1 : 0,
                                      orederController.orders[i]['order_Id']);
                                },
                              ),
                            ),
                          ],
                        )),
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
