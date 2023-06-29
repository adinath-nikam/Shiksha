import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class CodeCompilerDashBoard extends StatefulWidget {
  const CodeCompilerDashBoard({Key? key}) : super(key: key);

  @override
  State<CodeCompilerDashBoard> createState() => _CodeCompilerDashBoardState();
}

class _CodeCompilerDashBoardState extends State<CodeCompilerDashBoard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryYellowColor.withAlpha(80),
              ),
              child: customTextRegular(
                  text:
                      "Compilers for other Programming Languages will be added in Next Update",
                  textSize: 14,
                  color: primaryDarkColor),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref("SHIKSHA_APP/COMPILERS")
                      .onValue,
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();

                      return AnimationLimiter(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 20,
                              maxCrossAxisExtent: 200,
                            ),
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, index) {
                              return AnimationConfiguration.staggeredGrid(
                                duration: const Duration(milliseconds: 1000),
                                position: index,
                                columnCount: 2,
                                child: SlideAnimation(
                                  verticalOffset:
                                      MediaQuery.of(context).size.height,
                                  child: Container(
                                    height: 150.0,
                                    width: 150.0,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primaryDarkColor.withAlpha(50),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.code_rounded,
                                          color: primaryDarkColor,
                                          size: 35,
                                        ),
                                        customTextBold(
                                            text: list[index]['PL'],
                                            textSize: 18,
                                            color: primaryDarkColor),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    CompilerCProgramming(
                                                        url: list[index]
                                                            ['URL']),
                                                transitionsBuilder: (
                                                  BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child,
                                                ) =>
                                                    SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(1, 0),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryDarkColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15), // <-- Radius
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}

class CompilerCProgramming extends StatefulWidget {
  final String url;

  const CompilerCProgramming({Key? key, required this.url}) : super(key: key);

  @override
  State<CompilerCProgramming> createState() => _CompilerCProgrammingState();
}

class _CompilerCProgrammingState extends State<CompilerCProgramming> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    // controller.loadRequest(Uri.parse('https://www.programiz.com/c-programming/online-compiler/'));
    controller.loadRequest(Uri.parse(widget.url));
    controller.runJavaScript(
        "document.getElementsByClassName('header')[0].style.display='none';");
    controller
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
      controller.runJavaScript(
          "document.getElementsByClassName('header')[0].style.display='none';");
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "COMPILER")),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
