import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/AuthButtons.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/Models/ModelJob.dart';
import 'package:shiksha/WorkViews/AddJobView.dart';
import 'package:shiksha/WorkViews/WorkDetailView.dart';

import '../Admin/AdminView.dart';
import '../Components/Constants.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';

class WorkView extends StatefulWidget {
  const WorkView({Key? key}) : super(key: key);

  @override
  State<WorkView> createState() => _WorkViewState();
}

class _WorkViewState extends State<WorkView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: PrimaryWhiteColor,
          body: const WorkViewContent(),
          floatingActionButton: modelProfileData.getCanPostJob
              ? FloatingActionButton.extended(
            elevation: 0.0,
            icon: const Icon(MdiIcons.briefcaseOutline),
            backgroundColor: PrimaryDarkColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (builder) => const AddJobView()),
              );
            },
            label: CustomText(
                text: "Add Job", textSize: 14, color: PrimaryWhiteColor),
          )
              : null,
        ));
  }
}

class WorkViewContent extends StatefulWidget {
  const WorkViewContent({Key? key}) : super(key: key);

  @override
  State<WorkViewContent> createState() => _WorkViewContentState();
}

class _WorkViewContentState extends State<WorkViewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: WorkListView()
    );
  }


  Widget WorkListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DB_ROOT_NAME)
          .doc(WORK_CONSTANTS)
          .collection(WORK_CONSTANTS_OFFCAMPUS)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: PrimaryWhiteColor,
            ),
          );
        }

        else if(snapshot.hasData && snapshot.data!.size>0){
          return Column(
            children: [
              CustomText(text: 'Best Match for your Profile', textSize: 18, color: PrimaryDarkColor),
              SizedBox(height: 20,),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map((data) => WorkListViewItem(context, data))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        }else{
          return Center(
              child: Icon(MdiIcons.briefcaseOutline, size: 50, color: PrimaryDarkColor,)
          );
        }


      },
    );
  }



  Widget WorkListViewItem(BuildContext context, DocumentSnapshot data) {
    final ModelWork modelWork = ModelWork.fromSnapshot(data);

    return Padding(
        key: ValueKey(modelWork.workTitle),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                ModelWork e = ModelWork.fromData(
                  modelWork.id,
                  modelWork.workTitle,
                  modelWork.workCompanyName,
                  modelWork.workCompensation,
                  modelWork.workDescription,
                  modelWork.workLocation,
                  modelWork.workType,
                  modelWork.workPostURL,
                  modelWork.workImageURL,
                );
                return e;
              })),


          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: PrimaryWhiteColor,
              elevation: 5,
              child:

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            modelWork.workImageURL!,
                            fit: BoxFit.fitWidth,
                            height: 55,
                            width: 55,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: modelWork.workCompanyName!,
                                textSize: 12,
                                color: PrimaryDarkColor),
                            CustomText(
                                text: modelWork.workTitle!,
                                textSize: 14,
                                color: PrimaryDarkColor),
                            CustomText(
                                text: modelWork.workCompensation!,
                                textSize: 10,
                                color: PrimaryDarkColor),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: PrimaryDarkColor.withAlpha(50),
                          ),
                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: CustomText(
                              text: modelWork.workType!,
                              textSize: 12,
                              color: PrimaryDarkColor),
                        ),
                      ],
                    ),
                  ],
                ),
              )


          ),
        ));
  }

}
