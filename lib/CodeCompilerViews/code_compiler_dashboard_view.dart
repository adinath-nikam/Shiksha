import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CodeCompilerDashBoard extends StatefulWidget {
  const CodeCompilerDashBoard({Key? key}) : super(key: key);

  @override
  State<CodeCompilerDashBoard> createState() => _CodeCompilerDashBoardState();
}

class _CodeCompilerDashBoardState extends State<CodeCompilerDashBoard> {

  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    super.initState();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse('https://www.programiz.com/c-programming/online-compiler/'));
    controller.runJavaScript("document.getElementsByClassName('header')[0].style.display='none';");
    controller.setNavigationDelegate(
        NavigationDelegate(
            onPageFinished                    : (String url){
              controller.runJavaScript("document.getElementsByClassName('header')[0].style.display='none';");
            }
        ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: controller,
        ),
      ),
    );
  }
}