import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shiksha/Admin/admin_view.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/Models/model_work.dart';
import '../BusTracking/bus_track_map_view.dart';
import '../BusTracking/bus_tracking_dashboard_view.dart';
import '../ChatGPT/page/chat_gpt_home_Page.dart';
import '../Components/common_component_widgets.dart';
import '../LibraryViews/library_dashboard_view.dart';
import '../colors/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String word = 'Loading..', pos = 'Loading..', mean = 'Loading..';
  late final Map wordOfTheDay;

  @override
  void initState() {
    super.initState();

    getUserData();

    updateLastActiveStatus();

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

  void updateLastActiveStatus() {
    try {
      FirebaseAPI()
          .firebaseDatabase
          .ref("SHIKSHA_APP/USERS_DATA/${modelUserData.getUserUID}")
          .update({"last_active": DateTime.now().toString()})
          .whenComplete(() {})
          .onError((error, stackTrace) {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: primaryWhiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: AnimationLimiter(
          child: AnimationConfiguration.synchronized(
            child: SlideAnimation(
              verticalOffset: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  //   child: Image.network('https://www.klescet.ac.in/wp-content/uploads/2021/01/cropped-cddfv-1024x112.png'),
                  // ),
                  campaignListView(),
                  chatBotWidget(),
                  HomeMenuView(context),
                  getWordOfTheDay(),
                  workListView(),
                  const SizedBox(
                    height: 20,
                  ),
                  showVersionCode(),
                  const SizedBox(
                    height: 50,
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
      width: MediaQuery.of(context).size.width,
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

  Widget chatBotWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(animatedRoute(HomePage()));
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: primaryDarkColor.withOpacity(1),
            elevation: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryWhiteColor,
              ),
              margin: EdgeInsets.all(2),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage(
                                "assets/images/shiksha_logo_landscape_light_bot.png"),
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          customTextBold(
                              text: "BOT",
                              textSize: 22,
                              color: primaryDarkColor),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_circle_right_rounded,
                            color: primaryDarkColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                      customTextRegular(
                          text:
                              "Ask anything.., \nand get queries solved quickly.",
                          textSize: 12,
                          color: primaryDarkColor.withOpacity(0.5)),
                    ],
                  ),
                  Image(
                    image: AssetImage("assets/images/shiksha_bot.gif"),
                    height: 125,
                    width: 125,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget HomeMenuView(BuildContext context) {
    HomeMenuItems item1 = HomeMenuItems(
        text: "Get Access to your College Library Materials",
        img: Image(
          image: AssetImage("assets/images/library_img.jpg"),
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        activity: LibraryDashboardView(appUserUSN: modelUserData.getUserUSN));

    HomeMenuItems item2 = HomeMenuItems(
        text: "Realtime College Bus Tracking\n(Experimental Feature)",
        img: Image(
          image: AssetImage("assets/images/bus_track_img.png"),
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
        activity: const BusTrackingDashboard());

    List<HomeMenuItems> expansionMenuItemsList = [
      item1,
      item2,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 0.85,
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          children: expansionMenuItemsList.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(animatedRoute(data.activity));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: primaryDarkColor.withOpacity(1),
                  elevation: 2,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryWhiteColor,
                    ),
                    margin: EdgeInsets.all(2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data.img,
                        SizedBox(height: 5),
                        customTextRegular(
                            text: data.text,
                            textSize: 10,
                            color: primaryDarkColor.withOpacity(0.5)),
                      ],
                    ),
                  )),
            );
          }).toList()),
    );
  }
  Widget workListView() {
    return Container(
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 25),
              child: customTextBold(
                  text: "Recent Posts",
                  textSize: 16,
                  color: primaryDarkColor)),
          Expanded(
            child: FirestoreListView<ModelWork>(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              query: FirebaseAPI().queryWorkStream(),
              pageSize: 10,
              loadingBuilder: (context) => progressIndicator(),
              itemBuilder: (context, doc) {
                final modelWork = doc.data();
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
                      modelWork.workPostedDate,
                    );
                    Navigator.of(context).push(animatedRoute(e));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(left: 20.0, right: 5.0),
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                customTextBold(
                                    text: modelWork.workCompensation! +
                                        " LPA",
                                    textSize: 12,
                                    color: primaryDarkColor
                                        .withOpacity(0.5)),
                                SizedBox(
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
                          ))),
                );
              },
            ),
          ),
        ],
      ),
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
                    width: MediaQuery.of(context).size.width,
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
                          errorWidget: (context, url, error) => Icon(
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
}

class HomeMenuItems {
  late String text;
  late Image img;
  late Widget activity;

  HomeMenuItems(
      {required this.text, required this.img, required this.activity});
}
