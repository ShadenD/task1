// ignore_for_file: avoid_print, unused_field, avoid_web_libraries_in_flutter, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:welcom/controller/notificationController.dart';
import 'package:welcom/main.dart';
import 'package:welcom/model/notificationMessage.dart';
import 'package:welcom/view/local_notifications.dart';

Future<dynamic> handalBackgroundMessage(RemoteMessage message) async {
  print('Title:${message.notification?.title}');
  print('Body:${message.notification?.body}');
  print('PayLoad:${message.data}');
}

class Notifications1 {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  NotificationController notificationController =
      Get.put(NotificationController());
  final _androidChannel = const AndroidNotificationChannel(
    'high importance channel',
    'high importance Notification',
    description: 'this channel is used for important notification',
    importance: Importance.defaultImportance,
  );

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    print(message);
    Get.to(() => LocalNotification(), arguments: {'message': message});
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("not nulllllll");
        handleMessage(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handalBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      notificationController.values1(
        NotificationModel(
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
            payload: message.data),
      );
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@mipmap/ic_launcher')),
        payload: jsonEncode(
          {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "status": "done",
            "screen": "/notificationPage"
          },
        ),
      );
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:$fCMToken');
    sharedPreferences!.setString('token', fCMToken!);
    initPushNotification();
    initLoacalNotifiction();
  }

  dynamic sendMessage(dynamic title, dynamic message, String id) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA9_Ysgys:APA91bH1wxDveCjfwVpukDlGJdG0zMnZpYePfRIsgsQqq8VK6AgR6Kxh4EBn6lT1jvv7_dHwlt3twL7-xA76pZLR71K_rSIqhjvXYDD23ku0hyWcVJLsfmeIIl66UJ14nyH8TYEOc_qa'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    RemoteMessage remoteMessage = RemoteMessage(
      messageId: id,
      data: {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": "default",
        "screen": "/notificationPage"
      },
      notification: RemoteNotification(
        body: message,
        title: title,
      ),
      senderId: sharedPreferences!.getString('token'),
    );
    remoteMessage.toMap();
    Map<String, dynamic> body = {
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": "default",
        "screen": "/notificationPage"
      },
      "to": sharedPreferences!.getString('token'),
      "notification": {"title": title, "body": message}
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    NotificationModel model =
        NotificationModel(title: title, body: message, payload: body['data']);
    notificationController.values1(model);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  Future initLoacalNotifiction() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      RemoteMessage message = RemoteMessage(
          data: json.decode(payload.payload.toString()),
          notification: RemoteNotification(
            title: notificationController.titleo.value,
            body: notificationController.bodyo.value,
          ));
      handleMessage(message);
      print(message);
    });
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}
