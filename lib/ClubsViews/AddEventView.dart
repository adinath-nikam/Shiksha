import 'dart:io';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Models/ModelEvent.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';
import 'multi_select_dialog.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({Key? key}) : super(key: key);

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController streamsController = TextEditingController();
  late String selectedEventDate;
  late String _startTime;


  @override
  void initState() {
    super.initState();
  }

  ModelEvent modelEvent = ModelEvent();
  final addEventFormKey = GlobalKey<FormState>();

  void eventDatePicker(BuildContext context) async {
    final DateTime? dobPicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: "Select Event Date...",
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (dobPicked != null) {
      setState(() {
        selectedEventDate = DateFormat('yyyy-MM-dd').format(dobPicked);
        eventDateController.text = selectedEventDate;
      });
    }
  }



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
            text: "Add Event", textSize: 18, color: PrimaryDarkColor),
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
                  key: addEventFormKey,
                  child: Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                            color: PrimaryDarkColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: StreamBuilder(
                            stream: FirebaseDatabase.instance
                                .ref()
                                .child("SHIKSHA_APP/CLUBS")
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
                                      text: CLUB_DROPDOWN_INTIAL_VALUE,
                                      textSize: 12,
                                      color: PrimaryDarkColor),
                                  dropdownColor: PrimaryDarkColor,
                                  icon: const Icon(
                                    MdiIcons.cardsClubOutline,
                                  ),
                                  iconSize: 30,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: PrimaryDarkColor),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      CLUB_DROPDOWN_INTIAL_VALUE = newValue!;
                                      modelEvent.eventClub = CLUB_DROPDOWN_INTIAL_VALUE;
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

                      SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Name...",
                          prefixIcon: const Icon(MdiIcons.flower),
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
                          modelEvent.eventName = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onTap: () => eventDatePicker(context),
                        controller: eventDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select Event Date...",
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventStartDate = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateTimeField(
                        format: DateFormat.jm(),
                        decoration: InputDecoration(
                          hintText: "Select Event Start Time...",
                          prefixIcon:
                              const Icon(MdiIcons.clockTimeEightOutline),
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
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventStartTime =
                              DateFormat.jm().format(value!);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateTimeField(
                        readOnly: true,
                        format: DateFormat.jm(),
                        decoration: InputDecoration(
                          hintText: "Select Event End Date...",
                          prefixIcon: const Icon(MdiIcons.calendarCheckOutline),
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
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );

                          return DateTimeField.convert(time);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventEndDate =
                              DateFormat.jm().format(value!);
                        },
                      ), //start time

                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Venue...",
                          prefixIcon: const Icon(MdiIcons.mapMarkerOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventVenue = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Description...",
                          prefixIcon: const Icon(MdiIcons.informationOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventDescription = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Total Seats...",
                          prefixIcon: const Icon(MdiIcons.sofaSingleOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventTotalSeats = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Instructions...",
                          prefixIcon: const Icon(MdiIcons.bullhornOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventInstructions = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: streamsController,
                        readOnly: true,
                        onTap: () async {
                          List<String> selectedStreams = [];
                          selectedStreams = await showDialog<List<String>>(
                                  context: context,
                                  builder: (_) => MultiSelectDialog(
                                      question: CustomText(
                                          text: "Select Streams",
                                          textSize: 16,
                                          color: PrimaryDarkColor),
                                      answers: ['CSE', 'ME'])) ??
                              [];

                          streamsController.text = selectedStreams.join("");
                          // Logic to save selected flavours in the database
                        },
                        decoration: InputDecoration(
                          hintText: "Select Streams...",
                          prefixIcon: const Icon(MdiIcons.bullhornOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventStreams = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: semesterController,
                        readOnly: true,
                        onTap: () async {
                          List<String> selectedSemesters = [];
                          selectedSemesters = await showDialog<List<String>>(
                                  context: context,
                                  builder: (_) => MultiSelectDialog(
                                      question: CustomText(
                                          text: "Select Semesters...",
                                          textSize: 16,
                                          color: PrimaryDarkColor),
                                      answers: ['SEMESTER 1', 'SEMESTER 2'])) ??
                              [];

                          semesterController.text = selectedSemesters.join("");
                          // Logic to save selected flavours in the database
                        },
                        decoration: InputDecoration(
                          hintText: "Select Semesters...",
                          prefixIcon:
                              const Icon(MdiIcons.calendarAccountOutline),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventSemesters = value!;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomButton(
                          text: "SUBMIT",
                          buttonSize: 60,
                          context: context,
                          function: () {
                            if (addEventFormKey.currentState!.validate()) {
                              addEventFormKey.currentState!.save();

                              modelEvent.userId =
                                  modelProfileData.getStudentUid;

                              if (addEventFormKey.currentState!.validate()) {

                                FirebaseFirestore.instance
                                    .collection(DB_ROOT_NAME)
                                    .doc(EVENTS_CONSTANT)
                                    .collection(modelProfileData.StudentCollege)
                                    .doc()
                                    .set(modelEvent.toMap());


                              }

                              else {}
                            }
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
