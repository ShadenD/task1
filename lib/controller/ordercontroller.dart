// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:welcom/model/order.dart';
import 'package:welcom/model/sqlitedb2.dart';

class OrederController extends GetxController {
  RxInt currencyId = 0.obs;
  RxDouble rate = 0.0.obs;
  RxInt userId = 0.obs;
  RxInt itemId = 0.obs;
  RxString item = "".obs;
  RxList orders = [].obs;
  RxList? states = [].obs;
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
      states!.clear();
      orders.sort((a, b) => -a['amount'].compareTo(b['amount']));
      addStates();
    } else {
      states!.clear();
      orders.sort((a, b) => a['amount'].compareTo(b['amount']));
      addStates();
    }
  }

  getAllPaid() {
    states!.clear();
    Iterable filterdUsers = orders.where((element) => element['status'] == 1);
    orders.replaceRange(0, orders.length, filterdUsers.toList());
    addStates();
  }

  getAllNotPaid() {
    states!.clear();
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

  // Future<void> updateItemId(String value1) async {
  //   // Execute the SQL query to retrieve the itemId
  //   var resultSet = await sqldb.readJoin('''
  //   SELECT items.itemId AS itemId
  //   FROM orders
  //   JOIN items ON items.itemId = orders.item_id
  //   WHERE itemName = '$value1'
  // ''');

  //   // Extract the integer value from the result set
  //   int? itemId1;
  //   if (resultSet.isNotEmpty) {
  //     // Assuming the first column of the first row contains the itemId
  //     itemId1 = resultSet.first['itemId'] as int?;
  //   }

  //   // Check if itemId is not null
  //   if (itemId != null) {
  //     // Update the itemId
  //     itemId.value = itemId1!;
  //     print('item id: $itemId');
  //   } else {
  //     // Handle the case where itemId is null
  //     print('Invalid item id: $value1');
  //   }
  // }

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
    SELECT 
    users.username AS username, 
    currency.currencyName AS currencyName, 
    currency.rate AS rate,
     items.itemId AS itemId, 
       items.itemName AS itemName, 
       items.image AS image,  
       items.price AS price, 
       items.quantity AS quantity,
    orders.order_date, 
    orders.status AS status, 
    orders.order_amount AS amount, 
    users.id AS user_id, 
    currency.currencyId AS curr_id,
    orders.type AS type,
    users.email AS email,
    users.bod AS bod, 
    orders.equal_order_amount AS equalAmount, 
    orders.order_id AS order_Id 
FROM 
    orders 
JOIN 
    users ON users.id = orders.user_id
JOIN 
    currency ON currency.currencyId = orders.curr_id
    JOIN items ON items.itemId = orders.item_id 

''');
    orders.addAll(response);
    addStates();
  }

  addStates() {
    Iterable orderStates = orders.map((element) => element['status']);
    states!.addAll(orderStates);
  }

  updateOrderState(int state, int id) async {
    int response = await sqldb.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE order_Id=$id
''');
    if (response > 0) {
      await updateLocalSolution(id);
    }
  }

  // switchOrderState(int index, bool value) {
  //   states![index] = value ? 1 : 0;
  // }

  updateOrders(String table, Orderss order, int id) async {
    Map<String, dynamic> orderMap = order.toMap();
    int response = await sqldb.update(table, orderMap, "order_id=$id");
    if (response > 0) {
      updateLocalSolution(id);
    }
  }

  updateLocalSolution(int id) async {
    List oneOrder = await getAnyById(id);
    Map order = oneOrder[0];
    int index = orders.indexWhere((o) => o['order_Id'] == id);
    if (index != -1) {
      orders.removeAt(index);
      orders.insert(index, order);
    } else {
      print('Index not found in currency list.');
    }
  }

  getLast() async {
    List<Map> oneOrder =
        await sqldb.readData(''' SELECT users.username AS username, 
       currency.currencyName AS currencyName,
       currency.rate AS rate, 
       items.itemId AS itemId, 
       items.itemName AS itemName, 
       items.image AS image,  
       items.price AS price, 
       items.quantity AS quantity,
       orders.order_date, 
       orders.status AS status, 
       orders.order_amount AS amount, 
       users.id AS user_id, 
       currency.currencyId AS curr_id,
       orders.type AS type,
       users.email AS email,
       users.bod AS bod, 
       orders.equal_order_amount AS equalAmount, 
       orders.order_id AS order_Id 
FROM orders 
JOIN users ON users.id = orders.user_id 
JOIN currency ON currency.currencyId = orders.curr_id 
JOIN items ON items.itemId = orders.item_id 
ORDER BY orders.order_id DESC 
LIMIT 1 ''');
    return oneOrder;
  }

  insert(String table, Orderss order) async {
    Map<String, dynamic> orderMap = order.toMap();
    int response = await sqldb.insert(table, orderMap);
    List<Map> inserted = await getLast();
    Map insertedOrder = inserted[0];
    orders.add(insertedOrder);
    print('sssssssssssss: $orders');
    return response;
  }

  getAnyById(int id) async {
    List<Map> oneIndex = await sqldb.getReadOne('''
    SELECT users.username AS username, currency.currencyName AS currencyName,currency.rate AS rate,items.itemId AS itemId, 
       items.itemName AS itemName, 
       items.image AS image,  
       items.price AS price, 
       items.quantity AS quantity,  
    orders.order_date, orders.status AS status, orders.order_amount AS amount, users.id AS user_id, currency.currencyId AS curr_id,
    orders.type AS type, orders.equal_order_amount AS equalAmount, orders.order_id AS order_Id
    FROM orders JOIN users 
    ON users.id=orders.user_id JOIN currency 
    JOIN items ON items.itemId = orders.item_id 
    ON currency.currencyId=orders.curr_id WHERE orders.order_id =$id
''');
    return oneIndex;
  }

  delete(String table, int id) async {
    int response = await sqldb.delete(table, "order_Id=$id");
    if (response > 0) {
      orders.removeWhere((order) => order!['order_Id'] == id);
    }
  }

  getUsers(int userId) async {
    List<Map> response =
        await sqldb.readData("SELECT * FROM orders WHERE  user_id=$userId");
    print(response);
    orders.addAll(response);
  }

  getCurrency(int currencyId) async {
    List<Map> response =
        await sqldb.readData("SELECT * FROM orders WHERE  curr_id=$currencyId");
    print(response);
    orders.addAll(response);
  }

  @override
  void onInit() {
    print(orders);
    readDataOrder();
    super.onInit();
  }
}
