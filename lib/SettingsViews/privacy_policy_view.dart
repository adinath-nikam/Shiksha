import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "PRIVACY POLICY")),
      backgroundColor: primaryWhiteColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage("assets/images/logo_landscape.png"),
                height: 180,
                width: 180,
              ),
              customTextBold(text: "This is Privacy Policy Text.", textSize: 14, color: primaryDarkColor),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(height: 50, indent: 20, endIndent: 20, thickness: 2,),),
                    customTextBold(
                        text: " Follow Us ",
                        textSize: 14,
                        color: primaryDarkColor),
                    const Expanded(
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
                      color: primaryDarkColor,
                    ),
                    Icon(
                      MdiIcons.twitter,
                      color: primaryDarkColor,
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
                        color: primaryDarkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
