import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiksha/Components/CommonComponentWidgets.dart';
import 'package:shiksha/Components/ShowSnackBar.dart';
import 'package:shiksha/Editors/ProfileEditView.dart';
import 'package:shiksha/Models/ModelProfileData.dart';
import 'package:shiksha/colors/colors.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: PrimaryWhiteColor,
      body: ProfileViewContent(),
    ));
  }
}

class ProfileViewContent extends StatefulWidget {
  const ProfileViewContent({Key? key}) : super(key: key);

  @override
  State<ProfileViewContent> createState() => _ProfileViewContentState();
}

class _ProfileViewContentState extends State<ProfileViewContent> {
  final double circleRadius = 120.0;

  @override
  void initState() {
    super.initState();
  }

  Widget isVerified() {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      return Icon(MdiIcons.checkDecagramOutline,
          size: 24, color: PrimaryLightBlueColor);
    } else {
      return Icon(MdiIcons.alertDecagramOutline,
          size: 24, color: PrimaryRedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    MdiIcons.arrowLeftBoldCircleOutline,
                    size: 30,
                    color: PrimaryDarkColor,
                  ),
                ),
                CustomText(
                    text: "ACCOUNT", textSize: 24, color: PrimaryDarkColor),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditProfileView()));
                  },
                  child: Icon(
                    MdiIcons.accountCogOutline,
                    size: 30,
                    color: PrimaryDarkColor,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 25),
                color: PrimaryWhiteColor,
                child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: circleRadius / 2.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 25),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: circleRadius / 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: CustomText(
                                                text: modelProfileData
                                                    .StudentUsername,
                                                textSize: 24,
                                                color: PrimaryDarkColor),
                                          ),
                                        ),
                                        // isVerified(),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    GestureDetector(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(text: modelProfileData.getStudentUid));
                                        showSnackBar(context, "User ID Copied to Clipboard.", PrimaryGreenColor);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(child: CustomTextRegular(text: modelProfileData.getStudentUid, textSize: 10, color: PrimaryDarkColor)),
                                          SizedBox(width: 5,),
                                          Icon(
                                            MdiIcons.contentCopy,
                                            size: 15,
                                            color: PrimaryDarkColor,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 18,
                                    ),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.schoolOutline,
                                                  size: 30,
                                                  color: PrimaryDarkColor,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                      text: modelProfileData
                                                          .StudentCollege,
                                                      textSize: 16,
                                                      color: PrimaryDarkColor),
                                                )
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.bookEducationOutline,
                                                  size: 30,
                                                  color: PrimaryDarkColor,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                      text: modelProfileData
                                                          .getStudentBranch,
                                                      textSize: 16,
                                                      color: PrimaryDarkColor),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MdiIcons
                                                      .calendarAccountOutline,
                                                  size: 30,
                                                  color: PrimaryDarkColor,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                      text: modelProfileData
                                                          .StudentSemester,
                                                      textSize: 16,
                                                      color: PrimaryDarkColor),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 30,
                                            indent: 20,
                                            endIndent: 20,
                                            color: PrimaryDarkColor,
                                            thickness: 1,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Container(
                                            height: 80,
                                            child: SfBarcodeGenerator(
                                              value: modelProfileData.StudentUSN
                                                  .toUpperCase(),
                                              showValue: true,
                                              textStyle: TextStyle(
                                                  fontFamily:
                                                      "ProductSans-Bold"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Divider(
                                      height: 10,
                                      indent: 20,
                                      endIndent: 20,
                                      color: PrimaryDarkColor,
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 10, horizontal: 32.0),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: <Widget>[
                                    //       Icon(
                                    //         MdiIcons.instagram,
                                    //         color: PrimaryDarkColor,
                                    //       ),
                                    //       Icon(
                                    //         MdiIcons.twitter,
                                    //         color: PrimaryDarkColor,
                                    //       ),
                                    //       Icon(
                                    //         MdiIcons.github,
                                    //         color: PrimaryDarkColor,
                                    //       ),
                                    //       Icon(
                                    //         MdiIcons.snapchat,
                                    //         color: PrimaryDarkColor,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    CustomTextRegular(
                                        text: "Joined on: "+modelProfileData.JoiningDate,
                                        textSize: 14,
                                        color: PrimaryDarkColor.withAlpha(100))
                                  ],
                                )),
                          ),
                        ),

                        ///Image Avatar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: PrimaryDarkColor,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: PrimaryDarkColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8), // Border radius
                              child: ClipOval(
                                  child: Image.network(
                                      'https://thumbs.dreamstime.com/b/monitor-material-design-icon-soft-shadow-blue-174047559.jpg')),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
