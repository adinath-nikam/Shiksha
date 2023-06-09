import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/SettingsViews/SettingsView.dart';

import '../AuthViews/SingInView.dart';
import '../HomeView/ProfileView.dart';

Widget CustomAppBar({
  required BuildContext context,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(10),
    child: Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => ProfileView()),
                );
              },
              child: Icon(
                MdiIcons.accountCircleOutline,
                size: 30,
              )),
          Image(
            image: AssetImage("assets/images/logo_landscape.png"),
            height: 120,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => SettingsView()));
              },
              child: Icon(
                MdiIcons.cogOutline,
                size: 30,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
