// ignore_for_file: file_names, unused_local_variable, avoid_print, unused_element, prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welcom/model/itemModel.dart';
import 'package:welcom/view/sidebar.dart';

import '../model/sqlitedb2.dart';

// ignore: camel_case_types
class itemController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  RxString selectedOption = ''.obs;
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  final List<String> selectedItems = [];

  RxInt counter = 0.obs;
  RxInt counter2 = 0.obs;
  // RxInt get counter => _counter.obs;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  var total = 0.obs;
  late Future<List<itemModel>> _cart;
  Future<List<itemModel>> get cart => _cart;
  List<itemModel> _item = [];
  double _price = 0.0;

  SqlDB sqldb = SqlDB();

  RxList itemO = [].obs;

  List cartItems = [].obs;

  getAnyByIdItem(int id) async {
    List<Map> response =
        await sqldb.readData("SELECT * FROM items WHERE itemId=$id");
    // List oneOrder = await getAnyById(id);

    cartItems.addAll(response);
    print("in select     $cartItems");

    return cartItems;
  }

  void itemchange(String itemvalue, bool isSelected) {
    if (isSelected) {
      selectedItems.add(itemvalue);
    } else {
      selectedItems.remove(itemvalue);
    }
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    // update();
  }

  void addCounter() {
    counter.value++;
    _setPrefItems();
    // update();
  }

  void removerCounter() {
    counter.value--;
    _setPrefItems();
    // update();
  }

  int getCounter() {
    _getPrefItems();
    return counter.value;
  }

  void incre(int count) {
    print(count);
    print('shaden');
    count++;
    print(count);
    update();
  }

  void decrement(double price) {
    total.value -= price.toInt();
    counter2--;
    update();
  }

  increase() {
    counter.value++;
  }

  zero() {
    counter.value = 0;
  }

  decrease() {
    counter.value--;
  }

  checkItem(int i) {
    if (itemO.contains(itemO[i])) {
      increase();
    } else {
      print('Item was exsist');
      const Text('Item was exsist');
    }
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', counter.value);
    prefs.setDouble('total_price', _totalPrice);
    // update();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    counter.value = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    // update();
  }

  insert(String table, itemModel item1) async {
    Map<String, dynamic> itemMap = item1.toMap();
    int response = await sqldb.insert(table, itemMap);
    List<Map> oneItem = await sqldb
        .readData("SELECT * FROM items ORDER BY itemId DESC LIMIT 1");
    Map indexCurrencyOne = oneItem[0];
    itemO.add(indexCurrencyOne);
    print(itemO);
    print('succfully');
  }

  void add(itemModel itemModel) {
    _item.add(itemModel);
    _price += itemModel.price;
  }

  int get count {
    return _item.length;
  }

  double get totalprice {
    return _price;
  }

  List<itemModel> get basketitem {
    return _item;
  }

  updateItem(String table, itemModel item, int id) async {
    Map<String, dynamic> itemMap = item.toMap();
    int response = await sqldb.update(table, itemMap, "itemId=$id");
    if (response > 0) {
      updateLocalSolution(id);
    }
  }

  updateLocalSolution(int id) async {
    List<Map> anyOne = await getAnyByIdItem(id);
    Map indexOne = anyOne[0];
    int index = itemO.indexWhere((element) => element['itemId'] == id);
    if (index != -1) {
      itemO.removeAt(index);
      itemO.insert(index, indexOne);
    } else {
      print('Index not found in currency list.');
    }
  }

  delete(int id) async {
    int response = await sqldb.deletData("DELETE FROM items WHERE itemId=$id");
    itemO.removeWhere((element) => element['itemId'] == id);
    if (response > 0) {
      Get.to(() => SideBarPage());
    }
  }

  void pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value =
          ((File(selectedImagePath.value).lengthSync() / 1024 / 1024))
                  .toStringAsFixed(2) +
              "MB";
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
  }

  readData2() async {
    List<Map> response = await sqldb.readData("SELECT * FROM items");
    print(response);
    itemO.addAll(response);
    return itemO;
  }

  @override
  void onInit() {
    readData2();
    // loadCartItems();
    super.onInit();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    super.onReady();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }
}
