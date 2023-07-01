import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/HomeView/main_tab_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/firebase_options.dart';
import 'package:shiksha/ChatGPT/utils/chat_gpt.dart';
import 'AuthViews/singin_view.dart';
import 'package:flutter/material.dart';
import 'AuthViews/college_select_view.dart';
import 'colors/colors.dart';
import 'package:shiksha/ChatGPT/stores/ai_chat_store.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await ChatGPT.initChatGPT();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

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
        color: primaryWhiteColor,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: SafeArea(
          child: Scaffold(
            backgroundColor: primaryWhiteColor,
            body: firebaseAuthServices.firebaseUser == null
                ? const SignInView()
                : StreamBuilder<ModelUserData?>(
                    stream: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        FlutterNativeSplash.remove();
                        return const TabView();
                      } else if (snapshot.hasError) {
                        FlutterNativeSplash.remove();
                        print(snapshot.hasError);
                        return const CollegeSelectView();
                      } else {
                        FlutterNativeSplash.remove();
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
