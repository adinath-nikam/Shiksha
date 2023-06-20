import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Admin/AdminView.dart';
import 'package:shiksha/ClubsViews/ClubsView.dart';
import 'package:shiksha/Models/ModelProfileData.dart';

import '../BusTracking/MapView.dart';
import '../ClubsViews/AddEventView.dart';
import '../CodeCompilerViews/code_compiler_dashboard_view.dart';
import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../Components/ShowSnackBar.dart';
import '../FirebaseServices/FirebaseService.dart';
import '../LibraryViews/library_dashboard_view.dart';
import '../Models/ModelEvent.dart';
import '../Models/ModelEventNew.dart';
import '../colors/colors.dart';
import '../NewsViews/NewsView.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;

import '../ChatGPT/page/HomePage.dart';

import 'package:shiksha/WorkViews/WorkView.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  var emojiParser = EmojiParser();

  String word = 'Loading..', pos = 'Loading..', mean = 'Loading..';
  late final Map WOTD;

  @override
  void initState() {
    super.initState();

    getUserInfo();

    FirebaseDatabase.instance
        .ref('SHIKSHA_APP/EXTRAS/WOTD')
        .once()
        .then((value) {
      WOTD = value.snapshot.value as Map;

      setState(() {
        word = WOTD['WORD'];
        pos = WOTD['POS'];
        mean = WOTD['MEANING'];
      });
    });

    // fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // MainHomeCarouselSlider(
            //     EnlargeCenterCard: true, InfiniteScroll: true),
            CampaignListView(),
            ExpansionMenu(context, emojiParser),

            getWordOfTheDay(),

            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: CustomText(
                    text: "Upcoming Events",
                    textSize: 16,
                    color: PrimaryDarkColor)),
            Container(height: 150, child: EventsListView()),
            RecentJobPosting(),
            SizedBox(
              height: 25,
            ),
          ],
        )),
      ),
      floatingActionButton: modelProfileData.getIsAdmin
          ? FloatingActionButton.extended(
              elevation: 0.0,
              icon: const Icon(MdiIcons.shieldCrownOutline),
              backgroundColor: PrimaryGreenColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => const AdminView()),
                );
              },
              label: CustomText(
                  text: "Admin", textSize: 14, color: PrimaryWhiteColor),
            )
          : null,
    ));
  }

  Widget getWordOfTheDay() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: PrimaryDarkColor.withAlpha(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: 'Word of the Day!🌻',
              textSize: 12,
              color: PrimaryDarkColor),
          SizedBox(
            height: 10,
          ),
          CustomText(
              text: "“ " + word + " ”", textSize: 24, color: PrimaryDarkColor),
          CustomText(text: pos, textSize: 10, color: PrimaryDarkColor),
          SizedBox(
            height: 10,
          ),
          CustomText(text: mean, textSize: 14, color: PrimaryDarkColor),
        ],
      ),
    );
  }


  Widget EventsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DB_ROOT_NAME)
          .doc(EVENTS_CONSTANT)
          .collection(modelProfileData.StudentCollege)
          .limit(10)
          .orderBy('eventStartDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: PrimaryWhiteColor,
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs
                .map((data) => EventListViewItem(context, data))
                .toList(),
          );
        } else if (snapshot.data == null) {
          return Center(
            child: CustomText(
                text: "No Recent Events",
                textSize: 20,
                color: PrimaryDarkColor),
          );
        } else {
          return Text("Error");
        }
      },
    );
  }

  Widget EventListViewItem(BuildContext context, DocumentSnapshot data) {
    final ModelEventNew modelEvent = ModelEventNew.fromSnapshot(data);



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
          child: CalenderCardItem(modelEvent),
        ));
  }

  Widget CalenderCardItem(ModelEventNew modelEvent) {

    final startDate = DateFormat("yyyy-MM-dd").parse(modelEvent.eventStartDate!);
    final postedDate = DateFormat("yyyy-MM-dd").parse(modelEvent.eventPostedDate!);

    final monthString = DateFormat('MMMM').format(startDate);
    final dayString = DateFormat('EEE').format(startDate);
    final dayNumber = DateFormat('dd').format(startDate);

    final postedMonthString = DateFormat('MMMM').format(postedDate);
    final postedYearNumber= DateFormat('yyyy').format(postedDate);
    final postedDayNumber = DateFormat('dd').format(postedDate);

    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Container(
          height: 120,
          width: 120,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10), bottom: Radius.zero),
                    color: PrimaryDarkColor,
                  ),
                  width: double.maxFinite,
                  height: 30,
                  child: Center(
                      child: CustomText(
                          text: monthString, textSize: 14, color: PrimaryWhiteColor)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        CustomText(
                            text: dayString,
                            textSize: 12,
                            color: PrimaryDarkColor),
                        CustomText(
                            text: dayNumber, textSize: 20, color: PrimaryDarkColor),
                        CustomText(
                            text: postedYearNumber,
                            textSize: 12,
                            color: PrimaryDarkColor),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.zero, bottom: Radius.circular(10)),
                    color: PrimaryDarkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //***********
  Widget CampaignListView() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("CAMPAIGNS_DATA").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        else if(snapshot.hasData){
          return CarouselSlider.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, a, b) {

                if((snapshot.data!.docs[a].data() as Map<String,dynamic>)['isActive'])
                {

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: PrimaryDarkColor,
                        borderRadius: BorderRadius.circular(5)),
                    child:





                    GestureDetector(
                      onTap: () {

                        try {
                          launch(
                              (snapshot.data!.docs[a].data()
                          as Map<String, dynamic>)['campaignURL']
                              .toString());
                        } catch (e) {
                          debugPrint(e.toString());
                        }

                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: (snapshot.data!.docs[a].data()
                          as Map<String, dynamic>)['campaignImgURL']
                              .toString(),
                          fit: BoxFit.fill,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(MdiIcons.alertCircleOutline, color: PrimaryWhiteColor,),
                        ),
                      ),
                    ),


                  );

                }else{

                  return SizedBox();

                }


              },
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 8),
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ));
        }

        else{
          return const SizedBox();
        }

      },
    );
  }

  //***********

  Widget RecentJobPosting() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                        text: "Recent Posts",
                        textSize: 16,
                        color: PrimaryDarkColor))),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       TextButton.icon(
            //           onPressed: () {},
            //           icon: Icon(
            //             MdiIcons.playCircleOutline,
            //             color: PrimaryLightBlueColor,
            //           ),
            //           label: CustomText(
            //               text: "See all",
            //               textSize: 12,
            //               color: PrimaryLightBlueColor)),
            //     ],
            //   ),
            // ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection(DB_ROOT_NAME).doc(WORK_CONSTANTS).collection(WORK_CONSTANTS_OFFCAMPUS).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              else if(snapshot.hasData){
                return CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, a, b) {

                      return Padding(
                          key: ValueKey((snapshot.data!.docs[a].data()
                          as Map<String, dynamic>)['workTitle']
                              .toString()),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: PrimaryWhiteColor,
                              elevation: 5,
                              child:

                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network(

                                              (snapshot.data!.docs[a].data()
                                              as Map<String, dynamic>)['workImageURL']
                                                  .toString(),


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
                                                text: (snapshot.data!.docs[a].data()
                                        as Map<String, dynamic>)['workTitle']
                              .toString(),
                                                textSize: 14,
                                                color: PrimaryDarkColor),
                                            SizedBox(height: 5,),
                                            CustomText(
                                                text: (snapshot.data!.docs[a].data()
                                                as Map<String, dynamic>)['workCompanyName']
                                                    .toString(),
                                                textSize: 12,
                                                color: PrimaryDarkColor.withOpacity(0.5)),
                                            SizedBox(height: 5,),
                                            CustomText(
                                                text: (snapshot.data!.docs[a].data()
                                                as Map<String, dynamic>)['workCompensation']
                                                    .toString(),
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
                                              text: (snapshot.data!.docs[a].data()
                                              as Map<String, dynamic>)['workType']
                                                  .toString(),
                                              textSize: 12,
                                              color: PrimaryDarkColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )


                          ));


                    },
                    options: CarouselOptions(
                      padEnds: false,
                      height: 170,
                      // aspectRatio: 21 / 9,
                      viewportFraction: 0.6,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 8),
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                    )


                );
              }

              else{
                return const SizedBox();
              }

            },
          ),
        ),
      ],
    );
  }

  Widget RecentClubPostCarouselSlider(
      {required bool EnlargeCenterCard, required bool InfiniteScroll}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                        text: "Recent Posts",
                        textSize: 16,
                        color: PrimaryDarkColor))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        MdiIcons.playCircleOutline,
                        color: PrimaryLightBlueColor,
                      ),
                      label: CustomText(
                          text: "See all",
                          textSize: 12,
                          color: PrimaryLightBlueColor)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        CarouselSlider(
            items: [1, 2].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 10, left: 20),
                    decoration: BoxDecoration(
                        color: PrimaryDarkColor,
                        borderRadius: BorderRadius.circular(5)),
                    child:

                        ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1679473379899-20654f983d1e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80",
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              padEnds: false,
              height: 120,
              // aspectRatio: 21 / 9,
              viewportFraction: 0.6,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 8),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: EnlargeCenterCard,
              scrollDirection: Axis.horizontal,
            )

        ),
      ],
    );
  }

  Widget ExpansionMenu(BuildContext context, var emojiParser) {
    ExpansionMenuItems item1 = ExpansionMenuItems(
        title: "AI Bot",
        img: Icon(
          Icons.adb_outlined,
          color: PrimaryWhiteColor,
          size: 35,
        ),
      Activity: const HomePage()

    );

    ExpansionMenuItems item2 = ExpansionMenuItems(
      title: "Compiler",
      img: Icon(
        MdiIcons.codeTags,
        color: PrimaryWhiteColor,
        size: 35,
      ),
        Activity: const CodeCompilerDashBoard()
    );


    ExpansionMenuItems item3 = ExpansionMenuItems(
      title: "Library",
      img: Icon(
        Icons.book,
        color: PrimaryWhiteColor,
        size: 35,
      ),
        Activity:
        LibraryDashboardView(appUserUSN: modelProfileData.getStudentUSN)
    );

    ExpansionMenuItems item4 = ExpansionMenuItems(
        title: "Track Bus",
        img: Icon(
          MdiIcons.busMarker,
          color: PrimaryWhiteColor,
          size: 35,
        ),
        Activity: MapScreenView()
    );

    List<ExpansionMenuItems> ExpansionMenuItemsList = [
      item1,
      item2,
      item3,
      item4,
    ];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            child: Card(
              color: PrimaryDarkColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      trailing: Icon(
                        MdiIcons.menu,
                        color: PrimaryWhiteColor,
                      ),
                      title: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                              text: "Menu",
                              textSize: 16,
                              color: PrimaryWhiteColor)),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              GridView.count(
                                  shrinkWrap: true,
                                  childAspectRatio: 1.0,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 20,
                                  children: ExpansionMenuItemsList.map((data) {
                                    return GestureDetector(
                                      onTap: () {
                                        // showSnackBar(context, "Comming Soon",
                                        //     PrimaryDarkColor);

                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (builder) => data.Activity));
                                      },
                                      child: Container(
                                        height: 150.0,
                                        width: 150.0,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              PrimaryWhiteColor.withAlpha(50),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            // Text(
                                            //   emojiParser.emojify(':bus:'),
                                            //   style: TextStyle(fontSize: 24),
                                            // ),

                                            data.img,

                                            //SizedBox(height: 12.0,),
                                            CustomText(
                                                text: data.title,
                                                textSize: 14,
                                                color: PrimaryWhiteColor)
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class ExpansionMenuItems {
  late String title;
  late Icon img;
  late Widget Activity;

  ExpansionMenuItems({required this.title, required this.img, required this.Activity});
}
