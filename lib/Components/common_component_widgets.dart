import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../HomeView/profile_view.dart';
import '../SettingsViews/settings_view.dart';
import '../colors/colors.dart';
import 'AuthButtons.dart';
import 'constants.dart';

// Custom Text Widget
Widget customTextBold(
    {required String text,
    required double textSize,
    required Color color,
    bool? softwrap}) {
  return Text(
    text,
    textAlign: TextAlign.left,
    overflow: TextOverflow.fade,
    softWrap: softwrap,
    style: TextStyle(
      fontSize: textSize,
      fontFamily: "ProductSans-Bold",
      color: color,
    ),
  );
}

Widget customTextRegular(
    {required String text,
    required double textSize,
    required Color color,
    bool? softwrap}) {
  return Text(
    text,
    textAlign: TextAlign.left,
    overflow: TextOverflow.fade,
    softWrap: softwrap,
    style: TextStyle(
      fontSize: textSize,
      fontFamily: "ProductSans-Regular",
      color: color,
    ),
  );
}

Widget commonAlertDialog(BuildContext context, String buttonText, Icon icon,
    Function function, int functionCount) {
  return AlertDialog(
    title:
        customTextBold(text: buttonText, textSize: 18, color: primaryDarkColor),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [icon],
        ),
      ],
    ),
    actions: <Widget>[
      CustomButton(
          text: 'OK',
          buttonSize: 50,
          context: context,
          function: () {
            for (int i = 0; i < functionCount; i++) {
              function();
            }
          })
    ],
  );
}

Widget madeInTAG() {
  return Center(
    child: customTextBold(
        text: "Built in Belgaum ❤", textSize: 14, color: primaryDarkColor),
  );
}

Widget termsAndConditionsText() {
  void launchTermsConditionsTab() async {
    try {
      launch('https://github.com');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  return GestureDetector(
    onTap: () => launchTermsConditionsTab(),
    child: Column(
      children: [
        customTextRegular(
            text: "On Clicking Submit You Agree to our",
            textSize: 14,
            color: primaryDarkColor),
        const SizedBox(
          height: 10,
        ),
        customTextBold(
            text: "Terms and Conditions.",
            textSize: 14,
            color: primaryBlueColor),
      ],
    ),
  );
}

void showSnackBar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(
        text,
      )));
}

Widget headerImage() {
  return const Align(
    alignment: Alignment.center,
    child: Image(
      image: AssetImage("assets/images/logo_main.png"),
      height: 150,
      width: 150,
    ),
  );
}

showLoaderDialog(BuildContext context, String progressIndicatorText) {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primaryWhiteColor,
            backgroundColor: primaryDarkColor,
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            child: customTextBold(
                text: progressIndicatorText,
                textSize: 16,
                color: primaryDarkColor),
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

versionCheck(context) async {
  late final PackageInfo info;
  late double currentVersion;
  late final FirebaseRemoteConfig remoteConfig;
  info = await PackageInfo.fromPlatform();
  currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
  remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 10),
  ));
  await remoteConfig.fetchAndActivate();
  try {
    if (kDebugMode) {
      print(remoteConfig.getString('force_update_current_version'));
    }
    double newVersion = double.parse(remoteConfig
        .getString('force_update_current_version')
        .trim()
        .replaceAll(".", ""));

    if (newVersion > currentVersion) {
      showVersionDialog(context);
    }
  } catch (exception) {
    if (kDebugMode) {
      print(exception);
    }
  }
}

showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Platform.isIOS
          ? CupertinoAlertDialog(
              title: customTextBold(
                  text: APP_UPDATE_DIALOG_TITLE,
                  textSize: 16,
                  color: primaryDarkColor),
              content: customTextBold(
                  text: APP_UPDATE_DIALOG_MESSAGE,
                  textSize: 16,
                  color: primaryDarkColor),
              actions: <Widget>[
                CustomButton(
                  text: "Update",
                  buttonSize: 50,
                  context: context,
                  function: () async {
                    if (await canLaunch(PLAY_STORE_URL)) {
                      await launchUrl(Uri.parse(PLAY_STORE_URL));
                    } else {
                      throw 'Could not launch $PLAY_STORE_URL';
                    }
                  },
                ),
              ],
            )
          : AlertDialog(
              title: customTextBold(
                  text: APP_UPDATE_DIALOG_TITLE,
                  textSize: 22,
                  color: primaryDarkColor),
              content: customTextBold(
                  text: APP_UPDATE_DIALOG_MESSAGE,
                  textSize: 16,
                  color: primaryDarkColor,
                  softwrap: true),
              actions: <Widget>[
                CustomButton(
                  text: "Update",
                  buttonSize: 50,
                  context: context,
                  function: () => launchUrl(Uri.parse(PLAY_STORE_URL)),
                ),
              ],
            );
    },
  );
}

Widget appBarHomeView({
  required BuildContext context,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(10),
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => const ProfileView()),
                );
              },
              child: Icon(
                Icons.account_circle_rounded,
                size: 30,
                color: primaryDarkColor,
              )),
          const Image(
            image: AssetImage("assets/images/logo_landscape.png"),
            height: 120,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const SettingsView()));
              },
              child: Icon(
                Icons.settings_rounded,
                size: 30,
                color: primaryDarkColor,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget appBarCommon(BuildContext context, String appbarTitle) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                Icons.arrow_back_rounded,
                color: primaryDarkColor,
                size: 30,
              )),
        ),
        const SizedBox(width: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          clipBehavior: Clip.antiAlias,
          child: const Image(
            width: 30,
            height: 30,
            image: AssetImage('assets/images/1.png'),
          ),
        ),
        const SizedBox(width: 8),
        customTextBold(
          text: appbarTitle,
          color: primaryDarkColor,
          textSize: 18,
        )
      ],
    ),
    backgroundColor: primaryWhiteColor,
    elevation: 0.5,
  );
}
