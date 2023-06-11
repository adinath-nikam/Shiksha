import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/AuthViews/ProfileBuildStepperView.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/HomeView/TabView.dart';
import 'package:shiksha/firebase_options.dart';
import 'package:shiksha/ChatGPT/utils/Chatgpt.dart';
import 'AuthViews/SingInView.dart';
import 'package:flutter/material.dart';
import 'ChatGPT/page/AppOpenPage.dart';
import 'Components/Constants.dart';
import 'Models/ModelProfileData.dart';
import 'colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shiksha/ChatGPT/stores/AIChatStore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  await GetStorage.init();
  await ChatGPT.initChatGPT();

  runApp(
      const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    try {
      versionCheck(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AIChatStore(),
      child: MaterialApp(
        color: PrimaryWhiteColor,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home:
        // SplashPage(),
        SafeArea(
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
        ),
      ),
    );
  }
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
