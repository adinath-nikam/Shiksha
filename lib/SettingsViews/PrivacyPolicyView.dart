import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: PrimaryDarkColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: CustomText(
            text: "Privacy Policy", textSize: 18, color: PrimaryDarkColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: PrimaryWhiteColor,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/images/logo_landscape.png"),
                  height: 180,
                  width: 180,
                ),
                CustomText(text: "This is Privacy Policy Text.", textSize: 14, color: PrimaryDarkColor),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(height: 50, indent: 20, endIndent: 20, thickness: 2,),),
                      CustomText(
                          text: " Follow Us ",
                          textSize: 14,
                          color: PrimaryDarkColor),
                      Expanded(
                        child: Divider(height: 50, indent: 20, endIndent: 20, thickness: 2,),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        MdiIcons.instagram,
                        color: PrimaryDarkColor,
                      ),
                      Icon(
                        MdiIcons.twitter,
                        color: PrimaryDarkColor,
                      ),
                      GestureDetector(
                        onTap: (){
                          try {
                            launch(
                                "https://www.github.com/adinath-nikam"
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: Icon(
                          MdiIcons.github,
                          color: PrimaryDarkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
