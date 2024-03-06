// ignore_for_file: file_names, unused_local_variable, avoid_print

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

class FacebookLogin extends GetxController {
  Future<void> signInWithFacebook() async {
    // FacebookAuth.instance.webAndDesktopInitialize(
   //     appId: "328682493009239", cookie: true, xfbml: true, version: "v15.0");
    try {
      // Trigger the Facebook sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the user successfully signed in
      if (result.status == LoginStatus.success) {
        // Retrieve the access token
        final AccessToken accessToken = result.accessToken!;

        // Use the access token to fetch the user's profile data
        final userData = await FacebookAuth.instance.getUserData();

        // Do something with the user's profile data
        print(userData);
      } else {
        // Handle sign-in failure
        print('Facebook sign-in failed');
      }
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      print('Error signing in with Facebook: $e');
    }
  }
}
