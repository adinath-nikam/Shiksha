import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Components/common_component_widgets.dart';
import '../colors/colors.dart';

class MapScreenView extends StatefulWidget {
  const MapScreenView({super.key});

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {
  late GoogleMapController mapController;
  String busCount = '0';

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final LatLng _center = const LatLng(15.849363993462724, 74.50009735933146);

  late LatLng currentLocationLatLng;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Future<void> _onMapCreated(controller) async {
    setState(() {
      mapController = controller;
      _customInfoWindowController.googleMapController = controller;
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        // icon: await MarkerIcon.downloadResizePicture(
        //     url:
        //         'https://firebasestorage.googleapis.com/v0/b/trash-add22.appspot.com/o/ic_bus.png?alt=media&token=840c8711-12f4-4a9d-8e20-c7add820c70a&_gl=1*128q90t*_ga*MTIwMjIyNDg3My4xNjg1MTA5NTc3*_ga_CW55HF8NVT*MTY4NjA0MjA5Mi4xNi4xLjE2ODYwNDIzNTUuMC4wLjA.',
        //     imageSize: 125),
        infoWindow: InfoWindow(
          title: 'Bus Id',
          snippet: specifyId,
        ));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('BUS_TRACK_DATA')
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          busCount = querySnapshot.docs.length.toString();
        });
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          initMarker(querySnapshot.docs[i].data(), querySnapshot.docs[i].id);
        }
      }

      // querySnapshot.docChanges.forEach((change) {
      //   print('>>>>>>>>>>>>>>>>>> '+change.doc.id);
      // });
    });

    // FirebaseFirestore.instance.collection('BUS_TRACK_DATA').get().then((value) {
    //   if (value.docs.isNotEmpty) {
    //     setState(() {
    //       busCount = value.docs.length.toString();
    //     });
    //     for (int i = 0; i < value.docs.length; i++) {
    //       initMarker(value.docs[i].data(), value.docs[i].id);
    //     }
    //   }
    // });
  }

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
  void initState() {
    getMarkerData();
    getUserCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: appBarCommon(context, "TRACK BUS (BETA)")),
          body: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                compassEnabled: true,
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 300,
                width: 300,
                offset: 50,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: FloatingActionButton.extended(
                    backgroundColor: primaryDarkColor,
                    onPressed: () async {},
                    label: customTextBold(
                        text: busCount, textSize: 16, color: primaryWhiteColor),
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryDarkColor,
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                initMarker(GeoPoint(value.latitude, value.longitude) as dynamic,
                    "My Location");

                // specified current users location
                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );

                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {
                  currentLocationLatLng =
                      LatLng(value.latitude, value.longitude);
                });
              });
            },
            child: const Icon(Icons.gps_fixed_rounded),
          )),
    );
  }
}
