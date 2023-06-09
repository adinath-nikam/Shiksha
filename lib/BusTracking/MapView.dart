import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Components/CommonComponentWidgets.dart';
import '../colors/colors.dart';

class MapScreenView extends StatefulWidget {
  @override
  _MapScreenViewState createState() => _MapScreenViewState();
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
        icon: await MarkerIcon.downloadResizePicture(
            url:
                'https://firebasestorage.googleapis.com/v0/b/trash-add22.appspot.com/o/ic_bus.png?alt=media&token=840c8711-12f4-4a9d-8e20-c7add820c70a&_gl=1*128q90t*_ga*MTIwMjIyNDg3My4xNjg1MTA5NTc3*_ga_CW55HF8NVT*MTY4NjA0MjA5Mi4xNi4xLjE2ODYwNDIzNTUuMC4wLjA.',
            imageSize: 125),
        // onTap: () {
        //   _customInfoWindowController.addInfoWindow!(
        //     Column(
        //       children: [
        //         Expanded(
        //           child: Container(
        //             decoration: BoxDecoration(
        //               color: Colors.black,
        //               borderRadius: BorderRadius.circular(4),
        //             ),
        //             width: double.infinity,
        //             height: double.infinity,
        //             child: const Padding(
        //               padding: EdgeInsets.all(20.0),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.electric_bolt_outlined,
        //                     color: Colors.white,
        //                     size: 30,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     LatLng(specify['location'].latitude, specify['location'].longitude),
        //   );
        // },
        infoWindow: InfoWindow(
          title: 'Bus Id',
          snippet: specifyId,
        ));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {


    FirebaseFirestore.instance.collection('BUS_TRACK_DATA').snapshots().listen((querySnapshot) {

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
      print("ERROR" + error.toString());
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
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: PrimaryDarkColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: false,
            title: CustomText(
                text: "Track Bus", textSize: 18, color: PrimaryDarkColor),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
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
                  padding: EdgeInsets.all(15),
                  child: FloatingActionButton.extended(
                    backgroundColor: PrimaryDarkColor,
                    onPressed: () async {},
                    label: CustomText(
                        text: busCount, textSize: 16, color: PrimaryWhiteColor),
                    icon: Icon(MdiIcons.bus),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(MdiIcons.alertOctagonOutline),
                    backgroundColor: PrimaryRedColor,
                    onPressed: () async {

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) =>
                            WillPopScope(
                              onWillPop: () async => false,
                              child: CommonAlertDialog(
                                  context, "Experimental Feature!",
                                  Icon(MdiIcons.alertOctagonOutline, color: PrimaryDarkColor, size: 50,),
                                      (){Navigator.of(context).pop();}, 1),
                            ),
                      );

                    },
                  ),
                ),
              ),



            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(MdiIcons.crosshairsGps),
            backgroundColor: PrimaryDarkColor,
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                print(value.latitude.toString() +
                    " " +
                    value.longitude.toString());

                initMarker(GeoPoint(value.latitude, value.longitude) as dynamic,
                    "My Location");

                // specified current users location
                CameraPosition cameraPosition = new CameraPosition(
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
          )),
    );
  }
}
