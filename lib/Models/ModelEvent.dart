import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/ClubsViews/GetListView.dart';
import 'package:shiksha/Components/ShowSnackBar.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../HomeView/TabView.dart';
import '../colors/colors.dart';
import 'ModelProfileData.dart';

class ModelEvent extends StatefulWidget {
  String? id;
  String? userId;
  String? eventName;
  String? eventStartDate;
  String? eventStartTime;
  String? eventEndDate;
  String? eventVenue;
  String? eventDescription;
  String? eventTotalSeats;
  String? eventInstructions;
  String? eventStreams;
  String? eventSemesters;
  String? eventClub;
  DocumentReference? reference;

  ModelEvent();

  ModelEvent.fromData(
      this.id,
      this.userId,
      this.eventName,
      this.eventStartDate,
      this.eventStartTime,
      this.eventEndDate,
      this.eventVenue,
      this.eventDescription,
      this.eventTotalSeats,
      this.eventInstructions,
      this.eventStreams,
      this.eventSemesters,
      this.eventClub);

  ModelEvent.fromMap(Map<String, dynamic> map, {required this.reference})
      :
        // assert(map['id'] != null),
        assert(map['userId'] != null),
        assert(map['eventName'] != null),
        assert(map['eventStartDate'] != null),
        assert(map['eventStartTime'] != null),
        assert(map['eventEndDate'] != null),
        assert(map['eventVenue'] != null),
        assert(map['eventDescription'] != null),
        assert(map['eventTotalSeats'] != null),
        assert(map['eventInstructions'] != null),
        assert(map['eventStreams'] != null),
        assert(map['eventSemesters'] != null),
        assert(map['eventClub'] != null),
        id = reference?.id,
        userId = map['userId'],
        eventName = map['eventName'],
        eventStartDate = map['eventStartDate'],
        eventStartTime = map['eventStartTime'],
        eventEndDate = map['eventEndDate'],
        eventVenue = map['eventVenue'],
        eventDescription = map['eventDescription'],
        eventTotalSeats = map['eventTotalSeats'],
        eventInstructions = map['eventInstructions'],
        eventStreams = map['eventStreams'],
        eventSemesters = map['eventSemesters'],
        eventClub = map['eventClub'];

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "eventName": eventName,
      "eventStartDate": eventStartDate,
      "eventStartTime": eventStartTime,
      "eventEndDate": eventEndDate,
      "eventVenue": eventVenue,
      "eventDescription": eventDescription,
      "eventTotalSeats": eventTotalSeats,
      "eventInstructions": eventInstructions,
      "eventStreams": eventStreams,
      "eventSemesters": eventSemesters,
      "eventClub": eventClub
    };
  }

  ModelEvent.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );

  @override
  State<StatefulWidget> createState() {
    return ModelEventState();
  }
}

class ModelEventState extends State<ModelEvent> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: PrimaryWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: PrimaryDarkColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                child: CustomText(
                    text: widget.eventClub!,
                    textSize: 16,
                    color: PrimaryDarkColor),
              ),
              SizedBox(
                height: 30,
              ),
              CustomText(
                  text: widget.eventName!,
                  textSize: 20,
                  color: PrimaryDarkColor),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: PrimaryDarkColor.withAlpha(50),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                              text: "May",
                              textSize: 16,
                              color: PrimaryDarkColor),
                          CustomText(
                              text: "29",
                              textSize: 32,
                              color: PrimaryDarkColor),
                          CustomText(
                              text: "2023",
                              textSize: 16,
                              color: PrimaryDarkColor),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: PrimaryDarkColor.withAlpha(50),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                              text: "Registered",
                              textSize: 14,
                              color: PrimaryDarkColor),
                          CustomText(
                              text: "0/100",
                              textSize: 25,
                              color: PrimaryDarkColor),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>GetListView(eventDocument: widget.id!,))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: PrimaryDarkColor.withAlpha(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                      text: "Get List",
                                      textSize: 14,
                                      color: PrimaryDarkColor),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    MdiIcons.viewList,
                                    color: PrimaryDarkColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.mapMarkerOutline,
                      color: PrimaryDarkColor,
                    ),
                    CustomText(
                        text: "venue", textSize: 16, color: PrimaryDarkColor)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.clockTimeEightOutline,
                      color: PrimaryDarkColor,
                    ),
                    CustomText(
                        text: "Start Time:" + widget.eventStartTime!,
                        textSize: 16,
                        color: PrimaryDarkColor)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.calendarCheckOutline,
                      color: PrimaryDarkColor,
                    ),
                    CustomText(
                        text: "Ends on:" + widget.eventEndDate!,
                        textSize: 16,
                        color: PrimaryDarkColor)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomText(
                  text: widget.eventDescription!,
                  textSize: 14,
                  color: PrimaryDarkColor),
              Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              CustomText(
                  text: "Instructions", textSize: 18, color: PrimaryDarkColor),
              SizedBox(
                height: 20,
              ),
              CustomText(
                  text: widget.eventInstructions!,
                  textSize: 12,
                  color: PrimaryDarkColor),
              Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              CustomText(
                  text: "Branches", textSize: 18, color: PrimaryDarkColor),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                child: CustomText(
                    text: widget.eventStreams!,
                    textSize: 12,
                    color: PrimaryDarkColor),
              ),
              SizedBox(
                height: 20,
              ),





              CustomButton(
                  text: "REGISTER",
                  buttonSize: 60,
                  context: context,
                  function: () {

                    modelProfileData.getStudentBranch == widget.eventStreams ?

                    FirebaseFirestore.instance
                        .collection(DB_ROOT_NAME)
                        .doc(EVENTS_CONSTANT)
                        .collection(modelProfileData.StudentCollege)
                        .doc(widget.id)
                        .collection("REGISTERS")
                        .doc(firebaseAuthServices.firebaseUser?.uid)
                        .set({
                      "IDS": firebaseAuthServices.firebaseUser?.uid
                    }).then((value) {
                      showSnackBar(
                          context, "Registered Successful", PrimaryGreenColor);
                    })

                    : showSnackBar(
                        context, "Only for "+widget.eventStreams!, PrimaryGreenColor);;


                  }),


              SizedBox(
                height: 20,
              ),
              if (widget.userId == firebaseAuthServices.firebaseUser?.uid  || modelProfileData.getIsAdmin)

                CustomDeleteButton(
                    text: "DELETE",
                    buttonHeight: 60,
                    context: context,
                    function: () {})
              
            ],
          ),
        ),
      ),
    ));
  }
}
