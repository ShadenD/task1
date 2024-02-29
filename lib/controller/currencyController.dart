// ignore_for_file: file_names, unused_local_variable, avoid_print, await_only_futures

import 'package:get/get.dart';
import 'package:welcom/model/currency.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/view/sidebar.dart';

class CurrencyController extends GetxController {
  SqlDB sqldb = SqlDB();
  RxList currency = [].obs;

  insert(String table, Currency currency1) async {
    Map<String, dynamic> currencyMap = await currency1.toMap();
    print(currencyMap);
    int response = await sqldb.insert(table, currencyMap);
    List<Map> oneCurrency = await sqldb
        .readData("SELECT * FROM currency ORDER BY currencyId DESC LIMIT 1");
    Map indexCurrencyOne = oneCurrency[0];
    print(indexCurrencyOne);
    currency.add(indexCurrencyOne);
  }

  readData2() async {
    List<Map> response = await sqldb.readData("SELECT * FROM currency");
    currency.addAll(response);
    return currency;
  }

  

  updateCurrency(String table, Currency currency, int id) async {
    Map<String, dynamic> orderMap = currency.toMap();
    int response = await sqldb.update(table, orderMap, "currencyId=$id");
    if (response > 0) {
      updateLocalSolution(id);
    }
  }

  updateLocalSolution(int id) async {
    List<Map> anyOne = await getAnyByIdCurrency(id);
    Map indexOne = anyOne[0];
    int index = currency.indexWhere((element) => element['currencyId'] == id);
    if (index != -1) {
      currency.removeAt(index);
      currency.insert(index, indexOne);
    } else {
      print('Index not found in currency list.');
    }
  }

  getAnyByIdCurrency(int id) async {
    List<Map> response =
        await sqldb.readData("SELECT * FROM currency WHERE currencyId=$id");
    return response;
  }

  delete(int id) async {
    int response =
        await sqldb.deletData("DELETE FROM currency WHERE currencyId=$id");
    currency.removeWhere((element) => element['currencyId'] == id);
    if (response > 0) {
      Get.to(() => SideBarPage());
    }
  }

  filter(String keyword) {
    Iterable filterdCurrencies = currency.where((element) =>
        element['currencyName']
            .toString()
            .toLowerCase()
            .startsWith(keyword.toLowerCase()) ||
        element['rate']
            .toString()
            .toLowerCase()
            .startsWith(keyword.toLowerCase()));
    currency.replaceRange(0, currency.length, filterdCurrencies.toList());
  }

  // updateCurrency(String table, Map<String, String> currency, int id) async {
  //   int response = await sqldb.update(table, currency, "currency_id=$id");
  //   if (response > 0) {
  //     // Get.to(() => Currency());
  //   }
  // }

  // updateCurreny(Map update) async {
  //   await sqldb.updateData(
  //       ''' UPDATE curreny SET curreny_name= "${update['currency_name']}" ,
  //                             currency_symbol= "${update['currency_symbol']}" ,
  //                              rate= "${update['rate']}"
  //                             WHERE currency_id= ${Get.arguments['id']} ''');
  // }

  @override
  void onInit() {
    readData2();
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
