import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Components/common_component_widgets.dart';
import '../FirebaseServices/firebase_api.dart';
import '../colors/colors.dart';
import 'package:http/http.dart' as http;
import 'model_blog_posts.dart';

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
                "Welcome to Code Compiler! 🎉",
                "'Top 100 Codes' included in compiler, Slide up to view in compiler.",
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
                                              url: list[index]['URL'],
                                              codeBlogID: list[index]
                                                  ['BLOG_ID'],
                                              blogAPIKey: list[index]
                                                  ['BLOG_API_KEY'],
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
  final String url, codeBlogID, blogAPIKey;

  const CompilerView(
      {Key? key,
      required this.url,
      required this.codeBlogID,
      required this.blogAPIKey})
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

  Future<PostList> fetchPosts(
      {required String blogId, required String apiKey}) async {
    var postListUrl = Uri.https(
        "blogger.googleapis.com", "/v3/blogs/$blogId/posts/", {"key": apiKey});
    // String url = 'https://www.googleapis.com/blogger/v3/blogs/$blogId/posts?key=$apiKey';
    final response = await http.get(postListUrl);
    print(response.body);
    if (response.statusCode == 200) {
      return PostList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "COMPILER")),
        body: Stack(
          children: [
            _loading
                ? WebViewWidget(
                    controller: controller,
                  )
                : progressIndicator(),
            DraggableScrollableSheet(
              initialChildSize: 0.05,
              minChildSize: 0.05,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: primaryWhiteColor,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryDarkColor.withOpacity(0.5),
                            ),
                            height: 10,
                            width: 50,
                            margin: EdgeInsets.symmetric(vertical: 10),
                          ),
                          FutureBuilder(
                              future: fetchPosts(
                                  blogId: widget.codeBlogID,
                                  apiKey: widget.blogAPIKey),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return progressIndicator();
                                } else
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.posts.length ?? 1,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: primaryDarkColor,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          leading: const Icon(
                                            Icons.code_rounded,
                                            color: primaryDarkColor,
                                          ),
                                          title: customTextBold(
                                              text: snapshot.data?.posts[index]
                                                      .title ??
                                                  "no items",
                                              textSize: 18,
                                              color: primaryDarkColor),
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          children: <Widget>[
                                            ListTile(
                                              subtitle: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: HtmlWidget(
                                                  HtmlUnescape().convert(snapshot
                                                          .data
                                                          ?.posts[index]
                                                          .content ??
                                                      "no items"),
                                                  enableCaching: true,
                                                ),
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () async {
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: snapshot
                                                              .data!
                                                              .posts[index]
                                                              .content));
                                                  showSnackBar(
                                                      context,
                                                      "Code Copied Successfully.",
                                                      primaryGreenColor);
                                                },
                                                child: Icon(Icons.copy_rounded,
                                                    color: primaryDarkColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
