// ignore_for_file: override_on_non_overriding_member

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RememberMeController extends GetxController {
  final GetStorage storage = GetStorage();

  final RxBool rememberMe = false.obs;
 
  @override
  void onInit() {
    rememberMe.value = storage.read('rememberMe') ?? false;
    super.onInit();
  }

   toggleRememberMe(value) {
    rememberMe.value = value!;
    // storage.write('rememberMe', value);
 
  }
}
