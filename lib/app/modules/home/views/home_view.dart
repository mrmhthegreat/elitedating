import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:eliteinapp/app/modules/home/views/widget/nativehelper.dart';
import 'package:eliteinapp/app/modules/home/views/widget/webviewpage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.url.isNotEmpty
        ? WebViewMini()
        : Scaffold(
            backgroundColor: HexColor("#ffffff"),
            body: Center(
              child: Loader(),
            ),
          ));
  }
}
