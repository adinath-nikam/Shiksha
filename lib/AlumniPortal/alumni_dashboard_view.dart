import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/AlumniPortal/alumni_profile_setup_view.dart';
import 'package:shiksha/Components/constants.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:shiksha/Models/model_user_data.dart';
import 'package:shiksha/colors/colors.dart';
import '../Components/common_component_widgets.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class AlumniDashboardView extends StatefulWidget {
  const AlumniDashboardView({Key? key}) : super(key: key);

  @override
  State<AlumniDashboardView> createState() => _AlumniDashboardViewState();
}

class _AlumniDashboardViewState extends State<AlumniDashboardView>
    with TickerProviderStateMixin {
  int initialTabCount = 0;
  List<Tab> tabsAlumniBatchYear = <Tab>[];
  List<Widget> tabWidgetList = <Widget>[];
  List<String> tabTitles = <String>[];
  late TabController tabControllerAlumniTab;
  CollectionReference alumniDBCollectionRef = FirebaseAPI()
      .firebaseFirestore
      .collection(DB_ROOT_NAME)
      .doc(ALUMNI_CONSTANT)
      .collection(modelUserData.getUserCollege);

  @override
  void initState() {
    getAlumniData();
    super.initState();
  }

  @override
  void dispose() {
    tabControllerAlumniTab.dispose();
    super.dispose();
  }

  TabController getTabController() {
    return TabController(length: tabsAlumniBatchYear.length, vsync: this)
      ..addListener(updatePage);
  }

  Widget getWidget(int widgetNumber, String title) {
    return AlumniListView(alumniBatchYear: title);
  }

  List<Tab> getTabs(int count) {
    tabsAlumniBatchYear.clear();
    for (int i = 0; i < count; i++) {
      tabsAlumniBatchYear.add(Tab());
    }
    return tabsAlumniBatchYear;
  }

  List<Widget> getWidgets() {
    tabWidgetList.clear();
    for (int i = 0; i < tabsAlumniBatchYear.length; i++) {
      tabWidgetList.add(getWidget(i, tabTitles[i]));
    }
    return tabWidgetList;
  }

  void updatePage() {
    setState(() {});
  }

  Future<void> getAlumniData() async {
    await alumniDBCollectionRef
        .orderBy('batch_year', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        List<Tab> listTabs = [];
        List<String> listTabTitles = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          DocumentSnapshot snap = snapshot.docs[i];
          listTabTitles.add(snap.id);
          listTabs.add(
            Tab(
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: primaryDarkColor, width: 1)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    snap.id,
                    style: TextStyle(fontFamily: "ProductSans-Bold"),
                  ),
                ),
              ),
            ),
          );
        }
        setState(() {
          initialTabCount = listTabs.length;
          tabsAlumniBatchYear = listTabs;
          tabTitles = listTabTitles;
        });

        tabControllerAlumniTab =
            TabController(vsync: this, length: initialTabCount);
        tabControllerAlumniTab.addListener(handleTabSelection);
      }
    });
  }

  void handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhiteColor,
      body: Stack(
        children: <Widget>[
          tabTitles.isNotEmpty
              ? Column(
                  children: [
                    TabBar(
                        controller: tabControllerAlumniTab,
                        isScrollable: true,
                        indicatorWeight: 0.1,
                        unselectedLabelColor: primaryDarkColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: primaryDarkColor),
                        tabs: tabsAlumniBatchYear),
                    Expanded(
                      flex: 1,
                      child: TabBarView(
                          controller: tabControllerAlumniTab,
                          children: getWidgets()),
                    ),
                  ],
                )
              : Center(
                  child: Image(
                  height: 250,
                  width: 250,
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/mgc-shiksha-82736.appspot.com/o/Images%2FIdle%20Graphics%2Fnull_alumni_img.png?alt=media&token=e9241f5f-6b4e-4568-af5f-a5e4ed89e6df'),
                )),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(animatedRoute(AlumniProfileBuildView()));
              },
              child: Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10),
                child: Card(
                  color: primaryBlueColor.withOpacity(0.5),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: primaryWhiteColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: SizedBox(
                      height: 55,
                      width: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/alumni_img.png',
                          fit: BoxFit.contain,
                          height: 55,
                          width: 55,
                        ),
                      ),
                    ),
                    title: customTextBold(
                        text: 'Setup your Alumni Profile here..',
                        textSize: 14,
                        color: primaryWhiteColor),
                    subtitle: customTextBold(
                        text: 'Complete your profile as Alumni.',
                        textSize: 12,
                        color: primaryWhiteColor.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlumniListView extends StatefulWidget {
  final String alumniBatchYear;

  const AlumniListView({Key? key, required this.alumniBatchYear})
      : super(key: key);

  @override
  State<AlumniListView> createState() => _AlumniListViewState();
}

class _AlumniListViewState extends State<AlumniListView>
    with AutomaticKeepAliveClientMixin<AlumniListView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: primaryWhiteColor,
      child: FirestoreListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        query: FirebaseFirestore.instance
            .collection(DB_ROOT_NAME)
            .doc(ALUMNI_CONSTANT)
            .collection(modelUserData.getUserCollege)
            .doc(widget.alumniBatchYear)
            .collection(ALUMNI_CONSTANT_2)
            .orderBy('alumni_name'),
        pageSize: 10,
        loadingBuilder: (context) => progressIndicator(),
        itemBuilder: (context, doc) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(animatedRoute(AlumniDetailView(
                alumniProfileImgUrl: doc['alumni_profile_img_url']!,
                worksAt: doc['alumni_work_status'],
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: doc['alumni_profile_img_url'] == 'nil'
                          ? Image.asset(
                              'assets/images/alumni_nil_icon.png',
                              height: 55,
                              width: 55,
                            )
                          : Image.network(
                              doc['alumni_profile_img_url'],
                              fit: BoxFit.contain,
                              height: 55,
                              width: 55,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: progressIndicator(),
                                );
                              },
                            ),
                    ),
                  ),
                  title: customTextBold(
                      text: doc['alumni_name'],
                      textSize: 14,
                      color: primaryDarkColor),
                  subtitle: customTextBold(
                      text: doc['alumni_work_status'],
                      textSize: 12,
                      color: primaryDarkColor.withOpacity(0.5)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AlumniDetailView extends StatelessWidget {
  final String alumniProfileImgUrl, worksAt;

  const AlumniDetailView(
      {Key? key, required this.alumniProfileImgUrl, required this.worksAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryWhiteColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarCommon(context, 'ALUMNI')),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: alumniProfileImgUrl == 'nil'
                      ? Image.asset(
                          'assets/images/alumni_nil_icon.png',
                          height: 100,
                          width: 100,
                        )
                      : Image.network(
                          alumniProfileImgUrl,
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: progressIndicator(),
                            );
                          },
                        ),
                ),
                SizedBox(
                  height: 50,
                ),
                customTextBold(
                    text: 'Adinath A. Nikam',
                    textSize: 32,
                    color: primaryDarkColor),
                SizedBox(
                  height: 25,
                ),
                customTextBold(
                    text: 'Works at ${worksAt}',
                    textSize: 16,
                    color: primaryDarkColor.withOpacity(0.5)),
              ],
            )),
      ),
    );
  }
}
