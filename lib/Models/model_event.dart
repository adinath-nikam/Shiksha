import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:shiksha/ClubsViews/edit_event_view.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../FirebaseServices/firebase_api.dart';
import '../colors/colors.dart';

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

  ModelEventNew({super.key});

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
      this.eventClub,
      {super.key});

  ModelEventNew.fromMap(Map<String, dynamic> map,
      {super.key, required this.reference})
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
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "EVENT")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: primaryDarkColor.withAlpha(50),
                    ),
                    child: customTextBold(
                        text: widget.eventClub!,
                        textSize: 16,
                        color: primaryDarkColor),
                  ),
                  IconButton(
                      onPressed: () {
                        ModelEventNew e = ModelEventNew.fromData(
                            widget.id,
                            widget.userId,
                            widget.eventName,
                            widget.eventStartDate,
                            widget.eventStartTime,
                            widget.eventVenue,
                            widget.eventDescription,
                            widget.eventInstructions,
                            widget.eventGoogleFormLink,
                            widget.eventPostedDate,
                            widget.eventClub);
                        Navigator.of(context).push(animatedRoute(EditEventViewNew(modelEventNew: e)));
                      },
                      icon: Icon(
                        Icons.settings_rounded,
                        color: primaryDarkColor,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              customTextBold(
                  text: widget.eventName!,
                  textSize: 20,
                  color: primaryDarkColor),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: primaryDarkColor.withAlpha(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customTextBold(
                              text: widget.eventStartDate!,
                              textSize: 32,
                              color: primaryDarkColor),
                          const SizedBox(
                            height: 10,
                          ),
                          customTextBold(
                              text: widget.eventStartTime!,
                              textSize: 24,
                              color: primaryDarkColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: primaryDarkColor,
                  ),
                  customTextBold(
                      text: "venue: ${widget.eventVenue!}",
                      textSize: 16,
                      color: primaryDarkColor)
                ],
              ),
              const Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              customTextBold(
                  text: "Description", textSize: 18, color: primaryDarkColor),
              const SizedBox(
                height: 10,
              ),
              customTextRegular(
                  text: widget.eventDescription!,
                  textSize: 14,
                  color: primaryDarkColor),
              const Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              customTextBold(
                  text: "Instructions", textSize: 18, color: primaryDarkColor),
              const SizedBox(
                height: 10,
              ),
              customTextRegular(
                  text: widget.eventInstructions!,
                  textSize: 12,
                  color: primaryDarkColor),
              const Divider(
                height: 50,
                thickness: 1,
                endIndent: 5,
                indent: 5,
              ),
              const SizedBox(
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
              const SizedBox(
                height: 20,
              ),
              if (widget.userId == firebaseAuthServices.firebaseUser?.uid ||
                  modelUserData.getUserIsAdmin)
                CustomDeleteButton(
                    text: "DELETE",
                    buttonHeight: 60,
                    context: context,
                    function: () {
                      FirebaseFirestore.instance
                          .collection(DB_ROOT_NAME)
                          .doc(EVENTS_CONSTANT)
                          .collection(modelUserData.getUserCollege)
                          .doc(widget.id)
                          .delete()
                          .whenComplete(() {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => WillPopScope(
                            onWillPop: () async => false,
                            child: commonAlertDialog(
                                context,
                                "Delete Event Success!",
                                Icon(
                                  Icons.event_available_rounded,
                                  color: primaryDarkColor,
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
