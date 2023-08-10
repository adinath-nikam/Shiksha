import 'package:flutter/material.dart';
import 'package:shiksha/CodeCompilerViews/code_compiler_dashboard_view.dart';
import 'package:shiksha/CodeCompilerViews/interview_prep_view.dart';

import '../colors/colors.dart';

class CCTabBarView extends StatefulWidget {
  const CCTabBarView({Key? key}) : super(key: key);

  @override
  State<CCTabBarView> createState() => _CCTabBarViewState();
}

class _CCTabBarViewState extends State<CCTabBarView> with AutomaticKeepAliveClientMixin<CCTabBarView> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: TabBar(
                  unselectedLabelColor: primaryDarkColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primaryDarkColor),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: primaryDarkColor, width: 1)),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Preparation",
                            style: TextStyle(fontFamily: "ProductSans-Bold"),
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
                            border:
                                Border.all(color: primaryDarkColor, width: 1)),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Code",
                            style: TextStyle(fontFamily: "ProductSans-Bold"),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                children: [
                  InterviewPrepView(),
                  CodeCompilerDashBoard(),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
