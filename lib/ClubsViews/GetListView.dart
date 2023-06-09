import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shiksha/Models/ModelEvent.dart';

import '../Components/CommonComponentWidgets.dart';
import '../Components/Constants.dart';
import '../Models/ModelProfileData.dart';
import '../colors/colors.dart';

class GetListView extends StatefulWidget {
  final String eventDocument;
  const   GetListView({Key? key, required this.eventDocument}) : super(key: key);

  @override
  State<GetListView> createState() => _GetListViewState();
}

class _GetListViewState extends State<GetListView> {

  _GetListViewState();



  Future<void> getData() async {
    print(">>>> "+widget.eventDocument);

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DB_ROOT_NAME)
        .doc(EVENTS_CONSTANT)
        .collection(modelProfileData.StudentCollege)
        .doc(widget.eventDocument)
        .collection("REGISTERS")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs;

    print(allData[0].id);
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
        centerTitle: true,
        title: CustomText(
            text: "Registered Users", textSize: 18, color: PrimaryDarkColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(DB_ROOT_NAME)
            .doc(EVENTS_CONSTANT)
            .collection(modelProfileData.StudentCollege)
            .doc(widget.eventDocument)
            .collection("REGISTERS")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: PrimaryWhiteColor,
              ),
            );
          }

          List<dynamic> idList = [];

          print(widget.eventDocument);

          for (var data in snapshot.data.docs) {
            idList.add(data.id);
          }

          print(idList);

          // return ListView(
          //   shrinkWrap: true,
          //   children: snapshot.data.docs
          //       .map<Widget>((data) => Card(child: Text(data.id)))
          //       .toList(),
          // );

          return FutureBuilder<List<ModelProfileData>?>(
            future: getUsersDetailsById(idList),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data
                    .map<Widget>((data) => ExpansionTile(
                              title: Text(data.getStudentUSN),
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
                                        Text(data.getStudentUsername),
                                        Text(data.getStudentBranch),
                                        Text(data.getStudentSemester),
                                        Text(data.getStudentEmail),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )

                        // Card(child: Text(data.getStudentUSN)))
                        )
                    .toList(),
              );
            },
          );

          print(idList);
        },
      ),
    ));
  }

  Future<List<ModelProfileData>?> getUsersDetailsById(List ids) async {


    try {
      List<ModelProfileData> users = [];
      for (var id in ids) {
        DataSnapshot dataSnapshot = await FirebaseDatabase.instance
            .ref("SHIKSHA_APP/USERS_DATA")
            .child(id)
            .get();
        ModelProfileData tempmodelProfileData = ModelProfileData.fromJson(
            dataSnapshot.value as Map<dynamic, dynamic>);

        print(tempmodelProfileData.CanPostEvent);

        users.add(tempmodelProfileData);
        return users;
      }


    } catch (e) {
      print(e);
      return null;
    }
  }
}
