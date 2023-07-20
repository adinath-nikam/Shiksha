import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../Components/constants.dart';
import '../Models/model_work.dart';
import '../colors/colors.dart';

class EditWorkView extends StatefulWidget {
  final ModelWork modelWork;

  const EditWorkView({Key? key, required this.modelWork}) : super(key: key);

  @override
  State<EditWorkView> createState() => _EditWorkViewState();
}

class _EditWorkViewState extends State<EditWorkView> {
  final TextEditingController workImageURLController = TextEditingController();
  final TextEditingController workTitleController = TextEditingController();
  final TextEditingController workDescController = TextEditingController();
  final TextEditingController workCompanyController = TextEditingController();
  final TextEditingController workCompensationController =
      TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final TextEditingController workPostURLController = TextEditingController();
  final addJobFormKey = GlobalKey<FormState>();
  ModelWork modelWork = ModelWork();
  String? workType;

  @override
  void initState() {
    super.initState();
    workImageURLController.text = widget.modelWork.workImageURL!;
    workTitleController.text = widget.modelWork.workTitle!;
    workDescController.text = widget.modelWork.workDescription!;
    workCompanyController.text = widget.modelWork.workCompanyName!;
    workLocationController.text = widget.modelWork.workLocation!;
    workCompensationController.text = widget.modelWork.workCompensation!;
    workPostURLController.text = widget.modelWork.workPostURL!;

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "UPDATE WORK")),
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
                        controller: workImageURLController,
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
                        controller: workTitleController,
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
                        controller: workCompanyController,
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
                        controller: workCompensationController,
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
                        controller: workLocationController,
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
                        controller: workDescController,
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
                      ),
                      TextFormField(
                        controller: workPostURLController,
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
                          text: "UPDATE WORK",
                          buttonSize: 60,
                          context: context,
                          function: () {
                            if (addJobFormKey.currentState!.validate()) {
                              showLoaderDialog(context, 'Please, wait!...');

                              addJobFormKey.currentState!.save();

                              modelWork.workPostedDate =
                                  DateTime.now().toString();

                              if (addJobFormKey.currentState!.validate()) {
                                FirebaseFirestore.instance
                                    .collection(DB_ROOT_NAME)
                                    .doc(WORK_CONSTANTS)
                                    .collection(WORK_CONSTANTS_OFFCAMPUS)
                                    .doc(widget.modelWork.id)
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
                                          "Update Job Success!",
                                          Icon(
                                            Icons.done_all_rounded,
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
