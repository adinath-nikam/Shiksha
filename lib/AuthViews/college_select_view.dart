import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/HomeView/main_tab_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/colors/colors.dart';
import '../Components/constants.dart';
import '../Models/utilty_shared_preferences.dart';

class CollegeSelectView extends StatelessWidget {
  const CollegeSelectView({Key? key}) : super(key: key);

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
            stream:
                FirebaseDatabase.instance.ref("SHIKSHA_APP/COLLEGES").onValue,
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
                                      side: BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: Icon(
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
                                          ),
                                        ));
                                      },
                                      child: Icon(
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

  const StreamSelectView({Key? key, required this.selectedCollege})
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
            stream:
                FirebaseDatabase.instance.ref("SHIKSHA_APP/STREAMS").onValue,
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
                                      side: BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: Icon(
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
                                          ),
                                        ));
                                      },
                                      child: Icon(
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

  const SemesterSelectView(
      {Key? key, required this.selectedCollege, required this.selectedStream})
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
            stream:
                FirebaseDatabase.instance.ref("SHIKSHA_APP/SEMESTERS").onValue,
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
                                      side: BorderSide(
                                          color: primaryDarkColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    leading: Icon(
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
                                          USNSelectView(
                                            selectedCollege: selectedCollege,
                                            selectedStream: selectedStream,
                                            selectedSemester:
                                                list[index].toString(),
                                          ),
                                        ));
                                      },
                                      child: Icon(
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

class USNSelectView extends StatefulWidget {
  final String selectedCollege, selectedStream, selectedSemester;

  const USNSelectView(
      {Key? key,
      required this.selectedCollege,
      required this.selectedStream,
      required this.selectedSemester})
      : super(key: key);

  @override
  State<USNSelectView> createState() => _USNSelectViewState();
}

class _USNSelectViewState extends State<USNSelectView> {
  UtilitySharedPreferences sharedPrefUserData = UtilitySharedPreferences();
  late final ModelUserData modelUserData;
  bool validateUSN = false;
  final TextEditingController controllerTextEditUSN = TextEditingController();

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
                text: "Enter your USN..",
                textSize: 28,
                color: primaryDarkColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
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
                  TextField(
                    controller: controllerTextEditUSN,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        hintText: "E.g. 2KL20CS...",
                        errorText: validateUSN ? 'USN Can\'t Be Empty!' : null,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: primaryDarkColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: primaryDarkColor),
                        ),
                        icon: Icon(
                          Icons.school_rounded,
                          color: primaryDarkColor,
                          size: 38,
                        )),
                    style: TextStyle(
                        color: primaryDarkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: "ProductSans-Bold"),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  AuthButtons(
                      buttonContext: context,
                      buttonSize: 70,
                      buttonText: "SUBMIT",
                      buttonFunction: () {
                        setState(() {
                          if (controllerTextEditUSN.text.isEmpty) {
                            validateUSN = true;
                          } else {
                            showLoaderDialog(context, "Building Profile...");
                            validateUSN = false;

                            modelUserData = ModelUserData(
                                userUID: firebaseAuthServices.firebaseUser!.uid,
                                userUSN: controllerTextEditUSN.text
                                    .toUpperCase()
                                    .toString(),
                                userCollege: widget.selectedCollege,
                                userSemester: widget.selectedSemester,
                                userStream: widget.selectedStream,
                                userJoiningDate: DateTime.now().toString());

                            // firebaseAuthServices.databaseReference
                            //     .child(
                            //         '$DB_ROOT_NAME/$RTDB_USERS_ROOT_NAME/${firebaseAuthServices.firebaseUser!.uid}')
                            //     .set(modelUserData.toJson())
                            //     .whenComplete(() async {
                            //
                            //
                            //   sharedPrefUserData
                            //       .save('SP_SHIKSHA_USER_DATA', modelUserData)
                            //       .whenComplete(() {
                            //     Navigator.of(context).pop();
                            //
                            //     Navigator.of(context)
                            //         .push(animatedRoute(const TabView()));
                            //   });
                            //
                            //
                            // });


                            sharedPrefUserData
                                .save('SP_SHIKSHA_USER_DATA', modelUserData)
                                .whenComplete(() {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .push(animatedRoute(const TabView()));
                            });




                          }
                        });
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                  termsAndConditionsText(),
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
