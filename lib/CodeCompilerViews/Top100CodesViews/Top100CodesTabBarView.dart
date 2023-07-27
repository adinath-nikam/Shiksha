import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Components/common_component_widgets.dart';
import '../../colors/colors.dart';
import '../model_blog_posts.dart';
import 'package:http/http.dart' as http;
import 'Top100CodesDetailView.dart';

class Top100CodesTabBarView extends StatefulWidget {
  const Top100CodesTabBarView({Key? key}) : super(key: key);

  @override
  State<Top100CodesTabBarView> createState() => _Top100CodesTabBarViewState();
}

class _Top100CodesTabBarViewState extends State<Top100CodesTabBarView> {
  final String blogAPIKey = 'AIzaSyBDPlHIlNACtFCL7SQftcnWhMYOa6jkAaA';

  Future<PostList> fetchPosts({required String blogId}) async {
    var postListUrl = Uri.https("blogger.googleapis.com",
        "/v3/blogs/$blogId/posts/", {"key": blogAPIKey, "orderBy": "updated"});
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return PostList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Widget codesBlogPostList({required String blogID}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
          future: fetchPosts(blogId: blogID),
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
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: primaryDarkColor, width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(animatedRoute(
                              Top100CodesDetailView(
                                  postURL:
                                  snapshot.data!.posts[index].postURL)));
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.tag_rounded,
                                      color: primaryDarkColor),
                                ),
                                TextSpan(
                                  style: TextStyle(
                                      color: primaryDarkColor,
                                      fontSize: 22,
                                      fontFamily: "ProductSans-Bold"),
                                  text: (index + 1).toString(),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_rounded,
                            color: primaryDarkColor,
                          ),
                          title: customTextBold(
                              text:
                                  snapshot.data?.posts[index].title ?? "No Items",
                              textSize: 18,
                              color: primaryDarkColor),
                        ),
                      ),
                    ),
                  );
                },
              );
          }),
    );
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
                      codesBlogPostList(blogID: '7732100168008150577'),
                      codesBlogPostList(blogID: '1537449566359078152'),
                      codesBlogPostList(blogID: '7613365311281289112'),
                      codesBlogPostList(blogID: '3868467066831585989'),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
