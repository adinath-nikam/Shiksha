import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shiksha/Admin/admin_view.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/Models/model_work.dart';
import '../BusTracking/bus_track_map_view.dart';
import '../Components/common_component_widgets.dart';
import '../LibraryViews/library_dashboard_view.dart';
import '../Models/model_event.dart';
import '../colors/colors.dart';
import '../ChatGPT/page/chat_gpt_home_Page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String word = 'Loading..',
      pos = 'Loading..',
      mean = 'Loading..';
  late final Map wordOfTheDay;

  @override
  void initState() {
    super.initState();

    getUserData();

    FirebaseDatabase.instance
        .ref('SHIKSHA_APP/EXTRAS/WOTD')
        .once()
        .then((value) {
      wordOfTheDay = value.snapshot.value as Map;

      setState(() {
        word = wordOfTheDay['WORD'];
        pos = wordOfTheDay['POS'];
        mean = wordOfTheDay['MEANING'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: AnimationLimiter(
              child: AnimationConfiguration.synchronized(
                child: SlideAnimation(
                  verticalOffset: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      campaignListView(),
                      expansionMenu(context),
                      getWordOfTheDay(),
                      SizedBox(height: 200, child: eventsListView()),
                      Container(height: 210, child: workListView()),
                      // recentJobPosting(),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: modelUserData.getUserIsAdmin
              ? FloatingActionButton.extended(
            elevation: 0.0,
            icon: const Icon(Icons.admin_panel_settings),
            backgroundColor: primaryGreenColor,
            onPressed: () {
              Navigator.of(context).push(animatedRoute(const AdminView()));
            },
            label: customTextBold(
                text: "Admin", textSize: 14, color: primaryWhiteColor),
          )
              : null,
        ));
  }

  Widget getWordOfTheDay() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: primaryDarkColor.withAlpha(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextBold(
              text: 'Word of the Day!🌻',
              textSize: 12,
              color: primaryDarkColor),
          const SizedBox(
            height: 10,
          ),
          customTextBold(
              text: "“ $word ”", textSize: 24, color: primaryDarkColor),
          customTextBold(text: pos, textSize: 10, color: primaryDarkColor),
          const SizedBox(
            height: 10,
          ),
          customTextBold(text: mean, textSize: 14, color: primaryDarkColor),
        ],
      ),
    );
  }

  Widget eventsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreEventsApi().eventsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: progressIndicator());
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: customTextBold(
                      text: "Upcoming Events",
                      textSize: 16,
                      color: primaryDarkColor)),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((data) {
                    final ModelEventNew modelEvent =
                    ModelEventNew.fromSnapshot(data);
                    final startDate = DateFormat("yyyy-MM-dd")
                        .parse(modelEvent.eventStartDate!);
                    final postedDate = DateFormat("yyyy-MM-dd")
                        .parse(modelEvent.eventPostedDate!);

                    final monthString = DateFormat('MMMM').format(startDate);
                    final dayString = DateFormat('EEE').format(startDate);
                    final dayNumber = DateFormat('dd').format(startDate);

                    final postedYearNumber =
                    DateFormat('yyyy').format(postedDate);

                    return GestureDetector(
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
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
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
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10),
                                          bottom: Radius.zero),
                                      color: primaryDarkColor,
                                    ),
                                    width: double.maxFinite,
                                    height: 30,
                                    child: Center(
                                        child: customTextBold(
                                            text: monthString,
                                            textSize: 14,
                                            color: primaryWhiteColor)),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          customTextBold(
                                              text: dayString,
                                              textSize: 12,
                                              color: primaryDarkColor),
                                          customTextBold(
                                              text: dayNumber,
                                              textSize: 20,
                                              color: primaryDarkColor),
                                          customTextBold(
                                              text: postedYearNumber,
                                              textSize: 12,
                                              color: primaryDarkColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.zero,
                                          bottom: Radius.circular(10)),
                                      color: primaryDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        } else {
          return const Text("Error");
        }
      },
    );
  }

  Widget workListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreEventsApi().workStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: progressIndicator());
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: customTextBold(
                      text: "Recent Posts",
                      textSize: 16,
                      color: primaryDarkColor)),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((data) {
                    final ModelWork modelWork = ModelWork.fromSnapshot(data);
                    return GestureDetector(
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
                        );
                        Navigator.of(context).push(animatedRoute(e));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 250,
                            ),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: primaryWhiteColor,
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            child: Image.network(
                                              modelWork.workImageURL!,
                                              fit: BoxFit.fitWidth,
                                              height: 55,
                                              width: 55,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    value: loadingProgress
                                                        .expectedTotalBytes !=
                                                        null
                                                        ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              customTextBold(
                                                  text: modelWork
                                                      .workCompanyName!,
                                                  textSize: 12,
                                                  color: primaryDarkColor),
                                              customTextBold(
                                                  text: modelWork.workTitle!,
                                                  textSize: 14,
                                                  color: primaryDarkColor),
                                              customTextBold(
                                                  text: modelWork
                                                      .workCompensation! +
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                              color: primaryDarkColor
                                                  .withAlpha(50),
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
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        } else {
          return const Text("Error");
        }
      },
    );
  }

  Widget campaignListView() {
    return StreamBuilder<QuerySnapshot>(
      stream:
      FirebaseFirestore.instance.collection("CAMPAIGNS_DATA").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else if (snapshot.hasData && snapshot.data!.docs.length > 0) {
          return CarouselSlider.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, a, b) {
                if ((snapshot.data!.docs[a].data()
                as Map<String, dynamic>)['isActive']) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: primaryDarkColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: GestureDetector(
                      onTap: () {
                        try {
                          launch((snapshot.data!.docs[a].data()
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
                              progressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(
                                Icons.info_rounded,
                                color: primaryWhiteColor,
                              ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
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
                autoPlayInterval: const Duration(seconds: 8),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget expansionMenu(BuildContext context) {
    ExpansionMenuItems item1 = ExpansionMenuItems(
        title: "AI Bot",
        img: Icon(
          Icons.adb_outlined,
          color: primaryWhiteColor,
          size: 35,
        ),
        activity: const HomePage());

    ExpansionMenuItems item2 = ExpansionMenuItems(
        title: "Library",
        img: Icon(
          Icons.book,
          color: primaryWhiteColor,
          size: 35,
        ),
        // activity: temp()
        activity: LibraryDashboardView(appUserUSN: modelUserData.getUserUSN));

    ExpansionMenuItems item3 = ExpansionMenuItems(
        title: "Track Bus",
        img: Icon(
          Icons.bus_alert_rounded,
          color: primaryWhiteColor,
          size: 35,
        ),
        activity: const MapScreenView());

    List<ExpansionMenuItems> expansionMenuItemsList = [
      item1,
      item2,
      item3,
    ];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Card(
            color: primaryDarkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    trailing: Icon(
                      Icons.menu_rounded,
                      color: primaryWhiteColor,
                    ),
                    title: Align(
                        alignment: Alignment.centerLeft,
                        child: customTextBold(
                            text: "Menu",
                            textSize: 16,
                            color: primaryWhiteColor)),
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
                                children: expansionMenuItemsList.map((data) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(animatedRoute(data.activity));
                                    },
                                    child: Container(
                                      height: 150.0,
                                      width: 150.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primaryWhiteColor.withAlpha(50),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          data.img,
                                          customTextBold(
                                              text: data.title,
                                              textSize: 14,
                                              color: primaryWhiteColor)
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
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class ExpansionMenuItems {
  late String title;
  late Icon img;
  late Widget activity;

  ExpansionMenuItems(
      {required this.title, required this.img, required this.activity});
}
