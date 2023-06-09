
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors/colors.dart';
import 'AuthButtons.dart';
import 'Constants.dart';
import 'ShowSnackBar.dart';

import 'package:url_launcher/url_launcher.dart';

// Custom Text Widget
Widget CustomText(
    {required String text, required double textSize, required Color color, bool? softwrap}) {
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

Widget CustomTextRegular(
    {required String text, required double textSize, required Color color, bool? softwrap}) {
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

Widget CommonAlertDialog(BuildContext context, String ButtonText, Icon icon, Function function, int functionCount) {
  return AlertDialog(
    title: CustomText(text: ButtonText, textSize: 18, color: PrimaryDarkColor),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Column(
              children: [
                icon
              ],
            )),
      ],
    ),
    actions: <Widget>[
      CustomButton(
          text: 'OK',
          buttonSize: 50,
          context: context,
          function: () {

            for(int i=0; i<functionCount; i++){
              function();
            }

            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          })
    ],
  );
}

// Terms and Conditions
Widget TermsAndConditionsText() {
  void launchTermsConditionsTab() async {
    try {
      // launch('https://github.com');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  return GestureDetector(
    onTap: () => launchTermsConditionsTab(),
    child: CustomText(
        text: "By Singing Up You Agree to our Terms and Conditions",
        textSize: 12,
        color: PrimaryDarkColor),
  );
}

//Header Image
Widget HeaderImage() {
  return Container(
    child: const Align(
      alignment: Alignment.center,
      child: Image(
        image: AssetImage("assets/images/logo_main.png"),
        height: 150,
        width: 150,
      ),
    ),
  );
}

// Circular Progress Indicator
showLoaderDialog(BuildContext context, String progressIndicatorText) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: CustomText(text: progressIndicatorText, textSize: 14, color: PrimaryDarkColor)),
      ],
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
        title: CustomText(
            text: APP_UPDATE_DIALOG_TITLE, textSize: 16, color: PrimaryDarkColor),
        content: CustomText(
            text: APP_UPDATE_DIALOG_MESSAGE, textSize: 16, color: PrimaryDarkColor),
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
        title: CustomText(
            text: APP_UPDATE_DIALOG_TITLE, textSize: 22, color: PrimaryDarkColor),
        content: CustomText(
            text: APP_UPDATE_DIALOG_MESSAGE,
            textSize: 16,
            color: PrimaryDarkColor,
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
