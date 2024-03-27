// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/sqlitedb2.dart';

class AutoComplete1 extends GetxController {
  SqlDB sqldb = SqlDB();

  TextEditingController textcontroller = TextEditingController();
  RxString selectedItem = ''.obs;
  RxBool isloading = false.obs;
  RxList<String> selectedString = <String>[].obs;
  RxInt products = 0.obs;
// To access the value of RxList, use .value
  RxList<String> cartItems = <String>[].obs;
  RxList p = [].obs;
  // Assuming cartItems is of type RxList<String>
  RxList<String> cartItems1 = <String>[].obs;
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;
  List<String?> selectedItems = [];
  Future<Iterable<String>> searchItems(String searchText) async {
    return cartItems.where((element) {
      return element.toLowerCase().contains(searchText.toLowerCase());
    }).toList(); // Convert Iterable<dynamic> to Iterable<String>
  }

  @override
  void onInit() {
    loadItems();
    sharedPreferences!.getStringList('items');
    loadSelectItems();
    super.onInit();
  }

  void addItem(String newItem) {
    selectedString.add(newItem);
    saveItems();
  }

  Future<void> saveItems() async {
    // Save the list of items to SharedPreferences
    await sharedPreferences!.setStringList('items', selectedString);
  }

  Future<void> loadSelectItems() async {
    // Retrieve the list of items from SharedPreferences
    List<String> items = sharedPreferences!.getStringList('items') ?? [];
  }

  Future<List<String>> getItems() async {
    try {
      // Assuming readData returns a List<Map<String, dynamic>>
      List<Map<String, dynamic>> response =
          await sqldb.readData("SELECT itemName FROM items");

      // Extracting item names from the list of maps
      List<String> items =
          response.map((item) => item['itemName'].toString()).toList();

      print('List correct: $items');
      return items;
    } catch (e) {
      print('Error fetching items: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  // getAllItems() async {
  //   for (var i in selectedString) {
  //     List<Map<String, dynamic>> response =
  //         await sqldb.readData("SELECT * FROM items WHERE itemName='$i'");
  //     p.addAll(response);
  //     print(p);
  //   }
  // }

  read(String name) async {
    var result =
        await sqldb.readData("SELECT itemId FROM items WHERE itemName='$name'");
    var result2 =
        await sqldb.readData("SELECT * FROM items WHERE itemName='$name'");
    int response;
    for (var row in result) {
      response = row['itemId'];
      products.value = response;
      p.add(result2);
      print('hi: $products');
    }
  }

  Future<void> loadItems() async {
    List<String> items = await getItems();
    print('welcom:   $cartItems1');
    cartItems.addAll(items);
    print('welcom:   $cartItems1');
  }

  // Future<void> fetchautocompleteApi() async {
  //   isloading.value = true;
  //   getItems();
  //   isloading.value = false;
  //   cartItems = getItems();
  // }
}
