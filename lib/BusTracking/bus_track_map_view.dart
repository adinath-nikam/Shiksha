import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shiksha/Components/constants.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/colors/colors.dart';
import '../Components/common_component_widgets.dart';

class MapViewBusTrack extends StatelessWidget {
  final String busNumber;

  const MapViewBusTrack({Key? key, required this.busNumber}) : super(key: key);

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      if (kDebugMode) {
        print("ERROR$error");
      }
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = Set();

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, 'TRACK BUS')),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(DB_ROOT_NAME_DRIVER)
              .doc(modelUserData.getUserCollege)
              .collection('BUSES')
              .doc(busNumber)
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData) {
              GeoPoint location = snapshot.data!.get("location");
              markers.clear();

              final latLng = LatLng(location.latitude, location.longitude);

              markers.add(
                  Marker(markerId: MarkerId("location"), position: latLng));

              return Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 15),
                    markers: markers,
                    onMapCreated: (controller) {},
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: FloatingActionButton.extended(
                        backgroundColor: primaryDarkColor,
                        onPressed: () async {},
                        label: customTextBold(
                            text: busNumber,
                            textSize: 16,
                            color: primaryWhiteColor),
                        icon: const Icon(Icons.directions_bus),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: primaryRedColor,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => WillPopScope(
                              onWillPop: () async => false,
                              child: commonAlertDialog(
                                  context,
                                  "Experimental Feature!",
                                  Icon(
                                    Icons.info_rounded,
                                    color: primaryDarkColor,
                                    size: 50,
                                  ), () {
                                Navigator.of(context).pop();
                              }, 1),
                            ),
                          );
                        },
                        child: const Icon(Icons.info_rounded),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: primaryDarkColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: customTextBold(
                              text: busNumber,
                              textSize: 45,
                              color: primaryDarkColor),
                          title: Container(
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: primaryDarkColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    customTextBold(
                                        text: snapshot.data!.get('driverName'),
                                        textSize: 18,
                                        color: primaryDarkColor),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: primaryDarkColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    customTextBold(
                                        text: snapshot.data!
                                            .get('driverPhoneNumber'),
                                        textSize: 18,
                                        color: primaryDarkColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Center(
              child: progressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
