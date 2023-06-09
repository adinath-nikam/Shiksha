import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/ProfileBuildStepperView.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/HomeView/TabView.dart';
import 'package:shiksha/firebase_options.dart';
import 'package:shiksha/ChatGPT/utils/Chatgpt.dart';
import 'AuthViews/SingInView.dart';
import 'package:flutter/material.dart';
import 'Models/ModelProfileData.dart';
import 'colors/colors.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:shiksha/components/HideKeyboard.dart';
import 'package:shiksha/ChatGPT/page/AppOpenPage.dart';
import 'package:shiksha/ChatGPT/stores/AIChatStore.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/ChatGPT/utils/Chatgpt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");

  await GetStorage.init();
  await ChatGPT.initChatGPT();

  runApp(

    MaterialApp(
      color: PrimaryWhiteColor,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: ChangeNotifierProvider(
        create: (context) => AIChatStore(),
        child: const MyApp(),
      ),
    ),

    // MaterialApp(
    // color: PrimaryWhiteColor,
    // debugShowCheckedModeBanner: false,
    // home: const MyApp())

  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String APP_STORE_URL =
      'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
  String PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.whatsapp';

  @override
  void initState() {
    super.initState();
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }

  }

  versionCheck(context) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    final FirebaseRemoteConfig remoteConfig =
    await FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      // cache refresh time
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();

    try {
      print(remoteConfig.getString('force_update_current_version'));
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));

      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } catch (exception) {
      print(exception);
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available!";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update";
        return Platform.isIOS
            ? CupertinoAlertDialog(
          title: CustomText(
              text: title, textSize: 16, color: PrimaryDarkColor),
          content: CustomText(
              text: message, textSize: 16, color: PrimaryDarkColor),
          actions: <Widget>[
            CustomButton(
              text: btnLabel,
              buttonSize: 50,
              context: context,
              function: _launchURL(APP_STORE_URL),
            ),
          ],
        )
            : AlertDialog(
          title: CustomText(
              text: title, textSize: 22, color: PrimaryDarkColor),
          content: CustomText(
              text: message, textSize: 16, color: PrimaryDarkColor, softwrap: true),
          actions: <Widget>[
            CustomButton(
              text: btnLabel,
              buttonSize: 50,
              context: context,
              function: () => _launchURL(PLAY_STORE_URL),
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryWhiteColor,
        body: firebaseAuthServices.firebaseUser == null
            ? const SignInView()
            : StreamBuilder<ModelProfileData?>(
            stream: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const TabView();
              } else if (snapshot.hasError) {
                return ProfileBuildStepperView();
              } else {
                return const Center(child: ErrorView());
              }
            }),
      ),
    );
  }
}

class MySingletonClass{

  MySingletonClass._();
  BuildContext get context => context;

}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.trophyBroken,
            color: PrimaryDarkColor,
            size: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
              text: "Something went Wrong!",
              textSize: 16,
              color: PrimaryDarkColor),
          const SizedBox(
            height: 50,
          ),
          CustomButton(
              text: "Try Again!",
              buttonSize: 50,
              context: context,
              function: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}