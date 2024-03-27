// ignore_for_file: file_names, deprecated_member_use, must_be_immutable

import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/itemController.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  itemController itemcontroller = Get.put(itemController());

  @override
  Widget build(BuildContext context) {
    if (itemcontroller.cartItems.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping Cart'),
            centerTitle: true,
            actions: [
              Center(
                child: Obx(
                  () => badges.Badge(
                    badgeAnimation: const BadgeAnimation.fade(
                      animationDuration: Duration(milliseconds: 300),
                    ),
                    showBadge: true,
                    badgeContent: Text(itemcontroller.counter().toString(),
                        style: const TextStyle(color: Colors.white)),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 20.0)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/empty_cart.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Your cart is empty 😌',
                      style: Theme.of(context).textTheme.headline5),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Explore products and shop your\nfavourite items',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2)
                ],
              ),
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          centerTitle: true,
          actions: [
            Center(
              child: badges.Badge(
                badgeAnimation: const BadgeAnimation.fade(
                  animationDuration: Duration(milliseconds: 300),
                ),
                showBadge: true,
                badgeContent: Text(itemcontroller.counter().toString(),
                    style: const TextStyle(color: Colors.white)),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(width: 20.0)
          ],
        ),
        body: ListView.builder(
          itemCount: itemcontroller.cartItems.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                            height: 100,
                            width: 100,
                            image: FileImage(
                                File(itemcontroller.cartItems[index]['image'])),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    itemcontroller.cartItems[index]['itemName'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          itemcontroller.incre(itemcontroller
                                              .cartItems[index]['price']);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      Obx(() => Text(
                                          '${itemcontroller.counter2.value}')),
                                      IconButton(
                                        onPressed: () {
                                          itemcontroller.decrement(
                                              itemcontroller.cartItems[index]
                                                  ['price']);
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ))
                        ]),
                    ListTile(
                      leading: Image.file(
                        File(itemcontroller.cartItems[index]['image']),
                      ),
                      title: Text(
                        itemcontroller.cartItems[index]['itemName'],
                      ),
                      trailing: SizedBox(
                        width: 120, // Provide a fixed width for the SizedBox
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                itemcontroller.incre(
                                    itemcontroller.cartItems[index]['price']);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Obx(() => Text('${itemcontroller.counter2.value}')),
                            IconButton(
                              onPressed: () {
                                itemcontroller.decrement(
                                    itemcontroller.cartItems[index]['price']);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
