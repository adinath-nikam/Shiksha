import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/LoadingIndicator.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../Models/ModelJob.dart';
import '../colors/colors.dart';

class AddJobView extends StatefulWidget {
  const AddJobView({Key? key}) : super(key: key);

  @override
  State<AddJobView> createState() => _AddJobViewState();
}

class _AddJobViewState extends State<AddJobView> {
  final addJobFormKey = GlobalKey<FormState>();
  ModelWork modelWork = ModelWork();

  String? workType;

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
        title:
            CustomText(text: "Add Job", textSize: 18, color: PrimaryDarkColor),
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
                  key: addJobFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Image URL...",
                          prefixIcon: const Icon(MdiIcons.imageOutline),
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
                          modelWork.workImageURL = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Title...",
                          prefixIcon: const Icon(MdiIcons.briefcaseOutline),
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
                          modelWork.workTitle = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Company Name...",
                          prefixIcon: const Icon(MdiIcons.domain),
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
                          modelWork.workCompanyName = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Compensation...",
                          prefixIcon: const Icon(MdiIcons.cash),
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
                          modelWork.workCompensation = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Location...",
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
                          modelWork.workLocation = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Description...",
                          prefixIcon: const Icon(MdiIcons.text),
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
                          modelWork.workDescription = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Posting URL...",
                          prefixIcon: const Icon(MdiIcons.linkVariant),
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
                          modelWork.workPostURL = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: CustomText(
                                text: "Full Time",
                                textSize: 16,
                                color: PrimaryDarkColor),
                            value: "Full Time",
                            groupValue: workType,
                            onChanged: (value) {
                              setState(() {
                                workType = value.toString();
                                modelWork.workType = workType!;
                              });
                            },
                          ),
                          RadioListTile(
                            title: CustomText(
                                text: "Internship",
                                textSize: 16,
                                color: PrimaryDarkColor),
                            selectedTileColor: PrimaryGreenColor,
                            value: "Internship",
                            groupValue: workType,
                            onChanged: (value) {
                              setState(() {
                                workType = value.toString();
                                modelWork.workType = workType!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: "ADD JOB",
                          buttonSize: 60,
                          context: context,
                          function: () {
                            if (addJobFormKey.currentState!.validate()) {
                              showLoaderDialog(context, 'Please, wait!...');

                              addJobFormKey.currentState!.save();

                              if (addJobFormKey.currentState!.validate()) {
                                FirebaseFirestore.instance
                                    .collection(DB_ROOT_NAME)
                                    .doc(WORK_CONSTANTS)
                                    .collection(WORK_CONSTANTS_OFFCAMPUS)
                                    .doc()
                                    .set(modelWork.toMap())
                                    .whenComplete(() {

                                  Navigator.of(context).pop();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        WillPopScope(
                                          onWillPop: () async => false,
                                          child: CommonAlertDialog(
                                              context, "Add Job Success!",
                                          Icon(MdiIcons.checkOutline, color: PrimaryDarkColor, size: 50,),
                                              (){Navigator.of(context).pop();}, 2),
                                        ),
                                  );
                                }

                                );
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
