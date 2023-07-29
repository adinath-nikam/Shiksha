import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ChatGPT/stores/ai_chat_store.dart';
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

Widget infoWidget(String infoTitle, String infoText, Color infoContentColor,
    Color infoBackgroundColor) {
  return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: infoBackgroundColor.withOpacity(0.5),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Icon(
          Icons.info_rounded,
          color: infoContentColor,
        ),
        minLeadingWidth: 5,
        title: customTextBold(
            text: infoTitle, textSize: 16, color: infoContentColor),
        subtitle: customTextRegular(
            text: infoText, textSize: 12, color: infoContentColor),
      ));
}

void showSnackBar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      showCloseIcon: true,
      closeIconColor: primaryWhiteColor,
      duration: Duration(milliseconds: 8000),
      content: Text(
        text,
      )));
}

Widget headerImage() {
  return const Align(
    alignment: Alignment.center,
    child: Image(
      image: AssetImage("assets/images/shiksha_logo_square_light.png"),
      height: 150,
      width: 150,
    ),
  );
}

Widget progressIndicator() {
  return const Center(
    child: const CircularProgressIndicator(
      color: primaryWhiteColor,
      backgroundColor: primaryDarkColor,
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
  print("current version: "+currentVersion.toString());
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

Widget showVersionCode() {
  return customTextBold(text: 'App Version 2.0.3+5', textSize: 12, color: primaryDarkColor.withOpacity(0.3));
}

Future<String> getUpdateURL() async {
  if (Platform.isAndroid) {
    DataSnapshot dataSnapshotAndroid = await FirebaseAPI()
        .firebaseDatabase
        .ref("SHIKSHA_APP/APP_UPDATE_URL/ANDROID")
        .get();
    String urlAndroid = dataSnapshotAndroid.value.toString();
    return urlAndroid;
  } else {
    DataSnapshot dataSnapshotIOS = await FirebaseAPI()
        .firebaseDatabase
        .ref("SHIKSHA_APP/APP_UPDATE_URL/IOS")
        .get();

    String urlIOS = dataSnapshotIOS.value.toString();
    return urlIOS;
  }
}

showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Platform.isIOS
          ? WillPopScope(
        onWillPop: () async => false,
            child: CupertinoAlertDialog(
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
                      String url = await getUpdateURL();
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
          )
          : WillPopScope(
        onWillPop: () async => false,
            child: AlertDialog(
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
                    function: () async {
                      String url = await getUpdateURL();

                      print(url);

                      launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
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
                  animatedRoute(const ProfileView()),
                );
              },
              child: Icon(
                Icons.account_circle_rounded,
                size: 30,
                color: primaryDarkColor,
              )),
          const Image(
            image:
                AssetImage("assets/images/shiksha_logo_horizontal_light.png"),
            height: 120,
            width: 120,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(animatedRoute(const SettingsView()));
            },
            child: Icon(
              Icons.settings_rounded,
              size: 30,
              color: primaryDarkColor,
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
            image: AssetImage('assets/images/क्षा_logo_dark.png'),
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

Route animatedRoute(final Widget activity) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => activity,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

Future<void> showDeleteConfirmationDialog(
  BuildContext context,
  String chatId,
) async {
  final store = Provider.of<AIChatStore>(context, listen: false);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: customTextBold(
            text: "Confirm Deletion ?", textSize: 18, color: primaryDarkColor),
        actions: <Widget>[
          TextButton(
            child: customTextBold(
                text: "Cancel", textSize: 16, color: primaryDarkColor),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: customTextBold(
                text: "Delete", textSize: 16, color: primaryRedColor),
            onPressed: () async {
              await store.deleteChatById(chatId);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
