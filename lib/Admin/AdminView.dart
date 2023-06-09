import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/colors/colors.dart';

import '../Models/ModelProfileData.dart';
import 'CampaignView.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

// Future<void> showEditUserDialog(BuildContext context) async {
//   return showDialog(
//       context: context,
//       builder: (BuildContext context){
//
//         return AlertDialog(
//           title: Text("Update"),
//           content: Container(
//             child: Column(
//               children: [
//                 Switch(
//                   onChanged: toggleSwitch,
//                   value: isSwitched,
//                 )
//               ],
//             )
//           ),
//           actions: [
//
//             TextButton(onPressed: (){
//               Navigator.pop(context);
//             }, child: Text("Cancel"),),
//
//             TextButton(onPressed: (){
//               Navigator.pop(context);
//             }, child: Text("Update"),)
//
//           ],
//         );
//
//       }
//   );
// }

class _AdminViewState extends State<AdminView> {
  bool isSwitched = false;

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
              centerTitle: true,
              title: CustomText(
                  text: "Admin Panel", textSize: 18, color: PrimaryDarkColor),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: PrimaryWhiteColor,
            body: Container(
              child: Column(
                children: [

                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => AppUsers())),
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 10,
                        color: PrimaryDarkColor,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: "App Users",
                                  textSize: 24,
                                  color: PrimaryWhiteColor),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                MdiIcons.account,
                                color: PrimaryWhiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => CampaignView())),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 10,
                        color: PrimaryDarkColor,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: "Add Campaign",
                                  textSize: 24,
                                  color: PrimaryWhiteColor),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                MdiIcons.post,
                                color: PrimaryWhiteColor,
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
      backgroundColor: PrimaryWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: PrimaryDarkColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: CustomText(
            text: "App Users", textSize: 18, color: PrimaryDarkColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.ref("SHIKSHA_APP/USERS_DATA").onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) {
              return Center(
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
                        padding: EdgeInsets.all(15),
                        child: FloatingActionButton.extended(
                          backgroundColor: PrimaryDarkColor,
                          onPressed: () async {},
                          label: CustomText(
                              text: 'Users: ' +
                                  snapshot.data!.snapshot.children.length
                                      .toString(),
                              textSize: 16,
                              color: PrimaryWhiteColor),
                          icon: Icon(MdiIcons.accountCircleOutline),
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
                              title: CustomText(
                                  text: list[index]['StudentUID'],
                                  textSize: 14,
                                  color: PrimaryDarkColor),
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Username: " +
                                            list[index]['StudentUsername']),
                                        Text("Email: " +
                                            list[index]['StudentEmail']),
                                        Text("Branch: " +
                                            list[index]['StudentBranch']),
                                        Text("Semester: " +
                                            list[index]['StudentSemester']),
                                        Text("Phone: " +
                                            list[index]['StudentPhone']),
                                        Row(
                                          children: [
                                            Text("Can Post Event: " +
                                                list[index]['CanPostEvent']
                                                    .toString()),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Container(
                                                child: Center(
                                                  child: Switch(
                                                    value: list[index]
                                                        ['CanPostEvent'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
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
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Can Post Job: " +
                                                list[index]['CanPostJob']
                                                    .toString()),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Container(
                                                child: Center(
                                                  child: Switch(
                                                    value: list[index]
                                                        ['CanPostJob'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
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
                                                ),
                                              );
                                            }),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Text("Is Admin: " +
                                                list[index]['IsAdmin']
                                                    .toString()),
                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                StateSetter setState) {
                                              return Container(
                                                child: Center(
                                                  child: Switch(
                                                    value: list[index]
                                                    ['IsAdmin'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FirebaseDatabase
                                                            .instance
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
