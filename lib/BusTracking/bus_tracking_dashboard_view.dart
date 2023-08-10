import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/BusTracking/bus_track_map_view.dart';
import 'package:shiksha/Components/constants.dart';
import 'package:shiksha/Models/model_user_data.dart';

import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class BusTrackingDashboard extends StatefulWidget {
  const BusTrackingDashboard({Key? key}) : super(key: key);

  @override
  State<BusTrackingDashboard> createState() => _BusTrackingDashboardState();
}

class _BusTrackingDashboardState extends State<BusTrackingDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, 'ACTIVE TRIPS')),
      backgroundColor: primaryWhiteColor,
      body: FirestoreListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        query: FirebaseFirestore.instance
            .collection(DB_ROOT_NAME_DRIVER)
            .doc(modelUserData.getUserCollege)
            .collection('BUSES'),
        pageSize: 10,
        emptyBuilder: (context) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 250,
                width: 250,
                image: AssetImage('assets/images/no_bus_img.png'),
              ),
              customTextBold(
                  text: 'No Active Trips!',
                  textSize: 18,
                  color: primaryDarkColor),
              customTextBold(
                  text: 'Active Trips will appear here..',
                  textSize: 12,
                  color: primaryDarkColor.withOpacity(0.5)),
            ],
          ));
        },
        loadingBuilder: (context) => progressIndicator(),
        itemBuilder: (context, doc) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(animatedRoute(MapViewBusTrack(
                busNumber: doc['driverBusNumber'],
              )));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: primaryDarkColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: SizedBox(
                    height: 55,
                    width: 55,
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: primaryDarkColor,
                      size: 55,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_rounded,
                    color: primaryDarkColor,
                  ),
                  title: customTextBold(
                      text: doc['driverName'],
                      textSize: 14,
                      color: primaryDarkColor),
                  subtitle: customTextBold(
                      text: 'Bus Number: ' + doc['driverBusNumber'],
                      textSize: 12,
                      color: primaryDarkColor.withOpacity(0.5)),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
