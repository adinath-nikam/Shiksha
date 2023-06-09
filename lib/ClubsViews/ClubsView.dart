import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/Models/ModelEvent.dart';

import '../Components/Constants.dart';
import '../Models/ModelEventNew.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';
import 'AddEventView.dart';
import 'AddEventViewNew.dart';

class ClubsView extends StatefulWidget {
  @override
  _ClubsViewState createState() => _ClubsViewState();
}

class _ClubsViewState extends State<ClubsView>
    with AutomaticKeepAliveClientMixin<ClubsView> {
  @override
  bool get wantKeepAlive => true;

  String orderBy = 'eventPostedDate';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: PrimaryWhiteColor,
            body: DefaultTabController(
              length: 1,
              initialIndex: 0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    child: TabBar(
                        unselectedLabelColor: PrimaryDarkColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: PrimaryDarkColor),
                        tabs: [
                          Tab(
                            child: Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: PrimaryDarkColor, width: 1)),
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

                  SizedBox(height: 50,),


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
                            child: EventsListView()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton:

                modelProfileData.CanPostEvent ?

            FloatingActionButton.extended(
              elevation: 0.0,
              icon: Icon(MdiIcons.plusThick),
              backgroundColor: PrimaryDarkColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => const AddEventViewNew()),
                );
              },
              label: CustomText(
                  text: "Add Event", textSize: 14, color: PrimaryWhiteColor),
            )

        : null


        ));
  }

  Widget EventsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DB_ROOT_NAME)
          .doc(EVENTS_CONSTANT)
          .collection(modelProfileData.StudentCollege)
          .orderBy(orderBy, descending: true)
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
        // return _buildList(context, snapshot.data!.docs);
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map((data) => EventListViewItem(context, data))
              .toList(),
        );
      },
    );
  }

  Widget EventListViewItem(BuildContext context, DocumentSnapshot data) {
    final ModelEventNew modelEvent = ModelEventNew.fromSnapshot(data);

    final startDate = DateFormat("yyyy-MM-dd").parse(modelEvent.eventStartDate!);
    final postedDate = DateFormat("yyyy-MM-dd").parse(modelEvent.eventPostedDate!);

    final monthString = DateFormat('MMMM').format(startDate);
    final dayString = DateFormat('EEE').format(startDate);
    final dayNumber = DateFormat('dd').format(startDate);

    final postedMonthString = DateFormat('MMMM').format(postedDate);
    final postedYearNumber= DateFormat('yyyy').format(postedDate);
    final postedDayNumber = DateFormat('dd').format(postedDate);

    return Padding(
        key: ValueKey(modelEvent.eventName),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
              modelEvent.eventClub
            );
            return e;
          })),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: PrimaryWhiteColor,
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
                      color: PrimaryDarkColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        CustomText(
                            text: dayNumber+', '+dayString,
                            textSize: 12,
                            color: PrimaryWhiteColor),

                        CustomText(
                            text: monthString,
                            textSize: 18,
                            color: PrimaryWhiteColor),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            text: modelEvent.eventName!,
                            textSize: 18,
                            color: PrimaryDarkColor),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: PrimaryDarkColor.withAlpha(50),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: CustomText(
                              text: modelEvent.eventClub!,
                              textSize: 12,
                              color: PrimaryDarkColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "Posted on: "+postedDayNumber+' '+postedMonthString+', '+postedYearNumber,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                color: PrimaryDarkColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
