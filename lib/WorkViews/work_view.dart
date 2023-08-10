import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Models/model_work.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/WorkViews/add_job_view.dart';
import '../FirebaseServices/firebase_api.dart';
import '../colors/colors.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

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
      body: Column(
        children: [
          customTextBold(
              text: 'Best Match for your Profile',
              textSize: 18,
              color: primaryDarkColor),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: FirestoreListView<ModelWork>(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              query: FirebaseAPI().queryWorkStream(),
              pageSize: 10,
              emptyBuilder: (context) {
                return Center(
                    child: Image(
                  height: 200,
                  width: 200,
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/mgc-shiksha-82736.appspot.com/o/Images%2FIdle%20Graphics%2Fnull_job_img.jpg?alt=media&token=2567fad8-96a6-4715-888c-0eb4cf215ef1'),
                ));
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Image(
                    height: 300,
                    width: 300,
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/mgc-shiksha-82736.appspot.com/o/Images%2FIdle%20Graphics%2Ferror_job_img.jpg?alt=media&token=14ef4681-9bf6-42a3-b5f6-700654c98d46'),
                  ),
                );
              },
              loadingBuilder: (context) => progressIndicator(),
              itemBuilder: (context, doc) {
                final modelWork = doc.data();
                final postedDate =
                    DateFormat("yyyy-MM-dd").parse(modelWork.workPostedDate!);
                final postedMonthString = DateFormat('MMMM').format(postedDate);
                final postedYearNumber = DateFormat('yyyy').format(postedDate);
                final postedDayNumber = DateFormat('dd').format(postedDate);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: primaryDarkColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                title: customTextBold(
                                    text: modelWork.workTitle!,
                                    textSize: 16,
                                    color: primaryDarkColor),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    customTextBold(
                                        text: modelWork.workCompensation! +
                                            " LPA",
                                        textSize: 12,
                                        color:
                                            primaryDarkColor.withOpacity(0.5)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: primaryDarkColor.withAlpha(50),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: customTextBold(
                                          text: modelWork.workType!,
                                          textSize: 12,
                                          color: primaryDarkColor),
                                    ),
                                    const SizedBox(
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
                                leading: Container(
                                  height: 55,
                                  width: 55,
                                  padding: const EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      modelWork.workImageURL!,
                                      fit: BoxFit.contain,
                                      height: 55,
                                      width: 55,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: progressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )))),
                );
              },
            ),
          ),
        ],
      ),
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
