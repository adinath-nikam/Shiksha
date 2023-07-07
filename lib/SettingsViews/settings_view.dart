import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:shiksha/AuthViews/splash_view.dart';
import 'package:shiksha/Models/model_user_data.dart';

import 'package:shiksha/colors/colors.dart';
import 'package:shiksha/main.dart';

import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../HomeView/main_tab_view.dart';
import '../Models/utilty_shared_preferences.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "SETTINGS")),
        backgroundColor: primaryWhiteColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage(
                        "assets/images/shiksha_logo_horizontal_light.png"),
                    height: 120,
                    width: 120,
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextBold(
                                  text: "Account",
                                  textSize: 16,
                                  color: primaryDarkColor),
                            ],
                          ),
                          const Divider(
                            height: 50,
                            thickness: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              try {
                                launch(
                                    'https://github.com/adinath-nikam/Shiksha-Documentation/blob/main/docs/terms_and_conditions.md');
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.label_rounded,
                                  color: primaryDarkColor,
                                ),
                                customTextBold(
                                    text: "Terms and Conditions",
                                    textSize: 16,
                                    color: primaryDarkColor),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 50,
                            thickness: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              try {
                                launch(
                                    'https://github.com/adinath-nikam/Shiksha-Documentation/blob/main/docs/privacy_policy.md');
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.security_rounded,
                                ),
                                customTextBold(
                                    text: "Privacy Policy",
                                    textSize: 16,
                                    color: primaryDarkColor),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 50,
                            thickness: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              try {
                                launch(
                                    'https://github.com/adinath-nikam/Shiksha-Documentation/blob/main/docs/about_us.md');
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                    color: primaryDarkColor
                                ),
                                customTextBold(
                                    text: "About Us",
                                    textSize: 16,
                                    color: primaryDarkColor),
                                Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 50,
                            thickness: 2,
                          ),
                          CustomButton(
                              text: "DELETE ACCOUNT",
                              buttonSize: 60,
                              context: context,
                              function: () {

                                try {
                                  UtilitySharedPreferences()
                                      .remove("SP_SHIKSHA_USER_DATA")
                                      .whenComplete(() {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        animatedRoute(IntroView()),(Route<dynamic> route) => false);
                                  });
                                } catch (e) {
                                  showSnackBar(context, e.toString(), primaryRedColor);
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Image(
                      height: 150,
                      width: 150,
                      image: AssetImage("assets/images/tag_mib.png")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
