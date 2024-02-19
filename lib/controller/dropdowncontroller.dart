import 'package:get/get.dart';
import 'package:welcom/model/sqlitedb2.dart';

class DropDownListController extends GetxController {
  var selectedItems = ''.obs;
  RxInt selectedCurrency = 0.obs;
  RxInt selectedUser = 0.obs;
  RxString selectedType = "".obs;
  SqlDB sqldb = SqlDB();
  
    List<String> items = [
      "Sell Order",
      "Purshased Order",
      "Return Sell Order",
      "Return Purshased Order"
    ];

  void updateSelectedItem(value) {
    selectedItems.value = value;
  }

  String? validateCurrency(value) {
    if (value == 0) {
      return "Select Currency";
    }
    return null;
  }

  void updateCurrency(value) {
    selectedCurrency.value = value;
  }

  String? validateUser(value) {
    if (value == 0) {
      return "Select User";
    }

    return null;
  }

  void updateUser(value) {
    selectedUser.value = value;
  }
    String? validateType(String value) {
    if (value == "") {
      return "Select Type";
    }

    return null;
  }
    void updateType(String value) {
    selectedType.value = value;
  }

}
