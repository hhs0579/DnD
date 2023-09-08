import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/colors.dart';
import '../drawer.dart';

class EquipPage extends StatefulWidget {
  const EquipPage({super.key});

  @override
  State<EquipPage> createState() => _EquipPageState();
}

final GlobalKey webViewKey = GlobalKey();
Uri myUrl = Uri.parse("https://darkanddarker.wiki.spellsandguns.com/Armors");
late final InAppWebViewController webViewController;
double progress = 0;

class _EquipPageState extends State<EquipPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorList.primary,
        key: scaffoldKey,
        endDrawer: drawer(context),
        appBar: AppBar(
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.menu, // 이 아이콘을 당신이 원하는 아이콘으로 변경 가능
                  color: Colors.white, // 이곳에서 아이콘 색상을 변경
                ),
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer(); // endDrawer를 엽니다.
                },
              ),
            ],
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Container(
              child: const Text('장비',
                  style: TextStyle(
                      fontFamily: 'oldd',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white)),
            )),
        body: SafeArea(
            child: WillPopScope(
                onWillPop: () async {
                  if (await webViewController.canGoBack()) {
                    webViewController.goBack();
                    return Future.value(false); // 현재 페이지를 유지
                  } else {
                    return Future.value(true); // 현재 페이지를 종료
                  }
                },
                child: Column(children: <Widget>[
                  progress < 1.0
                      ? LinearProgressIndicator(
                          value: progress, color: Colors.blue)
                      : Container(),
                  Expanded(
                      child: Stack(children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: myUrl),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            javaScriptCanOpenWindowsAutomatically: true,
                            javaScriptEnabled: true,
                            useOnDownloadStart: true,
                            useOnLoadResource: true,
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: true,
                            allowFileAccessFromFileURLs: true,
                            allowUniversalAccessFromFileURLs: true,
                            verticalScrollBarEnabled: true,
                            userAgent:
                                'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36'),
                        android: AndroidInAppWebViewOptions(
                            useHybridComposition: true,
                            allowContentAccess: true,
                            builtInZoomControls: true,
                            thirdPartyCookiesEnabled: true,
                            allowFileAccess: true,
                            supportMultipleWindows: true),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                          allowsBackForwardNavigationGestures: true,
                        ),
                      ),
                      onLoadStop: (InAppWebViewController controller, uri) {
                        setState(() {
                          myUrl = uri!;
                        });
                      },
                      onCreateWindow: (controller, createWindowRequest) async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: InAppWebView(
                                  // Setting the windowId property is important here!
                                  windowId: createWindowRequest.windowId,
                                  initialOptions: InAppWebViewGroupOptions(
                                    android: AndroidInAppWebViewOptions(
                                      builtInZoomControls: true,
                                      thirdPartyCookiesEnabled: true,
                                    ),
                                    crossPlatform: InAppWebViewOptions(
                                      mediaPlaybackRequiresUserGesture: false,
                                      cacheEnabled: true,
                                      javaScriptEnabled: true,
                                      userAgent:
                                          "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
                                    ),
                                    ios: IOSInAppWebViewOptions(
                                      allowsInlineMediaPlayback: true,
                                      allowsBackForwardNavigationGestures: true,
                                    ),
                                  ),
                                  onCloseWindow: (controller) async {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                        return true;
                      },
                    )
                  ]))
                ]))));
  }
}
