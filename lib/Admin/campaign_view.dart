import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/Models/model_campaign.dart';
import '../Components/AuthButtons.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, "CAMPAIGNS")),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          icon: const Icon(Icons.short_text_outlined),
          backgroundColor: primaryGreenColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (builder) => const AddCampaign()),
            );
          },
          label: customTextBold(
              text: "Add Campaign", textSize: 14, color: primaryWhiteColor),
        ),
        body: campaignListView(),
      ),
    );
  }
}

Widget campaignListView() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("CAMPAIGNS_DATA").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: primaryWhiteColor,
          ),
        );
      }
      // return _buildList(context, snapshot.data!.docs);
      return ListView(
        shrinkWrap: true,
        children: snapshot.data!.docs
            .map((data) => campaignListViewItem(context, data))
            .toList(),
      );
    },
  );
}

Widget campaignListViewItem(BuildContext context, DocumentSnapshot data) {
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
                customTextBold(
                    text: modelCampaign.campaignName!,
                    textSize: 12,
                    color: primaryDarkColor),
                const SizedBox(
                  height: 10,
                ),
                customTextBold(
                    text: modelCampaign.campaignTimeStamp!,
                    textSize: 12,
                    color: primaryDarkColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextBold(
                        text: "Active:\t\t",
                        textSize: 12,
                        color: primaryDarkColor),
                    Switch(
                      value: modelCampaign.isActive!,
                      onChanged: (value) {
                        FirebaseFirestore.instance
                            .collection('CAMPAIGNS_DATA')
                            .doc(modelCampaign.id!)
                            .update({'isActive': value});
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
                              FirebaseFirestore.instance
                                  .collection('CAMPAIGNS_DATA')
                                  .doc(modelCampaign.id!)
                                  .delete();
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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "ADD CAMPAIGN")),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      customTextBold(
                          text: "Add Campaign",
                          textSize: 18,
                          color: primaryDarkColor),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Campaign Name...",
                          prefixIcon: const Icon(Icons.text_fields_outlined),
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
                          modelCampaign.campaignName = value!;
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
                          hintText: "Enter Campaign Image URL...",
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Campaign URL...",
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
                                customTextBold(
                                    text: "Active:\t\t$isActive",
                                    textSize: 16,
                                    color: primaryDarkColor),
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
                                      child: commonAlertDialog(
                                          context,
                                          "Add Campaign Success!",
                                          Icon(
                                            Icons.post_add_rounded,
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
