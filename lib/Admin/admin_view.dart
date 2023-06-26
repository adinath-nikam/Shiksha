import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/common_component_widgets.dart';
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
            body: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => const AppUsers())),
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
                              MdiIcons.account,
                              color: primaryWhiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => const CampaignView())),
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
                              MdiIcons.post,
                              color: primaryWhiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
          stream:
              FirebaseDatabase.instance.ref("SHIKSHA_APP/USERS_DATA").onValue,
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
                          icon: const Icon(MdiIcons.accountCircleOutline),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: ExpansionTile(
                              title: customTextBold(
                                  text: list[index]['StudentUID'],
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
                                        Text(
                                            "Username: $list[index]['StudentUsername']"),
                                        Text(
                                            "Email: $list[index]['StudentEmail']"),
                                        Text(
                                            "Branch: $list[index]['StudentBranch']"),
                                        Text(
                                            "Semester: $list[index]['StudentSemester']"),
                                        Text(
                                            "Phone: $list[index]['StudentPhone']"),
                                        Row(
                                          children: [
                                            Text(
                                                "Can Post Event: ${list[index]['CanPostEvent']}"),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Center(
                                                child: Switch(
                                                  value: list[index]
                                                      ['CanPostEvent'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      FirebaseDatabase.instance
                                                          .ref(
                                                              "SHIKSHA_APP/USERS_DATA")
                                                          .child(list[index]
                                                              ['StudentUID'])
                                                          .update({
                                                        'CanPostEvent': value
                                                      });
                                                    });
                                                  },
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "Can Post Job: ${list[index]['CanPostJob']}"),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Center(
                                                child: Switch(
                                                  value: list[index]
                                                      ['CanPostJob'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      FirebaseDatabase.instance
                                                          .ref(
                                                              "SHIKSHA_APP/USERS_DATA")
                                                          .child(list[index]
                                                              ['StudentUID'])
                                                          .update({
                                                        'CanPostJob': value
                                                      });
                                                    });
                                                  },
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "Is Admin: ${list[index]['IsAdmin']}"),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Center(
                                                child: Switch(
                                                  value: list[index]['IsAdmin'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      FirebaseDatabase.instance
                                                          .ref(
                                                              "SHIKSHA_APP/USERS_DATA")
                                                          .child(list[index]
                                                              ['StudentUID'])
                                                          .update({
                                                        'IsAdmin': value
                                                      });
                                                    });
                                                  },
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
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
