import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/HomeView/main_tab_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/Models/utilty_shared_preferences.dart';
import 'package:shiksha/firebase_options.dart';
import 'package:shiksha/ChatGPT/utils/chat_gpt.dart';
import 'AuthViews/singin_view.dart';
import 'package:flutter/material.dart';
import 'AuthViews/college_select_view.dart';
import 'Models/ModelProfileData.dart';
import 'colors/colors.dart';
import 'package:shiksha/ChatGPT/stores/ai_chat_store.dart';
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

  Future<bool> checkIfUserDataExist() async {
    if (await UtilitySharedPreferences().check('SP_SHIKSHA_USER_DATA')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AIChatStore(),
      child: MaterialApp(
        color: primaryWhiteColor,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: SafeArea(
          child: Scaffold(
              backgroundColor: primaryWhiteColor,
              body: firebaseAuthServices.firebaseUser == null
                  ? const SignInView()
                  : FutureBuilder(
                      future: getUserData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<ModelUserData> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: primaryDarkColor,
                          ));
                        } else if (snapshot.data != null) {
                          return const TabView();
                        } else {
                          return const CollegeSelectView();
                        }
                      },
                    )),
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
            color: primaryDarkColor,
            size: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          customTextBold(
              text: "Something went Wrong!",
              textSize: 16,
              color: primaryDarkColor),
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