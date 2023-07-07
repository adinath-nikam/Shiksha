import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/Admin/word_of_the_day.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
import 'package:shiksha/FirebaseServices/firebase_api.dart';
import 'package:shiksha/colors/colors.dart';
import 'campaign_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: appBarCommon(context, "ADMIN")),
            backgroundColor: primaryWhiteColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(animatedRoute(const AddWOTDView())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 10,
                        color: primaryDarkColor,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextBold(
                                  text: "Update WOTD",
                                  textSize: 24,
                                  color: primaryWhiteColor),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.wordpress_rounded,
                                color: primaryWhiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(animatedRoute(const AppUsers())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 10,
                        color: primaryDarkColor,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextBold(
                                  text: "App Users",
                                  textSize: 24,
                                  color: primaryWhiteColor),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.account_circle_rounded,
                                color: primaryWhiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(animatedRoute(const CampaignView())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 10,
                        color: primaryDarkColor,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextBold(
                                  text: "Add Campaign",
                                  textSize: 24,
                                  color: primaryWhiteColor),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.signpost_rounded,
                                color: primaryWhiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

class AppUsers extends StatefulWidget {
  const AppUsers({Key? key}) : super(key: key);

  @override
  State<AppUsers> createState() => _AppUsersState();
}

class _AppUsersState extends State<AppUsers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: appBarCommon(context, "APP USERS")),
      body: StreamBuilder(
          stream: FirebaseAPI().realtimeDBStream("SHIKSHA_APP/USERS_DATA"),
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Map<dynamic, dynamic> map =
                  snapshot.data!.snapshot.value as dynamic;

              List<dynamic> list = [];
              list.clear();
              list = map.values.toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: FloatingActionButton.extended(
                          backgroundColor: primaryDarkColor,
                          onPressed: () async {},
                          label: customTextBold(
                              text:
                                  'Users: ${snapshot.data!.snapshot.children.length}',
                              textSize: 16,
                              color: primaryWhiteColor),
                          icon: const Icon(Icons.account_circle_rounded),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          print(snapshot.data!.snapshot.value as dynamic);
                          return ListTile(
                            title: ExpansionTile(
                              title: customTextBold(
                                  text: list[index]['user_id'],
                                  textSize: 14,
                                  color: primaryDarkColor),
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextRegular(
                                            text: "${list[index]['user_id']}",
                                            textSize: 14,
                                            color: primaryDarkColor),
                                        customTextRegular(
                                            text:
                                                "${list[index]['last_active']}",
                                            textSize: 14,
                                            color: primaryDarkColor)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    ));
  }
}
