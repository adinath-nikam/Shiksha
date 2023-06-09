import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
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

class ModelEventNew extends StatefulWidget {
  String? id;
  String? userId;
  String? eventName;
  String? eventStartDate;
  String? eventStartTime;
  String? eventVenue;
  String? eventDescription;
  String? eventInstructions;
  String? eventGoogleFormLink;
  String? eventPostedDate;
  String? eventClub;
  DocumentReference? reference;

  ModelEventNew();

  ModelEventNew.fromData(
      this.id,
      this.userId,
      this.eventName,
      this.eventStartDate,
      this.eventStartTime,
      this.eventVenue,
      this.eventDescription,
      this.eventInstructions,
      this.eventGoogleFormLink,
      this.eventPostedDate,
      this.eventClub);

  ModelEventNew.fromMap(Map<String, dynamic> map, {required this.reference})
      :
        // assert(map['id'] != null),
        assert(map['userId'] != null),
        assert(map['eventName'] != null),
        assert(map['eventStartDate'] != null),
        assert(map['eventStartTime'] != null),
        assert(map['eventVenue'] != null),
        assert(map['eventDescription'] != null),
        assert(map['eventInstructions'] != null),
        assert(map['eventGoogleFormLink'] != null),
        assert(map['eventPostedDate'] != null),
        assert(map['eventClub'] != null),
        id = reference?.id,
        userId = map['userId'],
        eventName = map['eventName'],
        eventStartDate = map['eventStartDate'],
        eventStartTime = map['eventStartTime'],
        eventVenue = map['eventVenue'],
        eventDescription = map['eventDescription'],
        eventInstructions = map['eventInstructions'],
        eventGoogleFormLink = map['eventGoogleFormLink'],
        eventPostedDate = map['eventPostedDate'],
        eventClub = map['eventClub'];

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "eventName": eventName,
      "eventStartDate": eventStartDate,
      "eventStartTime": eventStartTime,
      "eventVenue": eventVenue,
      "eventDescription": eventDescription,
      "eventInstructions": eventInstructions,
      "eventGoogleFormLink": eventGoogleFormLink,
      "eventPostedDate": eventPostedDate,
      "eventClub": eventClub
    };
  }

  ModelEventNew.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );

  @override
  State<StatefulWidget> createState() {
    return ModelEventNewState();
  }
}

class ModelEventNewState extends State<ModelEventNew> {
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
                              text: widget.eventStartDate!,
                              textSize: 32,
                              color: PrimaryDarkColor),
                          SizedBox(
                            height: 10,
                          ),
                          CustomText(
                              text: widget.eventStartTime!,
                              textSize: 24,
                              color: PrimaryDarkColor),
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
                        text: "venue: " + widget.eventVenue!,
                        textSize: 16,
                        color: PrimaryDarkColor)
                  ],
                ),
              ),
              Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              CustomText(
                  text: "Description", textSize: 18, color: PrimaryDarkColor),
              SizedBox(
                height: 10,
              ),
              CustomTextRegular(
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
                height: 10,
              ),
              CustomTextRegular(
                  text: widget.eventInstructions!,
                  textSize: 12,
                  color: PrimaryDarkColor),
              Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "REGISTER",
                  buttonSize: 60,
                  context: context,
                  function: () {
                    try {
                      launch(widget.eventGoogleFormLink!);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }),
              SizedBox(
                height: 20,
              ),


              if (widget.userId == firebaseAuthServices.firebaseUser?.uid ||
                  modelProfileData.getIsAdmin)
                CustomDeleteButton(
                    text: "DELETE",
                    buttonHeight: 60,
                    context: context,
                    function: () {
                      FirebaseFirestore.instance
                          .collection(DB_ROOT_NAME)
                          .doc(EVENTS_CONSTANT)
                          .collection(modelProfileData.getStudentCollege)
                          .doc(widget.id)
                          .delete()
                          .whenComplete(() {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => WillPopScope(
                            onWillPop: () async => false,
                            child: CommonAlertDialog(
                                context,
                                "Delete Event Success!",
                                Icon(
                                  MdiIcons.calendarClockOutline,
                                  color: PrimaryDarkColor,
                                  size: 50,
                                ), () {
                              Navigator.of(context).pop();
                            }, 1),
                          ),
                        );
                      });
                    })




            ],
          ),
        ),
      ),
    ));
  }
}
