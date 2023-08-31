import 'dart:isolate';
import 'dart:ui';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:eliteinapp/app/modules/home/views/widget/nativehelper.dart';
import 'package:eliteinapp/app/routes/app_pages.dart';
import 'package:eliteinapp/introduction_animation/components/notification.dart';
import 'package:eliteinapp/introduction_animation/onboarding_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp();
//   // var data = message.notification!;
//   // var title = data.title.toString();
//   // var body = data.body.toString();
//   // var image = message.data['image'] ?? '';
//   // var type = message.data['type'] ?? '';
//   // var id = '';
//   // id = message.data['url'] ?? '';
//   // if (image != null && image != 'null' && image != '') {
//   //   await generateImageNotication(title, body, image, type, id);
//   // } else {
//   //   await generateSimpleNotication(title, body, type, id);
//   // }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  // initMessaging();
  initialize();
  await FlutterDownloader.initialize(ignoreSsl: true);
  await FlutterDownloader.registerCallback(downloadCallback);
   
  var a = getBoolAsync('into');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(ScreenUtilInit(
      designSize: const Size(720, 1600),
      builder: (context, child) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
          title: "Elite",
          initialRoute:a? Routes.CHAT : Routes.HOME,
          // home: a ? const InitScreen() : const OnboardingScreen()
          ))
          
          ));
}

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
  
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) async {
    //   if (message != null) {
    //     var type = message.data['type'] ?? '';
    //     var id = '';
    //     id = message.data['url'] ?? '';

    //     if (type == 'url') {
    //       try {
    //         Get.offAllNamed(Routes.HOME, arguments: id);
    //       } catch (e) {
    //         Get.offAllNamed(Routes.HOME, arguments: id);
    //       }
    //     }
    //   } else {
        Get.offAllNamed(Routes.HOME);
      // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash screen.png",
                ),
                fit: BoxFit.fill)),
      ),
    );
  }
}
