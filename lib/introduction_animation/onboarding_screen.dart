import 'package:animate_do/animate_do.dart';
import 'package:eliteinapp/app/modules/home/views/widget/nativehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:eliteinapp/app/modules/home/bindings/home_binding.dart';
import 'package:eliteinapp/app/routes/app_pages.dart';
import 'package:eliteinapp/introduction_animation/onboarding_contents.dart';
import 'package:eliteinapp/introduction_animation/size_config.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    // Color(0xffDAD3C8),
    Color(0xffDCF6E6),

    Color.fromARGB(255, 247, 213, 188),
    Color(0xffDCF6E6),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: HexColor("FDCDE2"),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#FD1F88"),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: HexColor("#FD1F88"),
      systemNavigationBarDividerColor: HexColor("#FD1F88"),
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: HexColor("#FD1F88"),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return FadeInRight(
                  child: Image.asset(
                    contents[i].image,
                    width: 1.sw,
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
            _currentPage != contents.length - 1
                ? Positioned(
                    right: 0,
                    top: 5,
                    child: FadeInRight(
                      child: TextButton(
                        onPressed: () {
                          _controller.jumpToPage(contents.length - 1);
                        },
                        style: TextButton.styleFrom(
                          elevation: 0,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 13 : 17,
                          ),
                        ),
                        child: Text(
                          "Skip",
                          style:
                              TextStyle(color: HexColor("FDCDE2"), fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.shrink(),
                _currentPage + 1 == contents.length
                    ? FadeInRight(
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox.shrink(),
                              ElevatedButton(
                                onPressed: () async {
                                  await Permission.location.request();
                                  await Permission.camera.request();
                                  await Permission.mediaLibrary.request();
                                  await Permission.photos.request();
                                  await Permission.notification.request();
                                  await Permission.storage.request();
                                  await Permission.microphone.request();
                                  nb.setValue("into", true);
                                  Get.offAllNamed(Routes.HOME);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("FDCDE2"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  textStyle: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                child: Text(
                                  "Agree",
                                  style: TextStyle(color: HexColor("FC248A")),
                                ),
                              ),
                            ],
                          ),
                        ),
                    )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _currentPage > 0
                                ? FadeInLeft(
                                  child: TextButton(
                                      onPressed: () {
                                        _controller.jumpToPage(_currentPage - 1);
                                      },
                                      style: TextButton.styleFrom(
                                        elevation: 0,
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (width <= 550) ? 13 : 17,
                                        ),
                                      ),
                                      child: Text(
                                        "Back",
                                        style: TextStyle(
                                            color: HexColor("FDCDE2"),
                                            fontSize: 18),
                                      ),
                                    ),
                                )
                                : SizedBox.shrink(),
                            ElevatedButton(
                              onPressed: () {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("FDCDE2"),
                                shape: CircleBorder(
                                    side:
                                        BorderSide(color: HexColor("FDCDE2"))),
                                elevation: 0,
                                padding: const EdgeInsets.all(14),
                                textStyle: TextStyle(
                                    fontSize: (width <= 550) ? 13 : 17),
                              ),
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                color: HexColor("FC248A"),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
