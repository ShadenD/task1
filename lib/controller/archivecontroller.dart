// ignore_for_file: avoid_print, await_only_futures, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/view/sidebar.dart';

class ArchiveController extends GetxController {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  List users = [].obs;
  SqlDB sqldb = SqlDB();
  TextEditingController teSeach = TextEditingController();

  bool isEmailCorrect = false;
  bool passToggle = true;
  RxInt selectedIndex = 0.obs;

  final TextEditingController controller = TextEditingController();
  bool success = true;
  bool fail = false;
  late String vall;

  readData() async {
    List<Map> response = await sqldb.readData("SELECT * FROM users");
    users.addAll(response);
    update();
  }

  filter(String keyword) {
    Iterable filterdCurrencies = users.where((element) =>
        element['username']
            .toString()
            .toLowerCase()
            .startsWith(keyword.toLowerCase()) ||
        element['email']
            .toString()
            .toLowerCase()
            .startsWith(keyword.toLowerCase()));
    users.replaceRange(0, users.length, filterdCurrencies.toList());
  }

  // inseretuser(Users user) async {
  //   await sqldb.insert(
  //       "INSERT INTO users ('username','email','pass','bod','photo') VALUES(${user.username},${user.email},${user.pass},'20-1-2000',${user.photo})");
  //   users.add(user);
  // }

  inseretuser(String table, Users user1) async {
    Map<String, dynamic> userMapMap = await user1.toMap();
    print(userMapMap);
    int response = await sqldb.insert(table, userMapMap);
    List<Map> oneUser =
        await sqldb.readData("SELECT * FROM users ORDER BY id DESC LIMIT 1");
    Map indexUserOne = oneUser[0];
    print(indexUserOne);
    users.add(indexUserOne);
  }

  // uppdateuser(Map updatuser) async {
  // await sqldb
  //       .updateData(''' UPDATE users SET username= "${updatuser['username']}" ,
  //                             email= "${updatuser['email']}" ,
  //                              pass= "${updatuser['pass']}"
  //                             WHERE id= ${Get.arguments['id']}  ''');
  // }
  getCurrentUser(String email) async {
    List<Map> response2 =
        await sqldb.readData("SELECT * FROM users WHERE email='$email'");
    Map indexUserOne = response2[0];
    print(response2);
    print(indexUserOne);
    return indexUserOne;
  }

  getOne(int id) async {
    return await sqldb.readData("SELECT * FROM users WHERE id=$id");
  }

  @override
  void onInit() {
    super.onInit();

    readData();
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

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    if (password.length >= 8) {}

    if (numericRegex.hasMatch(password)) {}
  }

  deleteuser(int id) async {
    int response = await sqldb.deletData("DELETE FROM users WHERE id=$id");
    users.removeWhere((element) => element['id'] == id);
    if (response > 0) {
      Get.to(() => SideBarPage());
    }
  }

  // updateUser(String table, Map<String, dynamic> user, int id) async {
  //   await sqldb.update(table, user, "id=$id");
  // }
  updateUser(String table, Users user, int id) async {
    Map<String, dynamic> orderMap = user.toMap();
    int response = await sqldb.update(table, orderMap, "id=$id");
    if (response > 0) {
      updateLocalSolution(id);
    }
  }

  updateLocalSolution(int id) async {
    List<Map> anyOne = await getAnyByIdCurrency(id);
    Map indexOne = anyOne[0];
    int index = users.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      users.removeAt(index);
      users.insert(index, indexOne);
    } else {
      print('Index not found in currency list.');
    }
  }

  getAnyByIdCurrency(int id) async {
    List<Map> response =
        await sqldb.readData("SELECT * FROM users WHERE id=$id");
    return response;
  }
}
