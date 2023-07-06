import 'package:flutter/material.dart';
import 'package:shiksha/ClubsViews/clubs_view.dart';
import 'package:shiksha/HomeView/home_view.dart';
import 'package:shiksha/WorkViews/work_view.dart';
import 'package:shiksha/colors/colors.dart';
import '../CodeCompilerViews/code_compiler_dashboard_view.dart';
import '../Components/common_component_widgets.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final buildBody = <Widget>[
      const HomeView(),
      const CodeCompilerDashBoard(),
      const ClubsView(),
      const WorkView(),
    ];

    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: appBarHomeView(context: context),
      ),
      backgroundColor: primaryWhiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          backgroundColor: primaryDarkColor,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (x) {
            setState(() {
              index = x;
            });
          },
          elevation: 20,
          selectedItemColor: primaryWhiteColor,
          showSelectedLabels: false,
          unselectedItemColor: primaryWhiteColor.withAlpha(100),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                label: "HOME"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.code_rounded,
                  size: 30,
                ),
                label: "CODE"),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_outlined, size: 30), label: "CLUBS"),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_outline_rounded, size: 30),
                label: "WORK"),
          ],
        ),
      ),
      body: IndexedStack(
        index: index,
        children: buildBody,
      ),
    ));
  }
}
