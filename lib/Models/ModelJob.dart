import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../colors/colors.dart';
import 'ModelProfileData.dart';

class ModelWork extends StatefulWidget {
  String? id;
  String? workTitle;
  String? workCompanyName;
  String? workCompensation;
  String? workLocation;
  String? workDescription;
  String? workPostURL;
  String? workType;
  String? workImageURL;
  DocumentReference? reference;

  ModelWork();

  ModelWork.fromData(
    this.id,
    this.workTitle,
    this.workCompanyName,
    this.workCompensation,
    this.workDescription,
    this.workLocation,
    this.workType,
    this.workPostURL,
    this.workImageURL,
  );

  ModelWork.fromMap(Map<String, dynamic> map, {required this.reference})
      :
        // assert(map['id'] != null),
        assert(map['workTitle'] != null),
        assert(map['workCompanyName'] != null),
        assert(map['workCompensation'] != null),
        assert(map['workDescription'] != null),
        assert(map['workLocation'] != null),
        assert(map['workType'] != null),
        assert(map['workPostURL'] != null),
        assert(map['workImageURL'] != null),
        id = reference?.id,
        workTitle = map['workTitle'],
        workCompanyName = map['workCompanyName'],
        workCompensation = map['workCompensation'],
        workDescription = map['workDescription'],
        workLocation = map['workLocation'],
        workType = map['workType'],
        workPostURL = map['workPostURL'],
        workImageURL = map['workImageURL'];

  Map<String, dynamic> toMap() {
    return {
      "workTitle": workTitle,
      "workCompanyName": workCompanyName,
      "workCompensation": workCompensation,
      "workDescription": workDescription,
      "workLocation": workLocation,
      "workType": workType,
      "workPostURL": workPostURL,
      "workImageURL": workImageURL,
    };
  }

  ModelWork.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<String, dynamic>,
          reference: snapshot.reference,
        );

  @override
  State<ModelWork> createState() => _ModelWorkState();
}

class _ModelWorkState extends State<ModelWork> {
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.workImageURL!,
                  fit: BoxFit.fill,
                  height: 55,
                  width: 55,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CustomText(
                  text: widget.workTitle!,
                  textSize: 24,
                  color: PrimaryDarkColor),
              SizedBox(
                height: 10,
              ),
              CustomText(
                  text: widget.workCompanyName!,
                  textSize: 20,
                  color: PrimaryDarkColor.withAlpha(80)),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: CustomText(
                    text: widget.workType!, textSize: 12, color: PrimaryDarkColor),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.cash,
                      color: PrimaryDarkColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(
                        text: widget.workCompensation!+" LPA",
                        textSize: 12,
                        color: PrimaryDarkColor),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: PrimaryDarkColor.withAlpha(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.mapMarkerOutline,
                      color: PrimaryDarkColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(
                        text: widget.workLocation!, textSize: 12, color: PrimaryDarkColor),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextRegular(
                  text: widget.workDescription!,
                  textSize: 14,
                  color: PrimaryDarkColor),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "APPLY",
                  buttonSize: 55,
                  context: context,
                  function: () {
                    try {
                      launch(widget.workPostURL!);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }),

              SizedBox(
                height: 20,
              ),

              if (modelProfileData.getIsAdmin)
                CustomDeleteButton(
                    text: "DELETE",
                    buttonHeight: 60,
                    context: context,
                    function: () {
                      FirebaseFirestore.instance
                          .collection(DB_ROOT_NAME)
                          .doc(WORK_CONSTANTS)
                          .collection(WORK_CONSTANTS_OFFCAMPUS)
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
                                "Delete Job Success!",
                                Icon(
                                  MdiIcons.briefcaseOutline,
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
