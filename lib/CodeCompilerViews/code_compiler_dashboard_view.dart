import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Components/common_component_widgets.dart';
import '../FirebaseServices/firebase_api.dart';
import '../colors/colors.dart';


class CodeCompilerDashBoard extends StatefulWidget {
  const CodeCompilerDashBoard({Key? key}) : super(key: key);

  @override
  State<CodeCompilerDashBoard> createState() => _CodeCompilerDashBoardState();
}

class _CodeCompilerDashBoardState extends State<CodeCompilerDashBoard>
    with AutomaticKeepAliveClientMixin<CodeCompilerDashBoard> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            infoWidget(
                "Welcome to Shiksha App",
                "Now you Can Code in Many Different Programming Languages. 👩‍💻",
                primaryDarkColor,
                primaryGreenColor),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: StreamBuilder(
                  stream:
                      FirebaseAPI().realtimeDBStream("SHIKSHA_APP/COMPILERS"),
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return progressIndicator();
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();

                      return AnimationLimiter(
                        child: GridView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
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
                                        SvgPicture.network(
                                          list[index]['ICON'],
                                          semanticsLabel:
                                              'programming language icon',
                                          height: 50,
                                          width: 50,
                                          placeholderBuilder:
                                              (BuildContext context) =>
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30.0),
                                                      child:
                                                          progressIndicator()),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                animatedRoute(CompilerView(
                                              url: list[index]['URL']
                                            )));
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

class CompilerView extends StatefulWidget {
  final String url;

  const CompilerView(
      {Key? key,
      required this.url,})
      : super(key: key);

  @override
  State<CompilerView> createState() => _CompilerViewState();
}

class _CompilerViewState extends State<CompilerView> {
  bool _loading = false;
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse(widget.url));
    controller
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
      controller.runJavaScript(
          "document.getElementsByClassName('header')[0].style.display='none';");
      controller.runJavaScript(
          "document.getElementsByClassName('mobile-run-button run')[0].style.display='none'");
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
            child: appBarCommon(context, "COMPILER")),
        body: _loading
            ? WebViewWidget(
          controller: controller,
        )
            : progressIndicator(),
      ),
    );
  }
}
