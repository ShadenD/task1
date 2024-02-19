// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:welcom/model/sqlitedb2.dart';

class OrederController extends GetxController {
  RxInt currencyId = 0.obs;
  RxDouble rate = 0.0.obs;
  RxInt userId = 0.obs;
  RxString item = "".obs;
  RxList orders = [].obs;
  RxList states = [].obs;
  RxString stateKeyword = "".obs;
  SqlDB sqldb = SqlDB();
  RxBool isChecked = false.obs;
  RxBool sorted = false.obs;

  toggleCheck(value) {
    isChecked.value = value!;
  }

  invertSorting() {
    sorted.value = !sorted.value;
  }

  sorting() {
    if (sorted.value) {
      states.clear();
      orders.sort((a, b) => -a['amount'].compareTo(b['amount']));
      addStates();
    } else {
      states.clear();
      orders.sort((a, b) => a['amount'].compareTo(b['amount']));
      addStates();
    }
  }

  getAllPaid() {
    states.clear();
    Iterable filterdUsers = orders.where((element) => element['status'] == 1);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
    addStates();
  }

  getAllNotPaid() {
    states.clear();
    Iterable filterdUsers = orders.where((element) => element['status'] == 0);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
    addStates();
  }

  filter(String value) {
    Iterable filterdUsers = orders.where((element) =>
        element['username'].toString().toLowerCase().startsWith(value) ||
        element['amount'].toString().toLowerCase().startsWith(value));
    orders.replaceRange(0, orders.length, filterdUsers.toList());
  }

  upadateCurrencyId(int value) {
    currencyId.value = value;
  }

  updateRate(double value) {
    rate.value = value;
  }

  double equalAmmount(double amount, double value) {
    return amount / value;
  }

  upadateUserId(int value) {
    userId.value = value;
  }

  updateType(String value) {
    item.value = value;
  }

  updateStateKeyWord(value) {
    if (value == 1) {
      stateKeyword.value = "Paid";
    } else {
      stateKeyword.value = "Not Paid";
    }
    return stateKeyword.value;
  }

  Future<dynamic> readDataOrder() async {
    List response = await sqldb.readJoin('''
    SELECT users.username AS username, currency.curreny_name AS currencyName, 
    orders.order_date, orders.status AS status, orders.order_amount AS amount,
    orders.type AS type, orders.equal_order_amount AS equalAmount, orders.order_id AS order_Id
    FROM orders JOIN users 
    ON users.id=orders.order_id JOIN currency 
    ON currency.currency_id=orders.curr_id
''');
    orders.addAll(response);
    addStates();
  }

  addStates() {
    Iterable orderStates = orders.map((element) => element['status']);
    states.addAll(orderStates);
  }

  updateOrderState(int state, int id) async {
    int response = await sqldb.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE order_Id=$id
''');
    return response;
  }

  switchOrderState(int index, bool value) {
    states[index] = value ? 1 : 0;
  }

  insert(String table, Map<String, dynamic> order) async {
    int response = await sqldb.insert(table, order);
    return response;
  }

  delete(String table, int id) async {
    int response = await sqldb.delete(table, "order_id=$id");
    if (response > 0) {
      orders.removeWhere((order) => order!['order_Id'] == id);
    }
  }

  @override
  void onInit() {
    print(orders);
    readDataOrder();
    super.onInit();
  }
}
