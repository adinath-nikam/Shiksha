import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AppBar.dart';
import 'package:shiksha/FirebaseServices/FirebaseService.dart';
import 'package:shiksha/ClubsViews/ClubsView.dart';
import 'package:shiksha/HomeView/HomeView.dart';
import 'package:shiksha/Models/ModelProfileData.dart';
import 'package:shiksha/WorkViews/WorkView.dart';
import 'package:shiksha/colors/colors.dart';

import '../ClubsViews/Temp_Events_View.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  // var emojiParser = EmojiParser();
  int index = 0;




  void signOut() async {
    firebaseAuthServices.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final buildBody = <Widget>[
      const HomeView(),
      ClubsView(),
      WorkView(),
    ];

    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(context: context),
      ),
      backgroundColor: PrimaryWhiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          backgroundColor: PrimaryDarkColor,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (x) {
            setState(() {
              index = x;
            });
          },
          elevation: 20,
          selectedItemColor: PrimaryWhiteColor,
          showSelectedLabels: false,
          unselectedItemColor: PrimaryWhiteColor.withAlpha(100),
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.homeOutline,
                  size: 28,
                ),
                label: "HOME"),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.cardsClubOutline, size: 28),
                label: "CLUBS"),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.briefcaseOutline, size: 28), label: "WORK"),

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
