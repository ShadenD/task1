// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/api/user_invoice.dart';
import 'package:welcom/controller/archivecontroller.dart';
import 'package:welcom/controller/ordercontroller.dart';
import 'package:welcom/model/pdfmodel.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/model/userPdf.dart';
import 'package:welcom/view/pdf_page.dart';
import 'package:welcom/view/signup1.dart';

class Archives extends GetView<ArchiveController> {
  Archives({super.key});
  SqlDB sqldb = SqlDB();
  TextEditingController teSeach = TextEditingController();
  ArchiveController archivecontroller = Get.put(ArchiveController());
  OrederController orederController = Get.put(OrederController());

  var scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => SignupPage());
          }),
      body: Row(children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onSubmitted: (value) async {
                    await controller.filter(teSeach.text);
                  },
                  onChanged: (value) {
                    //  FocusScope.of(context).unfocus();
                    archivecontroller.filter(teSeach.text);
                    if (value == '') {
                      archivecontroller.users.clear();
                      archivecontroller.readData();
                    }
                  },
                  controller: teSeach,
                  decoration: InputDecoration(
                      hintText: 'Search...',
                      labelText: 'Search',
                      prefixIcon: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            archivecontroller.filter(teSeach.text);
                          },
                          child: const Icon(Icons.search)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      )),
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                      itemCount: archivecontroller.users.length,
                      itemBuilder: (context, i) {
                        return SizedBox(
                          child: Card(
                            elevation: 9,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: ListTile(
                              leading: Image.file(
                                File('${archivecontroller.users[i]['photo']}'),
                              ),
                              title: Container(
                                  padding: const EdgeInsets.all(10),
                                  //margin: EdgeInsets.all(10),
                                  child: Text(
                                    '${archivecontroller.users[i]['username']}',
                                    style: const TextStyle(fontSize: 10),
                                  )),
                              subtitle: Column(children: [
                                Text(
                                  '${archivecontroller.users[i]['email']}',
                                )
                              ]),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await archivecontroller.deleteuser(
                                              archivecontroller.users[i]['id']);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          Get.to(SignupPage(), arguments: {
                                            "id": archivecontroller.users[i]
                                                ['id'],
                                            "username": archivecontroller
                                                .users[i]['username']
                                                .toString(),
                                            "email": archivecontroller.users[i]
                                                    ['email']
                                                .toString(),
                                            "pass": archivecontroller.users[i]
                                                    ['pass']
                                                .toString(),
                                            "photo": archivecontroller.users[i]
                                                    ['photo']
                                                .toString(),
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          List<Map> customerMap =
                                              await controller.getOne(
                                                  archivecontroller.users[i]
                                                      ['id']);
                                          Map customer = customerMap[0];
                                          final DateTime date = DateTime.now();
                                          final DateTime dueDate =
                                              date.add(const Duration(days: 7));
                                          Iterable orders = orederController
                                              .orders
                                              .where((o) =>
                                                  o['user_id'] ==
                                                  controller.users[i]['id']);
                                          final userInvoice = UserPdf(
                                            orders1: orders.toList(),
                                            supplier: Users(
                                              username: "Spinel Technology",
                                              email: " spinel@gmail.com",
                                              pass: '',
                                              bod: " ",
                                              photo: '',
                                            ),
                                            customer: Users(
                                              username: customer['username'],
                                              email: customer['email'],
                                              pass: '',
                                              photo: '',
                                              bod: customer['bod'],
                                            ),
                                            invoiceInfo: InvoiceInfo(
                                                description: 'Goods sold',
                                                number: 'INV-001',
                                                date: date,
                                                dueDate: dueDate,
                                                descriptionPdf: [
                                                  " 1- Universal Compatibility: PDF documents can be viewed, printed, and shared across \n various platforms and devices without the need for specific\n software or operating systems. This universal\n compatibility makes PDFs a popular choice for document sharing.\n\n",
                                                  " 2- Preservation of Formatting: PDF documents accurately preserve\n the layout, formatting, fonts, and graphics of the original document, regardless of the software\n used to create them."
                                                ]),
                                          );
                                          final File pdfFile =
                                              await UserInvoicePDF.generate(
                                                  userInvoice);
                                          Get.to(() => PdfOpen(), arguments: {
                                            "File": pdfFile.path,
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.picture_as_pdf_outlined,
                                          color: Colors.black,
                                        ))
                                  ]),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ]),
      //),
    );
  }
}
