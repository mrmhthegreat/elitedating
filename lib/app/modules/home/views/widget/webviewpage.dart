// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:get/get.dart';
import 'package:eliteinapp/app/modules/home/views/widget/nativehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:eliteinapp/introduction_animation/components/notification.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/home_controller.dart';

class WebViewMini extends StatefulWidget {
  @override
  State<WebViewMini> createState() => _WebViewMiniState();
}

class _WebViewMiniState extends State<WebViewMini> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  var controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      // sub(context);
    });
  }

  var hidestaus = true.obs;
  setnavbarcolor(String a) {
    if (a == "Yes") {
      setStatusBarColor(Colors.transparent);
      if (!hidestaus.value) {
        hidestaus.value = true;
      }
    } else {
      if (hidestaus.value) {
        setStatusBarColor(HexColor("#F40176"));
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: HexColor("#FFFFFF"),
      systemNavigationBarDividerColor: HexColor("#FFFFFF"),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
        hidestaus.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context){

    return WillPopScope(
      onWillPop: () => controller.backbuton(context),
      child: Obx(
        () => Scaffold(
          extendBody: hidestaus.value,
          extendBodyBehindAppBar: hidestaus.value,
          backgroundColor: HexColor("#F40176"),
          body: controller.error.value
              ? errorpage()
              : Column(
                children: [
                  !hidestaus.value? 30.height:0.height,
                  Expanded(
                    child: InAppWebView(
                        onGeolocationPermissionsShowPrompt:
                            (InAppWebViewController controller, String origin) async {
                          return Future.value(GeolocationPermissionShowPromptResponse(
                              origin: origin, allow: true, retain: true));
                        },
                        onPermissionRequest: (
                          InAppWebViewController controller,
                          PermissionRequest origin,
                        ) async {
                          if (origin.resources.isNotEmpty) {
                            await Permission.microphone.request();
                            await Permission.audio.request();
                            await Permission.camera.request();
                            await Permission.microphone.request();
                          }
                          return PermissionResponse(
                              resources: origin.resources,
                              action: PermissionResponseAction.GRANT);
                        },
                        initialUserScripts: UnmodifiableListView([]),
                        initialUrlRequest:
                            URLRequest(url: WebUri(controller.url.value)),
                        initialSettings: ininitsetting(),
                        onWebViewCreated: (InAppWebViewController controlle) {
                          controller.ctrl = controlle;
                          controlle.addJavaScriptHandler(
                            handlerName: "filedownloadfluuter",
                            callback: (data) async {
                              if (data.isNotEmpty) {
                                final String receivedFileInBase64 = data[0];
                                setnavbarcolor(receivedFileInBase64);
                              }
                            },
                          );
                        },
                        onProgressChanged: (controlle, progress) async {
                          if (progress == 100) {
                          
                            controller.pullToRefreshController.endRefreshing();
                          }
                        },
                        // onLoadHttpError:
                        //     (controller, url, statusCode, description) {
                        //   setState(() {
                        //     error = true;
                        //   });
                        // },
                        onEnterFullscreen: (ctrl) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp,
                          ]);
                        },
                        onExitFullscreen: (ctrl) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp,
                          ]);
                        },
                        shouldOverrideUrlLoading: urlwatcher,
                        onJsConfirm: (controller, jsConfirmRequest) async {
                          JsConfirmResponseAction.CONFIRM;
                        },
                        onDownloadStartRequest: ondownloadstart,
                        onPrint: onprintauto,
                        onJsAlert: ((controller, jsAlertRequest) async {}),
                        pullToRefreshController: controller.pullToRefreshController,
                       
                        onTitleChanged:(controller, title) {
                          if(title=="Elite"){
                            setnavbarcolor("Yes");
                          }else{
                            setnavbarcolor("No");

                          }
                        },
                        onLoadStop: (ctr, urli) async {
                          controller.startloading(false);
                  
                          controller.pullToRefreshController.endRefreshing();
                        },
                        onPrintRequest: (controller, url, printJobController) async {
                          // handle the print job
                          return true;
                        },
                        onLoadError: (controlleer, url, code, message) {
                          controller.pullToRefreshController.endRefreshing();
                  
                          controller.error.value = true;
                        },
                        onLoadStart: (ctr, urli) {
                          controller.startloading(true);
                  
                          controller.pullToRefreshController.endRefreshing();
                        }),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  InAppWebViewSettings ininitsetting() {
    return InAppWebViewSettings(
      disableHorizontalScroll: false,
      useOnDownloadStart: true,
      allowBackgroundAudioPlaying: false,
      allowsPictureInPictureMediaPlayback: false,
      cacheEnabled: true,
      geolocationEnabled: true,
      transparentBackground: true,
      verticalScrollBarEnabled: false,
      supportZoom: false,
      useHybridComposition: false,
      javaScriptCanOpenWindowsAutomatically: true,
      javaScriptEnabled: true,
      
      preferredContentMode: UserPreferredContentMode.MOBILE,
      userAgent:
          'Mozilla/5.0 (Linux; Android 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Mobile Safari/537.36',
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    );
  }

  Widget errorpage() {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/10_Connection Lost.png'),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Align(
          alignment: FractionalOffset.bottomRight,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: RawMaterialButton(
              onPressed: () async {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult != ConnectivityResult.none) {
                  controller.error.value = false;
                }
              },
              elevation: 2.0,
              fillColor: Colors.amberAccent,
              padding: const EdgeInsets.all(18.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.refresh,
                color: Colors.blueGrey,
                size: 38.0,
              ),
            ),
          ),
        ));
  }

  void ondownloadstart(controller, url) async {
    if (await Permission.storage.isGranted) {
      var appDirectory = await getExternalStorageDirectory();
      var filename =
          "doc_${DateTime.now().microsecondsSinceEpoch.toString()}.${url.suggestedFilename!.split('.')[1]}";
      if (appDirectory != null) {
        await FlutterDownloader.enqueue(
            url: url.url.toString(),
            savedDir: appDirectory.path,
            fileName: filename,
            showNotification:
                true, // show download progress in status bar (for Android)
            openFileFromNotification: true,
            saveInPublicStorage: true);
      } else {
        var d = await getApplicationDocumentsDirectory();
        await FlutterDownloader.enqueue(
          url: url.url.toString(),
          savedDir: d.path,
          fileName: filename,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: false,
        );
      }
    } else {
      await Permission.storage.request();
    }
  }

  void onprintauto(InAppWebViewController controller, Uri? url) async {
    var webViewController = controller;
    if (await Permission.storage.isGranted) {
      var widgetsBingind = WidgetsBinding.instance;
      if (widgetsBingind.window.viewInsets.bottom > 0.0) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
        await webViewController.evaluateJavascript(
            source: "document.activeElement.blur();");
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // }

      var a = await controller
          .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration())
          .timeout(
            const Duration(milliseconds: 1500),
            onTimeout: () => null,
          );

      if (a != null) {
        var appDirectory = await getExternalStorageDirectory();

        if (appDirectory != null) {
          final pathOfImage = await File(
                  '${appDirectory.path}/${DateTime.now().millisecond.toString()}.png')
              .create();
          final Uint8List bytes = a.buffer.asUint8List();
          await pathOfImage.writeAsBytes(bytes);
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final pathOfImage = await File(
                  '${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png')
              .create();
          final Uint8List bytes = a.buffer.asUint8List();
          await pathOfImage.writeAsBytes(bytes);
        }
      }
    } else {
      await Permission.storage.request();
    }
  }

  Future<NavigationActionPolicy?> urlwatcher(controlleer, request) async {
    var uri = request.request.url;

    var url = request.request.url.toString();

    if (Platform.isAndroid && url.contains("intent")) {
      if (url.contains("maps")) {
        var mNewURL = url.replaceAll("intent://", "https://");
        if (await canLaunchUrl(Uri.parse(mNewURL))) {
          await launchUrl(Uri.parse(mNewURL));
          return NavigationActionPolicy.CANCEL;
        }
      } else {
        String id =
            url.substring(url.indexOf('id%3D') + 5, url.indexOf('#Intent'));
        await StoreRedirect.redirect(androidAppId: id);
        return NavigationActionPolicy.CANCEL;
      }
    } else if (url.contains("linkedin.com") ||
        url.contains("market://") ||
        url.contains("whatsapp://") ||
        url.contains("truecaller://") ||
        url.contains("facebook.com") ||
        url.contains("twitter.com") ||
        url.contains("wa.me") ||
        url.contains("api.whatsapp.com") ||
        url.contains("reddit.com") ||
        url.contains("tiktok.com") ||
        url.contains("youtube.com") ||
        url.contains("t.me") ||
        url.contains("wa.link") ||
        url.contains("www.google.com/maps") ||
        url.contains("pinterest.com") ||
        url.contains("snapchat.com") ||
        url.contains("instagram.com") ||
        url.contains("www.amazon.com") ||
        url.contains("play.google.com") ||
        url.contains("mailto:") ||
        url.contains("tel:") ||
        url.contains("google.it") ||
        url.contains("share=telegram") ||
        url.contains("messenger.com")) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
        return NavigationActionPolicy.CANCEL;
      } catch (e) {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        return NavigationActionPolicy.CANCEL;
      }
    } else if (!["http", "https", "chrome", "data", "javascript", "about"]
        .contains(uri!.scheme)) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        return NavigationActionPolicy.CANCEL;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }
}
