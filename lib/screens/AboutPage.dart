import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// https://qiita.com/mak_nm/items/42b122c6b607fc9e0cf0
class AboutPage extends StatefulWidget {
  AboutPage({super.key});
  
  @override
  State<AboutPage> createState() => AboutState();
}

class AboutState extends State<AboutPage> {

  late WebViewController controller;
  late Future<void> controllerInitialization;
  @override
  void initState() {
    super.initState();
    controllerInitialization = initController();
  }

  Future<void> initController() async {
    final html = await rootBundle.loadString('assets/index.html');
//    print(html);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
        // ページが読み込まれたときにJavaScriptからDartに変数を渡す
//        getJavaScriptVariable();
      }))
      ..loadRequest(
        Uri.dataFromString(
          html,
          mimeType: "text/html",
          encoding: Encoding.getByName("utf-8"),
        ),
      );
  }

  Future<void> getJavaScriptVariable() async {
    // JavaScriptの変数を取得
    print("----------------------------------");
    final test = await controller.runJavaScriptReturningResult("sendMs();");
    print(test);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: controllerInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 初期化が完了したらWebViewを表示
          return Scaffold(
            appBar: AppBar(title: Text("このゲームについて")),
            body: Stack(
            children:[
            Container(
                child: Image.asset('assets/image/maze.png')),
                Opacity( opacity: 0.8,
                child:WebViewWidget(controller: controller)),
            ]),
          );
        } else {
          // 初期化中はローディングなどを表示
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
