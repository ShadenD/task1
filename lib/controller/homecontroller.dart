import 'package:get/get.dart';
import 'package:welcom/model/sqlitedb2.dart';

class HomePageController extends GetxController {
  SqlDB sqldb = SqlDB();

  @override
  void onInit() {
    super.onInit();
    initdb();
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

  initdb() async {
    await sqldb.db;
  }
}
