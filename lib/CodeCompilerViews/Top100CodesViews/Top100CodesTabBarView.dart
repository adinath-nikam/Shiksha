import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../Components/common_component_widgets.dart';
import '../../colors/colors.dart';
import '../model_blog_posts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_code_editor/flutter_code_editor.dart';

import 'Top100CodesDetailView.dart';

class Top100CodesTabBarView extends StatefulWidget {
  const Top100CodesTabBarView({Key? key}) : super(key: key);

  @override
  State<Top100CodesTabBarView> createState() => _Top100CodesTabBarViewState();
}

class _Top100CodesTabBarViewState extends State<Top100CodesTabBarView> {
  Future<PostList> fetchPosts(
      {required String blogId, required String apiKey}) async {
    var postListUrl = Uri.https(
        "blogger.googleapis.com", "/v3/blogs/$blogId/posts/", {"key": apiKey});
    // String url = 'https://www.googleapis.com/blogger/v3/blogs/$blogId/posts?key=$apiKey';
    final response = await http.get(postListUrl);
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
              child: appBarCommon(context, "TOP 100 CODES")),
          backgroundColor: primaryWhiteColor,
          body: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: TabBar(
                      unselectedLabelColor: primaryDarkColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primaryDarkColor),
                      isScrollable: true,
                      tabs: [
                        Tab(
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: primaryDarkColor, width: 1)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "C",
                                style:
                                    TextStyle(fontFamily: "ProductSans-Bold"),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: primaryDarkColor, width: 1)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "C++",
                                style:
                                    TextStyle(fontFamily: "ProductSans-Bold"),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: primaryDarkColor, width: 1)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Java",
                                style:
                                    TextStyle(fontFamily: "ProductSans-Bold"),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: primaryDarkColor, width: 1)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Python",
                                style:
                                    TextStyle(fontFamily: "ProductSans-Bold"),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 0,
                ),
                Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FutureBuilder(
                            future: fetchPosts(
                                blogId: '7732100168008150577',
                                apiKey:
                                    'AIzaSyBDPlHIlNACtFCL7SQftcnWhMYOa6jkAaA'),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return progressIndicator();
                              } else
                                return ListView.builder(
                                  physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.posts.length ?? 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Card(
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: HtmlWidget(
                                                  HtmlUnescape().convert(
                                                      snapshot
                                                              .data
                                                              ?.posts[index]
                                                              .content ??
                                                          "no items"),
                                                  enableCaching: true,
                                                  textStyle: TextStyle(
                                                      fontFamily:
                                                          "ProductSans-Bold",
                                                      color: primaryDarkColor),
                                                ),
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () async {
                                                  Navigator.of(context).push(
                                                      animatedRoute(
                                                          Top100CodesDetailView(
                                                    codeContent: snapshot.data
                                                        !.posts[index].content,
                                                  )));

                                                  // await Clipboard.setData(
                                                  //     ClipboardData(
                                                  //         text: snapshot
                                                  //             .data!
                                                  //             .posts[index]
                                                  //             .content));
                                                  // showSnackBar(
                                                  //     context,
                                                  //     "Code Copied Successfully.",
                                                  //     primaryGreenColor);
                                                },
                                                child: Icon(Icons.copy_rounded,
                                                    color: primaryDarkColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                            }),
                      ),
                      Text("Tab 2"),
                      Text("Tab 3"),
                      Text("Tab 4"),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
