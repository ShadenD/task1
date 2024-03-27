// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, unused_element, unused_local_variable, unrelated_type_equality_checks, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:welcom/api/firebase_notification.dart';
import 'package:welcom/controller/archivecontroller.dart';
import 'package:welcom/controller/autocomplete.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/controller/dropdowncontroller.dart';
import 'package:welcom/controller/itemController.dart';
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/controller/ordercontroller.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/order.dart';
import 'package:welcom/model/orderArguments.dart';

class Add extends GetView<OrederController> {
  Add({super.key});
  TextEditingController datecontroller = TextEditingController();
  TextEditingController controllers = TextEditingController();

  TextEditingController amountcontroller = TextEditingController();
  TextEditingController equalamountcontroller = TextEditingController();
  DropDownListController dropDownListController =
      Get.put(DropDownListController());
  CurrencyController currencyController = Get.put(CurrencyController());
  OrederController ordercontroller = Get.put(OrederController());
  ArchiveController usercontroller = Get.put(ArchiveController());
  NotificationController notificationController =
      Get.put(NotificationController());
  itemController itemcontroller = Get.put(itemController());
  AutoComplete1 autoComplete1 = Get.put(AutoComplete1());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int id_item = 0;
    List<String> types = [
      "Sell Order",
      "Purshased Order",
      "Return Sell Order",
      "Return Purshased Order"
    ];
    // getUser() async {
    //   OrderArgument orderArgument = Get.arguments;
    //   var user1 = await ordercontroller.getUsers(orderArgument.order.user_id);
    //   // print(user1);
    //   ordercontroller.upadateUserId(
    //       user1[0]['user_id']); // Assuming this is the correct method name
    // }

    // getCurrency() async {
    //   OrderArgument orderArgument = Get.arguments;
    //   var currency1 =
    //       await ordercontroller.getCurrency(orderArgument.order.curr_id);
    //   ordercontroller.upadateCurrencyId(
    //       currency1[0]['curr_id']); // Assuming this is the correct method name
    //   ordercontroller.updateRate(
    //       currency1[0]['rate']); // Assuming this is the correct method name
    // }

    if (Get.arguments != null) {
      OrderArgument orderArgument = Get.arguments;
      ordercontroller.updateRate(orderArgument.currency.rate);
      controller.upadateCurrencyId(orderArgument.order.curr_id);
      controller.upadateUserId(orderArgument.order.user_id);
      datecontroller.text = orderArgument.order.order_date;
      amountcontroller.text = orderArgument.order.order_amount.toString();
      equalamountcontroller.text =
          orderArgument.order.equal_order_amount.toString();
      dropDownListController.selectedCurrency.value =
          orderArgument.order.curr_id;
      dropDownListController.selectedUser.value = orderArgument.order.user_id;
      dropDownListController.selectedType.value = orderArgument.order.type;
      controller.isChecked.value =
          orderArgument.order.status == 1 ? true : false;
    }
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
                                  .upadateCurrencyId(value['currencyId']);
                              ordercontroller.updateRate(value['rate']);
                            },
                            value: value['currencyId'],
                            child: Text(value['currencyName'].toString()));
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
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      } else {
                        autoComplete1.textcontroller.text =
                            textEditingValue.text.toString();
                        return autoComplete1.cartItems.where((element) {
                          return element
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      }
                    },
                    onSelected: (String selectedString2) async {
                      print(selectedString2);
                      autoComplete1.addItem(selectedString2);
                      autoComplete1.read(selectedString2);
                      await itemcontroller
                          .getAnyByIdItem(autoComplete1.products.value);
                      id_item = autoComplete1.products.value;
                      print('ooooooooooo:   $id_item');

                      // ordercontroller.updateItemId(selectedString2);
                      // id_item = int.parse('${autoComplete1.products}');
                      // print(id_item);
                      print(
                          'aaaaaaaa: ${sharedPreferences!.getStringList('items')}');
                      print('select string:  ${autoComplete1.selectedString}');
                      print('select:   ${autoComplete1.selectedString.value}');
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                      controllers = controller;
                      return Container(
                        width: 350,
                        height: 80,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: const InputDecoration(
                            hintText: "Search items",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      title: Obx(() {
                        final selectedString = autoComplete1
                            .selectedString; // Assuming selectedString is observable
                        return Text("selected items   $selectedString");
                      }),
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    alignment: Alignment.topCenter,
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: ordercontroller.isChecked.value,
                          onChanged: (bool? value) {
                            ordercontroller.toggleCheck(value);
                          },
                        ),
                        const Text('Paid'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Orderss orders = Orderss(
                        order_date: datecontroller.text,
                        order_amount: int.parse(amountcontroller.text),
                        equal_order_amount:
                            double.parse(equalamountcontroller.text),
                        curr_id: ordercontroller.currencyId.value,
                        status:
                            ordercontroller.isChecked.value == 1 ? true : false,
                        type: ordercontroller.item.value,
                        user_id: ordercontroller.userId.value,
                        item_id: autoComplete1.products.value,
                      );
                      if (Get.arguments == null) {
                        await ordercontroller.insert('orders', orders);
                        // await itemcontroller
                        //     .getAnyByIdItem(autoComplete1.products.value);
                        await Notifications1()
                            .sendMessage('hi', 'you add Order', 'aa');
                        await Notifications1().initNotifications();
                        notificationController.increase();
                        // autoComplete1.getAllItems();
                      } else {
                        await ordercontroller.updateOrders(
                            'orders', orders, Get.arguments.id);
                        await Notifications1()
                            .sendMessage('hi', 'you update Order', 'aa');
                        await Notifications1().initNotifications();
                        notificationController.increase();
                      }
                      Get.back();
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
