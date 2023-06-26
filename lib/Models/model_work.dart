import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Models/model_user_data.dart';

import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../colors/colors.dart';
import 'ModelProfileData.dart';

//ignore: must_be_immutable
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

  ModelWork({super.key});

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
      {super.key});

  ModelWork.fromMap(Map<String, dynamic> map,
      {super.key, required this.reference})
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
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "WORK")),
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
              const SizedBox(
                height: 25,
              ),
              customTextBold(
                  text: widget.workTitle!,
                  textSize: 24,
                  color: primaryDarkColor),
              const SizedBox(
                height: 10,
              ),
              customTextBold(
                  text: widget.workCompanyName!,
                  textSize: 20,
                  color: primaryDarkColor.withAlpha(80)),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customTextBold(
                    text: widget.workType!,
                    textSize: 12,
                    color: primaryDarkColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      color: primaryDarkColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    customTextBold(
                        text: "${widget.workCompensation!} LPA",
                        textSize: 12,
                        color: primaryDarkColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: primaryDarkColor.withAlpha(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: primaryDarkColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    customTextBold(
                        text: widget.workLocation!,
                        textSize: 12,
                        color: primaryDarkColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customTextRegular(
                  text: widget.workDescription!,
                  textSize: 14,
                  color: primaryDarkColor),
              const SizedBox(
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
              const SizedBox(
                height: 20,
              ),
              if (modelUserData.getUserIsAdmin)
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
                            child: commonAlertDialog(
                                context,
                                "Delete Job Success!",
                                Icon(
                                  MdiIcons.briefcaseOutline,
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
