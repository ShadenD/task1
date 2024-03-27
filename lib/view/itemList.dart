// ignore_for_file: camel_case_types, must_be_immutable, avoid_print, unused_local_variable, file_names
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/autocomplete.dart';
import 'package:welcom/controller/itemController.dart';
import 'package:welcom/model/itemModel.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/view/CartScreen.dart';
// import 'package:welcom/view/CartScreen.dart';
import 'package:welcom/view/addItem.dart';

class itemList extends GetView<itemController> {
  itemList({super.key});
  SqlDB sqldb = SqlDB();
  itemController itemcontroller = Get.put(itemController());
  AutoComplete1 autoComplete1 = Get.put(AutoComplete1());
  @override
  Widget build(BuildContext context) {
    int counter;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => addItems());
            // notificationController.decrease();
          }),
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text('Item List'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => CartScreen());
              },
              child: Obx(
                () => badges.Badge(
                  badgeAnimation: const BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 300),
                  ),
                  showBadge: true,
                  badgeContent: Text(itemcontroller.counter.value.toString(),
                      style: const TextStyle(color: Colors.white)),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
          ]),
      body: Column(
        children: [
          Obx(
            () => Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GridView.builder(
                  padding: const EdgeInsets.all(35),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: itemcontroller.itemO.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 16.0, bottom: 0),
                                child: InkWell(
                                  onTap: () async {
                                    await itemcontroller.delete(
                                        itemcontroller.itemO[index]['itemId']);
                                    itemcontroller.decrease();
                                    print("delete item");
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, bottom: 0),
                                child: InkWell(
                                  onTap: () async {
                                    Get.to(() => addItems(), arguments: {
                                      'itemId': itemcontroller.itemO[index]
                                          ['itemId'],
                                      'itemName': itemcontroller.itemO[index]
                                              ['itemName']
                                          .toString(),
                                      'price': itemcontroller.itemO[index]
                                          ['price'],
                                      'quantity': itemcontroller.itemO[index]
                                          ['quantity'],
                                      'unitTag': '',
                                      'image': itemcontroller.itemO[index]
                                              ['image']
                                          .toString(),
                                    });
                                  },
                                  child: const Icon(Icons.update),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ClipOval(
                              child: Image.file(
                                File('${itemcontroller.itemO[index]['image']}'),
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemcontroller.itemO[index]['itemName']
                                          .toString() +
                                      '                                        ' +
                                      r'$' +
                                      itemcontroller.itemO[index]['price']
                                          .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Quantity:  ${itemcontroller.itemO[index]['quantity']}"
                                      .toString(),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () async {
                                      print(index);
                                      print(index);
                                      print(itemcontroller.itemO[index]
                                              ['itemName']
                                          .toString());
                                      print(itemcontroller.itemO[index]['price']
                                          .toString());
                                      print('1');
                                      print(itemcontroller.itemO[index]['image']
                                          .toString());
                                      double price =
                                          itemcontroller.itemO[index]['price'];
                                      int id =
                                          itemcontroller.itemO[index]['itemId'];
                                      itemModel item = itemModel(
                                          itemName: itemcontroller.itemO[index]
                                                  ['itemName']
                                              .toString(),
                                          image: itemcontroller.itemO[index]
                                                  ['image']
                                              .toString(),
                                          price: price,
                                          quantity: null,
                                          unitTag: '');
                                      itemcontroller.add(item);
                                      // itemcontroller.insert('items', item);
                                      autoComplete1.getItems();
                                      // itemcontroller
                                      //     .getAnyByIdItem(item.itemId!);
                                      // itemcontroller.incre(price);
                                      itemcontroller.addTotalPrice(
                                          itemcontroller.itemO[index]['price']);
                                      itemcontroller.checkItem(index);

                                      const snackBar = SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Item is added to cart'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Text(
                                          'Add to cart',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )),
          )
        ],
      ),
    );
  }
}
