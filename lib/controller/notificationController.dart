// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:welcom/model/notificationMessage.dart';

class NotificationController extends GetxController {
  RxString titleo = ''.obs;
  RxString bodyo = ''.obs;
  Map<String, dynamic> payload = <String, dynamic>{}.obs;
  RxList v = [].obs;
  RxInt count = 0.obs;

  values1(NotificationModel notifi) {
    titleo.value = notifi.title;
    bodyo.value = notifi.body;
    payload = notifi.payload;
    add();
  }

  add() {
    v.add(NotificationModel(
        title: titleo.value, body: bodyo.value, payload: payload));
  }

  increase() {
    count.value++;
  }

  zero() {
    count.value = 0;
  }

  decrease() {
    count.value--;
  }
}
