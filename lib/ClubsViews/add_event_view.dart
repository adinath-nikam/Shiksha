import 'package:firebase_database/firebase_database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../Models/model_event.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';

class AddEventViewNew extends StatefulWidget {
  const AddEventViewNew({Key? key}) : super(key: key);

  @override
  State<AddEventViewNew> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventViewNew> {
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController streamsController = TextEditingController();
  late String selectedEventDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ModelEventNew modelEvent = ModelEventNew();
  final addEventFormKey = GlobalKey<FormState>();

  void eventDatePicker(BuildContext context) async {
    final DateTime? dobPicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "ADD EVENT")),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            color: primaryDarkColor.withOpacity(0.1),
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
                              Map<dynamic, dynamic> values3 = snapshot.data
                                  ?.snapshot.value as Map<dynamic, dynamic>;
                              values3.forEach((key, value) {
                                semestersList.add(value);
                              });

                              if (snapshot.hasData) {
                                return DropdownButton(
                                  isExpanded: true,

                                  underline: const SizedBox(),
                                  // value: dropdownValue,
                                  hint: customTextBold(
                                      text: CLUB_DROPDOWN_INTIAL_VALUE,
                                      textSize: 12,
                                      color: primaryDarkColor),
                                  dropdownColor: primaryDarkColor,
                                  icon: const Icon(
                                    Icons.eco_rounded,
                                  ),
                                  iconSize: 30,
                                  elevation: 16,
                                  style: TextStyle(color: primaryDarkColor),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      CLUB_DROPDOWN_INTIAL_VALUE = newValue!;
                                      modelEvent.eventClub =
                                          CLUB_DROPDOWN_INTIAL_VALUE;
                                    });
                                  },

                                  items: semestersList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style:
                                            TextStyle(color: primaryWhiteColor),
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
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Name...",
                          prefixIcon: const Icon(Icons.label_important_rounded),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
                        ),
                        onSaved: (value) {
                          modelEvent.eventName = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      const SizedBox(
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
                          fillColor: primaryDarkColor.withOpacity(0.1),
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
                      const SizedBox(
                        height: 20,
                      ),
                      DateTimeField(
                        format: DateFormat.jm(),
                        decoration: InputDecoration(
                          hintText: "Select Event Start Time...",
                          prefixIcon:
                              const Icon(Icons.access_time_filled_rounded),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Venue...",
                          prefixIcon: const Icon(Icons.location_on_rounded),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Description...",
                          prefixIcon: const Icon(Icons.info_rounded),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Instructions...",
                          prefixIcon: const Icon(Icons.speaker),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Event Google Form Link...",
                          prefixIcon: const Icon(Icons.link_rounded),
                          contentPadding: const EdgeInsets.all(25.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: primaryDarkColor.withOpacity(0.1),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelEvent.eventGoogleFormLink = value!;
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

                              modelEvent.eventPostedDate =
                                  DateTime.now().toString();

                              if (addEventFormKey.currentState!.validate()) {
                                FirebaseFirestore.instance
                                    .collection(DB_ROOT_NAME)
                                    .doc(EVENTS_CONSTANT)
                                    .collection(modelProfileData.StudentCollege)
                                    .doc()
                                    .set(modelEvent.toMap())
                                    .whenComplete(() {
                                  Navigator.of(context).pop();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        WillPopScope(
                                      onWillPop: () async => false,
                                      child: commonAlertDialog(
                                          context,
                                          "Add Event Success!",
                                          Icon(
                                            MdiIcons.calendarClockOutline,
                                            color: primaryDarkColor,
                                            size: 50,
                                          ), () {
                                        Navigator.of(context).pop();
                                      }, 1),
                                    ),
                                  );
                                });
                              } else {}
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
