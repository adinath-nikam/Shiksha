import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:shiksha/AuthViews/splash_view.dart';
import 'package:shiksha/colors/colors.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Models/utilty_shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  late final String aboutURL,tcURL,ppURL;
  late final Map wordOfTheDay;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance
        .ref('SHIKSHA_APP/SETTINGS/URLS')
        .once()
        .then((value) {
      Map settingsURLS = value.snapshot.value as Map;

      setState(() {
        aboutURL = settingsURLS['ABOUT_URL'];
        tcURL = settingsURLS['TC_URL'];
        ppURL = settingsURLS['PP_URL'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "SETTINGS")),
        backgroundColor: primaryWhiteColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                                launch(tcURL);
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
                                launch(ppURL);
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
                                launch(aboutURL);
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
                          CustomDeleteButton(
                              text: "DELETE ACCOUNT",
                              buttonHeight: 55,
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
                  SizedBox(height: 50,),
                  customTextBold(text: "Made with ♥ in Belgaum", textSize: 14, color: primaryDarkColor.withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
