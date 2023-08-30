// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:eliteinapp/app/routes/app_pages.dart';
// import 'package:eliteinapp/main.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:open_file_plus/open_file_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse res) {
//   // ignore: avoid_print
//   if (res.payload!.split(',')[0] == 'url') {
//     try {
//       Get.offAllNamed(Routes.HOME, arguments: res.payload!.split(',')[1]);
//     } catch (e) {
//       Get.offAllNamed(
//         Routes.HOME,
//         arguments: res.payload!.split(',')[1],
//       );
//     }
//   } else if (res.payload!.split(',')[0] == 'url') {
//     try {
//       Get.toNamed(Routes.BLOG);
//     } catch (e) {}
//   }
// }

// @pragma('vm:entry-point')
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// @pragma('vm:entry-point')
// FirebaseMessaging messaging = FirebaseMessaging.instance;

// const iosDetails = DarwinNotificationDetails(
//     presentAlert: true, presentBadge: true, presentSound: true);
// const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//   'high_importance_channel',
//   'Notifications',
//   channelDescription: "description",
//   enableVibration: true,
//   enableLights: true,
//   importance: Importance.max,
//   playSound: true,
//   priority: Priority.high,
// );

// Future<void> initMessaging() async {
//   await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_launcher'),
//         iOS: DarwinInitializationSettings(),
//       ), onDidReceiveNotificationResponse: (res) async {
//     if (res.payload!.split(',')[0] == 'url') {
//       try {
//         Get.offAllNamed(Routes.HOME, arguments: res.payload!.split(',')[1]);
//       } catch (e) {
//         Get.offAllNamed(
//           Routes.HOME,
//           arguments: res.payload!.split(',')[1],
//         );
//       }
//     } else if (res.payload!.split(',')[0] == 'blog') {
//       try {
//         Get.toNamed(Routes.BLOG);
//       } catch (e) {}
//     } else if (res.payload!.split(',')[0] == 'file') {
//       try {
//         await OpenFile.open(res.payload!.split(',')[1]);
//       } catch (e) {}
//     }
//   });
//   await messaging.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   messaging.requestPermission();
//   if (Platform.isIOS) {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   } else {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestPermission();
//   }

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     var id = '';
//     var type = message.data['type'] ?? '';

//     id = message.data['url'] ?? '';

//     if (type == 'url') {
//       try {
//         Get.offAllNamed(Routes.HOME, arguments: id);
//       } catch (e) {
//         Get.offAllNamed(Routes.HOME, arguments: id);
//       }
//     } else if (type == 'blog') {
//       try {
//         Get.toNamed(Routes.BLOG);
//       } catch (e) {}
//     }
//   });
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   FirebaseMessaging.onMessage.listen(
//     (RemoteMessage message) async {
//       var data = message.notification!;

//       var title = data.title.toString();
//       var body = data.body.toString();
//       var image = message.data['image'] ?? '';

//       var type = message.data['type'] ?? '';
//       var id = '';
//       id = message.data['url'] ?? '';

//       if (image != null && image != 'null' && image != '') {
//         await generateImageNotication(title, body, image, type, id);
//       } else {
//         await generateSimpleNotication(title, body, type, id);
//       }
//     },
//   );
// }

// void sub(BuildContext context) async {
//   var sb = getBoolAsync(
//     "sub",
//   );

//   if (!sb ) {
//     setValue("sub1", true);

//     var fbi = FirebaseMessaging.instance;

//     await fbi.subscribeToTopic('allnews');
//   } else {}
// }


// @pragma('vm:entry-point')
// Future<String> _downloadAndSaveImage(String url, String fileName) async {
//   var directory = await getApplicationDocumentsDirectory();
//   var filePath = '${directory.path}/$fileName';
//   var response = await http.get(Uri.parse(url));

//   var file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   return filePath;
// }

// @pragma('vm:entry-point')
// Future<void> generateImageNotication(
//     String title, String msg, String image, String type, String id) async {
//   var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
//   var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
//   var bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       hideExpandedLargeIcon: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//       summaryText: msg,
//       htmlFormatSummaryText: true);

//   var platformChannelSpecifics = const NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetails);
//   await flutterLocalNotificationsPlugin.show(
//     DateTime.now().minute + DateTime.now().second,
//     title,
//     msg,
//     platformChannelSpecifics,
//     payload: '$type,$id',
//   );
// }

// @pragma('vm:entry-point')
// Future<void> generateSimpleNotication(
//     String title, String msg, String type, String id) async {
//   var platformChannelSpecifics = const NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetails);
//   await flutterLocalNotificationsPlugin.show(
//     DateTime.now().minute + DateTime.now().second,
//     title,
//     msg,
//     platformChannelSpecifics,
//     payload: '$type,$id',
//   );
// }

// var generalNotificationDetails = const NotificationDetails(
//     android: androidPlatformChannelSpecifics, iOS: iosDetails);
