import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/colors/colors.dart';
import 'package:shiksha/main.dart';
import '../FirebaseServices/firebase_api.dart';
import '../Models/utilty_shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CollegeSelectView extends StatelessWidget {
  final bool isUpdate;

  const CollegeSelectView({Key? key, required this.isUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        toolbarHeight: 120, // Set this height
        backgroundColor: primaryWhiteColor,
        elevation: 0,
        flexibleSpace: Center(
            child: customTextBold(
                text: "Select your College..",
                textSize: 28,
                color: primaryDarkColor)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: StreamBuilder(
            stream: FirebaseAPI().realtimeDBStream("SHIKSHA_APP/COLLEGES"),
            builder:
                (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: progressIndicator(),
                );
              } else {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();

                return AnimationLimiter(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 1000),
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: const Icon(
                                      Icons.school_rounded,
                                      color: primaryDarkColor,
                                    ),
                                    title: customTextBold(
                                        text: list[index],
                                        textSize: 18,
                                        color: primaryDarkColor),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(animatedRoute(
                                          StreamSelectView(
                                            selectedCollege:
                                                list[index].toString(),
                                            isUpdate: isUpdate,
                                          ),
                                        ));
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryDarkColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    ));
  }
}

class StreamSelectView extends StatelessWidget {
  final String selectedCollege;
  final bool isUpdate;

