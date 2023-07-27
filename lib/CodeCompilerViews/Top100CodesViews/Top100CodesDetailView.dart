import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Components/common_component_widgets.dart';

class Top100CodesDetailView extends StatefulWidget {
  final String postURL;

  const Top100CodesDetailView({
    Key? key,
    required this.postURL,
  }) : super(key: key);

  @override
  State<Top100CodesDetailView> createState() => _Top100CodesDetailViewState();
}

class _Top100CodesDetailViewState extends State<Top100CodesDetailView> {
  bool _loading = false;
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.loadRequest(Uri.parse(widget.postURL));
    webViewController.setBackgroundColor(Colors.white);
    webViewController
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
      webViewController.runJavaScript(
          "document.getElementById('comments').style.display='none';");
      webViewController.runJavaScript(
          "document.getElementById('PopularPosts1').style.display='none';");
      webViewController.runJavaScript(
          "document.getElementsByTagName('header')[0].style.display='none';");
      webViewController.runJavaScript(
          "document.getElementsByTagName('footer')[0].style.display='none';");
      webViewController.runJavaScript(
          "document.getElementsByClassName('centered-top-placeholder')[0].style.display='none';");
      webViewController.runJavaScript(
          "document.getElementsByClassName('bg-photo-container')[0].style.display='none';");
      webViewController.runJavaScript(
          "document.getElementsByClassName('bg-photo-overlay')[0].style.display='none';");
      webViewController
          .runJavaScript("document.body.style.backgroundColor='white';");
      setState(() {
        _loading = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "TOP 100 CODES")),
        body: _loading
            ? WebViewWidget(
                controller: webViewController,
              )
            : progressIndicator(),
      ),
    );
  }
}
