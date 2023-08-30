import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeController extends GetxController {
  var url = "".obs;
  var curl = "".obs;
  var loading = false.obs;
  startloading(bool a) {
    loading.value = a;
  }

  void getdata() async {
   
    if (arg != null) {
      url.value = arg!;
    } else {
      url.value = "https://elite-in.com/";
    }
  }

  late PullToRefreshController pullToRefreshController;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var error = false.obs;
  var error2 = false.obs;

  var curr = 0.obs;
  Future<bool> backbuton(BuildContext context) async {
    if (await ctrl!.canGoBack()) {
      ctrl!.goBack();

      curr.value = 0;

      return false;
    } else {
      var c = false;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("cl".tr),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('ext'.tr),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('yes'.tr),
                onPressed: () {
                  c = true;
                  Navigator.of(context).pop();
                  exit(0);
                },
              ),
              TextButton(
                child: Text('no'.tr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return c;
    }
  }

  InAppWebViewController? ctrl;
  late String? arg;
  @override
  void onInit() {
    super.onInit();
    arg = Get.arguments as String?;
    getdata();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          ctrl?.reload();
        }
      },
    );

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) async {
      if (e == ConnectivityResult.none) {
        error.value = true;
      } else {
        error.value = false;
      }
    });
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();

    super.onClose();
  }
}
