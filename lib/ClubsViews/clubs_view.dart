import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/Models/model_user_data.dart';
import '../Components/constants.dart';
import '../Models/model_event.dart';
import '../colors/colors.dart';
import 'add_event_view.dart';

class ClubsView extends StatefulWidget {
  const ClubsView({super.key});

  @override
  State<ClubsView> createState() => _ClubsViewState();
}

class _ClubsViewState extends State<ClubsView>
    with AutomaticKeepAliveClientMixin<ClubsView> {
  @override
  bool get wantKeepAlive => true;
  String orderBy = 'eventPostedDate';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: primaryWhiteColor,
            body: DefaultTabController(
              length: 1,
              initialIndex: 0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: TabBar(
                        unselectedLabelColor: primaryDarkColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: primaryDarkColor),
                        tabs: [
                          Tab(
                            child: Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: primaryDarkColor, width: 1)),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Club Events",
                                  style:
                                      TextStyle(fontFamily: "ProductSans-Bold"),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // Sort Filter
                  // GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       orderBy = 'eventStartDate';
                  //     });
                  //   },
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(100.0),
                  //         color: PrimaryDarkColor,
                  //       ),
                  //       padding:
                  //       const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  //       margin: EdgeInsets.only(right: 20),
                  //       child: Icon(MdiIcons.sort, color: PrimaryWhiteColor, size: 20,),
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, bottom: 0.0, top: 15),
                            child: eventListView()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: modelUserData.getUserCanPostEvent
                ? FloatingActionButton.extended(
                    elevation: 0.0,
                    icon: const Icon(Icons.event),
                    backgroundColor: primaryDarkColor,
                    onPressed: () {
                      Navigator.of(context)
                          .push(animatedRoute(const AddEventViewNew()));
                    },
                    label: customTextBold(
                        text: "Add Event",
                        textSize: 14,
                        color: primaryWhiteColor),
                  )
                : null));
  }

  Widget eventListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DB_ROOT_NAME)
          .doc(EVENTS_CONSTANT)
          .collection(modelUserData.getUserCollege)
          .orderBy(orderBy, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: primaryWhiteColor,
            ),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy_rounded,
                color: primaryDarkColor,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              customTextBold(
                  text: 'No Events :)', textSize: 22, color: primaryDarkColor)
            ],
          ));
        }
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map((data) => eventListItem(context, data))
              .toList(),
        );
      },
    );
  }

  Widget eventListItem(BuildContext context, DocumentSnapshot data) {
    final ModelEventNew modelEvent = ModelEventNew.fromSnapshot(data);

    final startDate =
        DateFormat("yyyy-MM-dd").parse(modelEvent.eventStartDate!);
    final postedDate =
        DateFormat("yyyy-MM-dd").parse(modelEvent.eventPostedDate!);

    final monthString = DateFormat('MMMM').format(startDate);
    final dayString = DateFormat('EEE').format(startDate);
    final dayNumber = DateFormat('dd').format(startDate);

    final postedMonthString = DateFormat('MMMM').format(postedDate);
    final postedYearNumber = DateFormat('yyyy').format(postedDate);
    final postedDayNumber = DateFormat('dd').format(postedDate);

    return Padding(
        key: ValueKey(modelEvent.eventName),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            ModelEventNew e = ModelEventNew.fromData(
                modelEvent.id,
                modelEvent.userId,
                modelEvent.eventName,
                modelEvent.eventStartDate,
                modelEvent.eventStartTime,
                modelEvent.eventVenue,
                modelEvent.eventDescription,
                modelEvent.eventInstructions,
                modelEvent.eventGoogleFormLink,
                modelEvent.eventPostedDate,
                modelEvent.eventClub);

            Navigator.of(context).push(animatedRoute(e));
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryWhiteColor,
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: primaryDarkColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customTextBold(
                            text: '$dayNumber, $dayString',
                            textSize: 12,
                            color: primaryWhiteColor),
                        customTextBold(
                            text: monthString,
                            textSize: 18,
                            color: primaryWhiteColor),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextBold(
                            text: modelEvent.eventName!,
                            textSize: 18,
                            color: primaryDarkColor),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: primaryDarkColor.withAlpha(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: customTextBold(
                              text: modelEvent.eventClub!,
                              textSize: 12,
                              color: primaryDarkColor),
                        ),
                        const SizedBox(
                          height: 10,
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
                  ),
                ],
              )),
        ));
  }
}
