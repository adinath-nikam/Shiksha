import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../colors/colors.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<EditProfileView> {
  bool isActive = false;
  final profileUpdateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: PrimaryDarkColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: CustomText(
                text: "Update Profile", textSize: 18, color: PrimaryDarkColor),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Form(
                      key: profileUpdateFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter Username...",
                              prefixIcon: const Icon(MdiIcons.accountCircleOutline),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: PrimaryDarkColor.withOpacity(0.1),
                            ),
                            onSaved: (value) {
                            },
                            validator: (value) {
                              return value == null ? '* Required' : null;
                            },
                          ),

                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter USN...",
                              prefixIcon: const Icon(MdiIcons.unicode),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: PrimaryDarkColor.withOpacity(0.1),
                            ),
                            onSaved: (value) {
                            },
                            validator: (value) {
                              return value == null ? '* Required' : null;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: PrimaryDarkColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: StreamBuilder(
                                stream: FirebaseDatabase.instance
                                    .ref()
                                    .child("SHIKSHA_APP/COLLEGES")
                                    .orderByKey()
                                    .onValue,
                                builder: (context,
                                    AsyncSnapshot<DatabaseEvent> snapshot) {
                                  List<String>? collegesList = [];
                                  Map<dynamic, dynamic> values3 = snapshot
                                      .data
                                      ?.snapshot
                                      .value as Map<dynamic, dynamic>;
                                  values3.forEach((key, value) {
                                    collegesList.add(value);
                                  });

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,

                                      underline: const SizedBox(),
                                      // value: dropdownValue,
                                      hint: CustomText(
                                          text: COLLEGE_DROPDOWN_INTIAL_VALUE,
                                          textSize: 12,
                                          color: PrimaryDarkColor),
                                      dropdownColor: PrimaryDarkColor,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                      ),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: PrimaryDarkColor),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          COLLEGE_DROPDOWN_INTIAL_VALUE = newValue!;
                                        });
                                      },

                                      items: collegesList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: PrimaryWhiteColor),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  } else {
                                    return const Text("Error");
                                  }
                                }),
                          ),

                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: PrimaryDarkColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: StreamBuilder(
                                stream: FirebaseDatabase.instance
                                    .ref()
                                    .child("SHIKSHA_APP/STREAMS")
                                    .orderByKey()
                                    .onValue,
                                builder: (context,
                                    AsyncSnapshot<DatabaseEvent> snapshot) {
                                  List<String>? streamsList = [];
                                  Map<dynamic, dynamic> values3 = snapshot
                                      .data
                                      ?.snapshot
                                      .value as Map<dynamic, dynamic>;
                                  values3.forEach((key, value) {
                                    streamsList.add(value);
                                  });

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,

                                      underline: const SizedBox(),
                                      // value: dropdownValue,
                                      hint: CustomText(
                                          text: BRANCH_DROPDOWN_INTIAL_VALUE,
                                          textSize: 12,
                                          color: PrimaryDarkColor),
                                      dropdownColor: PrimaryDarkColor,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                      ),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: PrimaryDarkColor),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          BRANCH_DROPDOWN_INTIAL_VALUE = newValue!;
                                        });
                                      },

                                      items: streamsList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: PrimaryWhiteColor),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  } else {
                                    return const Text("Error");
                                  }
                                }),
                          ),

                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: PrimaryDarkColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: StreamBuilder(
                                stream: FirebaseDatabase.instance
                                    .ref()
                                    .child("SHIKSHA_APP/SEMESTERS")
                                    .orderByKey()
                                    .onValue,
                                builder: (context,
                                    AsyncSnapshot<DatabaseEvent> snapshot) {
                                  List<String>? semestersList = [];
                                  Map<dynamic, dynamic> values3 = snapshot
                                      .data
                                      ?.snapshot
                                      .value as Map<dynamic, dynamic>;
                                  values3.forEach((key, value) {
                                    semestersList.add(value);
                                  });

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,

                                      underline: const SizedBox(),
                                      // value: dropdownValue,
                                      hint: CustomText(
                                          text: SEMESTER_DROPDOWN_INTIAL_VALUE,
                                          textSize: 12,
                                          color: PrimaryDarkColor),
                                      dropdownColor: PrimaryDarkColor,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                      ),
                                      iconSize: 30,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: PrimaryDarkColor),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          SEMESTER_DROPDOWN_INTIAL_VALUE = newValue!;
                                        });
                                      },

                                      items: semestersList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: PrimaryWhiteColor),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  } else {
                                    return const Text("Error");
                                  }
                                }),
                          ),

                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(
                              text: "UPDATE\t\t\tPROFILE",
                              buttonSize: 60,
                              context: context,
                              function: () {
                              }),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }
}
