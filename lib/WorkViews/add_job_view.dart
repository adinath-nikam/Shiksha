import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../Models/model_work.dart';
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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "ADD JOB")),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                          prefixIcon: const Icon(Icons.image_rounded),
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
                          modelWork.workImageURL = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Title...",
                          prefixIcon: const Icon(Icons.work_history_rounded),
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
                          modelWork.workTitle = value!;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Company Name...",
                          prefixIcon: const Icon(Icons.domain),
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
                          modelWork.workCompanyName = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Compensation...",
                          prefixIcon: const Icon(Icons.currency_rupee_rounded),
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
                          modelWork.workCompensation = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Location...",
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
                          modelWork.workLocation = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Description...",
                          prefixIcon: const Icon(Icons.short_text_rounded),
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
                          modelWork.workDescription = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),cd DesktopTextSelectionToolbar(anchor: anchor, children: children)
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Job Posting URL...",
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
                          modelWork.workPostURL = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: customTextBold(
                                text: "Full Time",
                                textSize: 16,
                                color: primaryDarkColor),
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
                            title: customTextBold(
                                text: "Internship",
                                textSize: 16,
                                color: primaryDarkColor),
                            selectedTileColor: primaryGreenColor,
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
                      const SizedBox(
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
                                      child: commonAlertDialog(
                                          context,
                                          "Add Job Success!",
                                          Icon(
                                            MdiIcons.checkOutline,
                                            color: primaryDarkColor,
                                            size: 50,
                                          ), () {
                                        Navigator.of(context).pop();
                                      }, 2),
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
