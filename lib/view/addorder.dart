// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:welcom/controller/archivecontroller.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/controller/dropdowncontroller.dart';
import 'package:welcom/controller/ordercontroller.dart';
import 'package:welcom/view/sidebar.dart';

class Add extends GetView<OrederController> {
  Add({super.key});
  TextEditingController datecontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController equalamountcontroller = TextEditingController();
  DropDownListController dropDownListController =
      Get.put(DropDownListController());
  CurrencyController currencyController = Get.put(CurrencyController());
  OrederController ordercontroller = Get.put(OrederController());
  ArchiveController usercontroller = Get.put(ArchiveController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0.0,
          title: const Text('Add order'),
        ),
        body: ListView(children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    controller: datecontroller,
                    decoration: const InputDecoration(
                      label: Text('Select Date'),
                      icon: Icon(Icons.calendar_today_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill the input';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String date = DateFormat.yMMM().format(pickedDate);
                        datecontroller.text = date;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => Container(
                    width: 350,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint: const Text('Select Currency'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return dropDownListController.validateCurrency(value);
                      },
                      value: dropDownListController.selectedCurrency.value == 0
                          ? null
                          : dropDownListController.selectedCurrency.value,
                      onChanged: (value) {
                        dropDownListController.updateCurrency(value);
                        if (amountcontroller.text != '') {
                          double amount = double.parse(amountcontroller.text);
                          double equalAmount = ordercontroller.equalAmmount(
                              amount, ordercontroller.rate.value);
                          equalamountcontroller.text = equalAmount.toString();
                        }
                      },
                      items: currencyController.currency
                          .map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                            onTap: () {
                              ordercontroller
                                  .upadateCurrencyId(value['currency_id']);
                              ordercontroller.updateRate(value['rate']);
                            },
                            value: value['currency_id'],
                            child: Text(value['curreny_name'].toString()));
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextFormField(
                            controller: amountcontroller,
                            onChanged: (value) {
                              if (amountcontroller.text != '') {
                                double amount =
                                    double.parse(amountcontroller.text);
                                double equalAmount =
                                    ordercontroller.equalAmmount(
                                        amount, ordercontroller.rate.value);
                                equalamountcontroller.text =
                                    equalAmount.toString();
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: equalamountcontroller,
                            decoration: const InputDecoration(
                              labelText: 'Equel Amount',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => Container(
                      width: 350,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField(
                        padding: const EdgeInsets.all(10),
                        isDense: true,
                        isExpanded: true,
                        hint: const Text('Select User'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return dropDownListController
                              .validateUser(value.toString());
                        },
                        onChanged: (value) {
                          dropDownListController.updateUser(value);
                        },
                        items:
                            usercontroller.users.map<DropdownMenuItem>((value) {
                          return DropdownMenuItem(
                              onTap: () {
                                ordercontroller.upadateUserId(value['id']);
                              },
                              value: value['id'],
                              child: Text(value['username'].toString()));
                        }).toList(),
                        value: dropDownListController.selectedUser.value == 0
                            ? null
                            : dropDownListController.selectedUser.value,
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => Container(
                    width: 350,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint: const Text('Select Type'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return dropDownListController
                            .validateType(value.toString());
                      },
                      onChanged: (value) {
                        dropDownListController.updateType(value.toString());
                      },
                      items: dropDownListController.items
                          .map<DropdownMenuItem>((String value) {
                        return DropdownMenuItem(
                            onTap: () {
                              ordercontroller.updateType(value);
                            },
                            value: value,
                            child: Text(value));
                      }).toList(),
                      value: dropDownListController.selectedType.value == ""
                          ? null
                          : dropDownListController.selectedType.value,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() => Container(
                      alignment: Alignment.topCenter,
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: ordercontroller.isChecked.value,
                              onChanged: (bool? value) {
                                ordercontroller.toggleCheck(value);
                              },
                            ),
                            const Text('Paid'),
                          ]),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> order1 = {
                        "order_date": datecontroller.text,
                        "order_amount": amountcontroller.text,
                        "equal_order_amount": equalamountcontroller.text,
                        "curr_id": ordercontroller.currencyId.value,
                        "status": ordercontroller.isChecked.value ? 1 : 0,
                        "type": ordercontroller.item.value,
                        "user_id": ordercontroller.userId.value,
                      };
                      await ordercontroller.insert('orders', order1);
                      // await ordercontroller.insertorder(order);
                      controller.orders.clear();
                      controller.readDataOrder();
                      Get.off(() => SideBarPage());
                    }
                  },
                  child: const Text('ADD ORDER'),
                ),
              ],
            ),
          ),
        ]));
  }
}
