import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Models/ModelCampaign.dart';
import 'package:shiksha/Models/ModelProfileData.dart';

import '../Components/AuthButtons.dart';
import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';
import 'AdminView.dart';

class CampaignView extends StatefulWidget {
  const CampaignView({Key? key}) : super(key: key);

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> {
  ModelCampaign modelCampaign = ModelCampaign();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          icon: const Icon(MdiIcons.text),
          backgroundColor: PrimaryGreenColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (builder) => const AddCampaign()),
            );
          },
          label: CustomText(
              text: "Add Campaign", textSize: 14, color: PrimaryWhiteColor),
        ),
        body: CampaignListView(),
      ),
    );
  }
}

Widget CampaignListView() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("CAMPAIGNS_DATA").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: PrimaryWhiteColor,
          ),
        );
      }
      // return _buildList(context, snapshot.data!.docs);
      return ListView(
        shrinkWrap: true,
        children: snapshot.data!.docs
            .map((data) => CampaignListViewItem(context, data))
            .toList(),
      );
    },
  );
}

Widget CampaignListViewItem(BuildContext context, DocumentSnapshot data) {
  final ModelCampaign modelCampaign = ModelCampaign.fromSnapshot(data);

  return Padding(
      key: ValueKey(modelCampaign.campaignName),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: modelCampaign.campaignName!,
                    textSize: 12,
                    color: PrimaryDarkColor),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                    text: modelCampaign.campaignTimeStamp!,
                    textSize: 12,
                    color: PrimaryDarkColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: "Active:\t\t",
                        textSize: 12,
                        color: PrimaryDarkColor),
                    Switch(
                      value: modelCampaign.isActive!,
                      onChanged: (value) {

                        FirebaseFirestore.instance.collection('CAMPAIGNS_DATA').doc(modelCampaign.id!).update({'isActive': value});
                        
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    SizedBox(
                        width: 150,
                        height: 40,
                        child: CustomDeleteButton(
                            text: "Delete",
                            buttonHeight: 40,
                            context: context,
                            function: () {
                              FirebaseFirestore.instance.collection('CAMPAIGNS_DATA').doc(modelCampaign.id!).delete();

                            }))
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}

class AddCampaign extends StatefulWidget {
  const AddCampaign({Key? key}) : super(key: key);

  @override
  State<AddCampaign> createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  bool isActive = false;
  ModelCampaign modelCampaign = ModelCampaign();
  final addCampaignFormKey = GlobalKey<FormState>();

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
            text: "Add Campaign", textSize: 18, color: PrimaryDarkColor),
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
                  key: addCampaignFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                          text: "Add Campaign",
                          textSize: 18,
                          color: PrimaryDarkColor),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Campaign Name...",
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
                          modelCampaign.campaignName = value!;
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
                          hintText: "Enter Campaign Image URL...",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Required.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          modelCampaign.campaignImgURL = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Campaign URL...",
                          prefixIcon: const Icon(MdiIcons.link),
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
                          modelCampaign.campaignURL = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Row(
                              children: [
                                CustomText(
                                    text: "Active:\t\t$isActive",
                                    textSize: 16,
                                    color: PrimaryDarkColor),
                                const SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Switch(
                                    value: isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        isActive = value;
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: "ADD CAMPAIGN",
                          buttonSize: 60,
                          context: context,
                          function: () {
                            if (addCampaignFormKey.currentState!.validate()) {
                              addCampaignFormKey.currentState!.save();

                              modelCampaign.isActive = isActive;

                              modelCampaign.campaignTimeStamp = "Temp String";

                              if (addCampaignFormKey.currentState!.validate()) {
                                FirebaseFirestore.instance
                                    .collection('CAMPAIGNS_DATA')
                                    .doc()
                                    .set(modelCampaign.toMap())
                                    .whenComplete(() {

                                  Navigator.of(context).pop();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        WillPopScope(
                                          onWillPop: () async => false,
                                          child: CommonAlertDialog(
                                              context, "Add Campaign Success!",
                                              Icon(MdiIcons.post, color: PrimaryDarkColor, size: 50,),
                                                  (){Navigator.of(context).pop();}, 1),
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
