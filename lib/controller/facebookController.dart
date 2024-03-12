// ignore_for_file: file_names, unused_local_variable, avoid_print, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/view/sidebar.dart';

class FacebookLogin extends GetxController {
  SqlDB sqldb = SqlDB();
  RxString alert = ''.obs;
  Future signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult != null && loginResult.accessToken != null) {
      try {
        Future<void> handleFacebookSignOut() async {
          await FacebookAuth.instance.logOut();
        }

        login(String email) async {
          List<Map> response2 =
              await sqldb.readData("SELECT * FROM users WHERE email='$email'");
          return response2;
        }

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        print('User logged in: ${userCredential.user!.displayName}');
        // Navigate to the next screen or perform other actions after successful login
        if (userCredential != null) {
          Users users = Users(
              username: userCredential.user!.displayName.toString(),
              email: userCredential.user!.email.toString(),
              pass: '',
              bod: '',
              photo: "file.path");
          List<Map> reg = await login(userCredential.user!.email.toString());
          if (reg.isEmpty) {
            print('User with the provided email does not exist!');
            Map<String, dynamic> userMap = users.toMap();
            await sqldb.insert('users', userMap);
            Get.to(() => SideBarPage());
            // Get.to(() => Archives());
          } else {
            alert.value = "This email was registered";
            print("Error");
            handleFacebookSignOut();
          }
        }
      } catch (e) {
        print('Failed to sign in with Facebook: $e');
      }
    } else {
      print('Facebook login was not successful');
    }
  }
}
