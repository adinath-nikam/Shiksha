import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/Components/Constants.dart';
import 'package:shiksha/FirebaseServices/FirebaseService.dart';
import 'package:shiksha/HomeView/TabView.dart';
import 'package:shiksha/Models/ModelProfileData.dart';

import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';
import 'package:flutter/scheduler.dart';

import '../main.dart';


class ProfileBuildStepperView extends StatefulWidget {
  @override
  _ProfileBuildStepperViewState createState() =>
      _ProfileBuildStepperViewState();
}

class _ProfileBuildStepperViewState extends State<ProfileBuildStepperView> {


  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController usnController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  StepperType stepperType = StepperType.vertical;
  int _currentStep = 0;
  int value = 0;

  bool isCompleted = false;

  late String selectedDOB;
  late String selectedGender;
  late final ModelProfileData modelProfileData;


  @override
  void initState() {
    super.initState();
  }

  bool isDetailComplete() {
    if (_currentStep == 0) {
      if (userNameController.text.isEmpty ||
          userNameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          phoneNumberController.text.length!=10 ||
          dateOfBirthController.text.isEmpty) {
        return false;
      } else {
        return true; //if all fields are not empty
      }
    } else if (_currentStep == 1) {
      //check receiver fields
      if (selectedGender == null) {
        return false;
      } else {
        return true;
      }
    } else if (_currentStep == 2) {
      //check receiver fields
      if (COLLEGE_DROPDOWN_INTIAL_VALUE == "Select your College" ||
          SEMESTER_DROPDOWN_INTIAL_VALUE == "Select your Semester" ||
          BRANCH_DROPDOWN_INTIAL_VALUE == "Select your Branch") {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  void dateOfBirthPicker(BuildContext context) async {
    final DateTime? dobPicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: "Select Date of Birth",
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (dobPicked != null) {
      setState(() {
        selectedDOB = DateFormat('yyyy-MM-dd').format(dobPicked);
        dateOfBirthController.text = selectedDOB;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryWhiteColor,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              CustomText(
                  text: "Let's Build Your Profile!",
                  textSize: 26,
                  color: PrimaryDarkColor),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Theme(
                  data: ThemeData(
                      colorScheme:
                      ColorScheme.light(primary: PrimaryDarkColor)),
                  child: Form(
                    key: _formKey,
                    child: Stepper(
                      type: stepperType,
                      physics: const ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      onStepContinue: continued,
                      onStepCancel: cancel,
                      steps: <Step>[
                        Step(
                          title: CustomText(
                              text: "Personal Details",
                              textSize: 15,
                              color: PrimaryDarkColor),
                          subtitle: CustomText(
                              text: "Username, USN, Phone, D.O.B",
                              textSize: 10,
                              color: PrimaryDarkColor.withAlpha(100)),
                          content: Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: userNameController,
                                      decoration: InputDecoration(
                                        hintText: "Create Username",
                                        prefixIcon: const Icon(Icons.person),
                                        contentPadding:
                                        const EdgeInsets.all(25.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                        PrimaryDarkColor.withOpacity(0.1),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "* Required.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: usnController,
                                      decoration: InputDecoration(
                                        hintText:
                                        "Enter University Seat Number",
                                        prefixIcon: const Icon(Icons.pin),
                                        contentPadding:
                                        const EdgeInsets.all(25.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                        PrimaryDarkColor.withOpacity(0.1),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "* Required";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: phoneNumberController,
                                      decoration: InputDecoration(
                                        hintText: "Enter Phone Number",
                                        prefixIcon: const Icon(Icons.call),
                                        contentPadding:
                                        const EdgeInsets.all(25.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                        PrimaryDarkColor.withOpacity(0.1),
                                      ),
                                      validator: (value) {
                                        if (value==null || value.isEmpty) {
                                          return "*Required";
                                        }else if(value.length<10){
                                          return "Invalid Phone Number";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onTap: () => dateOfBirthPicker(context),
                                      controller: dateOfBirthController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: "Enter Date of Birth",
                                        prefixIcon: const Icon(
                                            Icons.calendar_month_outlined),
                                        contentPadding:
                                        const EdgeInsets.all(25.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                        PrimaryDarkColor.withOpacity(0.1),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "* Required.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: CustomText(
                              text: "Gender",
                              textSize: 15,
                              color: PrimaryDarkColor),
                          subtitle: CustomText(
                              text: "Select Gender",
                              textSize: 10,
                              color: PrimaryDarkColor.withAlpha(100)),
                          content: Row(
                            children: <Widget>[
                              CustomRadioButton("Male", 1),
                              CustomRadioButton("Female", 2),
                              CustomRadioButton("Other", 3),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 1
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: CustomText(
                              text: "College Details",
                              textSize: 15,
                              color: PrimaryDarkColor),
                          subtitle: CustomText(
                              text: "College, Branch, Semester",
                              textSize: 10,
                              color: PrimaryDarkColor.withAlpha(100)),
                          content: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: PrimaryDarkColor.withAlpha(100),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child("SHIKSHA_APP/COLLEGES")
                                        .orderByValue()
                                        .onValue,
                                    builder: (context, snapshot) {
                                      List<String>? collegesList = [];
                                      Map<dynamic, dynamic> values1 = snapshot
                                          .data
                                          ?.snapshot
                                          .value as Map<dynamic, dynamic>;
                                      values1.forEach((key, value) {
                                        collegesList.add(value);
                                      });

                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                          isExpanded: true,

                                          underline: SizedBox(),
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
                                        return Text("Error");
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: PrimaryDarkColor.withAlpha(100),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child("SHIKSHA_APP/STREAMS")
                                        .orderByValue()
                                        .onValue,
                                    builder: (context,
                                        AsyncSnapshot<DatabaseEvent> snapshot) {
                                      List<String>? streamsList = [];
                                      Map<dynamic, dynamic> values2 = snapshot
                                          .data
                                          ?.snapshot
                                          .value as Map<dynamic, dynamic>;
                                      values2.forEach((key, value) {
                                        streamsList.add(value);
                                      });

                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                          isExpanded: true,

                                          underline: SizedBox(),
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
                                        return Text("Error");
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: PrimaryDarkColor.withAlpha(100),
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
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 2
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    // _currentStep < 2 ? setState(() => _currentStep += 1) : null;
    final isLastStep = _currentStep == 3 - 1;
    _formKey.currentState!.validate();
    bool isDetailValid =
    isDetailComplete(); //this check if ok to move on to next screen
    if (isDetailValid) {
      if (isLastStep) {


        showLoaderDialog(context, "Creating Profile...");


        setState(() {
          isCompleted = true;
          modelProfileData = ModelProfileData(
              StudentUid: FirebaseAuth.instance.currentUser!.uid,
              StudentBranch: BRANCH_DROPDOWN_INTIAL_VALUE,
              StudentCollege: COLLEGE_DROPDOWN_INTIAL_VALUE,
              StudentDOB: selectedDOB,
              StudentEmail: firebaseAuthServices.firebaseUser?.email as String,
              StudentGender: selectedDOB,
              StudentPhone: phoneNumberController.text.trim(),
              StudentSemester: SEMESTER_DROPDOWN_INTIAL_VALUE,
              StudentUsername: userNameController.text.trim(),
              StudentUSN: usnController.text.trim(),
            JoiningDate: DateTime.now().toString()
          );

          firebaseAuthServices.databaseReference
              .child(
              '$DB_ROOT_NAME/$RTDB_USERS_ROOT_NAME/${FirebaseAuth.instance.currentUser!.uid}')
              .set(modelProfileData.toJson()).then((value) async {






          }).whenComplete(() {
            // Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (builder) => const MyApp()));
          });




        });
      } else {
        setState(() {
          _currentStep += 1;
        });
      }
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget CustomRadioButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (value == index)
              ? PrimaryDarkColor
              : PrimaryDarkColor.withAlpha(100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          setState(() {
            value = index;
            selectedGender = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: (value == index)
                ? PrimaryWhiteColor
                : PrimaryDarkColor.withAlpha(100),
          ),
        ),
      ),
    );
  }
}