  const StreamSelectView(
      {Key? key, required this.selectedCollege, required this.isUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        toolbarHeight: 120, // Set this height
        backgroundColor: primaryWhiteColor,
        elevation: 0,
        flexibleSpace: Center(
            child: customTextBold(
                text: "Select your Stream..",
                textSize: 28,
                color: primaryDarkColor)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: StreamBuilder(
            stream: FirebaseAPI().realtimeDBStream("SHIKSHA_APP/STREAMS"),
            builder:
                (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();

                return AnimationLimiter(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 1000),
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: const Icon(
                                      Icons.school_rounded,
                                      color: primaryDarkColor,
                                    ),
                                    title: customTextBold(
                                        text: list[index],
                                        textSize: 18,
                                        color: primaryDarkColor),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(animatedRoute(
                                          SemesterSelectView(
                                            selectedCollege: selectedCollege,
                                            selectedStream:
                                                list[index].toString(),
                                            isUpdate: isUpdate,
                                          ),
                                        ));
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryDarkColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    ));
  }
}

class SemesterSelectView extends StatelessWidget {
  final String selectedCollege, selectedStream;
  final bool isUpdate;

  const SemesterSelectView(
      {Key? key,
      required this.selectedCollege,
      required this.selectedStream,
      required this.isUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        toolbarHeight: 120, // Set this height
        backgroundColor: primaryWhiteColor,
        elevation: 0,
        flexibleSpace: Center(
            child: customTextBold(
                text: "Select your Semester..",
                textSize: 28,
                color: primaryDarkColor)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: StreamBuilder(
            stream: FirebaseAPI().realtimeDBStream("SHIKSHA_APP/SEMESTERS"),
            builder:
                (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();
                return AnimationLimiter(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 1000),
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: const Icon(
                                      Icons.school_rounded,
                                      color: primaryDarkColor,
                                    ),
                                    title: customTextBold(
                                        text: list[index],
                                        textSize: 18,
                                        color: primaryDarkColor),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(animatedRoute(
                                          UEPView(
                                            selectedCollege: selectedCollege,
                                            selectedStream: selectedStream,
                                            selectedSemester:
                                                list[index].toString(),
                                            isUpdate: isUpdate,
                                          ),
                                        ));
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryDarkColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    ));
  }
}

class UEPView extends StatefulWidget {
  final String selectedCollege, selectedStream, selectedSemester;
  final bool isUpdate;

  const UEPView(
      {Key? key,
      required this.selectedCollege,
      required this.selectedStream,
      required this.selectedSemester,
      required this.isUpdate})
      : super(key: key);

  @override
  State<UEPView> createState() => _UEPViewState();
}

class _UEPViewState extends State<UEPView> {
  UtilitySharedPreferences sharedPrefUserData = UtilitySharedPreferences();
  final GlobalKey<FormState> formKeyUEP = GlobalKey();
  late final ModelUserData signUpModelUserData;
  final TextEditingController controllerTextEditUSN = TextEditingController();
  final TextEditingController controllerTextEditEmail = TextEditingController();
  final TextEditingController controllerTextEditPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      controllerTextEditUSN.text = modelUserData.getUserUSN;
      controllerTextEditEmail.text = modelUserData.getUserEmail;
      controllerTextEditPhone.text = modelUserData.getUserPhone;
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    controllerTextEditUSN.dispose();
    controllerTextEditEmail.dispose();
    controllerTextEditPhone.dispose();
  }

  Future<bool> allowSignUp() async {
    DataSnapshot allowSignUpDataSnapshot = await FirebaseDatabase.instance
        .ref('SHIKSHA_APP/SIGNUP_LIMIT/LIMIT')
        .get();
    DataSnapshot dataSnapshot2 =
        await FirebaseDatabase.instance.ref('SHIKSHA_APP/USERS_DATA').get();
    int limit = allowSignUpDataSnapshot.value as int;
    int usersCount = dataSnapshot2.children.length;
    if (usersCount >= limit) {
      return false;
    } else {
      return true;
    }
  }

  temp() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        toolbarHeight: 120, // Set this height
        backgroundColor: primaryWhiteColor,
        elevation: 0,
        flexibleSpace: Center(
            child: customTextBold(
                text: "Few More Details...",
                textSize: 28,
                color: primaryDarkColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: AnimationLimiter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1000),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  infoWidget(
                      "Data Privacy",
                      "We Don't Collect any Data and all this data will reside on this device only. for more info read our privacy policy.",
                      primaryWhiteColor,
                      primaryRedColor),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: formKeyUEP,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controllerTextEditUSN,
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Enter USN...",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                icon: const Icon(
                                  Icons.school_rounded,
                                  color: primaryDarkColor,
                                  size: 30,
                                )),
                            style: TextStyle(
                                color: primaryDarkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "ProductSans-Bold"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "USN Required!";
                              } else if (value.toString().length < 7 ||
                                  value.toString().length > 14) {
                                return "Enter Valid USN";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: controllerTextEditEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                enabled: widget.isUpdate ? false : true,
                                hintText: "Enter Email...",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                icon: const Icon(
                                  Icons.email_rounded,
                                  color: primaryDarkColor,
                                  size: 30,
                                )),
                            style: TextStyle(
                                color: widget.isUpdate
                                    ? primaryDarkColor.withOpacity(0.5)
                                    : primaryDarkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "ProductSans-Bold"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "E-Mail Required!";
                              }
                              var rx = RegExp("\b*@gmail\.com\$",
                                  caseSensitive: false);
                              return rx.hasMatch(value)
                                  ? null
                                  : 'Invalid E-Mail Domain.';
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          widget.isUpdate
                              ? const SizedBox()
                              : customTextBold(
                                  text: "*Email Can't be Changed Later.",
                                  textSize: 12,
                                  color: primaryRedColor),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: controllerTextEditPhone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                enabled: widget.isUpdate ? false : true,
                                hintText: "Enter Phone Number...",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryDarkColor),
                                ),
                                icon: const Icon(
                                  Icons.phone_android_rounded,
                                  color: primaryDarkColor,
                                  size: 30,
                                )),
                            style: TextStyle(
                                color: widget.isUpdate
                                    ? primaryDarkColor.withOpacity(0.5)
                                    : primaryDarkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "ProductSans-Bold"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone Number Required!";
                              } else if (value.toString().length != 10) {
                                return "Enter Valid Phone Number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.isUpdate
                              ? const SizedBox()
                              : customTextBold(
                                  text: "*Phone Number Can't be Changed Later.",
                                  textSize: 12,
                                  color: primaryRedColor),
                        ],
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  AuthButtons(
                      buttonContext: context,
                      buttonSize: 70,
                      buttonText: "SUBMIT",
                      buttonFunction: () async {
                        if (formKeyUEP.currentState!.validate()) {
                          if (widget.isUpdate) {
                            try {
                              showLoaderDialog(context, "Building Profile...");
                              signUpModelUserData = ModelUserData(
                                  userUID: sha1
                                      .convert(utf8.encode(
                                          controllerTextEditEmail.text
                                                  .toString() +
                                              controllerTextEditPhone.text
                                                  .toString()))
                                      .toString(),
                                  userUSN: controllerTextEditUSN.text
                                      .toUpperCase()
                                      .toString(),
                                  userCollege: widget.selectedCollege,
                                  userSemester: widget.selectedSemester,
                                  userStream: widget.selectedStream,
                                  userEmail: modelUserData.getUserEmail,
                                  userPhone: modelUserData.getUserPhone,
                                  userJoiningDate:
                                      modelUserData.getUserJoiningDate);

                              sharedPrefUserData
                                  .save('SP_SHIKSHA_USER_DATA',
                                      signUpModelUserData)
                                  .whenComplete(() {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .push(animatedRoute(const MyApp()));
                              });
                            } catch (e) {
                              showSnackBar(
                                  context, e.toString(), primaryRedColor);
                            }
                          } else {
                            try {
                              if (await allowSignUp()) {
                                try {
                                  showLoaderDialog(
                                      context, "Building Profile...");
                                  signUpModelUserData = ModelUserData(
                                      userUID: sha1
                                          .convert(utf8.encode(
                                              controllerTextEditEmail.text
                                                      .toString() +
                                                  controllerTextEditPhone.text
                                                      .toString()))
                                          .toString(),
                                      userUSN: controllerTextEditUSN.text
                                          .toUpperCase()
                                          .toString(),
                                      userCollege: widget.selectedCollege,
                                      userSemester: widget.selectedSemester,
                                      userStream: widget.selectedStream,
                                      userEmail: controllerTextEditEmail.text
                                          .toString(),
                                      userPhone: controllerTextEditPhone.text
                                          .toString(),
                                      userJoiningDate:
                                          DateTime.now().toString());
                                  FirebaseAPI()
                                      .firebaseDatabase
                                      .ref(
                                          "SHIKSHA_APP/USERS_DATA/${signUpModelUserData.getUserUID}")
                                      .set({
                                    "user_id": signUpModelUserData.getUserUID,
                                    "last_active":
                                        signUpModelUserData.getUserJoiningDate
                                  }).whenComplete(() {
                                    sharedPrefUserData
                                        .save('SP_SHIKSHA_USER_DATA',
                                            signUpModelUserData)
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(animatedRoute(const MyApp()));
                                    });
                                  });
                                } catch (e) {
                                  showSnackBar(
                                      context, e.toString(), primaryRedColor);
                                }
                              } else {
                                showSnackBar(
                                    context,
                                    "We have temporarily halted the registration due to resource constraints, we will notify once we open the registrations.",
                                    primaryRedColor);
                              }
                            } catch (e) {
                              showSnackBar(
                                  context, e.toString(), primaryRedColor);
                            }
                          }
                        }
                      }),
                  const SizedBox(
                    height: 50,
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
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
