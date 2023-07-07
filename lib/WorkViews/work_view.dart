import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Models/model_work.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/WorkViews/add_job_view.dart';
import '../FirebaseServices/firebase_api.dart';
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
      backgroundColor: primaryWhiteColor,
      body: const WorkViewContent(),
      floatingActionButton: modelUserData.getUserCanPostJob
          ? FloatingActionButton.extended(
              elevation: 0.0,
              icon: const Icon(Icons.work_history_rounded),
              backgroundColor: primaryDarkColor,
              onPressed: () {
                Navigator.of(context).push(
                  animatedRoute(const AddJobView()),
                );
              },
              label: customTextBold(
                  text: "Add Job", textSize: 14, color: primaryWhiteColor),
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
        margin: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: workListView());
  }

  Widget workListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseAPI().workStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: primaryWhiteColor,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.size > 0) {
          return Column(
            children: [
              customTextBold(
                  text: 'Best Match for your Profile',
                  textSize: 18,
                  color: primaryDarkColor),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map((data) => workListViewItem(context, data))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_history_rounded,
                color: primaryDarkColor,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextBold(
                      text: 'No Jobs Posted :(',
                      textSize: 22,
                      color: primaryDarkColor),
                  customTextBold(
                      text: 'Any Job Posting\nwill appear here...',
                      textSize: 14,
                      color: primaryDarkColor.withOpacity(0.5)),
                ],
              )
            ],
          ));
        }
      },
    );
  }

  Widget workListViewItem(BuildContext context, DocumentSnapshot data) {
    final ModelWork modelWork = ModelWork.fromSnapshot(data);

    final postedDate =
        DateFormat("yyyy-MM-dd").parse(modelWork.workPostedDate!);
    final postedMonthString = DateFormat('MMMM').format(postedDate);
    final postedYearNumber = DateFormat('yyyy').format(postedDate);
    final postedDayNumber = DateFormat('dd').format(postedDate);

    return Padding(
        key: ValueKey(modelWork.workTitle),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
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
              modelWork.workPostedDate,
            );

            Navigator.of(context).push(animatedRoute(e));
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: primaryDarkColor.withOpacity(1),
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryWhiteColor,
                ),
                margin: EdgeInsets.all(2),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextBold(
                                text: modelWork.workCompanyName!,
                                textSize: 12,
                                color: primaryDarkColor),
                            customTextBold(
                                text: modelWork.workTitle!,
                                textSize: 14,
                                color: primaryDarkColor),
                            customTextBold(
                                text: "CTC: " +
                                    modelWork.workCompensation! +
                                    " LPA",
                                textSize: 10,
                                color: primaryDarkColor),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: primaryDarkColor.withAlpha(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: customTextBold(
                              text: modelWork.workType!,
                              textSize: 12,
                              color: primaryDarkColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Posted on: $postedDayNumber $postedMonthString, $postedYearNumber",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
                          color: primaryDarkColor),
                    ),
                  ],
                ),
              )),
        ));
  }
}
